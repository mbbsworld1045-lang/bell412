-- =============================================================================
-- BELL 412 - HYDRAULICS SYSTEM LOGIC
-- Platform: Air Manager + Arduino Mega 2560
-- Hardware: Arduino Channel B (Pedestal Panel)
-- Logic: Buttons Only (Active Low)
-- =============================================================================

-- =============================================================================
-- 1. HARDWARE CONFIGURATION HEADER
-- =============================================================================
-- INPUTS (Switches converted to Buttons) D40..D43
local PIN_CYC_CTR_LED_L     = "ARDUINO_MEGA2560_B_D42" -- Note: B_D42
local PIN_CYC_CTR_LED_R     = "ARDUINO_MEGA2560_B_D42" -- Note: B_D42 (Shared Pin)
local PIN_CYC_CTR_TEST_R    = "ARDUINO_MEGA2560_B_D32"
local PIN_CYC_CTR_TEST_L    = "ARDUINO_MEGA2560_B_D40"
local PIN_HYD1_SW           = "ARDUINO_MEGA2560_A_D39"
local PIN_HYD2_SW           = "ARDUINO_MEGA2560_A_D42"
local PIN_HYD1_FAIL_LED = "ARDUINO_MEGA2560_B_D46"
local PIN_HYD2_FAIL_LED = "ARDUINO_MEGA2560_B_D47"
local PIN_CYC_CTR_LED   = "ARDUINO_MEGA2560_B_D48"  -- Cyclic Centering Warning LED (stick off-center)

-- =============================================================================
-- 2. INITIALIZE HARDWARE LEDS
-- =============================================================================
local led_cyc_ctr_test_l = hw_led_add(PIN_CYC_CTR_LED_L, 0.0)  -- Cyclic Center Test Status LED Left
local led_cyc_ctr_test_r = hw_led_add(PIN_CYC_CTR_LED_R, 0.0)  -- Cyclic Center Test Status LED Right
local led_hyd1_h    = hw_led_add(PIN_HYD1_FAIL_LED, 0.0)
local led_hyd2_h    = hw_led_add(PIN_HYD2_FAIL_LED, 0.0)
local led_cyc_ctr_h = hw_led_add(PIN_CYC_CTR_LED, 0.0)  -- Cyclic Centering Warning LED

-- =============================================================================
-- 3. INTERNAL VARIABLES & CONSTANTS
-- =============================================================================
-- Physics Constants
local HYD_PRESS_NOMINAL = 2800.0
local HYD_PRESS_MIN     = 600.0
local HYD_ROTOR_MIN_RPM = 50.0
local CYC_CTR_THRESHOLD = 5.0  -- Percent deflection threshold

-- Local State (Switch Positions)
local sw_hyd1 = 0
local sw_hyd2 = 0
local btn_cyc_ch1_state = 0
local btn_cyc_ch2_state = 0

-- Sim Feedback Variables
local dc_bus        = 0
local rotor_rpm     = 0.0
local hyd1_pressure = 0.0
local hyd2_pressure = 0.0

-- Cyclic Centering Variables
local yoke_x_pos    = 0.0
local yoke_y_pos    = 0.0
local rotor_rpm_pct = 100.0

-- =============================================================================
-- 4. SYSTEM LOGIC FUNCTIONS
-- =============================================================================

-- LED UPDATE: ON if Switch OFF OR Pressure < 600 PSI
local function update_led_states()
    if dc_bus == 0 then
        hw_led_set(led_hyd1_h, 0.0)
        hw_led_set(led_hyd2_h, 0.0)
        return
    end
    local hyd1_fail = (sw_hyd1 == 0) or (hyd1_pressure < HYD_PRESS_MIN)
    local hyd2_fail = (sw_hyd2 == 0) or (hyd2_pressure < HYD_PRESS_MIN)

    hw_led_set(led_hyd1_h, hyd1_fail and 1.0 or 0.0)
    hw_led_set(led_hyd2_h, hyd2_fail and 1.0 or 0.0)
end

-- CYCLIC CENTERING WARNING LED: ON if stick off-center AND rotor RPM < 95%
local function update_cyc_ctr_led()
    if dc_bus == 0 then
        hw_led_set(led_cyc_ctr_h, 0.0)
        return
    end
    local abs_x = math.abs(yoke_x_pos)
    local abs_y = math.abs(yoke_y_pos)
    local off_center = (abs_x > CYC_CTR_THRESHOLD) or (abs_y > CYC_CTR_THRESHOLD)
    local low_rpm = (rotor_rpm_pct < 95.0)
    
    local led_on = off_center and low_rpm
    hw_led_set(led_cyc_ctr_h, led_on and 1.0 or 0.0)
end

-- CORE LOGIC: Calculate Hydraulic Pressure based on Rotor RPM
local function update_hydraulics_logic()
    if dc_bus == 0 then
        hyd1_pressure = 0.0
        hyd2_pressure = 0.0
    else
        -- Calculate RPM factor (0.0 to 1.0)
        local rpm_factor = 0.0
        if rotor_rpm >= HYD_ROTOR_MIN_RPM then
            rpm_factor = (rotor_rpm - HYD_ROTOR_MIN_RPM) / (100.0 - HYD_ROTOR_MIN_RPM)
            if rpm_factor > 1.0 then rpm_factor = 1.0 end
        end

        -- Pressure = Switch ON * RPM Factor * Nominal
        hyd1_pressure = (sw_hyd1 == 1) and (rpm_factor * HYD_PRESS_NOMINAL) or 0.0
        hyd2_pressure = (sw_hyd2 == 1) and (rpm_factor * HYD_PRESS_NOMINAL) or 0.0
    end

    -- Write to Simulator
    fsx_variable_write("L:HydPressure1", "Number", hyd1_pressure)
    fsx_variable_write("L:HydPressure2", "Number", hyd2_pressure)

    -- Update LEDs
    update_led_states()
end

-- =============================================================================
-- 5. HARDWARE INPUTS (BUTTONS)
-- =============================================================================

-- HYDRAULIC SYSTEM 1
hw_button_add(PIN_HYD1_SW,
    function() -- PRESSED (ON)
        print("ACTION: Hyd Sys 1 ON - Pin: " .. PIN_HYD1_SW)
        sw_hyd1 = 1
        fsx_variable_write("L:Sw hydsysA", "Number", 0)
        print("WRITE: L:Sw hydsysA = 0")
        update_hydraulics_logic()
    end,
    function() -- RELEASED (OFF)
        print("ACTION: Hyd Sys 1 OFF - Pin: " .. PIN_HYD1_SW)
        sw_hyd1 = 0
        fsx_variable_write("L:Sw hydsysA", "Number", 1)
        print("WRITE: L:Sw hydsysA = 1")
        update_hydraulics_logic()
end
)

-- HYDRAULIC SYSTEM 2
hw_button_add(PIN_HYD2_SW,
    function() -- PRESSED (ON)
        print("ACTION: Hyd Sys 2 ON - Pin: " .. PIN_HYD2_SW)
        sw_hyd2 = 1
        fsx_variable_write("L:Sw hydsysB", "Number", 1)
        print("WRITE: L:Sw hydsysB = 1")
        update_hydraulics_logic()
    end,
    function() -- RELEASED (OFF)
        print("ACTION: Hyd Sys 2 OFF - Pin: " .. PIN_HYD2_SW)
        sw_hyd2 = 0
        fsx_variable_write("L:Sw hydsysB", "Number", 0)
        print("WRITE: L:Sw hydsysB = 0")
        update_hydraulics_logic()
    end
)

-- CYCLIC CENTERING TEST BUTTON LEFT (Momentary)
hw_button_add(PIN_CYC_CTR_TEST_L,
    function() -- PRESSED
        print("ACTION: Cyclic Center Test Left PRESSED")
        btn_cyc_ch1_state = 1
        hw_led_set(led_cyc_ctr_test_l, (dc_bus == 1) and 1.0 or 0.0)
        -- Write 1 if EITHER button is pressed
        local val = (btn_cyc_ch1_state == 1 or btn_cyc_ch2_state == 1) and 1 or 0
        fsx_variable_write("L:Cyctest", "Number", val)
    end,
    function() -- RELEASED
        print("ACTION: Cyclic Center Test Left RELEASED")
        btn_cyc_ch1_state = 0
        hw_led_set(led_cyc_ctr_test_l, 0.0)
        -- Write 1 if EITHER button is pressed
        local val = (btn_cyc_ch1_state == 1 or btn_cyc_ch2_state == 1) and 1 or 0
        fsx_variable_write("L:Cyctest", "Number", val)
    end
)

-- CYCLIC CENTERING TEST BUTTON RIGHT (Momentary)
hw_button_add(PIN_CYC_CTR_TEST_R,
    function() -- PRESSED
        print("ACTION: Cyclic Center Test Right PRESSED")
        btn_cyc_ch2_state = 1
        hw_led_set(led_cyc_ctr_test_r, (dc_bus == 1) and 1.0 or 0.0)
        -- Write 1 if EITHER button is pressed
        local val = (btn_cyc_ch1_state == 1 or btn_cyc_ch2_state == 1) and 1 or 0
        fsx_variable_write("L:Cyctest", "Number", val)
    end,
    function() -- RELEASED
        print("ACTION: Cyclic Center Test Right RELEASED")
        btn_cyc_ch2_state = 0
        hw_led_set(led_cyc_ctr_test_r, 0.0)
        -- Write 1 if EITHER button is pressed
        local val = (btn_cyc_ch1_state == 1 or btn_cyc_ch2_state == 1) and 1 or 0
        fsx_variable_write("L:Cyctest", "Number", val)
    end
)

-- =============================================================================
-- 6. SIMULATOR SUBSCRIPTIONS (Data In -> Logic Update)
-- =============================================================================

-- Listen for DC Bus state
fsx_variable_subscribe("L:MasterDcBus", "Number", function(val)
    dc_bus = (val ~= 0) and 1 or 0
    update_hydraulics_logic()
end)

-- Listen for Rotor RPM (for hydraulic pressure calc)
fsx_variable_subscribe("A:Eng Rotor Rpm", "Percent", function(val)
    rotor_rpm = val or 0.0
    update_hydraulics_logic()
end)

-- Listen for Yoke Position and Rotor RPM (for cyclic centering warning LED)
fsx_variable_subscribe("A:YOKE X POSITION", "Percent", 
                       "A:YOKE Y POSITION", "Percent",
                       "ROTOR RPM PCT:1", "Percent",
    function(x, y, rpm)
        yoke_x_pos = x or 0.0
        yoke_y_pos = y or 0.0
        rotor_rpm_pct = rpm or 100.0
        update_cyc_ctr_led()
    end
)

-- Listen for Cyclic Center Test state (for status LEDs)
-- Listen for Cyclic Center Test state (Debug logging only, LEDs handled by buttons)
fsx_variable_subscribe("L:Cyctest", "Number", function(val)
    print("SUBSCRIBE: L:Cyctest = " .. tostring(val))
end)

-- =============================================================================
-- 7. STARTUP INITIALIZATION
-- =============================================================================
print("INIT: Hydraulics System - Initializing...")
print("INIT: PIN_HYD1_SW = " .. PIN_HYD1_SW)
print("INIT: PIN_HYD2_SW = " .. PIN_HYD2_SW)

fsx_variable_write("L:HydPressure1", "Number", 0.0)
fsx_variable_write("L:HydPressure2", "Number", 0.0)
fsx_variable_write("L:Sw hydsysA", "Number", 1)
fsx_variable_write("L:Sw hydsysB", "Number", 1)
fsx_variable_write("L:Cyctest", "Number", 0)

print("INIT: Hydraulics System - Initialization complete")

-- Run logic once at start
update_hydraulics_logic()
update_cyc_ctr_led()
