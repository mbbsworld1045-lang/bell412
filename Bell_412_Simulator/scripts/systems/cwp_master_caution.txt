-- =============================================================================
-- BELL 412 - CENTRAL WARNING PANEL (CWP) / MASTER CAUTION LOGIC
-- Platform: Air Manager + Arduino Mega 2560
-- Hardware: Arduino Channel C (Main Panel)
-- Logic: Buttons Only (Active Low)
-- =============================================================================

-- =============================================================================
-- 1. HARDWARE CONFIGURATION HEADER
-- =============================================================================
-- INPUTS (Buttons) D10..D13
local PIN_TEST_PNL_POS1 = "ARDUINO_MEGA2560_C_D10"  -- MC Test Panel Position 1
local PIN_TEST_PNL_POS2 = "ARDUINO_MEGA2560_C_D13"  -- MC Test Panel Position 2
local PIN_TEST_LT   = "ARDUINO_MEGA2560_C_D11"
local PIN_RESET     = "ARDUINO_MEGA2560_C_D12"

-- OUTPUTS (LEDs) D40
local PIN_MC_LED    = "ARDUINO_MEGA2560_C_D40"

-- =============================================================================
-- 2. INITIALIZE HARDWARE LEDS
-- =============================================================================
local led_mc_h = hw_led_add(PIN_MC_LED, 0.0)

-- =============================================================================
-- 3. INTERNAL VARIABLES & CONSTANTS
-- =============================================================================
-- Test Button States
local test_pnl_pos1_pressed = false  -- MC Test Panel Position 1
local test_pnl_pos2_pressed = false  -- MC Test Panel Position 2
local test_lt_held  = false
local mc_test       = 0

-- Sim Feedback Variables
local dc_bus           = 0
local genmast          = 0
local batt1_sw         = 0
local batt2_sw         = 0
local gen1_producing   = 0
local gen2_producing   = 0
local hyd1_pressure    = 0.0
local hyd2_pressure    = 0.0
local hyd1_sw          = 0
local hyd2_sw          = 0
local oil1_psi         = 999
local oil2_psi         = 999
local rotor_rpm        = 100
local fuel_center_pct  = 100
local rotor_brake      = 0
local fire1_pull       = 0
local fire2_pull       = 0
local fire_test        = 0
local xmsn_press_warn  = 0
local xmsn_temp_warn   = 0
local cbox_press_warn  = 0
local gov_a_warn       = 0
local gov_b_warn       = 0
local xmsn_chip_warn   = 0
local inv1_sw          = 0
local inv2_sw          = 0
local fuel_valve1_pos  = 0.0
local fuel_valve2_pos  = 0.0
local fuel_valve1_cmd  = 0
local fuel_valve2_cmd  = 0

-- =============================================================================
-- 4. SYSTEM LOGIC FUNCTIONS
-- =============================================================================

-- FUEL VALVE WARNING: Check for transit or mismatch
local function fuel_valve_warning()
    local v1_transit = (fuel_valve1_pos > 0.01) and (fuel_valve1_pos < 0.99)
    local v2_transit = (fuel_valve2_pos > 0.01) and (fuel_valve2_pos < 0.99)

    local v1_mismatch = (fuel_valve1_cmd == 1 and fuel_valve1_pos < 0.99) or
                        (fuel_valve1_cmd == 0 and fuel_valve1_pos > 0.01)
    local v2_mismatch = (fuel_valve2_cmd == 1 and fuel_valve2_pos < 0.99) or
                        (fuel_valve2_cmd == 0 and fuel_valve2_pos > 0.01)

    return (v1_transit or v2_transit or v1_mismatch or v2_mismatch) and 1 or 0
end

-- MASTER CAUTION LED: Update based on all caution conditions
local function update_master_caution()
    local any_caution = false

    -- No power = LED OFF
    if dc_bus == 0 then
        hw_led_set(led_mc_h, 0.0)
        return
    end

    -- Test Mode = LED ON
    if mc_test ~= 0 then
        hw_led_set(led_mc_h, 1.0)
        return
    end

    -- Battery Caution: Batts ON but no generators/GPU
    local batts_on = (batt1_sw == 1) and (batt2_sw == 1)
    if batts_on and (genmast == 0) then any_caution = true end

    -- Generator Fails
    if gen1_producing == 0 then any_caution = true end
    if gen2_producing == 0 then any_caution = true end

    -- Hydraulic Fails: Switch OFF OR Pressure < 600
    if (hyd1_pressure < 600.0) or (hyd1_sw == 0) then any_caution = true end
    if (hyd2_pressure < 600.0) or (hyd2_sw == 0) then any_caution = true end

    -- Oil Pressure Low
    if oil1_psi < 50 then any_caution = true end
    if oil2_psi < 50 then any_caution = true end

    -- Rotor RPM Out of Range
    if (rotor_rpm <= 95) or (rotor_rpm >= 105) then any_caution = true end

    -- Low Fuel
    if fuel_center_pct < 9.2 then any_caution = true end

    -- Rotor Brake Active
    if rotor_brake == 1 then any_caution = true end

    -- Fire Handle / Test
    if fire1_pull == 1 or fire_test == 1 then any_caution = true end
    if fire2_pull == 1 or fire_test == 1 then any_caution = true end

    -- XMSN/CBOX Warnings
    if xmsn_press_warn == 1 then any_caution = true end
    if xmsn_temp_warn == 1 then any_caution = true end
    if cbox_press_warn == 1 then any_caution = true end

    -- Governor Warnings
    if gov_a_warn == 1 then any_caution = true end
    if gov_b_warn == 1 then any_caution = true end
    if xmsn_chip_warn == 1 then any_caution = true end

    -- Fuel Valve Transit/Mismatch
    if fuel_valve_warning() == 1 then any_caution = true end

    -- Inverter Fails
    if inv1_sw == 0 then any_caution = true end
    if inv2_sw == 0 then any_caution = true end

    -- Set LED
    hw_led_set(led_mc_h, any_caution and 1.0 or 0.0)
end

-- TEST PANEL SWITCH: Update state based on two position pins (3-position: 0=OFF, 1=Position 1, -1=Position 2)
local function update_test_panel_state()
    local new_state = 0
    
    if test_pnl_pos1_pressed then
        new_state = 1  -- Position 1 (D10)
    elseif test_pnl_pos2_pressed then
        new_state = -1  -- Position 2 (D13)
    else
        new_state = 0  -- OFF (both released)
    end
    
    -- Update mc_test if state changed (test panel has priority over TEST_LT)
    if mc_test ~= new_state then
        mc_test = new_state
        fsx_variable_write("L:TestMC", "Number", mc_test)
        print("TEST PANEL: State changed to " .. tostring(mc_test))
        update_master_caution()
    end
end

-- TEST SWITCH: Update test mode state (for TEST_LT button - only if test panel is not active)
local function update_test_switch()
    -- Test panel switch has priority - only update if test panel is OFF
    if not test_pnl_pos1_pressed and not test_pnl_pos2_pressed then
        if test_lt_held then
            mc_test = 2
        else
            mc_test = 0
        end
        fsx_variable_write("L:TestMC", "Number", mc_test)
        update_master_caution()
    end
end

-- =============================================================================
-- 5. HARDWARE INPUTS (BUTTONS)
-- =============================================================================

-- MC TEST PANEL SWITCH (3-Position: 0=OFF, 1=Position 1 (D10), -1=Position 2 (D13))
-- Position 1 Button (D10 -> State = 1)
hw_button_add(PIN_TEST_PNL_POS1,
    function() -- PRESSED (Position 1)
        print("ACTION: MC Test Panel -> Position 1 (State = 1)")
        test_pnl_pos1_pressed = true
        update_test_panel_state()
    end,
    function() -- RELEASED
        print("ACTION: MC Test Panel Position 1 RELEASED")
        test_pnl_pos1_pressed = false
        update_test_panel_state()
    end
)

-- Position 2 Button (D13 -> State = -1)
hw_button_add(PIN_TEST_PNL_POS2,
    function() -- PRESSED (Position 2)
        print("ACTION: MC Test Panel -> Position 2 (State = -1)")
        test_pnl_pos2_pressed = true
        update_test_panel_state()
    end,
    function() -- RELEASED
        print("ACTION: MC Test Panel Position 2 RELEASED")
        test_pnl_pos2_pressed = false
        update_test_panel_state()
    end
)

-- MC TEST LT (Momentary Down)
hw_button_add(PIN_TEST_LT,
    function() -- PRESSED
        print("ACTION: MC Test LT PRESSED")
        test_lt_held = true
        fsx_variable_write("L:TestMC", "Number", 2)
        update_test_switch()
    end,
    function() -- RELEASED
        print("ACTION: MC Test LT RELEASED")
        test_lt_held = false
        fsx_variable_write("L:TestMC", "Number", 0)
        update_test_switch()
    end
)

-- MC RESET (Momentary)
hw_button_add(PIN_RESET,
    function() -- PRESSED
        print("ACTION: MC Reset PRESSED")
        fsx_variable_write("L:ResetMC", "Number", 1)
    end,
    function() -- RELEASED
        print("ACTION: MC Reset RELEASED")
        fsx_variable_write("L:ResetMC", "Number", 0)
    end
)

-- =============================================================================
-- 6. SIMULATOR SUBSCRIPTIONS (Data In -> LED Update)
-- =============================================================================

-- DC Bus
fsx_variable_subscribe("L:MasterDcBus", "Number", function(val)
    dc_bus = (val ~= 0) and 1 or 0
    update_master_caution()
end)

-- Test Mode (from Sim/Other sources)
fsx_variable_subscribe("L:TestMC", "Number", function(val)
    -- Only update if buttons are not being held
    if not test_pnl_pos1_pressed and not test_pnl_pos2_pressed and not test_lt_held then
        local new_state = val or 0
        if mc_test ~= new_state then
            mc_test = new_state
            update_master_caution()
            print("SUBSCRIBE: L:TestMC = " .. tostring(val))
        end
    end
end)

-- Battery Switches
fsx_variable_subscribe("L:Swbatta", "Number", "L:Swbattb", "Number", function(sw1, sw2)
    batt1_sw = (sw1 ~= 0) and 1 or 0
    batt2_sw = (sw2 ~= 0) and 1 or 0
    update_master_caution()
end)

-- Generator Status
fsx_variable_subscribe("L:CGenel", "Number", function(val)
    gen1_producing = (val ~= 0) and 1 or 0
    update_master_caution()
end)

fsx_variable_subscribe("L:CGener", "Number", function(val)
    gen2_producing = (val ~= 0) and 1 or 0
    update_master_caution()
end)

-- Generator Master
fsx_variable_subscribe("L:Genmast", "Number", function(val)
    genmast = (val ~= 0) and 1 or 0
    update_master_caution()
end)

-- Hydraulic Pressures
fsx_variable_subscribe("L:HydPressure1", "Number", function(val)
    hyd1_pressure = val or 0.0
    update_master_caution()
end)

fsx_variable_subscribe("L:HydPressure2", "Number", function(val)
    hyd2_pressure = val or 0.0
    update_master_caution()
end)

-- Hydraulic Switches
fsx_variable_subscribe("L:Sw hydsysA", "Number", function(val)
    hyd1_sw = (val ~= 0) and 1 or 0
    update_master_caution()
end)

fsx_variable_subscribe("L:Sw hydsysB", "Number", function(val)
    hyd2_sw = (val ~= 0) and 1 or 0
    update_master_caution()
end)

-- Oil Pressures
fsx_variable_subscribe("L:OILE1", "Number", function(val)
    oil1_psi = val or 0
    update_master_caution()
end)

fsx_variable_subscribe("L:OILE2", "Number", function(val)
    oil2_psi = val or 0
    update_master_caution()
end)

-- Rotor RPM
fsx_variable_subscribe("ROTOR RPM PCT:1", "Percent", function(val)
    rotor_rpm = val or 0
    update_master_caution()
end)

-- Fuel Level
fsx_variable_subscribe("FUEL TANK CENTER LEVEL", "Percent", function(val)
    fuel_center_pct = val or 0
    update_master_caution()
end)

-- XMSN/CBOX Warnings
fsx_variable_subscribe("L:XmsnPressWarn", "Number", function(val)
    xmsn_press_warn = (val == 1) and 1 or 0
    update_master_caution()
end)

fsx_variable_subscribe("L:XmsnTempWarn", "Number", function(val)
    xmsn_temp_warn = (val == 1) and 1 or 0
    update_master_caution()
end)

fsx_variable_subscribe("L:CboxPressWarn", "Number", function(val)
    cbox_press_warn = (val == 1) and 1 or 0
    update_master_caution()
end)

-- Rotor Brake
fsx_variable_subscribe("A:Rotor Brake Active", "Bool", function(val)
    rotor_brake = (val and 1 or 0)
    update_master_caution()
end)

-- Fire Handles
fsx_variable_subscribe("L:firethandl", "Number", function(val)
    fire1_pull = (val ~= 0) and 1 or 0
    update_master_caution()
end)

fsx_variable_subscribe("L:firethandr", "Number", function(val)
    fire2_pull = (val ~= 0) and 1 or 0
    update_master_caution()
end)

fsx_variable_subscribe("L:Swfiretest", "Bool", function(val)
    fire_test = (val and 1 or 0)
    update_master_caution()
end)

-- Governor Warnings
fsx_variable_subscribe("L:SwGovA", "Bool", function(val)
    gov_a_warn = (val and 1 or 0)
    update_master_caution()
end)

fsx_variable_subscribe("L:SwGovB", "Bool", function(val)
    gov_b_warn = (val and 1 or 0)
    update_master_caution()
end)

fsx_variable_subscribe("L:XMSN CHIP", "Bool", function(val)
    xmsn_chip_warn = (val and 1 or 0)
    update_master_caution()
end)

-- Inverter Switches
fsx_variable_subscribe("L:Swinva", "Bool", function(val)
    inv1_sw = (val and 1 or 0)
    update_master_caution()
end)

fsx_variable_subscribe("L:Swinvb", "Bool", function(val)
    inv2_sw = (val and 1 or 0)
    update_master_caution()
end)

-- Fuel Valve Positions
fsx_variable_subscribe("L:FuelValve1Pos", "Number", "L:FuelValve2Pos", "Number", function(p1, p2)
    fuel_valve1_pos = p1 or 0.0
    fuel_valve2_pos = p2 or 0.0
    update_master_caution()
end)

-- Fuel Valve Commands
fsx_variable_subscribe("L:SwvalveEng1", "Number", "L:SwvalveEng2", "Number", function(c1, c2)
    fuel_valve1_cmd = (c1 ~= 0) and 1 or 0
    fuel_valve2_cmd = (c2 ~= 0) and 1 or 0
    update_master_caution()
end)

-- =============================================================================
-- 7. STARTUP INITIALIZATION
-- =============================================================================
fsx_variable_write("L:TestMC", "Number", 0)

-- Initialize test panel state
update_test_panel_state()

-- Run logic once at start
update_master_caution()
