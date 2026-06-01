-- =============================================================================
-- BELL 412 - COLLECTIVE & ENGINE CONTROL LOGIC
-- Platform: Air Manager + Arduino Mega 2560
-- Hardware: Arduino Channel C (Collective)
-- =============================================================================

print("Collective Script Running")

-- =============================================================================
-- 1. HARDWARE CONFIGURATION HEADER
-- =============================================================================

-- INPUTS (Analog Axes)
local PIN_THROTTLE1         = "ARDUINO_MEGA2560_C_A0"       -- Throttle 1 Axis
local PIN_THROTTLE2         = "ARDUINO_MEGA2560_C_A1"       -- Throttle 2 Axis

-- =============================================================================
-- COLLECTIVE RIGHT HAND (PILOT)
-- =============================================================================

-- Landing Light
local PIN_LDG_LT_LT         = "ARDUINO_MEGA2560_C_D22"      -- LDG LIGHT LT (Light ON/OFF)
local PIN_LDG_LT_EXT        = "ARDUINO_MEGA2560_C_D26"      -- LDG LT EXT (Extend)
local PIN_LDG_LT_RETR       = "ARDUINO_MEGA2560_C_D25"      -- LDG LT RETR (Retract)

-- Search Light
local PIN_SRCH_LT_ON        = "ARDUINO_MEGA2560_C_D23"      -- SRCH LT ON (Toggle)
local PIN_SRCH_LT_STOW      = "ARDUINO_MEGA2560_C_D24"      -- SRCH LT STOW (Retract)
local PIN_SRCH_LT_EXT       = "ARDUINO_MEGA2560_C_D39"      -- SRCH LT EXT (Extend)
local PIN_SRCH_LT_L         = "ARDUINO_MEGA2560_C_D37"      -- SRCH LT L (Left)
local PIN_SRCH_LT_R         = "ARDUINO_MEGA2560_C_D38"      -- SRCH LT R (Right)
local PIN_SRCH_LT_RETR      = "ARDUINO_MEGA2560_C_D40"      -- SRCH LT RETR (Retract)

-- Idle Stop
local PIN_IDLE_STOP_ENG1    = "ARDUINO_MEGA2560_C_D28"      -- IDLE STOP ENG1 (Swapped from D29)
local PIN_IDLE_STOP_ENG2    = "ARDUINO_MEGA2560_C_D29"      -- IDLE STOP ENG2 (Swapped from D28)

-- Idle Stop Solenoids (Outputs)
local PIN_SOLENOID_ENG1     = "ARDUINO_MEGA2560_C_D53"      -- SOLENOID ENG1 (Swapped from D52)
local PIN_SOLENOID_ENG2     = "ARDUINO_MEGA2560_C_D52"      -- SOLENOID ENG2 (Swapped from D53)

-- Start Switches
local PIN_START_ENG1        = "ARDUINO_MEGA2560_C_D31"      -- START ENG1
local PIN_START_ENG2        = "ARDUINO_MEGA2560_C_D30"      -- START ENG2

-- Governor / RPM (Right Hand)
local PIN_RPM_INC_RH        = "ARDUINO_MEGA2560_C_D34"      -- RPM INC
local PIN_RPM_DEC_RH        = "ARDUINO_MEGA2560_C_D35"      -- RPM DEC
local PIN_RPM_PLUS2         = "ARDUINO_MEGA2560_C_D36"      -- RPM +2
local PIN_RPM_MINUS2        = "ARDUINO_MEGA2560_C_D33"      -- RPM -2

-- Yaw Trim (Right Hand)
local PIN_YAW_UP_RH         = "ARDUINO_MEGA2560_C_D48"      -- YAW UP (Rudder Trim Right)
local PIN_YAW_DOWN_RH       = "ARDUINO_MEGA2560_C_D32"      -- YAW DOWN (Rudder Trim Left)

-- Go Around (Right Hand)
local PIN_GO_AROUND_RH      = "ARDUINO_MEGA2560_C_D41"      -- GO AROUND

-- =============================================================================
-- COLLECTIVE LEFT HAND (CO-PILOT)
-- =============================================================================

-- Governor / RPM (Left Hand)
local PIN_RPM_INC_LH        = "ARDUINO_MEGA2560_C_D45"      -- RPM INC
local PIN_RPM_DEC_LH        = "ARDUINO_MEGA2560_C_D46"      -- RPM DEC

-- Yaw Trim (Left Hand)
local PIN_YAW_UP_LH         = "ARDUINO_MEGA2560_C_D44"      -- YAW UP (Rudder Trim Right)
local PIN_YAW_DOWN_LH       = "ARDUINO_MEGA2560_C_D43"      -- YAW DOWN (Rudder Trim Left)

-- Go Around (Left Hand)
local PIN_GO_AROUND_LH      = "ARDUINO_MEGA2560_C_D42"      -- GO AROUND

-- =============================================================================
-- 2. INTERNAL VARIABLES & STATE
local rpm_n1_e1 = 0.0
local rpm_n1_e2 = 0.0
-- State is now handled in throttle.lua via L-variables
local btn_idle_1      = false
local btn_idle_2      = false

-- Solenoid output handles
local solenoid_eng1 = hw_output_add(PIN_SOLENOID_ENG1, true)
local solenoid_eng2 = hw_output_add(PIN_SOLENOID_ENG2, true)

-- Create SI Variables for communication
local si_sol1 = si_variable_create("bell412_solenoid1", "BOOL", false)
local si_sol2 = si_variable_create("bell412_solenoid2", "BOOL", false)

local last_sol_1 = nil
local last_sol_2 = nil

-- Solenoid control moved to subscriptions at the bottom of the file

-- Timers for repeating events while held
local yaw_timer_rh = nil
local yaw_timer_lh = nil

-- =============================================================================
-- 3. UTILITY FUNCTIONS
-- =============================================================================

-- =============================================================================
-- 4. HARDWARE INPUTS (ANALOG)
-- =============================================================================

-- THROTTLE 1 (Commented out: throttle.lua handles this directly via Leo Bodnar)
-- hw_adc_input_add(PIN_THROTTLE1, function(val)
--     -- Direct pass-through of raw hardware value (0.0 - 1.0)
--     fsx_variable_write("L:throgas1", "Number", val or 0.0)
-- end)

-- THROTTLE 2 (Commented out: throttle.lua handles this directly via Leo Bodnar)
-- hw_adc_input_add(PIN_THROTTLE2, function(val)
--     -- Direct pass-through of raw hardware value (0.0 - 1.0)
--     fsx_variable_write("L:throgas2", "Number", val or 0.0)
-- end)

-- =============================================================================
-- 5. HARDWARE INPUTS (DIGITAL)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- START & IDLE STOP
-- -----------------------------------------------------------------------------
hw_button_add(PIN_START_ENG1,
    function() print("BTN: START ENG1"); fsx_variable_write("L:starteng", "Number", 1) end,
    function() fsx_variable_write("L:starteng", "Number", 0) end
)
hw_button_add(PIN_START_ENG2,
    function() print("BTN: START ENG2"); fsx_variable_write("L:starteng", "Number", -1) end,
    function() fsx_variable_write("L:starteng", "Number", 0) end
)

hw_button_add(PIN_IDLE_STOP_ENG1,
    function()
        btn_idle_1 = true
        print("BTN: Idle Stop 1 Pressed")
        -- Directly unlock the idle stop via SI variable
        si_variable_write(si_sol1, true)
        -- Force hardware update immediately (in case subscription ignores local write)
        hw_output_set(solenoid_eng1, true)
    end,
    function()
        btn_idle_1 = false
        print("BTN: Idle Stop 1 Released")
    end
)
hw_button_add(PIN_IDLE_STOP_ENG2,
    function()
        btn_idle_2 = true
        print("BTN: Idle Stop 2 Pressed")
        -- Directly unlock the idle stop via SI variable
        si_variable_write(si_sol2, true)
        -- Force hardware update immediately (in case subscription ignores local write)
        hw_output_set(solenoid_eng2, true)
    end,
    function()
        btn_idle_2 = false
        print("BTN: Idle Stop 2 Released")
    end
)

-- -----------------------------------------------------------------------------
-- RPM / GOVERNOR
-- -----------------------------------------------------------------------------
local function rpm_inc(pressed)
    if pressed then
        print("BTN: RPM INC")
        fsx_variable_write("L:GOVERNOR RPM SWITCH", "Number", 1)
        fsx_event("ROTOR_GOV_RPM_INC")
    else
        fsx_variable_write("L:GOVERNOR RPM SWITCH", "Number", 0)
    end
end

local function rpm_dec(pressed)
    if pressed then
        print("BTN: RPM DEC")
        fsx_variable_write("L:GOVERNOR RPM SWITCH", "Number", -1)
        fsx_event("ROTOR_GOV_RPM_DEC")
    else
        fsx_variable_write("L:GOVERNOR RPM SWITCH", "Number", 0)
    end
end

hw_button_add(PIN_RPM_INC_RH, function() rpm_inc(true) end, function() rpm_inc(false) end)
hw_button_add(PIN_RPM_DEC_RH, function() rpm_dec(true) end, function() rpm_dec(false) end)
hw_button_add(PIN_RPM_INC_LH, function() rpm_inc(true) end, function() rpm_inc(false) end)
hw_button_add(PIN_RPM_DEC_LH, function() rpm_dec(true) end, function() rpm_dec(false) end)

hw_button_add(PIN_RPM_PLUS2, function() print("BTN: RPM +2") end, function() end)
hw_button_add(PIN_RPM_MINUS2, function() print("BTN: RPM -2") end, function() end)

-- -----------------------------------------------------------------------------
-- GO AROUND (SimConnect K-Event: AUTO_THROTTLE_TO_GA)
-- -----------------------------------------------------------------------------
hw_button_add(PIN_GO_AROUND_RH,
    function()
        print("BTN: GO AROUND RH -> AUTO_THROTTLE_TO_GA")
        fsx_event("AUTO_THROTTLE_TO_GA")
    end,
    function() end
)
hw_button_add(PIN_GO_AROUND_LH,
    function()
        print("BTN: GO AROUND LH -> AUTO_THROTTLE_TO_GA")
        fsx_event("AUTO_THROTTLE_TO_GA")
    end,
    function() end
)

-- -----------------------------------------------------------------------------
-- LANDING LIGHT (SimConnect K-Events)
-- LDG_LT_LT: Toggle ON/OFF -> LANDING_LIGHTS_TOGGLE
-- LDG_LT_EXT: Extend -> LANDING_LIGHT_DOWN (while held)
-- LDG_LT_RETR: Retract -> LANDING_LIGHT_UP (while held)
-- -----------------------------------------------------------------------------
hw_button_add(PIN_LDG_LT_LT,
    function()
        print("BTN: LDG LIGHT LT -> LANDING_LIGHTS_TOGGLE")
        fsx_event("LANDING_LIGHTS_TOGGLE")
    end,
    function() end
)
hw_button_add(PIN_LDG_LT_EXT,
    function()
        print("BTN: LDG LT EXT -> LANDING_LIGHT_DOWN")
        fsx_event("LANDING_LIGHT_DOWN")
    end,
    function() end
)
hw_button_add(PIN_LDG_LT_RETR,
    function()
        print("BTN: LDG LT RETR -> LANDING_LIGHT_UP")
        fsx_event("LANDING_LIGHT_UP")
    end,
    function() end
)

-- -----------------------------------------------------------------------------
-- SEARCH LIGHT (SimConnect K-Events)
-- SRCH_LT_ON: Toggle ON/OFF -> SEARCH_LIGHTS_TOGGLE
-- SRCH_LT_EXT: Extend -> LANDING_LIGHT_DOWN (reuses landing light axis)
-- SRCH_LT_STOW/RETR: Retract -> LANDING_LIGHT_UP
-- SRCH_LT_L/R: Direction control (placeholder - no standard K-event)
-- -----------------------------------------------------------------------------
hw_button_add(PIN_SRCH_LT_ON,
    function()
        print("BTN: SRCH LT ON -> SEARCH_LIGHTS_TOGGLE")
        fsx_event("SEARCH_LIGHTS_TOGGLE")
    end,
    function() end
)
hw_button_add(PIN_SRCH_LT_EXT,
    function()
        print("BTN: SRCH LT EXT -> LANDING_LIGHT_DOWN")
        fsx_event("LANDING_LIGHT_DOWN")
    end,
    function() end
)
hw_button_add(PIN_SRCH_LT_RETR,
    function()
        print("BTN: SRCH LT RETR -> LANDING_LIGHT_UP")
        fsx_event("LANDING_LIGHT_UP")
    end,
    function() end
)
hw_button_add(PIN_SRCH_LT_STOW,
    function()
        print("BTN: SRCH LT STOW -> LANDING_LIGHT_UP")
        fsx_event("LANDING_LIGHT_UP")
    end,
    function() end
)
-- Search Light L/R: No standard K-event, debug only
hw_button_add(PIN_SRCH_LT_L, function() print("BTN: SRCH LT L (No K-event)") end, function() end)
hw_button_add(PIN_SRCH_LT_R, function() print("BTN: SRCH LT R (No K-event)") end, function() end)

-- -----------------------------------------------------------------------------
-- YAW TRIM (SimConnect K-Events: RUDDER_TRIM_LEFT / RUDDER_TRIM_RIGHT)
-- Fires repeatedly while held using timer
-- -----------------------------------------------------------------------------
hw_button_add(PIN_YAW_UP_RH,
    function()
        print("BTN: YAW UP RH -> RUDDER_TRIM_RIGHT")
        fsx_event("RUDDER_TRIM_RIGHT")
        yaw_timer_rh = timer_start(100, function() fsx_event("RUDDER_TRIM_RIGHT") end)
    end,
    function()
        if yaw_timer_rh then timer_stop(yaw_timer_rh); yaw_timer_rh = nil end
    end
)
hw_button_add(PIN_YAW_DOWN_RH,
    function()
        print("BTN: YAW DOWN RH -> RUDDER_TRIM_LEFT")
        fsx_event("RUDDER_TRIM_LEFT")
        yaw_timer_rh = timer_start(100, function() fsx_event("RUDDER_TRIM_LEFT") end)
    end,
    function()
        if yaw_timer_rh then timer_stop(yaw_timer_rh); yaw_timer_rh = nil end
    end
)
hw_button_add(PIN_YAW_UP_LH,
    function()
        print("BTN: YAW UP LH -> RUDDER_TRIM_RIGHT")
        fsx_event("RUDDER_TRIM_RIGHT")
        yaw_timer_lh = timer_start(100, function() fsx_event("RUDDER_TRIM_RIGHT") end)
    end,
    function()
        if yaw_timer_lh then timer_stop(yaw_timer_lh); yaw_timer_lh = nil end
    end
)
hw_button_add(PIN_YAW_DOWN_LH,
    function()
        print("BTN: YAW DOWN LH -> RUDDER_TRIM_LEFT")
        fsx_event("RUDDER_TRIM_LEFT")
        yaw_timer_lh = timer_start(100, function() fsx_event("RUDDER_TRIM_LEFT") end)
    end,
    function()
        if yaw_timer_lh then timer_stop(yaw_timer_lh); yaw_timer_lh = nil end
    end
)

-- =============================================================================
-- 6. SIMULATOR SUBSCRIPTIONS (A-vars for LED feedback)
-- =============================================================================

-- Landing Light State (for LED feedback)
fsx_variable_subscribe("A:LIGHT LANDING", "Bool", function(val)
    -- Add LED control here if needed
end)

-- Search Light State (for LED feedback)
fsx_variable_subscribe("A:LIGHT SEARCH", "Bool", function(val)
    -- Add LED control here if needed
end)

-- Rudder Trim Position (for debug)
fsx_variable_subscribe("A:RUDDER TRIM PCT", "Percent", function(val)
    -- Optional: Monitor rudder trim position for debug
end)

-- Go Around Active (for LED feedback)
fsx_variable_subscribe("A:AUTOPILOT TOGA ACTIVE", "Bool", function(val)
    -- Add LED control here if needed
end)

-- =============================================================================
-- 6.5 IDLE STOP SUBSCRIPTIONS (Driven by throttle.lua)
-- =============================================================================
local idle_1_released = false
local idle_2_released = false

si_variable_subscribe("bell412_solenoid1", "BOOL", function(val)
    print("DEBUG - SI Solenoid 1 changed to: " .. tostring(val))
    idle_1_released = val
    hw_output_set(solenoid_eng1, idle_1_released)
    
    -- Update L:idle eng for simulator sync
    if idle_1_released then
        fsx_variable_write("L:idle eng", "Number", 1)
    elseif not idle_2_released then
        fsx_variable_write("L:idle eng", "Number", 0)
    end
end)

si_variable_subscribe("bell412_solenoid2", "BOOL", function(val)
    print("DEBUG - SI Solenoid 2 changed to: " .. tostring(val))
    idle_2_released = val
    hw_output_set(solenoid_eng2, idle_2_released)
    
    -- Update L:idle eng for simulator sync
    if idle_2_released then
        fsx_variable_write("L:idle eng", "Number", -1)
    elseif not idle_1_released then
        fsx_variable_write("L:idle eng", "Number", 0)
    end
end)

-- =============================================================================
-- 7. INITIALIZATION
-- =============================================================================
fsx_variable_write("L:starteng", "Number", 0)
fsx_variable_write("L:idle eng", "Number", 0)
fsx_variable_write("L:GOVERNOR RPM SWITCH", "Number", 0)

fsx_variable_write("L:GOVERNOR RPM SWITCH", "Number", 0)
