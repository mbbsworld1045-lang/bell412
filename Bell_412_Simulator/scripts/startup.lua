-- =============================================================================
-- BELL 412 - ENGINE STARTUP LOGIC
-- Platform: Air Manager + Arduino Mega 2560
-- Hardware: Arduino Channel C (Main Panel / Collective)
-- Logic: Buttons Only (Active Low) + ADC Throttles
-- =============================================================================

-- =============================================================================
-- 1. HARDWARE CONFIGURATION HEADER
-- =============================================================================
-- INPUTS (Buttons) D2..D7
-- Start Engine Switch (3-position: 0=OFF, 1=Engine 1, -1=Engine 2)
local PIN_START_ENG_POS1 = "ARDUINO_MEGA2560_C_D2"  -- Start Engine Position 1 (State = 1, Engine 1)
local PIN_START_ENG_POS2 = "ARDUINO_MEGA2560_C_D3"  -- Start Engine Position 2 (State = -1, Engine 2)
-- Idle Stop Switch (3-position: 0=OFF, 1=Engine 1, -1=Engine 2)
local PIN_IDLE_STOP_POS1 = "ARDUINO_MEGA2560_C_D4"  -- Idle Stop Position 1 (State = 1, Engine 1)
local PIN_IDLE_STOP_POS2 = "ARDUINO_MEGA2560_C_D7"  -- Idle Stop Position 2 (State = -1, Engine 2)
local PIN_PARTSEP1    = "ARDUINO_MEGA2560_C_D5"
local PIN_PARTSEP2    = "ARDUINO_MEGA2560_C_D6"

-- INPUTS (Rotor Brake) D24
local PIN_ROTOR_BRAKE_SW  = "ARDUINO_MEGA2560_C_D24"

-- INPUTS (Analog - Throttles) A0..A1
local PIN_THROTTLE1   = "ARDUINO_MEGA2560_C_A0"
local PIN_THROTTLE2   = "ARDUINO_MEGA2560_C_A1"

-- OUTPUTS (LEDs) D30, D31, D34, D35
local PIN_START_LED       = "ARDUINO_MEGA2560_C_D30"
local PIN_ROTOR_BRAKE_LED = "ARDUINO_MEGA2560_C_D31"
local PIN_PARTSEP1_LED    = "ARDUINO_MEGA2560_C_D34"  -- Particle Separator 1 Status LED
local PIN_PARTSEP2_LED    = "ARDUINO_MEGA2560_C_D35"  -- Particle Separator 2 Status LED

-- =============================================================================
-- 2. INITIALIZE HARDWARE LEDS
-- =============================================================================
local led_start_h       = hw_led_add(PIN_START_LED, 0.0)
local led_rotor_brake_h = hw_led_add(PIN_ROTOR_BRAKE_LED, 0.0)
local led_partsep1_h    = hw_led_add(PIN_PARTSEP1_LED, 0.0)
local led_partsep2_h    = hw_led_add(PIN_PARTSEP2_LED, 0.0)

-- =============================================================================
-- 3. INTERNAL VARIABLES & CONSTANTS
-- =============================================================================
-- Logic Constants
local IDLE_DETENT_MIN = 0.12    -- 12% throttle position (idle stop detent)
local ROTOR_BRAKE_MAX_RPM = 40.0  -- Maximum safe RPM for rotor brake application

-- Local State (Button Positions)
-- Start Engine Switch State (3-position: 0=OFF, 1=Engine 1, -1=Engine 2)
local start_eng_pos1_pressed = false
local start_eng_pos2_pressed = false
local start_eng_state = 0

-- Idle Stop Switch State (3-position: 0=OFF, 1=Engine 1, -1=Engine 2)
local idle_stop_pos1_pressed = false
local idle_stop_pos2_pressed = false
local idle_stop_state = 0

-- Particle Separator Switch States
local sw_partsep1 = 0
local sw_partsep2 = 0

-- Throttle Raw Values
local throttle1_raw = 0.0
local throttle2_raw = 0.0

-- Start Switch Logic
local start_sw_pos = 0
local starteng_val = 0

-- Rotor State
local rotor_brake_on = false
local rotor_rpm_pct = 0.0  -- Current rotor RPM for brake warning

-- Sim Feedback Variables
local fuel_p1        = 0.0
local fuel_p2        = 0.0
local valve1_pos     = 0.0
local valve2_pos     = 0.0
local fueltrans1_sw  = 0
local fueltrans2_sw  = 0
local batt1_sw       = 0
local batt2_sw       = 0

-- Forward declaration
local function update_all_flags() end

-- =============================================================================
-- 4. SYSTEM LOGIC FUNCTIONS
-- =============================================================================

-- THROTTLE CLAMP: Apply idle stop logic per engine
-- Per Flight Manual: "Rotate throttle full open, then back against idle stop.
-- Actuate IDLE STOP release, roll throttle to full closed."
local function clamp_throttle(raw_value, engine_num)
    local v = raw_value or 0.0
    local idle_released = false
    
    -- Check idle stop state for this specific engine
    if engine_num == 1 then
        idle_released = (idle_stop_state == 1)  -- Engine 1 idle stop released
    elseif engine_num == 2 then
        idle_released = (idle_stop_state == -1)  -- Engine 2 idle stop released
    end
    
    if idle_released then
        -- Idle stop released for this engine: Allow full range (0.0 to 1.0) for engine cutoff
        return v
    else
        -- Idle stop engaged: Clamp minimum to idle detent (prevents accidental shutdown)
        return math.max(v, IDLE_DETENT_MIN)
    end
end

-- APPLY THROTTLE 1
local function apply_throttle_1()
    local clamped = clamp_throttle(throttle1_raw, 1)
    local sim_pct = clamped * 100.0
    fsx_variable_write("L:throgas1", "Number", clamped)
    fsx_variable_write("GENERAL ENG THROTTLE LEVER POSITION:1", "Percent", sim_pct)
end

-- APPLY THROTTLE 2
local function apply_throttle_2()
    local clamped = clamp_throttle(throttle2_raw, 2)
    local sim_pct = clamped * 100.0
    fsx_variable_write("L:throgas2", "Number", clamped)
    fsx_variable_write("GENERAL ENG THROTTLE LEVER POSITION:2", "Percent", sim_pct)
end

-- START ENGINE SWITCH: Update state based on two position pins (3-position: 0=OFF, 1=Engine 1, -1=Engine 2)
local function update_start_switch_state()
    local new_state = 0
    
    if start_eng_pos1_pressed and not rotor_brake_on then
        new_state = 1  -- Position 1 (D2) - Engine 1
    elseif start_eng_pos2_pressed and not rotor_brake_on then
        new_state = -1  -- Position 2 (D3) - Engine 2
    else
        new_state = 0  -- OFF (both released or rotor brake on)
    end
    
    if start_eng_state ~= new_state then
        start_eng_state = new_state
        
        -- Update legacy variables for compatibility
        if new_state == 1 then
            start_sw_pos = 1
            starteng_val = 1
        elseif new_state == -1 then
            start_sw_pos = 2
            starteng_val = -1
        else
            start_sw_pos = 0
            starteng_val = 0
        end
        
        fsx_variable_write("L:StartSwitch", "Number", (start_sw_pos ~= 0) and 1 or 0)
        fsx_variable_write("L:starteng", "Number", starteng_val)
        print("START SWITCH: State changed to " .. tostring(starteng_val))
        
        -- Direct Feedback: Start LED
        hw_led_set(led_start_h, (start_sw_pos ~= 0) and 1.0 or 0.0)
        
        if (start_eng_pos1_pressed or start_eng_pos2_pressed) and rotor_brake_on then
            print("WARNING: Start Ignored - Rotor Brake ON!")
        end
        
            update_all_flags()
        end
    end

-- IDLE STOP SWITCH: Update state based on two position pins (3-position: 0=OFF, 1=Engine 1, -1=Engine 2)
local function update_idle_stop_state()
    local new_state = 0
    
    if idle_stop_pos1_pressed then
        new_state = 1  -- Position 1 (D4) - Engine 1 Idle Stop Release
    elseif idle_stop_pos2_pressed then
        new_state = -1  -- Position 2 (D7) - Engine 2 Idle Stop Release
    else
        new_state = 0  -- OFF (both released)
    end
    
    if idle_stop_state ~= new_state then
        idle_stop_state = new_state
        fsx_variable_write("L:idle eng", "Number", idle_stop_state)
        print("IDLE STOP SWITCH: State changed to " .. tostring(idle_stop_state))
        
        -- Update legacy L:IdleStopRel for compatibility (1 if either engine selected, 0 if off)
        local idle_stop_rel = (idle_stop_state ~= 0) and 1 or 0
        fsx_variable_write("L:IdleStopRel", "Number", idle_stop_rel)
        
        -- Update fuel cut based on engine selection
        if idle_stop_state == 1 then
            -- Engine 1 idle stop released
            fsx_variable_write("L:FuelcutE1", "Number", 1)
            fsx_variable_write("L:FuelcutE2", "Number", 0)
        elseif idle_stop_state == -1 then
            -- Engine 2 idle stop released
            fsx_variable_write("L:FuelcutE1", "Number", 0)
            fsx_variable_write("L:FuelcutE2", "Number", 1)
        else
            -- Both idle stops engaged
            fsx_variable_write("L:FuelcutE1", "Number", 0)
            fsx_variable_write("L:FuelcutE2", "Number", 0)
        end
        
        -- Re-apply throttles with new clamp state
        apply_throttle_1()
        apply_throttle_2()
    end
end

-- ENGINE START PERMISSION: Check all conditions
local function update_eng1_start_flag()
    local batts_ok = (batt1_sw == 1) or (batt2_sw == 1)
    local all_ok = batts_ok
                 and (fueltrans1_sw == 1)
                 and (fuel_p1 > 4.0)
                 and (valve1_pos >= 0.99)
                 and (start_eng_state == 1)  -- Updated to use new state variable
                 and (not rotor_brake_on)

    fsx_variable_write("L:Eng1StartFlag", "Number", all_ok and 1 or 0)
end

local function update_eng2_start_flag()
    local batts_ok = (batt1_sw == 1) or (batt2_sw == 1)
    local all_ok = batts_ok
                 and (fueltrans2_sw == 1)
                 and (fuel_p2 > 4.0)
                 and (valve2_pos >= 0.99)
                 and (start_eng_state == -1)  -- Updated to use new state variable
                 and (not rotor_brake_on)

    fsx_variable_write("L:Eng2StartFlag", "Number", all_ok and 1 or 0)
    end

update_all_flags = function()
    update_eng1_start_flag()
    update_eng2_start_flag()
end

-- LED UPDATE: Particle Separator Status LEDs
local function update_partsep_leds()
    hw_led_set(led_partsep1_h, (sw_partsep1 == 1) and 1.0 or 0.0)
    hw_led_set(led_partsep2_h, (sw_partsep2 == 1) and 1.0 or 0.0)
end

-- =============================================================================
-- 5. HARDWARE INPUTS (BUTTONS)
-- =============================================================================

-- START ENGINE SWITCH (3-Position: 0=OFF, 1=Engine 1 (D2), -1=Engine 2 (D3))
-- Position 1 Button (D2 -> State = 1, Engine 1)
hw_button_add(PIN_START_ENG_POS1,
    function() -- PRESSED (Position 1 - Engine 1)
        print("ACTION: Start Engine Switch -> Position 1 (State = 1, Engine 1)")
        start_eng_pos1_pressed = true
        update_start_switch_state()
    end,
    function() -- RELEASED
        print("ACTION: Start Engine Switch Position 1 RELEASED")
        start_eng_pos1_pressed = false
        update_start_switch_state()
    end
)

-- Position 2 Button (D3 -> State = -1, Engine 2)
hw_button_add(PIN_START_ENG_POS2,
    function() -- PRESSED (Position 2 - Engine 2)
        print("ACTION: Start Engine Switch -> Position 2 (State = -1, Engine 2)")
        start_eng_pos2_pressed = true
        update_start_switch_state()
    end,
    function() -- RELEASED
        print("ACTION: Start Engine Switch Position 2 RELEASED")
        start_eng_pos2_pressed = false
        update_start_switch_state()
    end
)

-- IDLE STOP SWITCH (3-Position: 0=OFF, 1=Engine 1 (D4), -1=Engine 2 (D7))
-- Per Flight Manual: "Actuate IDLE STOP release, roll throttle to full closed."
-- Position 1 Button (D4 -> State = 1, Engine 1 Idle Stop Release)
hw_button_add(PIN_IDLE_STOP_POS1,
    function() -- PRESSED (Position 1 - Engine 1)
        print("ACTION: Idle Stop Switch -> Position 1 (State = 1, Engine 1 Idle Stop Release)")
        idle_stop_pos1_pressed = true
        update_idle_stop_state()
    end,
    function() -- RELEASED
        print("ACTION: Idle Stop Switch Position 1 RELEASED")
        idle_stop_pos1_pressed = false
        update_idle_stop_state()
    end
)

-- Position 2 Button (D7 -> State = -1, Engine 2 Idle Stop Release)
hw_button_add(PIN_IDLE_STOP_POS2,
    function() -- PRESSED (Position 2 - Engine 2)
        print("ACTION: Idle Stop Switch -> Position 2 (State = -1, Engine 2 Idle Stop Release)")
        idle_stop_pos2_pressed = true
        update_idle_stop_state()
    end,
    function() -- RELEASED
        print("ACTION: Idle Stop Switch Position 2 RELEASED")
        idle_stop_pos2_pressed = false
        update_idle_stop_state()
    end
)

-- PARTICLE SEPARATOR 1
hw_button_add(PIN_PARTSEP1,
    function() -- PRESSED (ON)
        print("ACTION: Part Sep 1 ON")
        sw_partsep1 = 1
        fsx_variable_write("L:SwpartsepA", "Number", 1)
        update_partsep_leds()
    end,
    function() -- RELEASED (OFF)
        print("ACTION: Part Sep 1 OFF")
        sw_partsep1 = 0
        fsx_variable_write("L:SwpartsepA", "Number", 0)
        update_partsep_leds()
    end
)

-- PARTICLE SEPARATOR 2
hw_button_add(PIN_PARTSEP2,
    function() -- PRESSED (ON)
        print("ACTION: Part Sep 2 ON")
        sw_partsep2 = 1
        fsx_variable_write("L:SwpartsepB", "Number", 1)
        update_partsep_leds()
    end,
    function() -- RELEASED (OFF)
        print("ACTION: Part Sep 2 OFF")
        sw_partsep2 = 0
        fsx_variable_write("L:SwpartsepB", "Number", 0)
        update_partsep_leds()
    end
)

-- ROTOR BRAKE SWITCH
-- Per Flight Manual: "Apply at or below 40% ROTOR RPM."
hw_button_add(PIN_ROTOR_BRAKE_SW,
    function() -- PRESSED (Brake ON)
        print("ACTION: Rotor Brake ON")
        
        -- Safety Check: Warn if applied above 40% RPM
        if rotor_rpm_pct > ROTOR_BRAKE_MAX_RPM then
            print("WARNING: ROTOR BRAKE APPLIED ABOVE 40% RPM! (Current: " .. 
                  string.format("%.1f", rotor_rpm_pct) .. "%)")
        end
        
        -- Execute brake regardless (log pilot error, don't block)
        fsx_event("ROTOR_BRAKE", 100)
    end,
    function() -- RELEASED (Brake OFF)
        print("ACTION: Rotor Brake OFF")
        fsx_event("ROTOR_BRAKE", 0)
    end
)

-- =============================================================================
-- 5b. THROTTLE ANALOG INPUTS (ADC)
-- =============================================================================

hw_adc_input_add(PIN_THROTTLE1, function(val)
    throttle1_raw = val or 0.0
    apply_throttle_1()
end)

hw_adc_input_add(PIN_THROTTLE2, function(val)
    throttle2_raw = val or 0.0
    apply_throttle_2()
end)

-- =============================================================================
-- 6. SIMULATOR SUBSCRIPTIONS (Data In -> Logic Update)
-- =============================================================================

-- Fuel Pressure
fsx_variable_subscribe("L:FuelPressure1", "Number", function(val)
    fuel_p1 = val or 0.0
    update_all_flags()
end)

fsx_variable_subscribe("L:FuelPressure2", "Number", function(val)
    fuel_p2 = val or 0.0
    update_all_flags()
end)

-- Fuel Valve Position
fsx_variable_subscribe("L:FuelValve1Pos", "Number", "L:FuelValve2Pos", "Number", function(p1, p2)
    valve1_pos = p1 or 0.0
    valve2_pos = p2 or 0.0
    update_all_flags()
end)

-- Fuel Transfer Switches
fsx_variable_subscribe("L:SwfueltransengA", "Number", function(val)
    fueltrans1_sw = (val ~= 0) and 1 or 0
    update_all_flags()
end)

fsx_variable_subscribe("L:SwfueltransengB", "Number", function(val)
    fueltrans2_sw = (val ~= 0) and 1 or 0
    update_all_flags()
end)

-- Battery Switches
fsx_variable_subscribe("L:Swbatta", "Number", "L:Swbattb", "Number", function(a, b)
    batt1_sw = (a ~= 0) and 1 or 0
    batt2_sw = (b ~= 0) and 1 or 0
    update_all_flags()
end)

-- Rotor RPM (for brake warning check)
fsx_variable_subscribe("ROTOR RPM PCT:1", "Percent", function(val)
    rotor_rpm_pct = val or 0.0
end)

-- Rotor Brake Handle Position (for start interlock logic)
fsx_variable_subscribe("A:ROTOR BRAKE HANDLE POS", "Percent", function(val)
    local was_on = rotor_brake_on

    if val <= 1.0 then
        rotor_brake_on = (val > 0.05)
    else
        rotor_brake_on = (val > 5.0)
    end
    
    if was_on ~= rotor_brake_on then
        update_start_switch_state()  -- Updated function name
    end
end)

-- Rotor Brake Active (for LED)
fsx_variable_subscribe("A:Rotor Brake Active", "Bool", function(val)
    local led_state = val and 1.0 or 0.0
    hw_led_set(led_rotor_brake_h, led_state)
    print("SUBSCRIBE: Rotor Brake Active = " .. tostring(val))
end)

-- Particle Separator 1 State (for LED sync)
fsx_variable_subscribe("L:SwpartsepA", "Number", function(val)
    local new_state = (val ~= 0) and 1 or 0
    if sw_partsep1 ~= new_state then
        sw_partsep1 = new_state
        update_partsep_leds()
        print("SUBSCRIBE: Part Sep 1 = " .. tostring(val))
    end
end)

-- Particle Separator 2 State (for LED sync)
fsx_variable_subscribe("L:SwpartsepB", "Number", function(val)
    local new_state = (val ~= 0) and 1 or 0
    if sw_partsep2 ~= new_state then
        sw_partsep2 = new_state
        update_partsep_leds()
        print("SUBSCRIBE: Part Sep 2 = " .. tostring(val))
    end
end)

-- =============================================================================
-- 7. STARTUP INITIALIZATION
-- =============================================================================
        fsx_variable_write("L:starteng", "Number", 0)
fsx_variable_write("L:idle eng", "Number", 0)
        fsx_variable_write("L:StartSwitch", "Number", 0)
fsx_variable_write("L:IdleStopRel", "Number", 0)
fsx_variable_write("L:FuelcutE1", "Number", 0)
fsx_variable_write("L:FuelcutE2", "Number", 0)
fsx_variable_write("L:SwpartsepA", "Number", 0)
fsx_variable_write("L:SwpartsepB", "Number", 0)

-- Initialize switch states
update_start_switch_state()
update_idle_stop_state()
update_partsep_leds()
update_all_flags()
