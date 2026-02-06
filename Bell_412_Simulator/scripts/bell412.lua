-- =============================================================================
-- BELL 412 - COMBINED SCRIPT (PEDESTAL + FRONT PANEL + COLLECTIVE)
-- Platform: Air Manager + Arduino Mega 2560
-- Hardware: Channels A (Pedestal), B (Front Panel), C (Collective)
-- =============================================================================

print("Bell 412 - Combined Script is now active")

-- =============================================================================
-- PIN TABLES (reduces local variable count)
-- =============================================================================

-- Channel A: Pedestal
local PINS_A = {
    -- AFCS & Autopilot Inputs
    AP1 = "ARDUINO_MEGA2560_A_D13",
    AP2 = "ARDUINO_MEGA2560_A_D12",
    SAS = "ARDUINO_MEGA2560_A_D10",
    TEST = "ARDUINO_MEGA2560_A_D9",
    TRIM_FD = "ARDUINO_MEGA2560_A_D7",
    CPL = "ARDUINO_MEGA2560_A_D6",
    SYS2 = "ARDUINO_MEGA2560_A_D43",
    -- AHRS & Mag/DG
    AHRS_TEST_1 = "ARDUINO_MEGA2560_A_D53",
    AHRS_TEST_2 = "ARDUINO_MEGA2560_A_D49",
    MAG1 = "ARDUINO_MEGA2560_A_D51",
    MAG2 = "ARDUINO_MEGA2560_A_D47",
    DG1 = "ARDUINO_MEGA2560_A_D52",
    DG2 = "ARDUINO_MEGA2560_A_D48",
    SERVO = "ARDUINO_MEGA2560_A_D60",
    -- Fuel & Hydraulics
    VALVE1 = "ARDUINO_MEGA2560_A_D30",
    VALVE2 = "ARDUINO_MEGA2560_A_D32",
    XFEED1 = "ARDUINO_MEGA2560_A_D28",
    XFEED2 = "ARDUINO_MEGA2560_A_D31",
    FUEL_XFEED = "ARDUINO_MEGA2560_A_D33",
    TRANS1 = "ARDUINO_MEGA2560_A_D34",
    BOOST1 = "ARDUINO_MEGA2560_A_D35",
    INTCON = "ARDUINO_MEGA2560_A_D36",
    TRANS2 = "ARDUINO_MEGA2560_A_D37",
    BOOST2 = "ARDUINO_MEGA2560_A_D38",
    HYD1 = "ARDUINO_MEGA2560_A_D39",
    HYD2 = "ARDUINO_MEGA2560_A_D42",
    -- Gov, Trim, Misc
    GOV1 = "ARDUINO_MEGA2560_A_D23",
    GOV2 = "ARDUINO_MEGA2560_A_D29",
    PARTSEP1 = "ARDUINO_MEGA2560_A_D25",
    PARTSEP2 = "ARDUINO_MEGA2560_A_D27",
    FORCE_TRIM = "ARDUINO_MEGA2560_A_D40",
    RPM_AUDIO = "ARDUINO_MEGA2560_A_D41",
}

-- Channel B: Front Panel
local PINS_B = {
    -- Inputs
    BRG_PTR = "ARDUINO_MEGA2560_B_D38",
    BRG_PTR2 = "ARDUINO_MEGA2560_B_D10",
    FIRE_PULL1 = "ARDUINO_MEGA2560_B_D50",
    FIRE_PULL2 = "ARDUINO_MEGA2560_B_D35",
    FIRE_TEST = "ARDUINO_MEGA2560_B_D51",
    BAG_FIRE_TEST = "ARDUINO_MEGA2560_B_D52",
    EXT_POS1 = "ARDUINO_MEGA2560_B_D7",
    EXT_POS2 = "ARDUINO_MEGA2560_B_D8",
    MARKER_TEST = "ARDUINO_MEGA2560_B_D45",
    MARKER_TEST2 = "ARDUINO_MEGA2560_B_D37",
    OVERTQ_TEST = "ARDUINO_MEGA2560_B_D49",
    OVERTQ_TEST2 = "ARDUINO_MEGA2560_B_D33",
    CYC_L = "ARDUINO_MEGA2560_B_D40",
    CYC_R = "ARDUINO_MEGA2560_B_D32",
    MC_L = "ARDUINO_MEGA2560_B_D41",
    MC_R = "ARDUINO_MEGA2560_B_D36",
    FUEL_FWD = "ARDUINO_MEGA2560_B_D53",
    FUEL_MID = "ARDUINO_MEGA2560_B_D34",
    FUEL_DIGIT = "ARDUINO_MEGA2560_B_D44",
    NAV_R = "ARDUINO_MEGA2560_B_D11",
    NAV_L = "ARDUINO_MEGA2560_B_D25",
    -- LED Outputs
    LED_BRG1 = "ARDUINO_MEGA2560_B_D3",
    LED_BRG2 = "ARDUINO_MEGA2560_B_D13",
    LED_FIRE1 = "ARDUINO_MEGA2560_B_D5",
    LED_FIRE2 = "ARDUINO_MEGA2560_B_D24",
    LED_BAG = "ARDUINO_MEGA2560_B_D2",
    LED_MK_R_WHT = "ARDUINO_MEGA2560_B_D26",
    LED_MK_R_RED = "ARDUINO_MEGA2560_B_D27",
    LED_MK_R_BLU = "ARDUINO_MEGA2560_B_D28",
    LED_MK_L_WHT = "ARDUINO_MEGA2560_B_D46",
    LED_MK_L_BLU = "ARDUINO_MEGA2560_B_D47",
    LED_MK_L_RED = "ARDUINO_MEGA2560_B_D48",
    LED_OT_L = "ARDUINO_MEGA2560_B_D39",
    LED_OT_R = "ARDUINO_MEGA2560_B_D9",
    LED_CYC_L = "ARDUINO_MEGA2560_B_D42",
    LED_CYC_R = "ARDUINO_MEGA2560_B_D30",
    LED_MC_L = "ARDUINO_MEGA2560_B_D43",
    LED_MC_R = "ARDUINO_MEGA2560_B_D31",
    LED_ENG1 = "ARDUINO_MEGA2560_B_D4",
    LED_ENG2 = "ARDUINO_MEGA2560_B_D12",
}

-- Channel C: Collective
local PINS_C = {
    THROTTLE1 = "ARDUINO_MEGA2560_C_A0",
    THROTTLE2 = "ARDUINO_MEGA2560_C_A1",
    LDG_LT = "ARDUINO_MEGA2560_C_D22",
    LDG_EXT = "ARDUINO_MEGA2560_C_D26",
    LDG_RETR = "ARDUINO_MEGA2560_C_D25",
    SRCH_ON = "ARDUINO_MEGA2560_C_D23",
    SRCH_STOW = "ARDUINO_MEGA2560_C_D24",
    SRCH_EXT = "ARDUINO_MEGA2560_C_D39",
    SRCH_L = "ARDUINO_MEGA2560_C_D37",
    SRCH_R = "ARDUINO_MEGA2560_C_D38",
    SRCH_RETR = "ARDUINO_MEGA2560_C_D40",
    IDLE1 = "ARDUINO_MEGA2560_C_D28",
    IDLE2 = "ARDUINO_MEGA2560_C_D29",
    START1 = "ARDUINO_MEGA2560_C_D31",
    START2 = "ARDUINO_MEGA2560_C_D30",
    RPM_INC_RH = "ARDUINO_MEGA2560_C_D34",
    RPM_DEC_RH = "ARDUINO_MEGA2560_C_D35",
    RPM_PLUS2 = "ARDUINO_MEGA2560_C_D36",
    RPM_MINUS2 = "ARDUINO_MEGA2560_C_D33",
    YAW_UP_RH = "ARDUINO_MEGA2560_C_D48",
    YAW_DN_RH = "ARDUINO_MEGA2560_C_D32",
    GA_RH = "ARDUINO_MEGA2560_C_D41",
    RPM_INC_LH = "ARDUINO_MEGA2560_C_D45",
    RPM_DEC_LH = "ARDUINO_MEGA2560_C_D46",
    YAW_UP_LH = "ARDUINO_MEGA2560_C_D44",
    YAW_DN_LH = "ARDUINO_MEGA2560_C_D43",
    GA_LH = "ARDUINO_MEGA2560_C_D42",
}

-- =============================================================================
-- LED HANDLES (grouped into tables)
-- =============================================================================

-- Channel A LEDs
local LEDS_A = {
    trim = hw_output_add("ARDUINO_MEGA2560_A_A1", false),
    test = hw_output_add("ARDUINO_MEGA2560_A_A2", false),
    fd = hw_output_add("ARDUINO_MEGA2560_A_A3", false),
    cpl = hw_output_add("ARDUINO_MEGA2560_A_A4", false),
    sas = hw_led_add("ARDUINO_MEGA2560_A_D2", 0.0),
    att = hw_led_add("ARDUINO_MEGA2560_A_D3", 0.0),
    ap2 = hw_led_add("ARDUINO_MEGA2560_A_D4", 0.0),
    ap1 = hw_led_add("ARDUINO_MEGA2560_A_D5", 0.0),
    servo = hw_output_pwm_add(PINS_A.SERVO, 50, 0.075),
}

-- Channel B LEDs
local LEDS_B = {
    brg1 = hw_led_add(PINS_B.LED_BRG1, 0.0),
    brg2 = hw_led_add(PINS_B.LED_BRG2, 0.0),
    fire1 = hw_led_add(PINS_B.LED_FIRE1, 0.0),
    fire2 = hw_led_add(PINS_B.LED_FIRE2, 0.0),
    bag = hw_led_add(PINS_B.LED_BAG, 0.0),
    mk_r_red = hw_led_add(PINS_B.LED_MK_R_RED, 0.0),
    mk_r_wht = hw_led_add(PINS_B.LED_MK_R_WHT, 0.0),
    mk_r_blu = hw_led_add(PINS_B.LED_MK_R_BLU, 0.0),
    mk_l_wht = hw_led_add(PINS_B.LED_MK_L_WHT, 0.0),
    mk_l_blu = hw_led_add(PINS_B.LED_MK_L_BLU, 0.0),
    mk_l_red = hw_led_add(PINS_B.LED_MK_L_RED, 0.0),
    ot_l = hw_led_add(PINS_B.LED_OT_L, 0.0),
    ot_r = hw_led_add(PINS_B.LED_OT_R, 0.0),
    cyc_l = hw_led_add(PINS_B.LED_CYC_L, 0.0),
    cyc_r = hw_led_add(PINS_B.LED_CYC_R, 0.0),
    mc_l = hw_led_add(PINS_B.LED_MC_L, 0.0),
    mc_r = hw_led_add(PINS_B.LED_MC_R, 0.0),
    eng1 = hw_led_add(PINS_B.LED_ENG1, 0.0),
    eng2 = hw_led_add(PINS_B.LED_ENG2, 0.0),
}

-- =============================================================================
-- STATE TRACKING (grouped into tables)
-- =============================================================================

local STATE = {
    -- Pedestal (Channel A)
    ap1 = false, ap2 = false, cpl = false,
    sas_mode = "SAS", trim_cycle = 0, test_timer = nil,
    mag1 = false, mag2 = false, dg1 = false, dg2 = false, mag_dg = 0,
    ahrs1 = false, ahrs2 = false, ahrs_test = 0,
    xfeed1 = false, xfeed2 = false, xfeed = 0,
    
    -- Front Panel (Channel B)
    fire1 = 0, fire2 = 0, fire_test = false, bag_fire = 0,
    ext1 = false, ext2 = false, ext_state = 0,
    marker = 0, overtq = 0, cyc_test = 0,
    mc_l = false, mc_r = false,
    dc_bus = 0, test_mc = 0, rpm_n1_e1 = 100.0, rpm_n1_e2 = 100.0,
    
    -- Collective (Channel C)
    idle1 = false, idle2 = false,
}

-- =============================================================================
-- HELPER FUNCTIONS
-- =============================================================================

local function update_sas_att()
    if STATE.ap1 or STATE.ap2 then
        if STATE.sas_mode == "SAS" then hw_led_set(LEDS_A.sas, 1.0); hw_led_set(LEDS_A.att, 0.0)
        else hw_led_set(LEDS_A.sas, 0.0); hw_led_set(LEDS_A.att, 1.0) end
    else hw_led_set(LEDS_A.sas, 0.0); hw_led_set(LEDS_A.att, 0.0) end
end

local function set_servo(id, pos)
    hw_output_pwm_duty_cycle(id, 0.05 + (math.max(0, math.min(1, pos)) * 0.05))
end

local function update_mag_dg()
    local ns = 0
    if STATE.dg1 or STATE.dg2 then ns = 2
    elseif STATE.mag1 or STATE.mag2 then ns = 1 end
    if STATE.mag_dg ~= ns then STATE.mag_dg = ns; fsx_variable_write("L:SwMagDg", "Number", ns) end
end

local function update_ahrs_test()
    local ns = (STATE.ahrs1 or STATE.ahrs2) and 1 or 0
    if STATE.ahrs_test ~= ns then STATE.ahrs_test = ns; fsx_variable_write("L:AHRSTest", "Number", ns) end
end

local function update_xfeed()
    local ns = 0
    if STATE.xfeed2 then ns = 2 elseif STATE.xfeed1 then ns = 1 end
    if STATE.xfeed ~= ns then STATE.xfeed = ns; fsx_variable_write("L:Swxfeedbus", "Number", ns) end
end

local function update_fire_leds()
    if STATE.dc_bus == 0 then hw_led_set(LEDS_B.fire1, 0.0); hw_led_set(LEDS_B.fire2, 0.0); return end
    if STATE.fire_test then hw_led_set(LEDS_B.fire1, 1.0); hw_led_set(LEDS_B.fire2, 1.0)
    else
        hw_led_set(LEDS_B.fire1, (STATE.fire1 == 1) and 1.0 or 0.0)
        hw_led_set(LEDS_B.fire2, (STATE.fire2 == 1) and 1.0 or 0.0)
    end
end

local function update_marker_leds()
    local v = (STATE.marker == 1) and 1.0 or 0.0
    hw_led_set(LEDS_B.mk_l_wht, v); hw_led_set(LEDS_B.mk_l_blu, v); hw_led_set(LEDS_B.mk_l_red, v)
    hw_led_set(LEDS_B.mk_r_wht, v); hw_led_set(LEDS_B.mk_r_red, v); hw_led_set(LEDS_B.mk_r_blu, v)
end

local function update_overtq()
    local v = (STATE.overtq == 1) and 1.0 or 0.0
    hw_led_set(LEDS_B.ot_l, v); hw_led_set(LEDS_B.ot_r, v)
end

local function update_cyc_ctr()
    local v = (STATE.cyc_test == 1) and 1.0 or 0.0
    hw_led_set(LEDS_B.cyc_l, v); hw_led_set(LEDS_B.cyc_r, v)
end

local function update_extinguisher()
    local ns = 0
    if STATE.ext2 then ns = 2 elseif STATE.ext1 then ns = 1 end
    if STATE.ext_state ~= ns then STATE.ext_state = ns; fsx_variable_write("L:Extinguisher", "Number", ns) end
end

local function update_mc_reset()
    fsx_variable_write("L:ResetMC", "Number", (STATE.mc_l or STATE.mc_r) and 1 or 0)
    hw_led_set(LEDS_B.mc_l, STATE.mc_l and 1.0 or 0.0)
    hw_led_set(LEDS_B.mc_r, STATE.mc_r and 1.0 or 0.0)
end

local function update_engine_leds()
    if STATE.dc_bus == 0 then hw_led_set(LEDS_B.eng1, 0.0); hw_led_set(LEDS_B.eng2, 0.0); return end
    hw_led_set(LEDS_B.eng1, ((STATE.test_mc ~= 0) or (STATE.rpm_n1_e1 <= 55.0)) and 1.0 or 0.0)
    hw_led_set(LEDS_B.eng2, ((STATE.test_mc ~= 0) or (STATE.rpm_n1_e2 <= 55.0)) and 1.0 or 0.0)
end

local function throttle_val(raw, release)
    if release then return raw else return (raw < 0.12) and 0.12 or raw end
end

local function rpm_inc(pressed)
    if pressed then fsx_variable_write("L:GOVERNOR RPM SWITCH", "Number", 1); fsx_event("ROTOR_GOV_RPM_INC")
    else fsx_variable_write("L:GOVERNOR RPM SWITCH", "Number", 0) end
end

local function rpm_dec(pressed)
    if pressed then fsx_variable_write("L:GOVERNOR RPM SWITCH", "Number", -1); fsx_event("ROTOR_GOV_RPM_DEC")
    else fsx_variable_write("L:GOVERNOR RPM SWITCH", "Number", 0) end
end

-- =============================================================================
-- CHANNEL A: PEDESTAL BUTTON HANDLERS
-- =============================================================================

hw_button_add(PINS_A.AP1, function()
    local any = STATE.ap1 or STATE.ap2
    STATE.ap1 = not STATE.ap1
    hw_led_set(LEDS_A.ap1, STATE.ap1 and 1.0 or 0.0)
    if STATE.ap1 and not any then STATE.sas_mode = "SAS" end
    update_sas_att()
end)

hw_button_add(PINS_A.AP2, function()
    local any = STATE.ap1 or STATE.ap2
    STATE.ap2 = not STATE.ap2
    hw_led_set(LEDS_A.ap2, STATE.ap2 and 1.0 or 0.0)
    if STATE.ap2 and not any then STATE.sas_mode = "SAS" end
    update_sas_att()
end)

hw_button_add(PINS_A.SAS, function()
    if STATE.ap1 or STATE.ap2 then
        STATE.sas_mode = (STATE.sas_mode == "SAS") and "ATT" or "SAS"
        update_sas_att()
    end
end)

hw_button_add(PINS_A.TRIM_FD, function()
    STATE.trim_cycle = (STATE.trim_cycle + 1) % 3
    hw_output_set(LEDS_A.trim, STATE.trim_cycle == 1)
    hw_output_set(LEDS_A.fd, STATE.trim_cycle == 2)
end)

hw_button_add(PINS_A.CPL, function() STATE.cpl = not STATE.cpl; hw_output_set(LEDS_A.cpl, STATE.cpl) end)

hw_button_add(PINS_A.TEST, function()
    hw_output_set(LEDS_A.test, true)
    if STATE.test_timer then timer_stop(STATE.test_timer) end
    STATE.test_timer = timer_start(30000, function() hw_output_set(LEDS_A.test, false); STATE.test_timer = nil end)
end)

hw_button_add(PINS_A.AHRS_TEST_1, function() STATE.ahrs1 = true; update_ahrs_test() end, function() STATE.ahrs1 = false; update_ahrs_test() end)
hw_button_add(PINS_A.AHRS_TEST_2, function() STATE.ahrs2 = true; update_ahrs_test() end, function() STATE.ahrs2 = false; update_ahrs_test() end)

hw_button_add(PINS_A.MAG1, function() STATE.mag1 = true; update_mag_dg() end, function() STATE.mag1 = false; update_mag_dg() end)
hw_button_add(PINS_A.MAG2, function() STATE.mag2 = true; update_mag_dg() end, function() STATE.mag2 = false; update_mag_dg() end)
hw_button_add(PINS_A.DG1, function() STATE.dg1 = true; update_mag_dg() end, function() STATE.dg1 = false; update_mag_dg() end)
hw_button_add(PINS_A.DG2, function() STATE.dg2 = true; update_mag_dg() end, function() STATE.dg2 = false; update_mag_dg() end)

hw_button_add(PINS_A.VALVE1, function() fsx_variable_write("L:SwvalveEng1", "Number", 0) end, function() fsx_variable_write("L:SwvalveEng1", "Number", 1) end)
hw_button_add(PINS_A.VALVE2, function() fsx_variable_write("L:SwvalveEng2", "Number", 1) end, function() fsx_variable_write("L:SwvalveEng2", "Number", 0) end)

hw_button_add(PINS_A.XFEED1, function() STATE.xfeed1 = true; update_xfeed() end, function() STATE.xfeed1 = false; update_xfeed() end)
hw_button_add(PINS_A.XFEED2, function() STATE.xfeed2 = true; update_xfeed() end, function() STATE.xfeed2 = false; update_xfeed() end)

hw_button_add(PINS_A.FUEL_XFEED, function() fsx_variable_write("L:SwFuelxfeed", "Number", 0) end, function() fsx_variable_write("L:SwFuelxfeed", "Number", 1) end)
hw_button_add(PINS_A.TRANS1, function() fsx_variable_write("L:SwfueltransengA", "Number", 0) end, function() fsx_variable_write("L:SwfueltransengA", "Number", 1) end)
hw_button_add(PINS_A.TRANS2, function() fsx_variable_write("L:SwfueltransengB", "Number", 1) end, function() fsx_variable_write("L:SwfueltransengB", "Number", 0) end)
hw_button_add(PINS_A.BOOST1, function() fsx_variable_write("L:SwboostpuEng1", "Number", 1) end, function() fsx_variable_write("L:SwboostpuEng1", "Number", 0) end)
hw_button_add(PINS_A.BOOST2, function() fsx_variable_write("L:SwboostpuEng2", "Number", 1) end, function() fsx_variable_write("L:SwboostpuEng2", "Number", 0) end)
hw_button_add(PINS_A.INTCON, function() fsx_variable_write("L:Swfuelintcon", "Number", 0) end, function() fsx_variable_write("L:Swfuelintcon", "Number", 1) end)

hw_button_add(PINS_A.HYD1, function() fsx_variable_write("L:Sw hydsysA", "Number", 0) end, function() fsx_variable_write("L:Sw hydsysA", "Number", 1) end)
hw_button_add(PINS_A.HYD2, function() fsx_variable_write("L:Sw hydsysB", "Number", 1) end, function() fsx_variable_write("L:Sw hydsysB", "Number", 0) end)

hw_button_add(PINS_A.GOV1, function() fsx_variable_write("L:SwGovA", "Number", 0) end, function() fsx_variable_write("L:SwGovA", "Number", 1) end)
hw_button_add(PINS_A.GOV2, function() fsx_variable_write("L:SwGovB", "Number", 0) end, function() fsx_variable_write("L:SwGovB", "Number", 1) end)
hw_button_add(PINS_A.PARTSEP1, function() fsx_variable_write("L:SwpartsepA", "Number", 0) end, function() fsx_variable_write("L:SwpartsepA", "Number", 1) end)
hw_button_add(PINS_A.PARTSEP2, function() fsx_variable_write("L:SwpartsepB", "Number", 0) end, function() fsx_variable_write("L:SwpartsepB", "Number", 1) end)

hw_button_add(PINS_A.FORCE_TRIM, function() fsx_variable_write("L:Sw forcetrim", "Number", 0); fsx_event("ROTOR_TRIM_RESET") end, function() fsx_variable_write("L:Sw forcetrim", "Number", 1) end)
hw_button_add(PINS_A.RPM_AUDIO, function() fsx_variable_write("L:Sw RPMAudio", "Number", 0) end, function() fsx_variable_write("L:Sw RPMAudio", "Number", 1) end)

-- =============================================================================
-- CHANNEL B: FRONT PANEL BUTTON HANDLERS
-- =============================================================================

hw_button_add(PINS_B.BRG_PTR, function() fsx_variable_write("L:SwBrgPtr", "Number", 1); hw_led_set(LEDS_B.brg1, 1.0) end, function() fsx_variable_write("L:SwBrgPtr", "Number", 0); hw_led_set(LEDS_B.brg1, 0.0) end)
hw_button_add(PINS_B.BRG_PTR2, function() fsx_variable_write("L:SwBrgPtr", "Number", 1); hw_led_set(LEDS_B.brg2, 1.0) end, function() fsx_variable_write("L:SwBrgPtr", "Number", 0); hw_led_set(LEDS_B.brg2, 0.0) end)

hw_button_add(PINS_B.FIRE_PULL1, function() STATE.fire1 = 1; fsx_variable_write("L:firethandl", "Number", 1); update_fire_leds() end, function() STATE.fire1 = 0; fsx_variable_write("L:firethandl", "Number", 0); update_fire_leds() end)
hw_button_add(PINS_B.FIRE_PULL2, function() STATE.fire2 = 1; fsx_variable_write("L:firethandr", "Number", 1); update_fire_leds() end, function() STATE.fire2 = 0; fsx_variable_write("L:firethandr", "Number", 0); update_fire_leds() end)

hw_button_add(PINS_B.FIRE_TEST, function() STATE.fire_test = true; fsx_variable_write("L:Swfiretest", "Number", 1); update_fire_leds() end, function() STATE.fire_test = false; fsx_variable_write("L:Swfiretest", "Number", 0); update_fire_leds() end)
hw_button_add(PINS_B.BAG_FIRE_TEST, function() STATE.bag_fire = 1; fsx_variable_write("L:firetestbag", "Number", 1); hw_led_set(LEDS_B.bag, 1.0) end, function() STATE.bag_fire = 0; fsx_variable_write("L:firetestbag", "Number", 0); hw_led_set(LEDS_B.bag, 0.0) end)

hw_button_add(PINS_B.EXT_POS1, function() STATE.ext1 = true; update_extinguisher() end, function() STATE.ext1 = false; update_extinguisher() end)
hw_button_add(PINS_B.EXT_POS2, function() STATE.ext2 = true; update_extinguisher() end, function() STATE.ext2 = false; update_extinguisher() end)

hw_button_add(PINS_B.MARKER_TEST, function() STATE.marker = 1; fsx_variable_write("L:TestMarker", "Number", 1); update_marker_leds() end, function() STATE.marker = 0; fsx_variable_write("L:TestMarker", "Number", 0); update_marker_leds() end)
hw_button_add(PINS_B.MARKER_TEST2, function() STATE.marker = 1; fsx_variable_write("L:TestMarker", "Number", 1); update_marker_leds() end, function() STATE.marker = 0; fsx_variable_write("L:TestMarker", "Number", 0); update_marker_leds() end)

hw_button_add(PINS_B.OVERTQ_TEST, function() STATE.overtq = 1; fsx_variable_write("L:Overtq", "Number", 1); update_overtq() end, function() STATE.overtq = 0; fsx_variable_write("L:Overtq", "Number", 0); update_overtq() end)
hw_button_add(PINS_B.OVERTQ_TEST2, function() STATE.overtq = 1; fsx_variable_write("L:Overtq", "Number", 1); update_overtq() end, function() STATE.overtq = 0; fsx_variable_write("L:Overtq", "Number", 0); update_overtq() end)

hw_button_add(PINS_B.CYC_L, function() STATE.cyc_test = 1; fsx_variable_write("L:Cyctest", "Number", 1); update_cyc_ctr() end, function() STATE.cyc_test = 0; fsx_variable_write("L:Cyctest", "Number", 0); update_cyc_ctr() end)
hw_button_add(PINS_B.CYC_R, function() STATE.cyc_test = 1; fsx_variable_write("L:Cyctest", "Number", 1); update_cyc_ctr() end, function() STATE.cyc_test = 0; fsx_variable_write("L:Cyctest", "Number", 0); update_cyc_ctr() end)

hw_button_add(PINS_B.MC_L, function() STATE.mc_l = true; update_mc_reset() end, function() STATE.mc_l = false; update_mc_reset() end)
hw_button_add(PINS_B.MC_R, function() STATE.mc_r = true; update_mc_reset() end, function() STATE.mc_r = false; update_mc_reset() end)

hw_button_add(PINS_B.FUEL_FWD, function() fsx_variable_write("L:FuelQuantity", "Number", 1) end, function() fsx_variable_write("L:FuelQuantity", "Number", 0) end)
hw_button_add(PINS_B.FUEL_MID, function() fsx_variable_write("L:FuelQuantity", "Number", -1) end, function() fsx_variable_write("L:FuelQuantity", "Number", 0) end)
hw_button_add(PINS_B.FUEL_DIGIT, function() fsx_variable_write("L:Digitstest", "Number", 1) end, function() fsx_variable_write("L:Digitstest", "Number", 0) end)

hw_button_add(PINS_B.NAV_R, function() fsx_variable_write("L:NavGpsR", "Number", 1) end, function() fsx_variable_write("L:NavGpsR", "Number", 0) end)
hw_button_add(PINS_B.NAV_L, function() fsx_variable_write("L:NavGpsL", "Number", 1) end, function() fsx_variable_write("L:NavGpsL", "Number", 0) end)

-- =============================================================================
-- CHANNEL C: COLLECTIVE HANDLERS
-- =============================================================================

hw_adc_input_add(PINS_C.THROTTLE1, function(val) fsx_variable_write("L:throgas1", "Number", throttle_val(val, STATE.idle1)) end)
hw_adc_input_add(PINS_C.THROTTLE2, function(val) fsx_variable_write("L:throgas2", "Number", throttle_val(val, STATE.idle2)) end)

hw_button_add(PINS_C.START1, function() print("BTN: START ENG1"); fsx_variable_write("L:starteng", "Number", 1) end, function() fsx_variable_write("L:starteng", "Number", 0) end)
hw_button_add(PINS_C.START2, function() print("BTN: START ENG2"); fsx_variable_write("L:starteng", "Number", -1) end, function() fsx_variable_write("L:starteng", "Number", 0) end)

hw_button_add(PINS_C.IDLE1, function() print("BTN: IDLE STOP ENG1"); STATE.idle1 = true; fsx_variable_write("L:idle eng", "Number", 1) end, function() STATE.idle1 = false; fsx_variable_write("L:idle eng", "Number", 0) end)
hw_button_add(PINS_C.IDLE2, function() print("BTN: IDLE STOP ENG2"); STATE.idle2 = true; fsx_variable_write("L:idle eng", "Number", -1) end, function() STATE.idle2 = false; fsx_variable_write("L:idle eng", "Number", 0) end)

hw_button_add(PINS_C.RPM_INC_RH, function() print("BTN: RPM INC"); rpm_inc(true) end, function() rpm_inc(false) end)
hw_button_add(PINS_C.RPM_DEC_RH, function() print("BTN: RPM DEC"); rpm_dec(true) end, function() rpm_dec(false) end)
hw_button_add(PINS_C.RPM_INC_LH, function() rpm_inc(true) end, function() rpm_inc(false) end)
hw_button_add(PINS_C.RPM_DEC_LH, function() rpm_dec(true) end, function() rpm_dec(false) end)

hw_button_add(PINS_C.RPM_PLUS2, function() print("BTN: RPM +2") end, function() end)
hw_button_add(PINS_C.RPM_MINUS2, function() print("BTN: RPM -2") end, function() end)

hw_button_add(PINS_C.GA_RH, function() print("BTN: GO AROUND RH") end, function() end)
hw_button_add(PINS_C.GA_LH, function() print("BTN: GO AROUND LH") end, function() end)

hw_button_add(PINS_C.LDG_EXT, function() print("BTN: LDG LT EXT"); fsx_variable_write("L:landext", "Number", 1) end, function() end)
hw_button_add(PINS_C.LDG_RETR, function() print("BTN: LDG LT RETR"); fsx_variable_write("L:landext", "Number", 0) end, function() end)
hw_button_add(PINS_C.LDG_LT, function() print("BTN: LDG LIGHT LT") end, function() end)

hw_button_add(PINS_C.SRCH_L, function() print("BTN: SRCH LT L"); fsx_variable_write("L:Srchlr", "Number", -1) end, function() fsx_variable_write("L:Srchlr", "Number", 0) end)
hw_button_add(PINS_C.SRCH_R, function() print("BTN: SRCH LT R"); fsx_variable_write("L:Srchlr", "Number", 1) end, function() fsx_variable_write("L:Srchlr", "Number", 0) end)
hw_button_add(PINS_C.SRCH_EXT, function() print("BTN: SRCH LT EXT"); fsx_variable_write("L:Srchext", "Number", 1) end, function() end)
hw_button_add(PINS_C.SRCH_RETR, function() print("BTN: SRCH LT RETR"); fsx_variable_write("L:Srchext", "Number", 0) end, function() end)
hw_button_add(PINS_C.SRCH_STOW, function() print("BTN: SRCH LT STOW") end, function() end)
hw_button_add(PINS_C.SRCH_ON, function() print("BTN: SRCH LT ON") end, function() end)

hw_button_add(PINS_C.YAW_UP_RH, function() print("BTN: YAW UP RH") end, function() end)
hw_button_add(PINS_C.YAW_DN_RH, function() print("BTN: YAW DOWN RH") end, function() end)
hw_button_add(PINS_C.YAW_UP_LH, function() print("BTN: YAW UP LH") end, function() end)
hw_button_add(PINS_C.YAW_DN_LH, function() print("BTN: YAW DOWN LH") end, function() end)

-- =============================================================================
-- SIMULATOR SUBSCRIPTIONS
-- =============================================================================

fsx_variable_subscribe("L:MasterDcBus", "Number", function(val) STATE.dc_bus = (val ~= 0) and 1 or 0; update_fire_leds(); update_engine_leds(); update_sas_att() end)
fsx_variable_subscribe("L:TestMC", "Number", function(val) STATE.test_mc = val or 0; update_engine_leds() end)
fsx_variable_subscribe("TURB ENG N1:1", "Percent", function(val) STATE.rpm_n1_e1 = val or 0.0; update_engine_leds() end)
fsx_variable_subscribe("TURB ENG N1:2", "Percent", function(val) STATE.rpm_n1_e2 = val or 0.0; update_engine_leds() end)
fsx_variable_subscribe("L:firethandl", "Number", function(val) STATE.fire1 = (val ~= 0) and 1 or 0; update_fire_leds() end)
fsx_variable_subscribe("L:firethandr", "Number", function(val) STATE.fire2 = (val ~= 0) and 1 or 0; update_fire_leds() end)
fsx_variable_subscribe("L:Cyctest", "Number", function(val) STATE.cyc_test = (val ~= 0) and 1 or 0; update_cyc_ctr() end)
fsx_variable_subscribe("L:firetestbag", "Number", function(val) STATE.bag_fire = (val ~= 0) and 1 or 0; hw_led_set(LEDS_B.bag, (STATE.bag_fire == 1) and 1.0 or 0.0) end)
fsx_variable_subscribe("L:TestMarker", "Number", function(val) STATE.marker = (val ~= 0) and 1 or 0; update_marker_leds() end)
fsx_variable_subscribe("L:Overtq", "Number", function(val) STATE.overtq = (val ~= 0) and 1 or 0; update_overtq() end)
fsx_variable_subscribe("L:SwBrgPtr", "Number", function(val) local v = (val ~= 0) and 1.0 or 0.0; hw_led_set(LEDS_B.brg1, v); hw_led_set(LEDS_B.brg2, v) end)
fsx_variable_subscribe("L:MasterCaution", "Number", function(val) local v = (val ~= 0) and 1.0 or 0.0; hw_led_set(LEDS_B.mc_l, v); hw_led_set(LEDS_B.mc_r, v) end)
fsx_variable_subscribe("L:AutoPilot", "Number", function(val) local ns = (val ~= 0); if STATE.ap1 ~= ns then STATE.ap1 = ns; hw_led_set(LEDS_A.ap1, ns and 1.0 or 0.0); update_sas_att() end end)
fsx_variable_subscribe("L:AutoPilot2", "Number", function(val) local ns = (val ~= 0); if STATE.ap2 ~= ns then STATE.ap2 = ns; hw_led_set(LEDS_A.ap2, ns and 1.0 or 0.0); update_sas_att() end end)
fsx_variable_subscribe("L:SASATT", "Number", function(val) local nm = (val ~= 0) and "ATT" or "SAS"; if STATE.sas_mode ~= nm then STATE.sas_mode = nm; update_sas_att() end end)
fsx_variable_subscribe("L:CplActive", "Number", function(val) local ns = (val ~= 0); if STATE.cpl ~= ns then STATE.cpl = ns; hw_output_set(LEDS_A.cpl, ns) end end)
fsx_variable_subscribe("A:INDICATED HEADING", "Degrees", function(val) set_servo(LEDS_A.servo, ((val % 360) + 360) % 360 / 360) end)

-- =============================================================================
-- INITIALIZATION
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
fsx_variable_write("L:firethandl", "Number", 0)
fsx_variable_write("L:firethandr", "Number", 0)
fsx_variable_write("L:Swfiretest", "Number", 0)
fsx_variable_write("L:firetestbag", "Number", 0)
fsx_variable_write("L:Extinguisher", "Number", 0)
fsx_variable_write("L:TestMarker", "Number", 0)
fsx_variable_write("L:Overtq", "Number", 0)
fsx_variable_write("L:Cyctest", "Number", 0)
fsx_variable_write("L:ResetMC", "Number", 0)
fsx_variable_write("L:SwBrgPtr", "Number", 0)
fsx_variable_write("L:FuelQuantity", "Number", 0)
fsx_variable_write("L:starteng", "Number", 0)
fsx_variable_write("L:idle eng", "Number", 0)
fsx_variable_write("L:GOVERNOR RPM SWITCH", "Number", 0)
fsx_variable_write("L:landext", "Number", 0)
fsx_variable_write("L:Srchlr", "Number", 0)

update_sas_att()
update_fire_leds()
update_marker_leds()
update_overtq()
update_cyc_ctr()
update_extinguisher()
update_engine_leds()

print("Bell 412 Combined Script Loaded - Channels A, B, C")
