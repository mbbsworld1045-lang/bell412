-- =============================================================================
-- BELL 412 - PEDESTAL & OVERHEAD LOGIC (CHANNEL A)
-- Platform: Air Manager + Arduino Mega 2560
-- Hardware: Arduino Channel A (Pedestal/Overhead Panel)
-- Logic: Buttons Only (Active Low)
-- =============================================================================

print("Pedestal Script Running")

-- =============================================================================
-- 1. HARDWARE CONFIGURATION HEADER
-- =============================================================================

-- -------------------------
-- AFCS & Autopilot Inputs (Mega A)
-- -------------------------
local PIN_AP1_SW            = "ARDUINO_MEGA2560_B_D13"
local PIN_AP2_SW            = "ARDUINO_MEGA2560_B_D12"
local PIN_AFCS_SAS_SW       = "ARDUINO_MEGA2560_B_D10"
local PIN_AFCS_TEST_SW      = "ARDUINO_MEGA2560_B_D9"
local PIN_AFCS_TRIM_FD_SW   = "ARDUINO_MEGA2560_B_D7"
local PIN_AFCS_CPL_SW       = "ARDUINO_MEGA2560_B_D6"
local PIN_AFCS_SYS2         = "ARDUINO_MEGA2560_B_D43"

-- -------------------------
-- AFCS & Autopilot LEDs (Mega A)
-- -------------------------
local PIN_AP1_LED           = "ARDUINO_MEGA2560_B_D5"
local PIN_AP2_LED           = "ARDUINO_MEGA2560_B_D4"
local PIN_AFCS_SAS_LED      = "ARDUINO_MEGA2560_B_D2"
local PIN_AFCS_ATT_LED      = "ARDUINO_MEGA2560_B_D3"
local PIN_AFCS_TRIM_LED     = "ARDUINO_MEGA2560_B_A1"      -- Analog as Digital
local PIN_AFCS_TEST_LED     = "ARDUINO_MEGA2560_B_A2"      -- Analog as Digital
local PIN_AFCS_FD_LED       = "ARDUINO_MEGA2560_B_A3"      -- Analog as Digital
local PIN_AFCS_CPL_LED      = "ARDUINO_MEGA2560_B_A4"      -- Analog as Digital

-- -------------------------
-- AHRS & Mag/DG (Mega A)
-- -------------------------
local PIN_AHRS_TEST_1       = "ARDUINO_MEGA2560_B_D53"
local PIN_AHRS_TEST_2       = "ARDUINO_MEGA2560_B_D49"
local PIN_MAG_DG_MAG1       = "ARDUINO_MEGA2560_B_D51"
local PIN_MAG_DG_MAG2       = "ARDUINO_MEGA2560_B_D47"
local PIN_MAG_DG_DG1        = "ARDUINO_MEGA2560_B_D52"
local PIN_MAG_DG_DG2        = "ARDUINO_MEGA2560_B_D48"
local PIN_AHRS_SERVO        = "ARDUINO_MEGA2560_B_D60"     -- Placeholder for Servo

-- -------------------------
-- Fuel & Hydraulics (Mega A)
-- -------------------------
local PIN_VALVE1            = "ARDUINO_MEGA2560_B_D30"
local PIN_VALVE2            = "ARDUINO_MEGA2560_B_D32"
local PIN_XFEED             = "ARDUINO_MEGA2560_B_D28"      -- XFEED Bus Test 1 (L:Swxfeedbus = 1)
local PIN_XFEED_POS2        = "ARDUINO_MEGA2560_B_D31"      -- XFEED Bus Test 2 (L:Swxfeedbus = 2), Ground = 0
local PIN_FUEL_XFEED        = "ARDUINO_MEGA2560_B_D33"      -- Fuel Crossfeed (0=Normal, 1=Over Close)
local PIN_FUEL_TRANS1       = "ARDUINO_MEGA2560_B_D34"      -- Trans Fuel 1 (L:SwfueltransengA)
local PIN_BOOST1            = "ARDUINO_MEGA2560_B_D35"      -- Boost Pump 1 (L:SwboostpuEng1)
local PIN_FUEL_INTCON       = "ARDUINO_MEGA2560_B_D36"      -- Fuel Intercon (L:Swfuelintcon)
local PIN_FUEL_TRANS2       = "ARDUINO_MEGA2560_B_D37"      -- Trans Fuel 2 (L:SwfueltransengB)
local PIN_BOOST2            = "ARDUINO_MEGA2560_B_D38"      -- Boost Pump 2 (L:SwboostpuEng2)
local PIN_HYD1_SW           = "ARDUINO_MEGA2560_B_D39"
local PIN_HYD2_SW           = "ARDUINO_MEGA2560_B_D42"

-- -------------------------
-- Gov, Trim, & Misc (Mega A)
-- -------------------------
local PIN_GOV_ENG1          = "ARDUINO_MEGA2560_B_D23"
local PIN_GOV_ENG2          = "ARDUINO_MEGA2560_B_D29"
local PIN_PARTSEP1          = "ARDUINO_MEGA2560_B_D25"
local PIN_PARTSEP2          = "ARDUINO_MEGA2560_B_D27"
local PIN_FORCE_TRIM        = "ARDUINO_MEGA2560_B_D40"
local PIN_RPM_AUDIO         = "ARDUINO_MEGA2560_B_D41"

-- =============================================================================
-- 2. LED HANDLES
-- =============================================================================
local led_trim_h = hw_output_add("ARDUINO_MEGA2560_B_A1", false)
local led_test_h = hw_output_add("ARDUINO_MEGA2560_B_A2", false)
local led_fd_h   = hw_output_add("ARDUINO_MEGA2560_B_A3", false)
local led_cpl_h  = hw_output_add("ARDUINO_MEGA2560_B_A4", false)

local led_sas_h  = hw_led_add("ARDUINO_MEGA2560_B_D2", 0.0)
local led_att_h  = hw_led_add("ARDUINO_MEGA2560_B_D3", 0.0)
local led_ap2_h  = hw_led_add("ARDUINO_MEGA2560_B_D4", 0.0)
local led_ap1_h  = hw_led_add("ARDUINO_MEGA2560_B_D5", 0.0)

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
hw_button_add("ARDUINO_MEGA2560_B_D13", function()
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
hw_button_add("ARDUINO_MEGA2560_B_D12", function()
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
hw_button_add("ARDUINO_MEGA2560_B_D10", function()
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
hw_button_add("ARDUINO_MEGA2560_B_D7", function()
    trim_cycle = (trim_cycle + 1) % 3
    hw_output_set(led_trim_h, trim_cycle == 1)
    hw_output_set(led_fd_h, trim_cycle == 2)
end)

-- PIN 4: CPL BUTTON (Simple Toggle)
hw_button_add("ARDUINO_MEGA2560_B_D6", function()
    state_cpl = not state_cpl
    hw_output_set(led_cpl_h, state_cpl)
end)

-- PIN 6: TEST BUTTON (30s Timer)
hw_button_add("ARDUINO_MEGA2560_B_D9", function()
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
-- INIT: Pedestal Logic

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

update_sas_att()
