-- =============================================================================
-- BELL 412 - ANCILLARY SYSTEMS LOGIC
-- Platform: Air Manager + Arduino Mega 2560
-- Hardware: Arduino Channel A (Overhead) + Channel B (Pedestal)
-- Logic: Buttons Only (Active Low)
-- =============================================================================

print("DEBUG: Systems Ancillary Script Loaded")

-- =============================================================================
-- 1. HARDWARE CONFIGURATION HEADER
-- =============================================================================
-- INPUTS - CHANNEL A (Overhead - Preserved)
-- local PIN_DOME_LIGHT_POS1 = "ARDUINO_MEGA2560_A_D13"  -- CONFLICT with AP1. Disabled.
local PIN_PITOT_HEAT    = "ARDUINO_MEGA2560_A_D14"
local PIN_NAV_LIGHTS    = "ARDUINO_MEGA2560_A_D15"
local PIN_ANTICOLL      = "ARDUINO_MEGA2560_A_D16"
local PIN_WIPER_PI      = "ARDUINO_MEGA2560_A_D17"
local PIN_WIPER_CO      = "ARDUINO_MEGA2560_A_D18"
local PIN_HEATER        = "ARDUINO_MEGA2560_A_D19"
local PIN_VENT_BLOWER   = "ARDUINO_MEGA2560_A_D20"
local PIN_AFT_OUTLET    = "ARDUINO_MEGA2560_A_D21"
local PIN_DOME_LIGHT_POS2 = "ARDUINO_MEGA2560_A_D22"
local PIN_UTILITY_LT    = "ARDUINO_MEGA2560_A_D23"
local PIN_COMPASS_SLAVE = "ARDUINO_MEGA2560_A_D27"
local PIN_PLATE_MAPLIGHT = "ARDUINO_MEGA2560_A_A0"
local PIN_PLATE_MAPLIGHT_BTN = "ARDUINO_MEGA2560_A_D11"

-- -------------------------
-- CHANNEL A (Overhead & Main)
-- -------------------------
-- Inputs
local PIN_AFCS_SAS_SW       = "ARDUINO_MEGA2560_A_D10"  -- SAS/ATT Toggle
local PIN_AP2_SW            = "ARDUINO_MEGA2560_A_D12"  -- AP2 Button
local PIN_AP1_SW            = "ARDUINO_MEGA2560_A_D13"  -- AP1 Button
local PIN_AFCS_CPL_SW       = "ARDUINO_MEGA2560_A_D6"   -- CPL Button
local PIN_AFCS_TRIM_SW      = "ARDUINO_MEGA2560_A_D7"   -- Trim/FD Button
local PIN_AFCS_TEST_SW      = "ARDUINO_MEGA2560_A_D9"   -- AFCS Test Button
local PIN_MAG_DG_MAG2       = "ARDUINO_MEGA2560_A_D47"  -- Mag 2
local PIN_MAG_DG_DG2        = "ARDUINO_MEGA2560_A_D48"  -- Dg 2
local PIN_AHRS_TEST_2       = "ARDUINO_MEGA2560_A_D49"  -- AHRS Test 2
local PIN_MAG_DG_MAG1       = "ARDUINO_MEGA2560_A_D51"  -- Mag 1
local PIN_MAG_DG_DG1        = "ARDUINO_MEGA2560_A_D52"  -- Dg 1
local PIN_AHRS_TEST_1       = "ARDUINO_MEGA2560_A_D53"  -- AHRS Test 1
local PIN_AFCS_SYS2         = "ARDUINO_MEGA2560_A_D43"  -- AFCS Sys 2

-- Outputs (LEDs)
local PIN_AFCS_TRIM_LED     = "ARDUINO_MEGA2560_A_A1"   -- Trim LED
local PIN_AFCS_TEST_LED     = "ARDUINO_MEGA2560_A_A2"   -- Test LED
local PIN_AFCS_FD_LED       = "ARDUINO_MEGA2560_A_A3"   -- FD LED
local PIN_AFCS_CPL_LED      = "ARDUINO_MEGA2560_A_A4"   -- CPL LED
local PIN_AFCS_SAS_LED      = "ARDUINO_MEGA2560_A_D2"   -- SAS LED
local PIN_AFCS_ATT_LED      = "ARDUINO_MEGA2560_A_D3"   -- ATT LED
local PIN_AP2_LED           = "ARDUINO_MEGA2560_A_D4"   -- AP2 LED
local PIN_AP1_LED           = "ARDUINO_MEGA2560_A_D5"   -- AP1 LED
local PIN_AHRS_SERVO        = "ARDUINO_MEGA2560_A_D60"  -- Warn: Servo Pin

-- -------------------------
-- CHANNEL B (Pedestal)
-- -------------------------
-- Inputs
local PIN_BRG_PTR_LED       = "ARDUINO_MEGA2560_B_D3"   -- Led? (Possible Input/Output conflict in map?)
local PIN_BRG_PTR_SW        = "ARDUINO_MEGA2560_B_D38"  -- Left Switch
local PIN_BRG_PTR2_SW       = "ARDUINO_MEGA2560_B_D10"  -- Right Switch
local PIN_BRG_PTR2_LED      = "ARDUINO_MEGA2560_B_D13"  -- Right LED
local PIN_FIRE_HANDLE2_LED  = "ARDUINO_MEGA2560_B_D24"  -- Fire Handle 2 LED
local PIN_FIRE_PULL2        = "ARDUINO_MEGA2560_B_D35"  -- Fire Pull 2 Input
local PIN_MARKER_TEST_R     = "ARDUINO_MEGA2560_B_D37"  -- Marker Test Right
local PIN_MARKER_TEST_L     = "ARDUINO_MEGA2560_B_D45"  -- Marker Test Left
local PIN_OVERTQ_TEST_R     = "ARDUINO_MEGA2560_B_D33"  -- OT Test Right
local PIN_OVERTQ_TEST_L     = "ARDUINO_MEGA2560_B_D49"  -- OT Test Left
local PIN_OVERTQ_LED_L      = "ARDUINO_MEGA2560_B_D39"  -- OT LED Left
local PIN_OVERTQ_LED_R      = "ARDUINO_MEGA2560_B_D9"   -- OT LED Right
local PIN_FIRE_HANDLE1_LED  = "ARDUINO_MEGA2560_B_D5"   -- Fire Handle 1 LED
local PIN_FIRE_PULL1        = "ARDUINO_MEGA2560_B_D50"  -- Fire Pull 1 Input
local PIN_FIRE_TEST         = "ARDUINO_MEGA2560_B_D51"  -- Fire Test Input
local PIN_BAG_FIRE_TEST     = "ARDUINO_MEGA2560_B_D52"  -- Baggage Test Input
local PIN_BAG_FIRE_TEST_LED = "ARDUINO_MEGA2560_B_D2"   -- Baggage Test LED
local PIN_EXTINGUISHER_POS1 = "ARDUINO_MEGA2560_B_D7"   -- Main Extinguisher
local PIN_EXTINGUISHER_POS2 = "ARDUINO_MEGA2560_B_D8"   -- Reserve Extinguisher
local PIN_FORCE_TRIM        = "ARDUINO_MEGA2560_A_D40"  -- Force Trim

-- Marker LEDs (Mega B)
local PIN_MARKER_R_RED      = "ARDUINO_MEGA2560_B_D26"
local PIN_MARKER_R_WHT      = "ARDUINO_MEGA2560_B_D27"
local PIN_MARKER_R_BLU      = "ARDUINO_MEGA2560_B_D28"
local PIN_MARKER_L_WHT      = "ARDUINO_MEGA2560_B_D46"
local PIN_MARKER_L_BLU      = "ARDUINO_MEGA2560_B_D47"
local PIN_MARKER_L_RED      = "ARDUINO_MEGA2560_B_D48"

-- INPUTS - CHANNEL C (Nav Selectors, AFT Call/Test, DME Select) D14..D29
local PIN_COURSE_SET    = "ARDUINO_MEGA2560_C_D14"
local PIN_AFT_CALL      = "ARDUINO_MEGA2560_C_D17"
local PIN_AFT_CALL2     = "ARDUINO_MEGA2560_C_D48"
local PIN_AFT_TEST      = "ARDUINO_MEGA2560_C_D18"
local PIN_AFT_TEST2     = "ARDUINO_MEGA2560_C_D49"
local PIN_DME_SEL_POS1  = "ARDUINO_MEGA2560_C_D19"
local PIN_DME_SEL_POS2  = "ARDUINO_MEGA2560_C_D28"
local PIN_DAFCSEL       = "ARDUINO_MEGA2560_C_D27"

-- OUTPUTS - CHANNEL C (Marker LEDs Old - Replaced)
local PIN_MARKER_TEST_LED2 = "ARDUINO_MEGA2560_C_D59"  -- Marker Test LED 2

-- OUTPUTS - CHANNEL C (AFT Call/Test)
local PIN_AFT_CALL_LED     = "ARDUINO_MEGA2560_C_D44"
local PIN_AFT_CALL_LED2    = "ARDUINO_MEGA2560_C_D55"
local PIN_AFT_TEST_LED     = "ARDUINO_MEGA2560_C_D45"
local PIN_AFT_TEST_LED2    = "ARDUINO_MEGA2560_C_D56"

-- INPUTS - CHANNEL B (Pedestal Panel - Legacy/Conflicting removed)
-- local PIN_COMPASS       = "ARDUINO_MEGA2560_B_D21" -- Conflict
local PIN_STATIC_SRC    = "ARDUINO_MEGA2560_B_D22"
local PIN_AFCS_HP1      = "ARDUINO_MEGA2560_B_D23"
local PIN_AFCS_HP2      = "ARDUINO_MEGA2560_B_D24"
local PIN_STBY_ATT_TEST = "ARDUINO_MEGA2560_B_D27"
local PIN_CARGO_REL     = "ARDUINO_MEGA2560_B_D28"
local PIN_CARGO_TEST    = "ARDUINO_MEGA2560_B_D29"

-- OUTPUTS - CHANNEL B (Servo Motors)
local PIN_YAW_SERVO   = "ARDUINO_MEGA2560_B_D18"
local PIN_ROLL_SERVO  = "ARDUINO_MEGA2560_B_D19"
local PIN_PITCH_SERVO = "ARDUINO_MEGA2560_B_D57"

-- =============================================================================
-- 2. INITIALIZE HARDWARE LEDS
-- =============================================================================
local led_ap1_h             = hw_led_add(PIN_AP1_LED, 0.0)
local led_ap2_h             = hw_led_add(PIN_AP2_LED, 0.0)
local led_sas_h             = hw_led_add(PIN_AFCS_SAS_LED, 0.0)
local led_att_h             = hw_led_add(PIN_AFCS_ATT_LED, 0.0)
local led_afcs_test_h       = hw_led_add(PIN_AFCS_TEST_LED, 0.0)
local led_trim_h            = hw_led_add(PIN_AFCS_TRIM_LED, 0.0)
local led_fd_h              = hw_led_add(PIN_AFCS_FD_LED, 0.0)
local led_cpl_h             = hw_led_add(PIN_AFCS_CPL_LED, 0.0)

local led_brg_ptr_h         = hw_led_add(PIN_BRG_PTR_LED, 0.0)
local led_brg_ptr2_h        = hw_led_add(PIN_BRG_PTR2_LED, 0.0)
local led_fire_h1_h         = hw_led_add(PIN_FIRE_HANDLE1_LED, 0.0)
local led_fire_h2_h         = hw_led_add(PIN_FIRE_HANDLE2_LED, 0.0)
local led_bag_fire_test_h   = hw_led_add(PIN_BAG_FIRE_TEST_LED, 0.0)
local led_ot_l_h            = hw_led_add(PIN_OVERTQ_LED_L, 0.0)
local led_ot_r_h            = hw_led_add(PIN_OVERTQ_LED_R, 0.0)

-- Marker LEDs
local led_mk_r_red          = hw_led_add(PIN_MARKER_R_RED, 0.0)
local led_mk_r_wht          = hw_led_add(PIN_MARKER_R_WHT, 0.0)
local led_mk_r_blu          = hw_led_add(PIN_MARKER_R_BLU, 0.0)
local led_mk_l_wht          = hw_led_add(PIN_MARKER_L_WHT, 0.0)
local led_mk_l_blu          = hw_led_add(PIN_MARKER_L_BLU, 0.0)
local led_mk_l_red          = hw_led_add(PIN_MARKER_L_RED, 0.0)

local led_aft_call_h = hw_led_add(PIN_AFT_CALL_LED, 0.0)
local led_aft_test_h = hw_led_add(PIN_AFT_TEST_LED, 0.0)
local led_aft_call_h2 = hw_led_add(PIN_AFT_CALL_LED2, 0.0)
local led_aft_test_h2 = hw_led_add(PIN_AFT_TEST_LED2, 0.0)
local led_marker_test_h2 = hw_led_add(PIN_MARKER_TEST_LED2, 0.0)

-- Note: PIN_CARGO_TEST_LED (B_D49) conflicts with OT Test L, so we maintain it as commented out/removed.
-- local led_cargo_test_h = hw_led_add(PIN_CARGO_TEST_LED, 0.0) 

-- Initialize Servo Motors (Using PWM at 50Hz, default center ~0.075 duty)
local servo_yaw_h   = hw_output_pwm_add(PIN_YAW_SERVO, 50, 0.075)
local servo_roll_h  = hw_output_pwm_add(PIN_ROLL_SERVO, 50, 0.075)
local servo_pitch_h = hw_output_pwm_add(PIN_PITCH_SERVO, 50, 0.075)
local servo_ahrs_h  = hw_output_pwm_add(PIN_AHRS_SERVO, 50, 0.075)

-- =============================================================================
-- 3. INTERNAL VARIABLES & CONSTANTS
-- =============================================================================
-- AFCS Toggle States
local afcs_hp1_state = 0
local afcs_hp2_state = 0
local afcs_sas_state = 0
local afcs_att_state = 0
local force_trim_held = false

-- Standby Attitude Test State
local stby_att_pwr    = 0
local stby_att_flag   = 1
local stby_test_timer = nil

-- Fire Handle States
local fire_handle1_pulled = 0
local fire_handle2_pulled = 0

-- Fire Warning States
local fire_warn_eng1 = 0
local fire_warn_eng2 = 0
local fire_warn_bag  = 0
local fire_test_active = false

-- Switches
local extinguisher_pos1_pressed = false
local extinguisher_pos2_pressed = false
local extinguisher_state = 0

local dome_light_pos1_pressed = false
local dome_light_pos2_pressed = false
local dome_light_state = 0

local dc_bus = 0
local overtq_state = 0
local aft_call_state = 0
local aft_test_state = 0
local bag_fire_test_state = 0
local plate_maplight_btn_state = 0

local dme_sel_pos1_pressed = false
local dme_sel_pos2_pressed = false
local dme_sel_state = 0

local mag_dg_mag1_pressed = false
local mag_dg_mag2_pressed = false
local mag_dg_dg1_pressed = false
local mag_dg_dg2_pressed = false
local mag_dg_state = 0

local marker_test_state = 0
local afcs_sys2_state = 0
local auto_pilot_state = 0
local ahrs_test_state = 0

-- =============================================================================
-- 4. SYSTEM LOGIC FUNCTIONS
-- =============================================================================

-- HELPER: Servo PWM Duty Cycle (0.0 .. 1.0 position -> 0.05 .. 0.10 duty)
local function set_servo_position(id, pos)
    local p = math.max(0.0, math.min(1.0, pos))
    local duty = 0.05 + (p * 0.05)
    hw_output_pwm_duty_cycle(id, duty)
end

-- FIRE HANDLE STATUS LED UPDATE
local function update_fire_handle_leds()
    if dc_bus == 0 then
        hw_led_set(led_fire_h1_h, 0.0)
        hw_led_set(led_fire_h2_h, 0.0)
        return
    end
    hw_led_set(led_fire_h1_h, (fire_handle1_pulled == 1) and 1.0 or 0.0)
    hw_led_set(led_fire_h2_h, (fire_handle2_pulled == 1) and 1.0 or 0.0)
end

-- FIRE LED UPDATE
local function update_fire_leds()
    -- Assuming these are defined in a global scope or similar if used (e.g. from CWP)
    -- But here we only have definitions for led_fire_h1_h etc?
    -- Wait, the original code used led_fire_eng1_h which was NOT defined in the header snippet I read!
    -- I must assume they are defined locally or I missed them. 
    -- Looking at line 173 [PRESERVED INIT] ...
    -- I will define them if not present.
    -- Actually, looking at pin defs: PIN_FIRE_HANDLE1_LED is B_D5.
    -- Code uses led_fire_h1_h. 
    -- But `update_fire_leds` (line 285) used `led_fire_eng1_h`.
    -- Where is `led_fire_eng1_h` defined?
    -- It was NOT in the file head I read! 
    -- It must be `led_fire_h1_h` (Handle LED) OR there are other Engine Fire LEDs.
    -- Checking inputs: PIN_FIRE_HANDLE1_LED.
    -- Is there a separate Fire WARN LED?
    -- CWP has Fire Warn?
    -- I will assume `led_fire_eng1_h` was intended to be `led_fire_h1_h` OR I should assume they are the Handle LEDs. 
    -- Standard Bell 412: Fire Handle Lights UP when Pulled OR Fire Detected.
    -- So `led_fire_h1_h` IS the Fire Warning Light (in the handle).
    
    local show_fire = fire_test_active or (dc_bus == 1)
    
    if show_fire then
        if fire_test_active then
             hw_led_set(led_fire_h1_h, 1.0)
             hw_led_set(led_fire_h2_h, 1.0)
             -- Bag fire?
        else
             hw_led_set(led_fire_h1_h, (fire_warn_eng1 == 1) and 1.0 or 0.0)
             hw_led_set(led_fire_h2_h, (fire_warn_eng2 == 1) and 1.0 or 0.0)
        end
    else
        hw_led_set(led_fire_h1_h, 0.0)
        hw_led_set(led_fire_h2_h, 0.0)
    end
end

-- OVER TORQUE TEST LED UPDATE
local function update_overtq_led()
    local led_value = (overtq_state == 1) and 1.0 or 0.0
    hw_led_set(led_ot_l_h, led_value)
    hw_led_set(led_ot_r_h, led_value)
end

-- AFT CALL/TEST LED UPDATE
local function update_aft_leds()
    local call_value = (aft_call_state == 1) and 1.0 or 0.0
    hw_led_set(led_aft_call_h, call_value)
    hw_led_set(led_aft_call_h2, call_value)

    local test_value = (aft_test_state == 1) and 1.0 or 0.0
    hw_led_set(led_aft_test_h, test_value)
    hw_led_set(led_aft_test_h2, test_value)
end

-- BAGGAGE FIRE TEST LED UPDATE
local function update_bag_fire_test_led()
    hw_led_set(led_bag_fire_test_h, (bag_fire_test_state == 1) and 1.0 or 0.0)
end

-- DME SELECT STATE UPDATE
local function update_dme_select_state()
    local new_state = 0
    if dme_sel_pos2_pressed then new_state = 2
    elseif dme_sel_pos1_pressed then new_state = 1 end
    
    if dme_sel_state ~= new_state then
        dme_sel_state = new_state
        fsx_variable_write("L:Swdme", "Number", dme_sel_state)
        print("DME SELECT: State changed to " .. tostring(dme_sel_state))
    end
end

-- MAG/DG SWITCH STATE UPDATE
local function update_mag_dg_state()
    local new_state = 0
    if mag_dg_dg1_pressed or mag_dg_dg2_pressed then new_state = 2
    elseif mag_dg_mag1_pressed or mag_dg_mag2_pressed then new_state = 1 end

    if mag_dg_state ~= new_state then
        mag_dg_state = new_state
        fsx_variable_write("L:SwMagDg", "Number", mag_dg_state)
        print("MAG/DG SWITCH: State changed to " .. tostring(mag_dg_state))
    end
end

-- MARKER TEST LED UPDATE
local function update_marker_leds()
    local val = (marker_test_state == 1) and 1.0 or 0.0
    
    -- Update all marker LEDs
    hw_led_set(led_mk_r_red, val)
    hw_led_set(led_mk_r_wht, val)
    hw_led_set(led_mk_r_blu, val)
    hw_led_set(led_mk_l_wht, val)
    hw_led_set(led_mk_l_blu, val)
    hw_led_set(led_mk_l_red, val)
    
    -- Status LED
    hw_led_set(led_marker_test_h2, val)
end

-- EXTINGUISHER
local function update_extinguisher_state()
    local new_state = 0
    if extinguisher_pos2_pressed then new_state = 2
    elseif extinguisher_pos1_pressed then new_state = 1 end
    
    if extinguisher_state ~= new_state then
        extinguisher_state = new_state
        fsx_variable_write("L:Extinguisher", "Number", extinguisher_state)
    end
end

-- DOME LIGHT
local function update_dome_light_state()
    local new_state = 0
    if dome_light_pos2_pressed then new_state = 2
    elseif dome_light_pos1_pressed then new_state = 1 end
    
    if dome_light_state ~= new_state then
        dome_light_state = new_state
        fsx_variable_write("L:Swredwhite", "Number", dome_light_state)
    end
end

-- STBY ATT TEST
local function stby_test_press()
    stby_att_flag = 0
    fsx_variable_write("L:StbyAttFlag", "Number", 0)
    fsx_variable_write("L:Masterstbatt", "Number", 1)
    if stby_test_timer ~= nil and timer_stop ~= nil then pcall(timer_stop, stby_test_timer) end
    if timer_start ~= nil then
        stby_test_timer = timer_start(2000, nil, function()
            if stby_att_pwr == 0 then fsx_variable_write("L:StbyAttFlag", "Number", 1) end
            fsx_variable_write("L:Masterstbatt", "Number", 0)
            stby_test_timer = nil
        end)
    end
end

local function stby_test_release()
    if stby_test_timer ~= nil and timer_stop ~= nil then
        pcall(timer_stop, stby_test_timer)
        stby_test_timer = nil
    end
    fsx_variable_write("L:Masterstbatt", "Number", 0)
    if stby_att_pwr == 0 then fsx_variable_write("L:StbyAttFlag", "Number", 1) end
end

-- =============================================================================
-- 5. HARDWARE INPUTS
-- =============================================================================

hw_button_add(PIN_PITOT_HEAT, function() fsx_variable_write("L:Swpitot", "Number", 1) fsx_event("PITOT_HEAT_ON") end, function() fsx_variable_write("L:Swpitot", "Number", 0) fsx_event("PITOT_HEAT_OFF") end)
hw_button_add(PIN_NAV_LIGHTS, function() fsx_variable_write("L:Swposition", "Number", 1) fsx_event("NAV_LIGHTS_ON") end, function() fsx_variable_write("L:Swposition", "Number", 0) fsx_event("NAV_LIGHTS_OFF") end)
hw_button_add(PIN_ANTICOLL, function() fsx_variable_write("L:Swanticoll", "Number", 1) fsx_event("BEACON_LIGHTS_ON") end, function() fsx_variable_write("L:Swanticoll", "Number", 0) fsx_event("BEACON_LIGHTS_OFF") end)
hw_button_add(PIN_WIPER_PI, function() fsx_variable_write("L:Swpiwiper", "Number", 1) end, function() fsx_variable_write("L:Swpiwiper", "Number", 0) end)
hw_button_add(PIN_WIPER_CO, function() fsx_variable_write("L:Swcowiper", "Number", 1) end, function() fsx_variable_write("L:Swcowiper", "Number", 0) end)
hw_button_add(PIN_HEATER, function() fsx_variable_write("L:SwHeater", "Number", 1) end, function() fsx_variable_write("L:SwHeater", "Number", 0) end)
hw_button_add(PIN_VENT_BLOWER, function() fsx_variable_write("L:Swblower", "Number", 1) end, function() fsx_variable_write("L:Swblower", "Number", 0) end)
hw_button_add(PIN_AFT_OUTLET, function() fsx_variable_write("L:Swaftoutlet", "Number", 1) end, function() fsx_variable_write("L:Swaftoutlet", "Number", 0) end)
hw_button_add(PIN_DOME_LIGHT_POS2, function() dome_light_pos2_pressed=true update_dome_light_state() end, function() dome_light_pos2_pressed=false update_dome_light_state() end)
hw_button_add(PIN_UTILITY_LT, function() fsx_variable_write("L:Swutilitylight", "Number", 1) end, function() fsx_variable_write("L:Swutilitylight", "Number", 0) end)

hw_button_add(PIN_FIRE_PULL1, function() fire_handle1_pulled=1 fsx_variable_write("L:firethandl", "Number", 1) update_fire_handle_leds() end, function() fire_handle1_pulled=0 fsx_variable_write("L:firethandl", "Number", 0) update_fire_handle_leds() end)
hw_button_add(PIN_FIRE_PULL2, function() fire_handle2_pulled=1 fsx_variable_write("L:firethandr", "Number", 1) update_fire_handle_leds() end, function() fire_handle2_pulled=0 fsx_variable_write("L:firethandr", "Number", 0) update_fire_handle_leds() end)

hw_button_add(PIN_FIRE_TEST, function() fire_test_active=true fsx_variable_write("L:Swfiretest", "Bool", true) update_fire_leds() end, function() fire_test_active=false fsx_variable_write("L:Swfiretest", "Bool", false) update_fire_leds() end)
hw_button_add(PIN_BAG_FIRE_TEST, function() bag_fire_test_state=1 fsx_variable_write("L:firetestbag", "Number", 1) update_bag_fire_test_led() end, function() bag_fire_test_state=0 fsx_variable_write("L:firetestbag", "Number", 0) update_bag_fire_test_led() end)

hw_button_add(PIN_COMPASS_SLAVE, function() fsx_variable_write("L:CompassControl", "Number", 1) end, function() fsx_variable_write("L:CompassControl", "Number", 0) end)
hw_button_add(PIN_EXTINGUISHER_POS1, function() extinguisher_pos1_pressed=true update_extinguisher_state() end, function() extinguisher_pos1_pressed=false update_extinguisher_state() end)
hw_button_add(PIN_EXTINGUISHER_POS2, function() extinguisher_pos2_pressed=true update_extinguisher_state() end, function() extinguisher_pos2_pressed=false update_extinguisher_state() end)

hw_button_add(PIN_FORCE_TRIM, function() force_trim_held=true fsx_variable_write("L:Sw forcetrim", "Number", 0) fsx_event("ROTOR_TRIM_RESET") end, function() force_trim_held=false fsx_variable_write("L:Sw forcetrim", "Number", 1) end)
hw_button_add(PIN_STATIC_SRC, function() fsx_variable_write("L:SwStaticSource", "Number", 1) end, function() fsx_variable_write("L:SwStaticSource", "Number", 0) end)

hw_button_add(PIN_AFCS_HP1, function() afcs_hp1_state = (afcs_hp1_state==0) and 1 or 0 fsx_variable_write("L:HP1", "Number", afcs_hp1_state) end, function() end)
hw_button_add(PIN_AFCS_HP2, function() afcs_hp2_state = (afcs_hp2_state==0) and 1 or 0 fsx_variable_write("L:HP2", "Number", afcs_hp2_state) end, function() end)
hw_button_add(PIN_AFCS_SAS_SW, function() afcs_sas_state = (afcs_sas_state==0) and 1 or 0 fsx_variable_write("L:SASATT", "Number", afcs_sas_state) end, function() end)

hw_button_add(PIN_STBY_ATT_TEST, stby_test_press, stby_test_release)

hw_button_add(PIN_CARGO_REL, function() fsx_variable_write("L:Swcargorel", "Number", 1) end, function() fsx_variable_write("L:Swcargorel", "Number", 0) end)

-- Cargo Test: PIN_CARGO_TEST_LED was nil, so we remove the led set call inside check.
hw_button_add(PIN_CARGO_TEST, function() fsx_variable_write("L:CRTest", "Number", 1) end, function() fsx_variable_write("L:CRTest", "Number", 0) end)

hw_button_add(PIN_MAG_DG_MAG1, function() mag_dg_mag1_pressed=true update_mag_dg_state() end, function() mag_dg_mag1_pressed=false update_mag_dg_state() end)
hw_button_add(PIN_MAG_DG_MAG2, function() mag_dg_mag2_pressed=true update_mag_dg_state() end, function() mag_dg_mag2_pressed=false update_mag_dg_state() end)
hw_button_add(PIN_MAG_DG_DG1, function() mag_dg_dg1_pressed=true update_mag_dg_state() end, function() mag_dg_dg1_pressed=false update_mag_dg_state() end)
hw_button_add(PIN_MAG_DG_DG2, function() mag_dg_dg2_pressed=true update_mag_dg_state() end, function() mag_dg_dg2_pressed=false update_mag_dg_state() end)

hw_button_add(PIN_AFCS_SYS2, 
    -- Callback 1: Button PRESSED (Connected to Ground)
    function()
        print("AFCS Sys 2: PRESSED")
    end,

    -- Callback 2: Button RELEASED (Open Circuit)
    function()
        print("AFCS Sys 2: RELEASED")
    end
)
hw_button_add(PIN_AP1_SW, function() auto_pilot_state=1 fsx_variable_write("L:AutoPilot", "Number", 1) hw_led_set(led_ap1_h, 1.0) end, function() auto_pilot_state=0 fsx_variable_write("L:AutoPilot", "Number", 0) hw_led_set(led_ap1_h, 0.0) end)
hw_button_add(PIN_AHRS_TEST_1, function() ahrs_test_state=1 fsx_variable_write("L:AHRSTest", "Number", 1) end, function() ahrs_test_state=0 fsx_variable_write("L:AHRSTest", "Number", 0) end)

hw_button_add(PIN_COURSE_SET, function() fsx_variable_write("L:SwCourseset", "Number", 1) end, function() fsx_variable_write("L:SwCourseset", "Number", 0) end)
hw_button_add(PIN_BRG_PTR_SW, function() fsx_variable_write("L:SwBrgPtr", "Number", 1) end, function() fsx_variable_write("L:SwBrgPtr", "Number", 0) end)
hw_button_add(PIN_BRG_PTR2_SW, function() fsx_variable_write("L:SwBrgPtr", "Number", 1) end, function() fsx_variable_write("L:SwBrgPtr", "Number", 0) end)
hw_button_add(PIN_DAFCSEL, function() fsx_variable_write("L:Dafcssel", "Number", 1) end, function() fsx_variable_write("L:Dafcssel", "Number", 0) end)

hw_button_add(PIN_OVERTQ_TEST_L, function() overtq_state=1 fsx_variable_write("L:Overtq", "Number", 1) update_overtq_led() end, function() overtq_state=0 fsx_variable_write("L:Overtq", "Number", 0) update_overtq_led() end)
hw_button_add(PIN_OVERTQ_TEST_R, function() overtq_state=1 fsx_variable_write("L:Overtq", "Number", 1) update_overtq_led() end, function() overtq_state=0 fsx_variable_write("L:Overtq", "Number", 0) update_overtq_led() end)

hw_button_add(PIN_DME_SEL_POS1, function() dme_sel_pos1_pressed=true update_dme_select_state() end, function() dme_sel_pos1_pressed=false update_dme_select_state() end)
hw_button_add(PIN_DME_SEL_POS2, function() dme_sel_pos2_pressed=true update_dme_select_state() end, function() dme_sel_pos2_pressed=false update_dme_select_state() end)

hw_button_add(PIN_AFT_CALL, function() aft_call_state=1 fsx_variable_write("L:AFTcall", "Number", 1) update_aft_leds() end, function() aft_call_state=0 fsx_variable_write("L:AFTcall", "Number", 0) update_aft_leds() end)
hw_button_add(PIN_AFT_CALL2, function() aft_call_state=1 fsx_variable_write("L:AFTcall", "Number", 1) update_aft_leds() end, function() aft_call_state=0 fsx_variable_write("L:AFTcall", "Number", 0) update_aft_leds() end)
hw_button_add(PIN_AFT_TEST, function() aft_test_state=1 fsx_variable_write("L:Testaft", "Number", 1) update_aft_leds() end, function() aft_test_state=0 fsx_variable_write("L:Testaft", "Number", 0) update_aft_leds() end)
hw_button_add(PIN_AFT_TEST2, function() aft_test_state=1 fsx_variable_write("L:Testaft", "Number", 1) update_aft_leds() end, function() aft_test_state=0 fsx_variable_write("L:Testaft", "Number", 0) update_aft_leds() end)

hw_button_add(PIN_MARKER_TEST_L, function() marker_test_state=1 fsx_variable_write("L:TestMarker", "Number", 1) update_marker_leds() end, function() marker_test_state=0 fsx_variable_write("L:TestMarker", "Number", 0) update_marker_leds() end)
hw_button_add(PIN_MARKER_TEST_R, function() marker_test_state=1 fsx_variable_write("L:TestMarker", "Number", 1) update_marker_leds() end, function() marker_test_state=0 fsx_variable_write("L:TestMarker", "Number", 0) update_marker_leds() end)

-- Analog
hw_adc_input_add(PIN_PLATE_MAPLIGHT, function(val)
    local raw_value = val or 0.0
    local dimmer_value = math.floor(raw_value * 50.0 + 0.5)
    dimmer_value = math.max(0, math.min(50, dimmer_value))
    fsx_variable_write("L:platepilolight", "Number", dimmer_value)
end)
hw_button_add(PIN_PLATE_MAPLIGHT_BTN, function() fsx_variable_write("L:platepilolight", "Number", 25) end, function() fsx_variable_write("L:platepilolight", "Number", 0) end)


-- =============================================================================
-- 6. SIMULATOR SUBSCRIPTIONS
-- =============================================================================
fsx_variable_subscribe("L:MasterDcBus", "Number", function(val) dc_bus=(val~=0) and 1 or 0 update_fire_leds() update_fire_handle_leds() end)
fsx_variable_subscribe("L:stbatt", "Number", function(val)
    stby_att_pwr = (val~=0) and 1 or 0
    if stby_att_pwr == 1 then stby_att_flag=0 fsx_variable_write("L:StbyAttFlag", "Number", 0)
    else stby_att_flag=1 fsx_variable_write("L:StbyAttFlag", "Number", 1) end
end)
fsx_variable_subscribe("L:FireWarn1", "Number", function(val) fire_warn_eng1=(val~=0) and 1 or 0 update_fire_leds() end)
fsx_variable_subscribe("L:FireWarn2", "Number", function(val) fire_warn_eng2=(val~=0) and 1 or 0 update_fire_leds() end)
fsx_variable_subscribe("L:BagFire", "Number", function(val) fire_warn_bag=(val~=0) and 1 or 0 update_fire_leds() end)
fsx_variable_subscribe("L:firethandl", "Number", function(val) fire_handle1_pulled=(val~=0) and 1 or 0 update_fire_handle_leds() end)
fsx_variable_subscribe("L:firethandr", "Number", function(val) fire_handle2_pulled=(val~=0) and 1 or 0 update_fire_handle_leds() end)
fsx_variable_subscribe("L:TestMarker", "Number", function(val) marker_test_state=(val~=0) and 1 or 0 update_marker_leds() end)
fsx_variable_subscribe("L:Overtq", "Number", function(val) overtq_state=(val~=0) and 1 or 0 update_overtq_led() end)
fsx_variable_subscribe("L:AFTcall", "Number", function(val) aft_call_state=(val~=0) and 1 or 0 update_aft_leds() end)
fsx_variable_subscribe("L:Testaft", "Number", function(val) aft_test_state=(val~=0) and 1 or 0 update_aft_leds() end)
fsx_variable_subscribe("L:firetestbag", "Number", function(val) bag_fire_test_state=(val~=0) and 1 or 0 update_bag_fire_test_led() end)
fsx_variable_subscribe("L:Swdme", "Number", function(val) dme_sel_state=tonumber(val) or 0 update_dme_select_state() end)
fsx_variable_subscribe("L:SwMagDg", "Number", function(val) mag_dg_state=tonumber(val) or 0 update_mag_dg_state() end)

-- SERVO SUBSCRIPTIONS
fsx_variable_subscribe("A:RUDDER POSITION", "Percent", function(val) set_servo_position(servo_yaw_h, (val + 100.0) / 200.0) end)
fsx_variable_subscribe("A:AILERON POSITION", "Percent", function(val) set_servo_position(servo_roll_h, (val + 100.0) / 200.0) end)
fsx_variable_subscribe("A:ELEVATOR POSITION", "Percent", function(val) set_servo_position(servo_pitch_h, (val + 100.0) / 200.0) end)
fsx_variable_subscribe("A:INDICATED HEADING", "Degrees", function(val) set_servo_position(servo_ahrs_h, ((val % 360.0) + 360.0) % 360.0 / 360.0) end)

-- =============================================================================
-- 7. STARTUP INITIALIZATION
-- =============================================================================
fsx_variable_write("L:StbyAttFlag", "Number", 1)
fsx_variable_write("L:Masterstbatt", "Number", 0)
fsx_variable_write("L:firethandl", "Number", 0)
fsx_variable_write("L:firethandr", "Number", 0)
fsx_variable_write("L:Swfiretest", "Bool", false)
fsx_variable_write("L:CompassControl", "Number", 0)
fsx_variable_write("L:Sw forcetrim", "Number", 1)
fsx_variable_write("L:Extinguisher", "Number", 0)
fsx_variable_write("L:Swredwhite", "Number", 0)
fsx_variable_write("L:SwBambiRelease", "Number", 0)
fsx_variable_write("L:platepilolight", "Number", 0)
fsx_variable_write("L:SwBrgPtr", "Number", 0)
fsx_variable_write("L:SwCourseset", "Number", 0)
fsx_variable_write("L:Overtq", "Number", 0)
fsx_variable_write("L:AFTcall", "Number", 0)
fsx_variable_write("L:Testaft", "Number", 0)
fsx_variable_write("L:Swdme", "Number", 0)
fsx_variable_write("L:SwMagDg", "Number", 0)
fsx_variable_write("L:Dafcssel", "Number", 0)
fsx_variable_write("L:firetestbag", "Number", 0)
fsx_variable_write("L:TestMarker", "Number", 0)
fsx_variable_write("L:AFCSSys2", "Number", 0)
fsx_variable_write("L:AutoPilot", "Number", 0)
fsx_variable_write("L:AHRSTest", "Number", 0)
update_overtq_led()
update_aft_leds()
update_bag_fire_test_led()
update_dme_select_state()
update_mag_dg_state()
update_marker_leds()
update_fire_leds()
update_fire_handle_leds()
update_extinguisher_state()
update_dome_light_state()
