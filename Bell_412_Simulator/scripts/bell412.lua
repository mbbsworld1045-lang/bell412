-- BELL 412 - COMBINED LOGIC (PEDESTAL + FRONT PANEL)
-- Created from pedestal.lua and front_panel.lua
print("Bell 412 - Combined Logic Script is now active")

-- =============================================================================
-- CHANNEL A: PEDESTAL & OVERHEAD
-- =============================================================================

-- =============================================================================
-- 1. HARDWARE CONFIGURATION HEADER
-- =============================================================================

-- -------------------------
-- AFCS & Autopilot Inputs (Mega A)
-- -------------------------
local PIN_AP1_SW            = "ARDUINO_MEGA2560_A_D13"
local PIN_AP2_SW            = "ARDUINO_MEGA2560_A_D12"
local PIN_AFCS_SAS_SW       = "ARDUINO_MEGA2560_A_D10"
local PIN_AFCS_TEST_SW      = "ARDUINO_MEGA2560_A_D9"
local PIN_AFCS_TRIM_FD_SW   = "ARDUINO_MEGA2560_A_D7"
local PIN_AFCS_CPL_SW       = "ARDUINO_MEGA2560_A_D6"
local PIN_AFCS_SYS2         = "ARDUINO_MEGA2560_A_D43"

-- -------------------------
-- AFCS & Autopilot LEDs (Mega A)
-- -------------------------
local PIN_AP1_LED           = "ARDUINO_MEGA2560_A_D5"
local PIN_AP2_LED           = "ARDUINO_MEGA2560_A_D4"
local PIN_AFCS_SAS_LED      = "ARDUINO_MEGA2560_A_D2"
local PIN_AFCS_ATT_LED      = "ARDUINO_MEGA2560_A_D3"
local PIN_AFCS_TRIM_LED     = "ARDUINO_MEGA2560_A_A1"      -- Analog as Digital
local PIN_AFCS_TEST_LED     = "ARDUINO_MEGA2560_A_A2"      -- Analog as Digital
local PIN_AFCS_FD_LED       = "ARDUINO_MEGA2560_A_A3"      -- Analog as Digital
local PIN_AFCS_CPL_LED      = "ARDUINO_MEGA2560_A_A4"      -- Analog as Digital

-- -------------------------
-- AHRS & Mag/DG (Mega A)
-- -------------------------
local PIN_AHRS_TEST_1       = "ARDUINO_MEGA2560_A_D53"
local PIN_AHRS_TEST_2       = "ARDUINO_MEGA2560_A_D49"
local PIN_MAG_DG_MAG1       = "ARDUINO_MEGA2560_A_D51"
local PIN_MAG_DG_MAG2       = "ARDUINO_MEGA2560_A_D47"
local PIN_MAG_DG_DG1        = "ARDUINO_MEGA2560_A_D52"
local PIN_MAG_DG_DG2        = "ARDUINO_MEGA2560_A_D48"
local PIN_AHRS_SERVO        = "ARDUINO_MEGA2560_A_D60"     -- Placeholder for Servo

-- -------------------------
-- Fuel & Hydraulics (Mega A)
-- -------------------------
local PIN_VALVE1            = "ARDUINO_MEGA2560_A_D30"
local PIN_VALVE2            = "ARDUINO_MEGA2560_A_D32"
local PIN_XFEED             = "ARDUINO_MEGA2560_A_D28"      -- XFEED Bus Test 1 (L:Swxfeedbus = 1)
local PIN_XFEED_POS2        = "ARDUINO_MEGA2560_A_D31"      -- XFEED Bus Test 2 (L:Swxfeedbus = 2), Ground = 0
local PIN_FUEL_XFEED        = "ARDUINO_MEGA2560_A_D33"      -- Fuel Crossfeed (0=Normal, 1=Over Close)
local PIN_FUEL_TRANS1       = "ARDUINO_MEGA2560_A_D34"      -- Trans Fuel 1 (L:SwfueltransengA)
local PIN_BOOST1            = "ARDUINO_MEGA2560_A_D35"      -- Boost Pump 1 (L:SwboostpuEng1)
local PIN_FUEL_INTCON       = "ARDUINO_MEGA2560_A_D36"      -- Fuel Intercon (L:Swfuelintcon)
local PIN_FUEL_TRANS2       = "ARDUINO_MEGA2560_A_D37"      -- Trans Fuel 2 (L:SwfueltransengB)
local PIN_BOOST2            = "ARDUINO_MEGA2560_A_D38"      -- Boost Pump 2 (L:SwboostpuEng2)
local PIN_HYD1_SW           = "ARDUINO_MEGA2560_A_D39"
local PIN_HYD2_SW           = "ARDUINO_MEGA2560_A_D42"

-- -------------------------
-- Gov, Trim, & Misc (Mega A)
-- -------------------------
local PIN_GOV_ENG1          = "ARDUINO_MEGA2560_A_D23"
local PIN_GOV_ENG2          = "ARDUINO_MEGA2560_A_D29"
local PIN_PARTSEP1          = "ARDUINO_MEGA2560_A_D25"
local PIN_PARTSEP2          = "ARDUINO_MEGA2560_A_D27"
local PIN_FORCE_TRIM        = "ARDUINO_MEGA2560_A_D40"
local PIN_RPM_AUDIO         = "ARDUINO_MEGA2560_A_D41"

-- =============================================================================
-- 2. LED HANDLES
-- =============================================================================
local led_trim_h = hw_output_add("ARDUINO_MEGA2560_A_A1", false)
local led_test_h = hw_output_add("ARDUINO_MEGA2560_A_A2", false)
local led_fd_h   = hw_output_add("ARDUINO_MEGA2560_A_A3", false)
local led_cpl_h  = hw_output_add("ARDUINO_MEGA2560_A_A4", false)

local led_sas_h  = hw_led_add("ARDUINO_MEGA2560_A_D2", 0.0)
local led_att_h  = hw_led_add("ARDUINO_MEGA2560_A_D3", 0.0)
local led_ap2_h  = hw_led_add("ARDUINO_MEGA2560_A_D4", 0.0)
local led_ap1_h  = hw_led_add("ARDUINO_MEGA2560_A_D5", 0.0)

-- AHRS Servo (PWM)
local servo_ahrs_h      = hw_output_pwm_add(PIN_AHRS_SERVO, 50, 0.075)

-- =============================================================================
-- 3. STATE TRACKING
-- =============================================================================
local state_ap1    = false
local state_ap2    = false
local state_cpl    = false
local sas_mode     = "SAS"  
local trim_cycle   = 0      
local test_timer   = nil

-- Mag/DG States
local mag_dg_mag1_pressed = false
local mag_dg_mag2_pressed = false
local mag_dg_dg1_pressed  = false
local mag_dg_dg2_pressed  = false
local mag_dg_state        = 0

-- AHRS Test States
local ahrs_test1_pressed  = false
local ahrs_test2_pressed  = false
local ahrs_test_state     = 0

-- Fuel/Hydraulic States
local valve1_state      = 0
local valve2_state      = 0
local xfeed_state       = 0
local xfeed_pos1_pressed  = false
local xfeed_pos2_pressed  = false
local fuel_trans1_state = 0
local fuel_trans2_state = 0
local boost1_state      = 0
local boost2_state      = 0
local fuel_intcon_state = 0
local hyd1_state        = 0
local hyd2_state        = 0
local fuel_xfeed_state  = 0

-- Governor States
local gov_eng1_state    = 0
local gov_eng2_state    = 0
local partsep1_state    = 0
local partsep2_state    = 0
local force_trim_held   = false
local rpm_audio_state   = 0

-- DC Bus
local dc_bus            = 0

-- =============================================================================
-- 4. HELPER LOGIC: SAS/ATT MASTER CONTROL
-- =============================================================================
local function update_sas_att()
    -- Logic: SAS/ATT only on if AP1 OR AP2 is ON
    if state_ap1 or state_ap2 then
        if sas_mode == "SAS" then
            hw_led_set(led_sas_h, 1.0)
            hw_led_set(led_att_h, 0.0)
        else
            hw_led_set(led_sas_h, 0.0)
            hw_led_set(led_att_h, 1.0)
        end
    else
        -- If both are OFF, kill SAS and ATT
        hw_led_set(led_sas_h, 0.0)
        hw_led_set(led_att_h, 0.0)
    end
end

-- HELPER: Servo PWM Duty Cycle (0.0 .. 1.0 position -> 0.05 .. 0.10 duty)
local function set_servo_position(id, pos)
    local p = math.max(0.0, math.min(1.0, pos))
    local duty = 0.05 + (p * 0.05)
    hw_output_pwm_duty_cycle(id, duty)
end

-- UPDATE: Mag/DG State
local function update_mag_dg_state()
    local new_state = 0
    if mag_dg_dg1_pressed or mag_dg_dg2_pressed then
        new_state = 2  -- DG
    elseif mag_dg_mag1_pressed or mag_dg_mag2_pressed then
        new_state = 1  -- Mag
    else
        new_state = 0  -- Norm
    end
    
    if mag_dg_state ~= new_state then
        mag_dg_state = new_state
        fsx_variable_write("L:SwMagDg", "Number", mag_dg_state)
        print("MAG/DG: State = " .. tostring(mag_dg_state))
    end
end

-- UPDATE: AHRS Test State
local function update_ahrs_test_state()
    local new_state = (ahrs_test1_pressed or ahrs_test2_pressed) and 1 or 0
    if ahrs_test_state ~= new_state then
        ahrs_test_state = new_state
        fsx_variable_write("L:AHRSTest", "Number", ahrs_test_state)
        print("AHRS TEST: State = " .. tostring(ahrs_test_state))
    end
end

-- UPDATE: Crossfeed State (3-position)
local function update_xfeed_state()
    local new_state = 0
    if xfeed_pos2_pressed then
        new_state = 2
    elseif xfeed_pos1_pressed then
        new_state = 1
    end
    
    if xfeed_state ~= new_state then
        xfeed_state = new_state
        fsx_variable_write("L:Swxfeedbus", "Number", xfeed_state)
        print("XFEED: State = " .. tostring(xfeed_state))
    end
end

-- =============================================================================
-- 5. HARDWARE INPUTS (BUTTONS)
-- =============================================================================

-- -------------------------
-- AFCS & Autopilot (User's Working Logic)
-- -------------------------

-- PIN 3: AP1 BUTTON
hw_button_add("ARDUINO_MEGA2560_A_D13", function()
    -- Check if ANY AP was already on before this press
    local any_ap_already_on = state_ap1 or state_ap2
    
    state_ap1 = not state_ap1
    hw_led_set(led_ap1_h, state_ap1 and 1.0 or 0.0)
    
    -- Only reset to SAS if we are switching from "Everything Off" to "First AP On"
    if state_ap1 and not any_ap_already_on then 
        sas_mode = "SAS" 
    end
    
    update_sas_att()
end)

-- PIN 2: AP2 BUTTON
hw_button_add("ARDUINO_MEGA2560_A_D12", function()
    -- Check if ANY AP was already on before this press
    local any_ap_already_on = state_ap1 or state_ap2
    
    state_ap2 = not state_ap2
    hw_led_set(led_ap2_h, state_ap2 and 1.0 or 0.0)
    
    -- Only reset to SAS if we are switching from "Everything Off" to "First AP On"
    if state_ap2 and not any_ap_already_on then 
        sas_mode = "SAS" 
    end
    
    update_sas_att()
end)

-- PIN 1: SAS/ATT BUTTON (Alternative Toggle)
hw_button_add("ARDUINO_MEGA2560_A_D10", function()
    -- Only allow toggle if at least one AP is active
    if state_ap1 or state_ap2 then
        if sas_mode == "SAS" then
            sas_mode = "ATT"
        else
            sas_mode = "SAS"
        end
        update_sas_att()
    end
end)

-- PIN 5: TRIM / FD BUTTON (Cycle: Trim -> FD -> Off)
hw_button_add("ARDUINO_MEGA2560_A_D7", function()
    trim_cycle = (trim_cycle + 1) % 3
    hw_output_set(led_trim_h, trim_cycle == 1)
    hw_output_set(led_fd_h, trim_cycle == 2)
end)

-- PIN 4: CPL BUTTON (Simple Toggle)
hw_button_add("ARDUINO_MEGA2560_A_D6", function()
    state_cpl = not state_cpl
    hw_output_set(led_cpl_h, state_cpl)
end)

-- PIN 6: TEST BUTTON (30s Timer)
hw_button_add("ARDUINO_MEGA2560_A_D9", function()
    hw_output_set(led_test_h, true)
    if test_timer ~= nil then timer_stop(test_timer) end
    test_timer = timer_start(30000, function()
        hw_output_set(led_test_h, false)
        test_timer = nil
    end)
end)

-- AFCS SYS 2 SWITCH (0=OFF, 1=ON)
hw_button_add(PIN_AFCS_SYS2,
    function()
        print("AFCS SYS 2: PRESSED")
    end,
    function()
        print("AFCS SYS 2: RELEASED")
    end
)

-- -------------------------
-- AHRS & Mag/DG
-- -------------------------

-- AHRS TEST 1 (Momentary)
hw_button_add(PIN_AHRS_TEST_1,
    function()
        print("AHRS TEST 1: PRESSED")
        ahrs_test1_pressed = true
        update_ahrs_test_state()
    end,
    function()
        print("AHRS TEST 1: RELEASED")
        ahrs_test1_pressed = false
        update_ahrs_test_state()
    end
)

-- AHRS TEST 2 (Momentary)
hw_button_add(PIN_AHRS_TEST_2,
    function()
        print("AHRS TEST 2: PRESSED")
        ahrs_test2_pressed = true
        update_ahrs_test_state()
    end,
    function()
        print("AHRS TEST 2: RELEASED")
        ahrs_test2_pressed = false
        update_ahrs_test_state()
    end
)

-- MAG/DG MAG1
hw_button_add(PIN_MAG_DG_MAG1,
    function()
        print("MAG/DG MAG1: PRESSED")
        mag_dg_mag1_pressed = true
        update_mag_dg_state()
    end,
    function()
        print("MAG/DG MAG1: RELEASED")
        mag_dg_mag1_pressed = false
        update_mag_dg_state()
    end
)

-- MAG/DG MAG2
hw_button_add(PIN_MAG_DG_MAG2,
    function()
        print("MAG/DG MAG2: PRESSED")
        mag_dg_mag2_pressed = true
        update_mag_dg_state()
    end,
    function()
        print("MAG/DG MAG2: RELEASED")
        mag_dg_mag2_pressed = false
        update_mag_dg_state()
    end
)

-- MAG/DG DG1
hw_button_add(PIN_MAG_DG_DG1,
    function()
        print("MAG/DG DG1: PRESSED")
        mag_dg_dg1_pressed = true
        update_mag_dg_state()
    end,
    function()
        print("MAG/DG DG1: RELEASED")
        mag_dg_dg1_pressed = false
        update_mag_dg_state()
    end
)

-- MAG/DG DG2
hw_button_add(PIN_MAG_DG_DG2,
    function()
        print("MAG/DG DG2: PRESSED")
        mag_dg_dg2_pressed = true
        update_mag_dg_state()
    end,
    function()
        print("MAG/DG DG2: RELEASED")
        mag_dg_dg2_pressed = false
        update_mag_dg_state()
    end
)

-- -------------------------
-- Fuel & Hydraulics
-- -------------------------

-- VALVE 1 (Switch)
hw_button_add(PIN_VALVE1,
    function()
        print("VALVE1: ON")
        valve1_state = 0
        fsx_variable_write("L:SwvalveEng1", "Number", 0)
    end,
    function()
        print("VALVE1: OFF")
        valve1_state = 1
        fsx_variable_write("L:SwvalveEng1", "Number", 1)
    end
)

-- VALVE 2 (Switch)
hw_button_add(PIN_VALVE2,
    function()
        print("VALVE2: ON")
        valve2_state = 1
        fsx_variable_write("L:SwvalveEng2", "Number", 1)
    end,
    function()
        print("VALVE2: OFF")
        valve2_state = 0
        fsx_variable_write("L:SwvalveEng2", "Number", 0)
    end
)

-- XFEED POS1 (3-position)
hw_button_add(PIN_XFEED,
    function()
        print("XFEED POS1: PRESSED")
        xfeed_pos1_pressed = true
        update_xfeed_state()
    end,
    function()
        print("XFEED POS1: RELEASED")
        xfeed_pos1_pressed = false
        update_xfeed_state()
    end
)

-- XFEED POS2 (3-position)
hw_button_add(PIN_XFEED_POS2,
    function()
        print("XFEED POS2: PRESSED")
        xfeed_pos2_pressed = true
        update_xfeed_state()
    end,
    function()
        print("XFEED POS2: RELEASED")
        xfeed_pos2_pressed = false
        update_xfeed_state()
    end
)

-- FUEL CROSSFEED (Switch: 0=Normal, 1=Over Close)
hw_button_add(PIN_FUEL_XFEED,
    function()
        print("FUEL XFEED: OVER CLOSE")
        fuel_xfeed_state = 0
        fsx_variable_write("L:SwFuelxfeed", "Number", 0)
    end,
    function()
        print("FUEL XFEED: NORMAL")
        fuel_xfeed_state = 1
        fsx_variable_write("L:SwFuelxfeed", "Number", 1)
    end
)

-- FUEL TRANSFER 1 (Switch)
hw_button_add(PIN_FUEL_TRANS1,
    function()
        print("FUEL TRANS1: ON")
        fuel_trans1_state = 0
        fsx_variable_write("L:SwfueltransengA", "Number", 0)
    end,
    function()
        print("FUEL TRANS1: OFF")
        fuel_trans1_state = 1
        fsx_variable_write("L:SwfueltransengA", "Number", 1)
    end
)

-- FUEL TRANSFER 2 (Switch)
hw_button_add(PIN_FUEL_TRANS2,
    function()
        print("FUEL TRANS2: ON")
        fuel_trans2_state = 1
        fsx_variable_write("L:SwfueltransengB", "Number", 1)
    end,
    function()
        print("FUEL TRANS2: OFF")
        fuel_trans2_state = 0
        fsx_variable_write("L:SwfueltransengB", "Number", 0)
    end
)

-- BOOST PUMP 1 (Switch)
hw_button_add(PIN_BOOST1,
    function()
        print("BOOST1: ON")
        boost1_state = 1
        fsx_variable_write("L:SwboostpuEng1", "Number", 1)
    end,
    function()
        print("BOOST1: OFF")
        boost1_state = 0
        fsx_variable_write("L:SwboostpuEng1", "Number", 0)
    end
)

-- BOOST PUMP 2 (Switch)
hw_button_add(PIN_BOOST2,
    function()
        print("BOOST2: ON")
        boost2_state = 1
        fsx_variable_write("L:SwboostpuEng2", "Number", 1)
    end,
    function()
        print("BOOST2: OFF")
        boost2_state = 0
        fsx_variable_write("L:SwboostpuEng2", "Number", 0)
    end
)

-- FUEL INTERCON (Switch)
hw_button_add(PIN_FUEL_INTCON,
    function()
        print("FUEL INTCON: ON")
        fuel_intcon_state = 0
        fsx_variable_write("L:Swfuelintcon", "Number", 0)
    end,
    function()
        print("FUEL INTCON: OFF")
        fuel_intcon_state = 1
        fsx_variable_write("L:Swfuelintcon", "Number", 1)
    end
)

-- HYDRAULIC 1 (Switch)
hw_button_add(PIN_HYD1_SW,
    function()
        print("HYD1: ON")
        hyd1_state = 0
        fsx_variable_write("L:Sw hydsysA", "Number", 0)
    end,
    function()
        print("HYD1: OFF")
        hyd1_state = 1
        fsx_variable_write("L:Sw hydsysA", "Number", 1)
    end
)

-- HYDRAULIC 2 (Switch)
hw_button_add(PIN_HYD2_SW,
    function()
        print("HYD2: ON")
        hyd2_state = 1
        fsx_variable_write("L:Sw hydsysB", "Number", 1)
    end,
    function()
        print("HYD2: OFF")
        hyd2_state = 0
        fsx_variable_write("L:Sw hydsysB", "Number", 0)
    end
)

-- -------------------------
-- Gov, Trim, & Misc
-- -------------------------

-- GOVERNOR ENGINE 1 (Switch)
hw_button_add(PIN_GOV_ENG1,
    function()
        print("GOV ENG1: ON")
        gov_eng1_state = 0
        fsx_variable_write("L:SwGovA", "Number", 0)
    end,
    function()
        print("GOV ENG1: OFF")
        gov_eng1_state = 1
        fsx_variable_write("L:SwGovA", "Number", 1)
    end
)

-- GOVERNOR ENGINE 2 (Switch)
hw_button_add(PIN_GOV_ENG2,
    function()
        print("GOV ENG2: ON")
        gov_eng2_state = 0
        fsx_variable_write("L:SwGovB", "Number", 0)
    end,
    function()
        print("GOV ENG2: OFF")
        gov_eng2_state = 1
        fsx_variable_write("L:SwGovB", "Number", 1)
    end
)

-- PARTICLE SEPARATOR 1 (Switch)
hw_button_add(PIN_PARTSEP1,
    function()
        print("PARTSEP1: ON")
        partsep1_state = 0
        fsx_variable_write("L:SwpartsepA", "Number", 0)
    end,
    function()
        print("PARTSEP1: OFF")
        partsep1_state = 1
        fsx_variable_write("L:SwpartsepA", "Number", 1)
    end
)

-- PARTICLE SEPARATOR 2 (Switch)
hw_button_add(PIN_PARTSEP2,
    function()
        print("PARTSEP2: ON")
        partsep2_state = 0
        fsx_variable_write("L:SwpartsepB", "Number", 0)
    end,
    function()
        print("PARTSEP2: OFF")
        partsep2_state = 1
        fsx_variable_write("L:SwpartsepB", "Number", 1)
    end
)

-- FORCE TRIM (Momentary)
hw_button_add(PIN_FORCE_TRIM,
    function()
        print("FORCE TRIM: PRESSED")
        force_trim_held = false
        fsx_variable_write("L:Sw forcetrim", "Number", 0)
        fsx_event("ROTOR_TRIM_RESET")
    end,
    function()
        print("FORCE TRIM: RELEASED")
        force_trim_held = true
        fsx_variable_write("L:Sw forcetrim", "Number", 1)
    end
)

-- RPM AUDIO (Switch)
hw_button_add(PIN_RPM_AUDIO,
    function()
        print("RPM AUDIO: ON")
        rpm_audio_state = 0
        fsx_variable_write("L:Sw RPMAudio", "Number", 0)
    end,
    function()
        print("RPM AUDIO: OFF")
        rpm_audio_state = 1
        fsx_variable_write("L:Sw RPMAudio", "Number", 1)
    end
)

-- =============================================================================
-- 6. SIMULATOR SUBSCRIPTIONS
-- =============================================================================

-- DC Bus
fsx_variable_subscribe("L:MasterDcBus", "Number", function(val)
    dc_bus = (val ~= 0) and 1 or 0
    update_sas_att()
end)

-- AP States (from sim) - Update local state from sim when changed externally
fsx_variable_subscribe("L:AutoPilot", "Number", function(val)
    local new_state = (val ~= 0)
    if state_ap1 ~= new_state then
        state_ap1 = new_state
        hw_led_set(led_ap1_h, state_ap1 and 1.0 or 0.0)
        update_sas_att()
    end
end)

fsx_variable_subscribe("L:AutoPilot2", "Number", function(val)
    local new_state = (val ~= 0)
    if state_ap2 ~= new_state then
        state_ap2 = new_state
        hw_led_set(led_ap2_h, state_ap2 and 1.0 or 0.0)
        update_sas_att()
    end
end)

-- SAS/ATT State (from sim)
fsx_variable_subscribe("L:SASATT", "Number", function(val)
    local new_mode = (val ~= 0) and "ATT" or "SAS"
    if sas_mode ~= new_mode then
        sas_mode = new_mode
        update_sas_att()
    end
end)

-- CPL Active (from sim)
fsx_variable_subscribe("L:CplActive", "Number", function(val)
    local new_state = (val ~= 0)
    if state_cpl ~= new_state then
        state_cpl = new_state
        hw_output_set(led_cpl_h, state_cpl)
    end
end)

-- AHRS Servo (Heading)
fsx_variable_subscribe("A:INDICATED HEADING", "Degrees", function(val)
    local heading_norm = ((val % 360.0) + 360.0) % 360.0 / 360.0
    set_servo_position(servo_ahrs_h, heading_norm)
end)

-- =============================================================================
-- 7. STARTUP INITIALIZATION
-- =============================================================================

fsx_variable_write("L:AutoPilot", "Number", 0)
fsx_variable_write("L:AutoPilot2", "Number", 0)
fsx_variable_write("L:SASATT", "Number", 0)
fsx_variable_write("L:CplActive", "Number", 0)
fsx_variable_write("L:AFCSTest", "Number", 0)
fsx_variable_write("L:Sw forcetrim", "Number", 1)
fsx_variable_write("L:AFCSSys2", "Number", 0)
fsx_variable_write("L:SwMagDg", "Number", 0)
fsx_variable_write("L:AHRSTest", "Number", 0)
fsx_variable_write("L:SwvalveEng1", "Number", 1)
fsx_variable_write("L:SwvalveEng2", "Number", 1)
fsx_variable_write("L:Swxfeedbus", "Number", 0)
fsx_variable_write("L:Sw hydsysA", "Number", 1)
fsx_variable_write("L:Sw hydsysB", "Number", 0)
fsx_variable_write("L:SwGovA", "Number", 1)
fsx_variable_write("L:SwGovB", "Number", 0)
fsx_variable_write("L:SwpartsepA", "Number", 1)
fsx_variable_write("L:SwpartsepB", "Number", 1)
fsx_variable_write("L:Sw RPMAudio", "Number", 1)

-- Initialize LEDs
update_sas_att()

-- =============================================================================
-- CHANNEL B: FRONT PANEL
-- =============================================================================

-- =============================================================================
-- 1. HARDWARE CONFIGURATION HEADER
-- =============================================================================
-- INPUTS (Buttons)
-- BRG PTR Switches
local PIN_BRG_PTR           = "ARDUINO_MEGA2560_B_D38"      -- BRG PTR Switch Left (L:SwBrgPtr)
local PIN_BRG_PTR2          = "ARDUINO_MEGA2560_B_D10"      -- BRG PTR Switch Right (L:SwBrgPtr)

-- Fire System
local PIN_FIRE_PULL1        = "ARDUINO_MEGA2560_B_D50"      -- Fire Pull Handle Left (L:firethandl)
local PIN_FIRE_PULL2        = "ARDUINO_MEGA2560_B_D35"      -- Fire Pull Handle Right (L:firethandr)
local PIN_FIRE_TEST         = "ARDUINO_MEGA2560_B_D51"      -- Fire Detection Test (L:Swfiretest)
local PIN_BAG_FIRE_TEST     = "ARDUINO_MEGA2560_B_D52"      -- Baggage Fire Test (L:firetestbag)
local PIN_EXTINGUISHER_POS1 = "ARDUINO_MEGA2560_B_D7"       -- Fire Extinguisher Main (L:Extinguisher)
local PIN_EXTINGUISHER_POS2 = "ARDUINO_MEGA2560_B_D8"       -- Fire Extinguisher Reserve (L:Extinguisher)

-- Beacon Marker Tests
local PIN_MARKER_TEST       = "ARDUINO_MEGA2560_B_D45"      -- Marker Test Left (L:TestMarker)
local PIN_MARKER_TEST2      = "ARDUINO_MEGA2560_B_D37"      -- Marker Test Right (L:TestMarker)

-- Over Torque Tests
local PIN_OVERTQ_TEST       = "ARDUINO_MEGA2560_B_D49"      -- Over Torque Test Left (L:Overtq)
local PIN_OVERTQ_TEST2      = "ARDUINO_MEGA2560_B_D33"      -- Over Torque Test Right (L:Overtq)

-- Cyclic Center Tests
local PIN_CYC_CTR_TEST_L    = "ARDUINO_MEGA2560_B_D40"      -- Cyclic Center Test Left (L:Cyctest)
local PIN_CYC_CTR_TEST_R    = "ARDUINO_MEGA2560_B_D32"      -- Cyclic Center Test Right (L:Cyctest)

-- Master Caution Buttons
local PIN_MC_RESET_L        = "ARDUINO_MEGA2560_B_D41"      -- Master Caution Button Left
local PIN_MC_RESET_R        = "ARDUINO_MEGA2560_B_D36"      -- Master Caution Button Right

-- Fuel System
local PIN_FUEL_SYS_TEST_FWD = "ARDUINO_MEGA2560_B_D53"      -- Fuel Sys Test Fwd Tank (L:FuelQuantity = -1)
local PIN_FUEL_SYS_TEST_MID = "ARDUINO_MEGA2560_B_D34"      -- Fuel Sys Test Mid Tank (L:FuelQuantity = -1)
local PIN_FUEL_DIGIT_TEST   = "ARDUINO_MEGA2560_B_D44"      -- Fuel Digit Test

-- Nav GPS Buttons
local PIN_NAV_GPS_BTN_R     = "ARDUINO_MEGA2560_B_D11"      -- Nav GPS White Right Button
local PIN_NAV_GPS_BTN_L     = "ARDUINO_MEGA2560_B_D25"      -- Nav GPS White Left Button 

-- =============================================================================
-- OUTPUTS (LEDs)
-- =============================================================================
-- BRG PTR LEDs
local PIN_BRG_PTR_LED       = "ARDUINO_MEGA2560_B_D3"       -- BRG PTR Switch Left LED
local PIN_BRG_PTR2_LED      = "ARDUINO_MEGA2560_B_D13"      -- BRG PTR Switch Right LED

-- Fire Handle Status LEDs
local PIN_FIRE_HANDLE1_LED  = "ARDUINO_MEGA2560_B_D5"       -- Fire Handle 1 Status LED Left
local PIN_FIRE_HANDLE2_LED  = "ARDUINO_MEGA2560_B_D24"      -- Fire Handle 2 Status LED Right
local PIN_BAG_FIRE_TEST_LED = "ARDUINO_MEGA2560_B_D2"       -- Baggage Fire Test LED

-- Beacon Marker LEDs - Right Side
local PIN_MARKER_R_WHT      = "ARDUINO_MEGA2560_B_D26"      -- Marker Right White
local PIN_MARKER_R_RED      = "ARDUINO_MEGA2560_B_D27"      -- Marker Right Red
local PIN_MARKER_R_BLU      = "ARDUINO_MEGA2560_B_D28"      -- Marker Right Blue

-- Beacon Marker LEDs - Left Side
local PIN_MARKER_L_WHT      = "ARDUINO_MEGA2560_B_D46"      -- Marker Left White (right)
local PIN_MARKER_L_BLU      = "ARDUINO_MEGA2560_B_D47"      -- Marker Left Blue (left)
local PIN_MARKER_L_RED      = "ARDUINO_MEGA2560_B_D48"      -- Marker Left Red (middle)

-- Over Torque LEDs
local PIN_OVERTQ_LED_L      = "ARDUINO_MEGA2560_B_D39"      -- Over Torque LED Left
local PIN_OVERTQ_LED_R      = "ARDUINO_MEGA2560_B_D9"       -- Over Torque LED Right

-- Cyclic Center LEDs
local PIN_CYC_CTR_LED_L     = "ARDUINO_MEGA2560_B_D42"      -- Cyclic Center LED Left
local PIN_CYC_CTR_LED_R     = "ARDUINO_MEGA2560_B_D30"      -- Cyclic Center LED Right

-- Master Caution LEDs
local PIN_MC_LED_L          = "ARDUINO_MEGA2560_B_D43"      -- Master Caution LED Left
local PIN_MC_LED_R          = "ARDUINO_MEGA2560_B_D31"      -- Master Caution LED Right

-- Engine Warning LEDs
local PIN_ENG1_LED          = "ARDUINO_MEGA2560_B_D4"       -- Engine 1 Warning LED
local PIN_ENG2_LED          = "ARDUINO_MEGA2560_B_D12"      -- Engine 2 Warning LED

-- =============================================================================
-- 2. INITIALIZE HARDWARE LEDS
-- =============================================================================
-- BRG PTR LEDs
local led_brg_ptr_h         = hw_led_add(PIN_BRG_PTR_LED, 0.0)
local led_brg_ptr2_h        = hw_led_add(PIN_BRG_PTR2_LED, 0.0)

-- Fire Handle LEDs
local led_fire_h1_h         = hw_led_add(PIN_FIRE_HANDLE1_LED, 0.0)
local led_fire_h2_h         = hw_led_add(PIN_FIRE_HANDLE2_LED, 0.0)
local led_bag_fire_test_h   = hw_led_add(PIN_BAG_FIRE_TEST_LED, 0.0)

-- Beacon Marker LEDs
local led_mk_r_red          = hw_led_add(PIN_MARKER_R_RED, 0.0)
local led_mk_r_wht          = hw_led_add(PIN_MARKER_R_WHT, 0.0)
local led_mk_r_blu          = hw_led_add(PIN_MARKER_R_BLU, 0.0)
local led_mk_l_wht          = hw_led_add(PIN_MARKER_L_WHT, 0.0)
local led_mk_l_blu          = hw_led_add(PIN_MARKER_L_BLU, 0.0)
local led_mk_l_red          = hw_led_add(PIN_MARKER_L_RED, 0.0)

-- Over Torque LEDs
local led_ot_l_h            = hw_led_add(PIN_OVERTQ_LED_L, 0.0)
local led_ot_r_h            = hw_led_add(PIN_OVERTQ_LED_R, 0.0)

-- Cyclic Center LEDs
local led_cyc_ctr_l_h       = hw_led_add(PIN_CYC_CTR_LED_L, 0.0)
local led_cyc_ctr_r_h       = hw_led_add(PIN_CYC_CTR_LED_R, 0.0)

-- Master Caution LEDs
local led_mc_l_h            = hw_led_add(PIN_MC_LED_L, 0.0)
local led_mc_r_h            = hw_led_add(PIN_MC_LED_R, 0.0)

-- Engine Warning LEDs
local led_eng1_h            = hw_led_add(PIN_ENG1_LED, 0.0)
local led_eng2_h            = hw_led_add(PIN_ENG2_LED, 0.0)

-- =============================================================================
-- 3. INTERNAL VARIABLES & CONSTANTS
-- =============================================================================
-- Fire System States
local fire_handle1_pulled   = 0
local fire_handle2_pulled   = 0
local fire_test_active      = false
local bag_fire_test_state   = 0

-- Extinguisher State (3-position: 0=OFF, 1=Main, 2=Reserve)
local extinguisher_pos1_pressed = false
local extinguisher_pos2_pressed = false
local extinguisher_state    = 0

-- Marker Test States (separate left and right)
local marker_test_left_state  = 0
local marker_test_right_state = 0
local test_marker_state       = 0  -- Global marker test (L:TestMarker)

-- Over Torque State
local overtq_state          = 0

-- Cyclic Center Test State
local cyc_test_state        = 0

-- Master Caution Reset States
local mc_reset_l_held       = false
local mc_reset_r_held       = false

-- Fuel Quantity Test State
local fuel_quantity_state   = 0

-- DC Bus State
local dc_bus                = 0

-- Engine Warning States
local test_mc               = 0
local rpm_n1_e1             = 100.0
local rpm_n1_e2             = 100.0

-- =============================================================================
-- 4. SYSTEM LOGIC FUNCTIONS
-- =============================================================================

-- FIRE HANDLE LED UPDATE
local function update_fire_handle_leds()
    if dc_bus == 0 then
        hw_led_set(led_fire_h1_h, 0.0)
        hw_led_set(led_fire_h2_h, 0.0)
        return
    end
    hw_led_set(led_fire_h1_h, (fire_handle1_pulled == 1) and 1.0 or 0.0)
    hw_led_set(led_fire_h2_h, (fire_handle2_pulled == 1) and 1.0 or 0.0)
end

-- FIRE TEST LED UPDATE
local function update_fire_leds()
    if fire_test_active == 1 then
        hw_led_set(led_fire_h1_h, 1.0)
        hw_led_set(led_fire_h2_h, 1.0)
    else
        update_fire_handle_leds()
    end
end

-- BAGGAGE FIRE TEST LED UPDATE
local function update_bag_fire_test_led()
    hw_led_set(led_bag_fire_test_h, (bag_fire_test_state == 1) and 1.0 or 0.0)
end

-- MARKER LED UPDATE (separate left and right, or all if L:TestMarker=1)
local function update_marker_leds()
    -- If global test marker is active, light ALL beacon LEDs
    if test_marker_state == 1 then
        hw_led_set(led_mk_l_wht, 1.0)
        hw_led_set(led_mk_l_blu, 1.0)
        hw_led_set(led_mk_l_red, 1.0)
        hw_led_set(led_mk_r_wht, 1.0)
        hw_led_set(led_mk_r_red, 1.0)
        hw_led_set(led_mk_r_blu, 1.0)
        return
    end
    
    -- Left marker LEDs (controlled by left test button)
    local val_left = (marker_test_left_state == 1) and 1.0 or 0.0
    hw_led_set(led_mk_l_wht, val_left)
    hw_led_set(led_mk_l_blu, val_left)
    hw_led_set(led_mk_l_red, val_left)
    
    -- Right marker LEDs (controlled by right test button)
    local val_right = (marker_test_right_state == 1) and 1.0 or 0.0
    hw_led_set(led_mk_r_wht, val_right)
    hw_led_set(led_mk_r_red, val_right)
    hw_led_set(led_mk_r_blu, val_right)
end

-- OVER TORQUE LED UPDATE
local function update_overtq_led()
    local led_value = (overtq_state == 1) and 1.0 or 0.0
    hw_led_set(led_ot_l_h, led_value)
    hw_led_set(led_ot_r_h, led_value)
end

-- CYCLIC CENTER LED UPDATE
local function update_cyc_ctr_led()
    local led_val = (cyc_test_state == 1) and 1.0 or 0.0
    hw_led_set(led_cyc_ctr_l_h, led_val)
    hw_led_set(led_cyc_ctr_r_h, led_val)
end

-- EXTINGUISHER STATE UPDATE (3-position)
local function update_extinguisher_state()
    local new_state = 0
    if extinguisher_pos2_pressed then
        new_state = 2  -- Reserve
    elseif extinguisher_pos1_pressed then
        new_state = 1  -- Main
    end
    
    if extinguisher_state ~= new_state then
        extinguisher_state = new_state
        fsx_variable_write("L:Extinguisher", "Number", extinguisher_state)
        print("EXTINGUISHER: State changed to " .. tostring(extinguisher_state))
    end
end

-- MC RESET Logic (controls separate MC LEDs)
local function update_mc_reset()
    local reset_active = mc_reset_l_held or mc_reset_r_held
    fsx_variable_write("L:ResetMC", "Number", reset_active and 1 or 0)
    -- Left button (D41) controls Left LED (D43)
    hw_led_set(led_mc_l_h, mc_reset_l_held and 1.0 or 0.0)
    -- Right button (D36) controls Right LED (D31)
    hw_led_set(led_mc_r_h, mc_reset_r_held and 1.0 or 0.0)
    print("ACTION: MC Reset State = " .. tostring(reset_active))
end

-- BRG PTR LED UPDATE
local function update_brg_ptr_leds()
    -- Subscribe-based - will be updated from sim feedback
end

-- ENGINE WARNING LED UPDATE
-- Logic: LED ON when DC Bus ON AND (TestMC active OR RPM N1 <= 55%)
local function update_engine_leds()
    if dc_bus == 0 then
        hw_led_set(led_eng1_h, 0.0)
        hw_led_set(led_eng2_h, 0.0)
        return
    end
    
    -- Engine 1: ON if TestMC active OR RPM N1 E1 <= 55%
    local eng1_warn = (test_mc ~= 0) or (rpm_n1_e1 <= 55.0)
    hw_led_set(led_eng1_h, eng1_warn and 1.0 or 0.0)
    
    -- Engine 2: ON if TestMC active OR RPM N1 E2 <= 55%
    local eng2_warn = (test_mc ~= 0) or (rpm_n1_e2 <= 55.0)
    hw_led_set(led_eng2_h, eng2_warn and 1.0 or 0.0)
end

-- =============================================================================
-- 5. HARDWARE INPUTS (BUTTONS)
-- =============================================================================

-- BRG PTR SWITCH LEFT
hw_button_add(PIN_BRG_PTR,
    function() -- PRESSED
        print("ACTION: BRG PTR Left PRESSED")
        fsx_variable_write("L:SwBrgPtr", "Number", 1)
        hw_led_set(led_brg_ptr_h, 1.0)
    end,
    function() -- RELEASED
        print("ACTION: BRG PTR Left RELEASED")
        fsx_variable_write("L:SwBrgPtr", "Number", 0)
        hw_led_set(led_brg_ptr_h, 0.0)
    end
)

-- BRG PTR SWITCH RIGHT
hw_button_add(PIN_BRG_PTR2,
    function() -- PRESSED
        print("ACTION: BRG PTR Right PRESSED")
        fsx_variable_write("L:SwBrgPtr", "Number", 1)
        hw_led_set(led_brg_ptr2_h, 1.0)
    end,
    function() -- RELEASED
        print("ACTION: BRG PTR Right RELEASED")
        fsx_variable_write("L:SwBrgPtr", "Number", 0)
        hw_led_set(led_brg_ptr2_h, 0.0)
    end
)

-- FIRE PULL HANDLE LEFT
hw_button_add(PIN_FIRE_PULL1,
    function() -- PRESSED (Pulled)
        print("ACTION: Fire Handle Left PULLED")
        fire_handle1_pulled = 1
        fsx_variable_write("L:firethandl", "Number", 1)
        update_fire_handle_leds()
    end,
    function() -- RELEASED (Reset)
        print("ACTION: Fire Handle Left RESET")
        fire_handle1_pulled = 0
        fsx_variable_write("L:firethandl", "Number", 0)
        update_fire_handle_leds()
    end
)

-- FIRE PULL HANDLE RIGHT
hw_button_add(PIN_FIRE_PULL2,
    function() -- PRESSED (Pulled)
        print("ACTION: Fire Handle Right PULLED")
        fire_handle2_pulled = 1
        fsx_variable_write("L:firethandr", "Number", 1)
        update_fire_handle_leds()
    end,
    function() -- RELEASED (Reset)
        print("ACTION: Fire Handle Right RESET")
        fire_handle2_pulled = 0
        fsx_variable_write("L:firethandr", "Number", 0)
        update_fire_handle_leds()
    end
)

-- FIRE DETECTION TEST
hw_button_add(PIN_FIRE_TEST,
    function() -- PRESSED (LEDs ON)
        print("ACTION: Fire Test PRESSED")
        fire_test_active = 1
        fsx_variable_write("L:Swfiretest", "Number", 1)
        update_fire_leds()
    end,
    function() -- RELEASED (LEDs OFF)
        print("ACTION: Fire Test RELEASED")
        fire_test_active = 0
        fsx_variable_write("L:Swfiretest", "Number", 0)
        update_fire_leds()
    end
)

-- BAGGAGE FIRE TEST
hw_button_add(PIN_BAG_FIRE_TEST,
    function() -- PRESSED
        print("ACTION: Baggage Fire Test PRESSED")
        bag_fire_test_state = 1
        fsx_variable_write("L:firetestbag", "Number", 1)
        update_bag_fire_test_led()
    end,
    function() -- RELEASED
        print("ACTION: Baggage Fire Test RELEASED")
        bag_fire_test_state = 0
        fsx_variable_write("L:firetestbag", "Number", 0)
        update_bag_fire_test_led()
    end
)

-- FIRE EXTINGUISHER MAIN (Position 1)
hw_button_add(PIN_EXTINGUISHER_POS1,
    function() -- PRESSED
        print("ACTION: Extinguisher Main PRESSED")
        extinguisher_pos1_pressed = true
        update_extinguisher_state()
    end,
    function() -- RELEASED
        print("ACTION: Extinguisher Main RELEASED")
        extinguisher_pos1_pressed = false
        update_extinguisher_state()
    end
)

-- FIRE EXTINGUISHER RESERVE (Position 2)
hw_button_add(PIN_EXTINGUISHER_POS2,
    function() -- PRESSED
        print("ACTION: Extinguisher Reserve PRESSED")
        extinguisher_pos2_pressed = true
        update_extinguisher_state()
    end,
    function() -- RELEASED
        print("ACTION: Extinguisher Reserve RELEASED")
        extinguisher_pos2_pressed = false
        update_extinguisher_state()
    end
)

-- BEACON MARKER TEST LEFT (controls L:TestMarker -> all LEDs)
hw_button_add(PIN_MARKER_TEST,
    function() -- PRESSED
        print("ACTION: Marker Test Left PRESSED")
        fsx_variable_write("L:TestMarker", "Number", 1)
        test_marker_state = 1
        update_marker_leds()
    end,
    function() -- RELEASED
        print("ACTION: Marker Test Left RELEASED")
        fsx_variable_write("L:TestMarker", "Number", 0)
        test_marker_state = 0
        update_marker_leds()
    end
)

-- BEACON MARKER TEST RIGHT (controls L:TestMarker -> all LEDs)
hw_button_add(PIN_MARKER_TEST2,
    function() -- PRESSED
        print("ACTION: Marker Test Right PRESSED")
        fsx_variable_write("L:TestMarker", "Number", 1)
        test_marker_state = 1
        update_marker_leds()
    end,
    function() -- RELEASED
        print("ACTION: Marker Test Right RELEASED")
        fsx_variable_write("L:TestMarker", "Number", 0)
        test_marker_state = 0
        update_marker_leds()
    end
)

-- OVER TORQUE TEST LEFT
hw_button_add(PIN_OVERTQ_TEST,
    function() -- PRESSED
        print("ACTION: Over Torque Test Left PRESSED")
        overtq_state = 1
        fsx_variable_write("L:Overtq", "Number", 1)
        update_overtq_led()
    end,
    function() -- RELEASED
        print("ACTION: Over Torque Test Left RELEASED")
        overtq_state = 0
        fsx_variable_write("L:Overtq", "Number", 0)
        update_overtq_led()
    end
)

-- OVER TORQUE TEST RIGHT
hw_button_add(PIN_OVERTQ_TEST2,
    function() -- PRESSED
        print("ACTION: Over Torque Test Right PRESSED")
        overtq_state = 1
        fsx_variable_write("L:Overtq", "Number", 1)
        update_overtq_led()
    end,
    function() -- RELEASED
        print("ACTION: Over Torque Test Right RELEASED")
        overtq_state = 0
        fsx_variable_write("L:Overtq", "Number", 0)
        update_overtq_led()
    end
)

-- CYCLIC CENTER TEST LEFT
hw_button_add(PIN_CYC_CTR_TEST_L,
    function() -- PRESSED
        print("ACTION: Cyc Center Test Left PRESSED")
        cyc_test_state = 1
        fsx_variable_write("L:Cyctest", "Number", 1)
        update_cyc_ctr_led()
    end,
    function() -- RELEASED
        print("ACTION: Cyc Center Test Left RELEASED")
        cyc_test_state = 0
        fsx_variable_write("L:Cyctest", "Number", 0)
        update_cyc_ctr_led()
    end
)

-- CYCLIC CENTER TEST RIGHT
hw_button_add(PIN_CYC_CTR_TEST_R,
    function() -- PRESSED
        print("ACTION: Cyc Center Test Right PRESSED")
        cyc_test_state = 1
        fsx_variable_write("L:Cyctest", "Number", 1)
        update_cyc_ctr_led()
    end,
    function() -- RELEASED
        print("ACTION: Cyc Center Test Right RELEASED")
        cyc_test_state = 0
        fsx_variable_write("L:Cyctest", "Number", 0)
        update_cyc_ctr_led()
    end
)

-- MASTER CAUTION RESET LEFT
hw_button_add(PIN_MC_RESET_L,
    function() -- PRESSED
        print("ACTION: MC Reset Left PRESSED")
        mc_reset_l_held = true
        update_mc_reset()
    end,
    function() -- RELEASED
        print("ACTION: MC Reset Left RELEASED")
        mc_reset_l_held = false
        update_mc_reset()
    end
)

-- MASTER CAUTION RESET RIGHT
hw_button_add(PIN_MC_RESET_R,
    function() -- PRESSED
        print("ACTION: MC Reset Right PRESSED")
        mc_reset_r_held = true
        update_mc_reset()
    end,
    function() -- RELEASED
        print("ACTION: MC Reset Right RELEASED")
        mc_reset_r_held = false
        update_mc_reset()
    end
)

-- FUEL SYSTEM TEST FWD
hw_button_add(PIN_FUEL_SYS_TEST_FWD,
    function() -- PRESSED
        print("ACTION: Fuel Sys Test Fwd PRESSED")
        fuel_quantity_state = 1
        fsx_variable_write("L:FuelQuantity", "Number", -1)
    end,
    function() -- RELEASED
        print("ACTION: Fuel Sys Test Fwd RELEASED")
        fuel_quantity_state = 0
        fsx_variable_write("L:FuelQuantity", "Number", 0)
    end
)

-- FUEL SYSTEM TEST MID
hw_button_add(PIN_FUEL_SYS_TEST_MID,
    function() -- PRESSED
        print("ACTION: Fuel Sys Test Mid PRESSED")
        fuel_quantity_state = 1
        fsx_variable_write("L:FuelQuantity", "Number", -1)
    end,
    function() -- RELEASED
        print("ACTION: Fuel Sys Test Mid RELEASED")
        fuel_quantity_state = 0
        fsx_variable_write("L:FuelQuantity", "Number", 0)
    end
)

-- FUEL DIGIT TEST
hw_button_add(PIN_FUEL_DIGIT_TEST,
    function() -- PRESSED
        print("ACTION: Fuel Digit Test PRESSED")
        -- L:FuelDigitTest not specified but assuming similar logic
        fsx_variable_write("L:FuelDigitTest", "Number", 1)
    end,
    function() -- RELEASED
        print("ACTION: Fuel Digit Test RELEASED")
        fsx_variable_write("L:FuelDigitTest", "Number", 0)
    end
)

-- NAV GPS BUTTON LEFT
hw_button_add(PIN_NAV_GPS_BTN_L,
    function()
        print("NAV GPS Left Pressed")
    end,
    function()
        print("NAV GPS Left Released")
    end
)

-- NAV GPS BUTTON RIGHT
hw_button_add(PIN_NAV_GPS_BTN_R,
    function()
        print("NAV GPS Right Pressed")
    end,
    function()
        print("NAV GPS Right Released")
    end
)


-- =============================================================================
-- 6. SIMULATOR SUBSCRIPTIONS
-- =============================================================================

-- Fire Test Bag State
fsx_variable_subscribe("L:firetestbag", "Number", function(val)
    bag_fire_test_state = (val ~= 0) and 1 or 0
    update_bag_fire_test_led()
end)

-- Global Marker Test (L:TestMarker = 1 lights ALL beacon LEDs)
fsx_variable_subscribe("L:TestMarker", "Number", function(val)
    test_marker_state = (val ~= 0) and 1 or 0
    update_marker_leds()
    print("TestMarker state: " .. tostring(test_marker_state))
end)

-- BRG PTR State
fsx_variable_subscribe("L:SwBrgPtr", "Number", function(val)
    local led_val = (val ~= 0) and 1.0 or 0.0
    hw_led_set(led_brg_ptr_h, led_val)
    hw_led_set(led_brg_ptr2_h, led_val)
end)

-- Master Caution LED State (from CWP logic)
fsx_variable_subscribe("L:MasterCaution", "Number", function(val)
    local led_val = (val ~= 0) and 1.0 or 0.0
    hw_led_set(led_mc_l_h, led_val)
    hw_led_set(led_mc_r_h, led_val)
end)

-- DC Bus State (Also subscribed in Pedestal section - duplicates are OK/Safe)
fsx_variable_subscribe("L:MasterDcBus", "Number", function(val)
    dc_bus = (val ~= 0) and 1 or 0
    update_fire_handle_leds()
    update_engine_leds()
end)

-- Engine 1 RPM (for warning light)
fsx_variable_subscribe("L:RPM N1 ENG1", "Number", function(val)
    rpm_n1_e1 = val
    update_engine_leds()
end)

-- Engine 2 RPM (for warning light)
fsx_variable_subscribe("L:RPM N1 ENG2", "Number", function(val)
    rpm_n1_e2 = val
    update_engine_leds()
end)

-- =============================================================================
-- 7. STARTUP INITIALIZATION
-- =============================================================================

print("INIT: Channel B (Front Panel) Logic - Initializing...")

fsx_variable_write("L:SwBrgPtr", "Number", 0)
fsx_variable_write("L:firethandl", "Number", 0)
fsx_variable_write("L:firethandr", "Number", 0)
fsx_variable_write("L:Swfiretest", "Number", 0)
fsx_variable_write("L:firetestbag", "Number", 0)
fsx_variable_write("L:Extinguisher", "Number", 0)
fsx_variable_write("L:TestMarker", "Number", 0)
fsx_variable_write("L:Overtq", "Number", 0)
fsx_variable_write("L:Cyctest", "Number", 0)
fsx_variable_write("L:ResetMC", "Number", 0)
fsx_variable_write("L:FuelQuantity", "Number", 0)
fsx_variable_write("L:FuelDigitTest", "Number", 0)

-- Initialize LEDs
update_fire_handle_leds()
update_marker_leds()
update_overtq_led()
update_cyc_ctr_led()
update_mc_reset()

print("INIT: Channel B (Front Panel) Logic - Initialization Complete")

