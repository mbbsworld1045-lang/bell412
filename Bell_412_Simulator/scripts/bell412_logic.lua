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
    FT_RELEASE = "ARDUINO_MEGA2560_C_D47", -- New Force Trim Release
}

-- =============================================================================


-- Channel D: Overhead Panel
local PINS_D = {
    BATT1 = "ARDUINO_MEGA2560_D_D44",
    BATT2 = "ARDUINO_MEGA2560_D_D49",
    GEN1_ON = "ARDUINO_MEGA2560_D_D50",
    GEN1_RESET = "ARDUINO_MEGA2560_D_D51",
    GEN2_ON = "ARDUINO_MEGA2560_D_A9",
    GEN2_RESET = "ARDUINO_MEGA2560_D_A10",
    INV1 = "ARDUINO_MEGA2560_D_A12",
    INV2 = "ARDUINO_MEGA2560_D_A11",
    NON_BUS = "ARDUINO_MEGA2560_D_A13",
    EMER_LOAD = "ARDUINO_MEGA2560_D_A14",
    STBY_ATT = "ARDUINO_MEGA2560_D_D10",
    MAP_DIM_BTN = "ARDUINO_MEGA2560_D_D11",
    PITOT = "ARDUINO_MEGA2560_D_D53",
    NAV = "ARDUINO_MEGA2560_D_D15",
    ANTICOLL = "ARDUINO_MEGA2560_D_D16",
    WIPER_PI = "ARDUINO_MEGA2560_D_D17",
    WIPER_CO = "ARDUINO_MEGA2560_D_D18",
    HEATER = "ARDUINO_MEGA2560_D_D43",
    BLOWER = "ARDUINO_MEGA2560_D_D36",
    AFT_OUTLET = "ARDUINO_MEGA2560_D_D37",
    DOME = "ARDUINO_MEGA2560_D_D22",
    UTIL = "ARDUINO_MEGA2560_D_D23",
    FIRE1 = "ARDUINO_MEGA2560_D_D24",
    FIRE2 = "ARDUINO_MEGA2560_D_D25",
    FIRE_TEST = "ARDUINO_MEGA2560_D_D26",
    COMPASS = "ARDUINO_MEGA2560_D_D27",
    MAP_DIM = "ARDUINO_MEGA2560_D_A0",
    -- Output LEDs
    LED_GEN1_FAIL = "ARDUINO_MEGA2560_D_D30",
    LED_GEN2_FAIL = "ARDUINO_MEGA2560_D_D31",
    LED_INV1_FAIL = "ARDUINO_MEGA2560_D_D32",
    LED_INV2_FAIL = "ARDUINO_MEGA2560_D_D33",
    LED_BATT_CAUT = "ARDUINO_MEGA2560_D_D34",
    LED_FIRE1 = "ARDUINO_MEGA2560_D_D35",
    LED_FIRE2 = "ARDUINO_MEGA2560_D_D36",
    LED_BAG_FIRE = "ARDUINO_MEGA2560_D_D37",
}

-- Channel E: Caution Panel
local PINS_E = {
    -- Digital Inputs
    TEST_SW_POS1 = "ARDUINO_MEGA2560_E_D22",
    TEST_BTN = "ARDUINO_MEGA2560_E_D23",
    TEST_SW_POS2 = "ARDUINO_MEGA2560_E_D24",
    BRIGHT_DIM_POS1 = "ARDUINO_MEGA2560_E_D4",
    BRIGHT_DIM_POS2 = "ARDUINO_MEGA2560_E_D5",
    -- LED Outputs
    LED_ENG1_OUT = "ARDUINO_MEGA2560_E_D25",
    LED_ENG2_OUT = "ARDUINO_MEGA2560_E_D26",
    LED_ROTOR_BRAKE = "ARDUINO_MEGA2560_E_D27",
    LED_XMSN_OIL_PRESS = "ARDUINO_MEGA2560_E_D28",
    LED_XMSN_OIL_TEMP = "ARDUINO_MEGA2560_E_D29",
    LED_CBOX_OIL_PRESS = "ARDUINO_MEGA2560_E_D30",
    LED_CBOX_OIL_TEMP = "ARDUINO_MEGA2560_E_D31",
    LED_BATT1_HOT = "ARDUINO_MEGA2560_E_D32",
    LED_BATT2_HOT = "ARDUINO_MEGA2560_E_D33",
    LED_ENG_OIL_PRESS1 = "ARDUINO_MEGA2560_E_D34",
    LED_ENG_OIL_PRESS2 = "ARDUINO_MEGA2560_E_D35",
    LED_ENG_CHIP1 = "ARDUINO_MEGA2560_E_D36",
    LED_ENG_CHIP2 = "ARDUINO_MEGA2560_E_D37",
    LED_FUEL_FILTER1 = "ARDUINO_MEGA2560_E_D38",
    LED_FUEL_FILTER2 = "ARDUINO_MEGA2560_E_D39",
    LED_FUEL_BOOST1 = "ARDUINO_MEGA2560_E_D40",
    LED_FUEL_BOOST2 = "ARDUINO_MEGA2560_E_D41",
    LED_FUEL_TRANS1 = "ARDUINO_MEGA2560_E_D42",
    LED_FUEL_TRANS2 = "ARDUINO_MEGA2560_E_D50",
    LED_FUEL_VALVE1 = "ARDUINO_MEGA2560_E_D49",
    LED_FUEL_VALVE2 = "ARDUINO_MEGA2560_E_D48",
    LED_FUEL_LOW = "ARDUINO_MEGA2560_E_D3",
    LED_FUEL_INTCON = "ARDUINO_MEGA2560_E_D47",
    LED_FUEL_XFEED = "ARDUINO_MEGA2560_E_D46",
    LED_GOV_MAN1 = "ARDUINO_MEGA2560_E_D45",
    LED_GOV_MAN2 = "ARDUINO_MEGA2560_E_D44",
    LED_PARTSEP1 = "ARDUINO_MEGA2560_E_D43",
    LED_PARTSEP2 = "ARDUINO_MEGA2560_E_D6",
    LED_DC_GEN1 = "ARDUINO_MEGA2560_E_D7",
    LED_DC_GEN2 = "ARDUINO_MEGA2560_E_D8",
    LED_INVERTER1 = "ARDUINO_MEGA2560_E_A15",
    LED_INVERTER2 = "ARDUINO_MEGA2560_E_A14",
    LED_BATTERY = "ARDUINO_MEGA2560_E_A13",
    LED_GEN_OVHT1 = "ARDUINO_MEGA2560_E_A12",
    LED_GEN_OVHT2 = "ARDUINO_MEGA2560_E_A11",
    LED_HYDRAULIC1 = "ARDUINO_MEGA2560_E_A10",
    LED_HYDRAULIC2 = "ARDUINO_MEGA2560_E_A9",
    LED_EXT_POWER = "ARDUINO_MEGA2560_E_A8",
    LED_XMSN_CHIP = "ARDUINO_MEGA2560_E_A7",
    LED_CBOX_CHIP = "ARDUINO_MEGA2560_E_A6",
    LED_4290_CHIP = "ARDUINO_MEGA2560_E_A5",
    LED_OVER_TORQ = "ARDUINO_MEGA2560_E_D51",
    LED_RPM = "ARDUINO_MEGA2560_E_D52",
    LED_AFCS = "ARDUINO_MEGA2560_E_D53",
    LED_FT_OFF = "ARDUINO_MEGA2560_E_A4",
    LED_CYC_CTR = "ARDUINO_MEGA2560_E_A3",
    LED_DOOR_LOCK = "ARDUINO_MEGA2560_E_A2",
    LED_HEATER_AIR = "ARDUINO_MEGA2560_E_A1",
    LED_CAUTION_PNL = "ARDUINO_MEGA2560_E_A0",
    LED_EMER_FLOATS = "ARDUINO_MEGA2560_E_D9",
    LED_CARGO_REL = "ARDUINO_MEGA2560_E_D10",
    LED_BAG_FIRE = "ARDUINO_MEGA2560_E_D11",
    LED_WSHLD_HEAT = "ARDUINO_MEGA2560_E_D12",
    LED_20FT_CAUTION = "ARDUINO_MEGA2560_E_D13",
    LED_NIGHTSUN = "ARDUINO_MEGA2560_E_D2",
    LED_SPARE = "ARDUINO_MEGA2560_E_D14",


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

-- Channel D LEDs
local LEDS_D = {
    gen1_fail = hw_led_add(PINS_D.LED_GEN1_FAIL, 0.0),
    gen2_fail = hw_led_add(PINS_D.LED_GEN2_FAIL, 0.0),
    inv1_fail = hw_led_add(PINS_D.LED_INV1_FAIL, 0.0),
    inv2_fail = hw_led_add(PINS_D.LED_INV2_FAIL, 0.0),
    batt_caut = hw_led_add(PINS_D.LED_BATT_CAUT, 0.0),
    fire1 = hw_led_add(PINS_D.LED_FIRE1, 0.0),
    fire2 = hw_led_add(PINS_D.LED_FIRE2, 0.0),
    bag_fire = hw_led_add(PINS_D.LED_BAG_FIRE, 0.0),
}

-- Channel E LEDs (CWP)
local LEDS_E = {
    eng1_out = hw_led_add(PINS_E.LED_ENG1_OUT, 0.0),
    eng2_out = hw_led_add(PINS_E.LED_ENG2_OUT, 0.0),
    rotor_brake = hw_led_add(PINS_E.LED_ROTOR_BRAKE, 0.0),
    xmsn_oil_press = hw_led_add(PINS_E.LED_XMSN_OIL_PRESS, 0.0),
    xmsn_oil_temp = hw_led_add(PINS_E.LED_XMSN_OIL_TEMP, 0.0),
    cbox_oil_press = hw_led_add(PINS_E.LED_CBOX_OIL_PRESS, 0.0),
    cbox_oil_temp = hw_led_add(PINS_E.LED_CBOX_OIL_TEMP, 0.0),
    batt1_hot = hw_led_add(PINS_E.LED_BATT1_HOT, 0.0),
    batt2_hot = hw_led_add(PINS_E.LED_BATT2_HOT, 0.0),
    eng_oil_press1 = hw_led_add(PINS_E.LED_ENG_OIL_PRESS1, 0.0),
    eng_oil_press2 = hw_led_add(PINS_E.LED_ENG_OIL_PRESS2, 0.0),
    eng_chip1 = hw_led_add(PINS_E.LED_ENG_CHIP1, 0.0),
    eng_chip2 = hw_led_add(PINS_E.LED_ENG_CHIP2, 0.0),
    fuel_filter1 = hw_led_add(PINS_E.LED_FUEL_FILTER1, 0.0),
    fuel_filter2 = hw_led_add(PINS_E.LED_FUEL_FILTER2, 0.0),
    fuel_boost1 = hw_led_add(PINS_E.LED_FUEL_BOOST1, 0.0),
    fuel_boost2 = hw_led_add(PINS_E.LED_FUEL_BOOST2, 0.0),
    fuel_trans1 = hw_led_add(PINS_E.LED_FUEL_TRANS1, 0.0),
    fuel_trans2 = hw_led_add(PINS_E.LED_FUEL_TRANS2, 0.0),
    fuel_valve1 = hw_led_add(PINS_E.LED_FUEL_VALVE1, 0.0),
    fuel_valve2 = hw_led_add(PINS_E.LED_FUEL_VALVE2, 0.0),
    fuel_low = hw_led_add(PINS_E.LED_FUEL_LOW, 0.0),
    fuel_intcon = hw_led_add(PINS_E.LED_FUEL_INTCON, 0.0),
    fuel_xfeed = hw_led_add(PINS_E.LED_FUEL_XFEED, 0.0),
    gov_man1 = hw_led_add(PINS_E.LED_GOV_MAN1, 0.0),
    gov_man2 = hw_led_add(PINS_E.LED_GOV_MAN2, 0.0),
    partsep1 = hw_led_add(PINS_E.LED_PARTSEP1, 0.0),
    partsep2 = hw_led_add(PINS_E.LED_PARTSEP2, 0.0),
    dc_gen1 = hw_led_add(PINS_E.LED_DC_GEN1, 0.0),
    dc_gen2 = hw_led_add(PINS_E.LED_DC_GEN2, 0.0),
    inverter1 = hw_led_add(PINS_E.LED_INVERTER1, 0.0),
    inverter2 = hw_led_add(PINS_E.LED_INVERTER2, 0.0),
    battery = hw_led_add(PINS_E.LED_BATTERY, 0.0),
    gen_ovht1 = hw_led_add(PINS_E.LED_GEN_OVHT1, 0.0),
    gen_ovht2 = hw_led_add(PINS_E.LED_GEN_OVHT2, 0.0),
    hydraulic1 = hw_led_add(PINS_E.LED_HYDRAULIC1, 0.0),
    hydraulic2 = hw_led_add(PINS_E.LED_HYDRAULIC2, 0.0),
    ext_power = hw_led_add(PINS_E.LED_EXT_POWER, 0.0),
    xmsn_chip = hw_led_add(PINS_E.LED_XMSN_CHIP, 0.0),
    cbox_chip = hw_led_add(PINS_E.LED_CBOX_CHIP, 0.0),
    chip_4290 = hw_led_add(PINS_E.LED_4290_CHIP, 0.0),
    over_torq = hw_led_add(PINS_E.LED_OVER_TORQ, 0.0),
    rpm = hw_led_add(PINS_E.LED_RPM, 0.0),
    afcs = hw_led_add(PINS_E.LED_AFCS, 0.0),
    ft_off = hw_led_add(PINS_E.LED_FT_OFF, 0.0),
    cyc_ctr = hw_led_add(PINS_E.LED_CYC_CTR, 0.0),
    door_lock = hw_led_add(PINS_E.LED_DOOR_LOCK, 0.0),
    heater_air = hw_led_add(PINS_E.LED_HEATER_AIR, 0.0),
    caution_pnl = hw_led_add(PINS_E.LED_CAUTION_PNL, 0.0),
    emer_floats = hw_led_add(PINS_E.LED_EMER_FLOATS, 0.0),
    cargo_rel = hw_led_add(PINS_E.LED_CARGO_REL, 0.0),
    bag_fire = hw_led_add(PINS_E.LED_BAG_FIRE, 0.0),
    wshld_heat = hw_led_add(PINS_E.LED_WSHLD_HEAT, 0.0),
    caution_20ft = hw_led_add(PINS_E.LED_20FT_CAUTION, 0.0),
    nightsun = hw_led_add(PINS_E.LED_NIGHTSUN, 0.0),
    spare = hw_led_add(PINS_E.LED_SPARE, 0.0),


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
    
    -- Overhead (Channel D)
    batt1 = false, batt2 = false,
    gen1 = false, gen2 = false, gen1_prod = false, gen2_prod = false,
    inv1 = false, inv2 = false,
    non_bus = false, emer_load = false, stby_att = false,
    pitot = false, nav = false, anticoll = false,
    wiper_pi = false, wiper_co = false,
    heater = false, blower = false, aft_outlet = false,
    dome = 0, util = false, map_dim_val = 0.0,

    -- Caution Panel (Channel E)
    cwp_test_state = 0, cwp_bright_state = 0, led_brightness = 1.0,
    caution_states = {
        eng1_out = 0, eng2_out = 0, rotor_brake = 0,
        xmsn_oil_press = 0, xmsn_oil_temp = 0, cbox_oil_press = 0, cbox_oil_temp = 0,
        batt1_hot = 0, batt2_hot = 0,
        eng_oil_press1 = 0, eng_oil_press2 = 0, eng_chip1 = 0, eng_chip2 = 0,
        fuel_filter1 = 0, fuel_filter2 = 0, fuel_boost1 = 0, fuel_boost2 = 0,
        fuel_trans1 = 0, fuel_trans2 = 0, fuel_valve1 = 0, fuel_valve2 = 0,
        fuel_low = 0, fuel_intcon = 0, fuel_xfeed = 0,
        gov_man1 = 0, gov_man2 = 0, partsep1 = 0, partsep2 = 0,
        dc_gen1 = 0, dc_gen2 = 0, inverter1 = 0, inverter2 = 0, battery = 0,
        gen_ovht1 = 0, gen_ovht2 = 0, hydraulic1 = 0, hydraulic2 = 0, ext_power = 0,
        xmsn_chip = 0, cbox_chip = 0, chip_4290 = 0,
        over_torq = 0, rpm = 0, afcs = 0, ft_off = 0, cyc_ctr = 0,
        door_lock = 0, heater_air = 0, caution_pnl = 0,
        emer_floats = 0, cargo_rel = 0, bag_fire = 0, wshld_heat = 0,
        caution_20ft = 0, nightsun = 0, spare = 0
    },


}

-- =============================================================================
-- HELPER FUNCTIONS
-- =============================================================================

local update_cwp_leds -- Forward Declaration
local update_mc_reset -- Forward Declaration

local function update_sas_att()
    -- Force Trim Interlock: If FT is OFF, forced to SAS mode
    if STATE.caution_states.ft_off == 1 then STATE.sas_mode = "SAS" end
    
    -- Coupled Interlock
    if STATE.cpl then
        local valid_cpl = (STATE.ap1 or STATE.ap2) and (STATE.sas_mode == "ATT") and (STATE.caution_states.ft_off == 0)
        if not valid_cpl then
            STATE.cpl = false
            fsx_variable_write("L:CplActive", "Number", 0)
            if LEDS_A.cpl then hw_output_set(LEDS_A.cpl, false) end
        end
    end

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

function update_mc_reset()
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

local function update_elec_leds()
    local g1 = ((not STATE.gen1_prod) or (not STATE.gen1)) and 1.0 or 0.0
    local g2 = ((not STATE.gen2_prod) or (not STATE.gen2)) and 1.0 or 0.0
    -- Inverter Caution: Switch OFF or DC Bus Dead
    local i1 = ((not STATE.inv1) or (STATE.dc_bus == 0)) and 1.0 or 0.0
    local i2 = ((not STATE.inv2) or (STATE.dc_bus == 0)) and 1.0 or 0.0
    
    hw_led_set(LEDS_D.gen1_fail, g1); hw_led_set(LEDS_D.gen2_fail, g2)
    hw_led_set(LEDS_D.inv1_fail, i1); hw_led_set(LEDS_D.inv2_fail, i2)
    
    -- Battery Caution: Batts ON but no Gens
    local batts_on = STATE.batt1 or STATE.batt2
    local gens_on = STATE.gen1_prod or STATE.gen2_prod
    local b_caut = (batts_on and not gens_on) and 1.0 or 0.0
    hw_led_set(LEDS_D.batt_caut, b_caut)

    -- Update Caution Panel States (Sync logic)
    if STATE.caution_states then
        STATE.caution_states.dc_gen1 = (g1 == 1.0) and 1 or 0
        STATE.caution_states.dc_gen2 = (g2 == 1.0) and 1 or 0
        STATE.caution_states.inverter1 = (i1 == 1.0) and 1 or 0
        STATE.caution_states.inverter2 = (i2 == 1.0) and 1 or 0
        STATE.caution_states.battery = (b_caut == 1.0) and 1 or 0
    end
    
    if update_cwp_leds then update_cwp_leds() end
end

local function update_oh_fire_leds()
    if STATE.dc_bus == 0 then hw_led_set(LEDS_D.fire1, 0.0); hw_led_set(LEDS_D.fire2, 0.0); hw_led_set(LEDS_D.bag_fire, 0.0); return end
    local test = STATE.fire_test
    hw_led_set(LEDS_D.fire1, (test or (STATE.fire1 == 1)) and 1.0 or 0.0)
    hw_led_set(LEDS_D.fire2, (test or (STATE.fire2 == 1)) and 1.0 or 0.0)
    hw_led_set(LEDS_D.bag_fire, (test or (STATE.bag_fire == 1)) and 1.0 or 0.0)
    hw_led_set(LEDS_D.bag_fire, (test or (STATE.bag_fire == 1)) and 1.0 or 0.0)
end

-- Caution Panel Helper Functions
local function set_cwp_led(led_handle, state)
    if STATE.dc_bus == 0 then hw_led_set(led_handle, 0.0); return end
    if STATE.cwp_test_state == 2 then hw_led_set(led_handle, STATE.led_brightness); return end -- Lamp Test
    if STATE.cwp_test_state == 1 then hw_led_set(led_handle, 0.0); return end -- PNL Test (Force OFF except Caution PNL)
    hw_led_set(led_handle, (state == 1) and STATE.led_brightness or 0.0)
end

function update_cwp_leds()
    local s = STATE.caution_states
    
    set_cwp_led(LEDS_E.eng1_out, s.eng1_out); set_cwp_led(LEDS_E.eng2_out, s.eng2_out)
    set_cwp_led(LEDS_E.rotor_brake, s.rotor_brake)
    set_cwp_led(LEDS_E.xmsn_oil_press, s.xmsn_oil_press); set_cwp_led(LEDS_E.xmsn_oil_temp, s.xmsn_oil_temp)
    set_cwp_led(LEDS_E.cbox_oil_press, s.cbox_oil_press); set_cwp_led(LEDS_E.cbox_oil_temp, s.cbox_oil_temp)
    set_cwp_led(LEDS_E.batt1_hot, s.batt1_hot); set_cwp_led(LEDS_E.batt2_hot, s.batt2_hot)
    
    set_cwp_led(LEDS_E.eng_oil_press1, s.eng_oil_press1); set_cwp_led(LEDS_E.eng_oil_press2, s.eng_oil_press2)
    set_cwp_led(LEDS_E.eng_chip1, s.eng_chip1); set_cwp_led(LEDS_E.eng_chip2, s.eng_chip2)
    set_cwp_led(LEDS_E.fuel_filter1, s.fuel_filter1); set_cwp_led(LEDS_E.fuel_filter2, s.fuel_filter2)
    set_cwp_led(LEDS_E.fuel_boost1, s.fuel_boost1); set_cwp_led(LEDS_E.fuel_boost2, s.fuel_boost2)
    set_cwp_led(LEDS_E.fuel_trans1, s.fuel_trans1); set_cwp_led(LEDS_E.fuel_trans2, s.fuel_trans2)
    
    -- Valve Transit Logic override
    local v1 = (STATE.valve_transit_1) and 1 or s.fuel_valve1
    local v2 = (STATE.valve_transit_2) and 1 or s.fuel_valve2
    set_cwp_led(LEDS_E.fuel_valve1, v1); set_cwp_led(LEDS_E.fuel_valve2, v2)
    
    set_cwp_led(LEDS_E.fuel_low, s.fuel_low); set_cwp_led(LEDS_E.fuel_intcon, s.fuel_intcon)
    set_cwp_led(LEDS_E.fuel_xfeed, s.fuel_xfeed)
    set_cwp_led(LEDS_E.gov_man1, s.gov_man1); set_cwp_led(LEDS_E.gov_man2, s.gov_man2)
    set_cwp_led(LEDS_E.partsep1, s.partsep1); set_cwp_led(LEDS_E.partsep2, s.partsep2)
    
    set_cwp_led(LEDS_E.dc_gen1, s.dc_gen1); set_cwp_led(LEDS_E.dc_gen2, s.dc_gen2)
    set_cwp_led(LEDS_E.inverter1, s.inverter1); set_cwp_led(LEDS_E.inverter2, s.inverter2)
    set_cwp_led(LEDS_E.battery, s.battery)
    set_cwp_led(LEDS_E.gen_ovht1, s.gen_ovht1); set_cwp_led(LEDS_E.gen_ovht2, s.gen_ovht2)
    
    -- Hydraulics Logic (Switch OFF or Low Pressure/RPM)
    local h1 = (s.hydraulic1 == 1) or (STATE.rpm_n1_e1 < 40.0) and 1 or 0
    local h2 = (s.hydraulic2 == 1) or (STATE.rpm_n1_e2 < 40.0) and 1 or 0
    set_cwp_led(LEDS_E.hydraulic1, h1); set_cwp_led(LEDS_E.hydraulic2, h2)
    
    -- Hydraulic Master Caution Trigger
    if (h1 == 1 or h2 == 1) and (STATE.dc_bus > 0) then fsx_variable_write("L:MasterCaution", "Number", 1) end

    set_cwp_led(LEDS_E.ext_power, s.ext_power)
    
    -- XMSN Oil Press Logic
    local xmsn = (s.xmsn_oil_press == 1) or ((STATE.xmsn_press or 100) < 30) and 1 or 0
    set_cwp_led(LEDS_E.xmsn_oil_press, xmsn); set_cwp_led(LEDS_E.xmsn_oil_temp, s.xmsn_oil_temp)
    
    set_cwp_led(LEDS_E.cbox_chip, s.cbox_chip)
    set_cwp_led(LEDS_E.chip_4290, s.chip_4290); set_cwp_led(LEDS_E.over_torq, s.over_torq)
    set_cwp_led(LEDS_E.rpm, s.rpm); set_cwp_led(LEDS_E.afcs, s.afcs)
    set_cwp_led(LEDS_E.ft_off, s.ft_off); set_cwp_led(LEDS_E.cyc_ctr, s.cyc_ctr)
    
    set_cwp_led(LEDS_E.door_lock, s.door_lock); set_cwp_led(LEDS_E.heater_air, s.heater_air)
    set_cwp_led(LEDS_E.emer_floats, s.emer_floats); set_cwp_led(LEDS_E.cargo_rel, s.cargo_rel)
    set_cwp_led(LEDS_E.bag_fire, s.bag_fire); set_cwp_led(LEDS_E.wshld_heat, s.wshld_heat)
    set_cwp_led(LEDS_E.caution_20ft, s.caution_20ft); set_cwp_led(LEDS_E.nightsun, s.nightsun)
    set_cwp_led(LEDS_E.spare, s.spare)
    
    -- Special case for Canton PNL (Caution Panel) LED - ON during PNL test
    if STATE.dc_bus > 0 then
        if STATE.cwp_test_state == 1 then hw_led_set(LEDS_E.caution_pnl, STATE.led_brightness)
        else set_cwp_led(LEDS_E.caution_pnl, s.caution_pnl) end
    else hw_led_set(LEDS_E.caution_pnl, 0.0) end
end

local function update_cwp_state_vars()
    fsx_variable_write("L:CWP_TestMode", "Number", STATE.cwp_test_state)
    fsx_variable_write("L:CWP_Brightness", "Number", STATE.cwp_bright_state)
    update_cwp_leds()
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

hw_button_add(PINS_A.SYS2, function() fsx_variable_write("L:AFCSSys2", "Number", 1) end, function() fsx_variable_write("L:AFCSSys2", "Number", 0) end)

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

hw_button_add(PINS_A.VALVE1, 
    function() 
        fsx_variable_write("L:SwvalveEng1", "Number", 0)
        STATE.valve_transit_1 = true
        update_cwp_leds()
        timer_start(2000, function() STATE.valve_transit_1 = false; update_cwp_leds() end)
    end, 
    function() 
        fsx_variable_write("L:SwvalveEng1", "Number", 1)
        STATE.valve_transit_1 = true
        update_cwp_leds()
        timer_start(2000, function() STATE.valve_transit_1 = false; update_cwp_leds() end)
    end
)
hw_button_add(PINS_A.VALVE2, 
    function() 
        fsx_variable_write("L:SwvalveEng2", "Number", 1)
        STATE.valve_transit_2 = true
        update_cwp_leds()
        timer_start(2000, function() STATE.valve_transit_2 = false; update_cwp_leds() end)
    end, 
    function() 
        fsx_variable_write("L:SwvalveEng2", "Number", 0)
        STATE.valve_transit_2 = true
        update_cwp_leds()
        timer_start(2000, function() STATE.valve_transit_2 = false; update_cwp_leds() end)
    end
)

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

hw_button_add(PINS_C.START1, 
    function() 
        if STATE.caution_states.rotor_brake == 1 then
            print("ROTOR BRAKE WARNING: Cannot start with brake ON")
        else
            print("BTN: START ENG1")
            fsx_variable_write("L:starteng", "Number", 1) 
        end
    end, 
    function() end
)
hw_button_add(PINS_C.START2, 
    function() 
        if STATE.caution_states.rotor_brake == 1 then
            print("ROTOR BRAKE WARNING: Cannot start with brake ON")
        else
            print("BTN: START ENG2")
            fsx_variable_write("L:starteng", "Number", -1) 
        end
    end, 
    function() end
)

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
-- Force Trim Release (Cyclic)
hw_button_add(PINS_C.FT_RELEASE, function() fsx_variable_write("L:Sw forcetrim", "Number", 0) end, function() fsx_variable_write("L:Sw forcetrim", "Number", 1) end)

-- =============================================================================
-- SIMULATOR SUBSCRIPTIONS
-- =============================================================================

fsx_variable_subscribe("L:MasterDcBus", "Number", function(val) STATE.dc_bus = (val ~= 0) and 1 or 0; update_fire_leds(); update_engine_leds(); update_sas_att(); update_elec_leds(); update_oh_fire_leds(); update_cwp_leds() end)


fsx_variable_subscribe("L:TestMC", "Number", function(val) STATE.test_mc = val or 0; update_engine_leds() end)
fsx_variable_subscribe("TURB ENG N1:1", "Percent", function(val) 
    STATE.rpm_n1_e1 = val or 0.0
    update_engine_leds() 
    -- Starter Dropout
    if (val > 55.0) then fsx_variable_write("L:starteng", "Number", 0) end
end)
fsx_variable_subscribe("TURB ENG N1:2", "Percent", function(val) 
    STATE.rpm_n1_e2 = val or 0.0
    update_engine_leds() 
    -- Starter Dropout (Assuming L:starteng handles both, or we check if it is -1)
    if (val > 55.0) then fsx_variable_write("L:starteng", "Number", 0) end
end)
fsx_variable_subscribe("L:firethandl", "Number", function(val) STATE.fire1 = (val ~= 0) and 1 or 0; update_fire_leds(); update_oh_fire_leds() end)
fsx_variable_subscribe("L:firethandr", "Number", function(val) STATE.fire2 = (val ~= 0) and 1 or 0; update_fire_leds(); update_oh_fire_leds() end)

fsx_variable_subscribe("L:Cyctest", "Number", function(val) STATE.cyc_test = (val ~= 0) and 1 or 0; update_cyc_ctr() end)
fsx_variable_subscribe("L:firetestbag", "Number", function(val) STATE.bag_fire = (val ~= 0) and 1 or 0; hw_led_set(LEDS_B.bag, (STATE.bag_fire == 1) and 1.0 or 0.0); update_oh_fire_leds() end)

fsx_variable_subscribe("L:TestMarker", "Number", function(val) STATE.marker = (val ~= 0) and 1 or 0; update_marker_leds() end)
fsx_variable_subscribe("L:Overtq", "Number", function(val) STATE.overtq = (val ~= 0) and 1 or 0; update_overtq() end)
fsx_variable_subscribe("L:SwBrgPtr", "Number", function(val) local v = (val ~= 0) and 1.0 or 0.0; hw_led_set(LEDS_B.brg1, v); hw_led_set(LEDS_B.brg2, v) end)
fsx_variable_subscribe("L:MasterCaution", "Number", function(val) local v = (val ~= 0) and 1.0 or 0.0; hw_led_set(LEDS_B.mc_l, v); hw_led_set(LEDS_B.mc_r, v) end)
fsx_variable_subscribe("L:AutoPilot", "Number", function(val) local ns = (val ~= 0); if STATE.ap1 ~= ns then STATE.ap1 = ns; hw_led_set(LEDS_A.ap1, ns and 1.0 or 0.0); update_sas_att() end end)
fsx_variable_subscribe("L:AutoPilot2", "Number", function(val) local ns = (val ~= 0); if STATE.ap2 ~= ns then STATE.ap2 = ns; hw_led_set(LEDS_A.ap2, ns and 1.0 or 0.0); update_sas_att() end end)
fsx_variable_subscribe("L:SASATT", "Number", function(val) local nm = (val ~= 0) and "ATT" or "SAS"; if STATE.sas_mode ~= nm then STATE.sas_mode = nm; update_sas_att() end end)
fsx_variable_subscribe("L:CplActive", "Number", function(val) local ns = (val ~= 0); if STATE.cpl ~= ns then STATE.cpl = ns; hw_output_set(LEDS_A.cpl, ns) end end)
fsx_variable_subscribe("A:INDICATED HEADING", "Degrees", function(val) set_servo(LEDS_A.servo, ((val % 360) + 360) % 360 / 360) end)
-- Overhead specific shared subscriptions (Gens)
fsx_variable_subscribe("L:CGenel", "Number", function(val) STATE.gen1_prod = (val ~= 0); update_elec_leds() end)
    
-- Caution Panel Subscriptions
fsx_variable_subscribe("TURB ENG N1:1", "Percent", function(val) STATE.caution_states.eng1_out = (val < 53) and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("TURB ENG N1:2", "Percent", function(val) STATE.caution_states.eng2_out = (val < 53) and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("A:Rotor Brake Active", "Bool", function(val) STATE.caution_states.rotor_brake = val and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:XmsnPressWarn", "Number", function(val) STATE.caution_states.xmsn_oil_press = (val ~= 0) and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:XmsnTempWarn", "Number", function(val) STATE.caution_states.xmsn_oil_temp = (val ~= 0) and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:CboxPressWarn", "Number", function(val) STATE.caution_states.cbox_oil_press = (val ~= 0) and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("FUEL TANK CENTER LEVEL", "Percent", function(val) STATE.caution_states.fuel_low = (val < 9.2) and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:XMSN CHIP", "Bool", function(val) STATE.caution_states.xmsn_chip = val and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("ROTOR RPM PCT:1", "Percent", function(val) STATE.caution_states.rpm = ((val <= 95) or (val >= 105)) and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:BagFire", "Number", function(val) STATE.caution_states.bag_fire = (val ~= 0) and 1 or 0; update_cwp_leds() end)
-- Shared Caution mappings
fsx_variable_subscribe("L:SwboostpuEng1", "Number", function(val) STATE.caution_states.fuel_boost1 = (val == 0) and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:SwboostpuEng2", "Number", function(val) STATE.caution_states.fuel_boost2 = (val == 0) and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:SwfueltransengA", "Number", function(val) STATE.caution_states.fuel_trans1 = (val == 0) and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:SwfueltransengB", "Number", function(val) STATE.caution_states.fuel_trans2 = (val == 0) and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:Swfuelintcon", "Number", function(val) STATE.caution_states.fuel_intcon = (val ~= 0) and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:SwFuelxfeed", "Number", function(val) STATE.caution_states.fuel_xfeed = (val ~= 0) and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:Swinva", "Number", function(val) STATE.caution_states.inverter1 = (val == 0) and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:Swinvb", "Number", function(val) STATE.caution_states.inverter2 = (val == 0) and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:Sw hydsysA", "Number", function(val) STATE.caution_states.hydraulic1 = (val == 0) and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:Sw hydsysB", "Number", function(val) STATE.caution_states.hydraulic2 = (val == 0) and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:SwGovA", "Number", function(val) STATE.caution_states.gov_man1 = (val == 0) and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:SwGovB", "Number", function(val) STATE.caution_states.gov_man2 = (val == 0) and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:SwpartsepA", "Number", function(val) STATE.caution_states.partsep1 = (val ~= 0) and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:SwpartsepB", "Number", function(val) STATE.caution_states.partsep2 = (val ~= 0) and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:Sw forcetrim", "Number", function(val) STATE.caution_states.ft_off = (val == 0) and 1 or 0; update_cwp_leds(); update_sas_att() end)
fsx_variable_subscribe("L:XmsnOilPress", "Number", function(val) STATE.xmsn_press = val; update_cwp_leds() end)


-- =============================================================================
-- CHANNEL D: OVERHEAD HANDLERS
-- =============================================================================

hw_button_add(PINS_D.BATT1, function() STATE.batt1 = true; fsx_variable_write("L:Swbatta", "Number", 1); update_elec_leds() end, function() STATE.batt1 = false; fsx_variable_write("L:Swbatta", "Number", 0); update_elec_leds() end)
hw_button_add(PINS_D.BATT2, function() STATE.batt2 = true; fsx_variable_write("L:Swbattb", "Number", 1); update_elec_leds() end, function() STATE.batt2 = false; fsx_variable_write("L:Swbattb", "Number", 0); update_elec_leds() end)

hw_button_add(PINS_D.GEN1_ON, function() STATE.gen1 = true; fsx_variable_write("L:Genel", "Number", 1); fsx_event("TOGGLE_ALTERNATOR1"); update_elec_leds() end, function() STATE.gen1 = false; fsx_variable_write("L:Genel", "Number", 0); fsx_event("TOGGLE_ALTERNATOR1"); update_elec_leds() end)
hw_button_add(PINS_D.GEN1_RESET, function() print("GEN1 RESET") end, function() end)

hw_button_add(PINS_D.GEN2_ON, function() STATE.gen2 = true; fsx_variable_write("L:Gener", "Number", 1); fsx_event("TOGGLE_ALTERNATOR2"); update_elec_leds() end, function() STATE.gen2 = false; fsx_variable_write("L:Gener", "Number", 0); fsx_event("TOGGLE_ALTERNATOR2"); update_elec_leds() end)
hw_button_add(PINS_D.GEN2_RESET, function() print("GEN2 RESET") end, function() end)

hw_button_add(PINS_D.INV1, function() STATE.inv1 = true; fsx_variable_write("L:Swinva", "Number", 1); update_elec_leds() end, function() STATE.inv1 = false; fsx_variable_write("L:Swinva", "Number", 0); update_elec_leds() end)
hw_button_add(PINS_D.INV2, function() STATE.inv2 = true; fsx_variable_write("L:Swinvb", "Number", 1); update_elec_leds() end, function() STATE.inv2 = false; fsx_variable_write("L:Swinvb", "Number", 0); update_elec_leds() end)

hw_button_add(PINS_D.NON_BUS, function() STATE.non_bus = true; fsx_variable_write("L:Swnonbus", "Number", 1) end, function() STATE.non_bus = false; fsx_variable_write("L:Swnonbus", "Number", 0) end)
hw_button_add(PINS_D.EMER_LOAD, function() STATE.emer_load = true; fsx_variable_write("L:Swemerload", "Number", 1) end, function() STATE.emer_load = false; fsx_variable_write("L:Swemerload", "Number", 0) end)
hw_button_add(PINS_D.STBY_ATT, function() STATE.stby_att = true; fsx_variable_write("L:Swstbyatt", "Number", 1); fsx_variable_write("L:stbatt", "Number", 1) end, function() STATE.stby_att = false; fsx_variable_write("L:Swstbyatt", "Number", 0); fsx_variable_write("L:stbatt", "Number", 0) end)

hw_button_add(PINS_D.PITOT, function() STATE.pitot = true; fsx_variable_write("L:Swpitot", "Number", 1); fsx_event("PITOT_HEAT_ON") end, function() STATE.pitot = false; fsx_variable_write("L:Swpitot", "Number", 0); fsx_event("PITOT_HEAT_OFF") end)
hw_button_add(PINS_D.NAV, function() STATE.nav = true; fsx_variable_write("L:Swposition", "Number", 1); fsx_event("NAV_LIGHTS_ON") end, function() STATE.nav = false; fsx_variable_write("L:Swposition", "Number", 0); fsx_event("NAV_LIGHTS_OFF") end)
hw_button_add(PINS_D.ANTICOLL, function() STATE.anticoll = true; fsx_variable_write("L:Swanticoll", "Number", 1); fsx_event("BEACON_LIGHTS_ON") end, function() STATE.anticoll = false; fsx_variable_write("L:Swanticoll", "Number", 0); fsx_event("BEACON_LIGHTS_OFF") end)

hw_button_add(PINS_D.WIPER_PI, function() STATE.wiper_pi = true; fsx_variable_write("L:Swpiwiper", "Number", 1) end, function() STATE.wiper_pi = false; fsx_variable_write("L:Swpiwiper", "Number", 0) end)
hw_button_add(PINS_D.WIPER_CO, function() STATE.wiper_co = true; fsx_variable_write("L:Swcowiper", "Number", 1) end, function() STATE.wiper_co = false; fsx_variable_write("L:Swcowiper", "Number", 0) end)

hw_button_add(PINS_D.HEATER, function() STATE.heater = true; fsx_variable_write("L:SwHeater", "Number", 1) end, function() STATE.heater = false; fsx_variable_write("L:SwHeater", "Number", 0) end)
hw_button_add(PINS_D.BLOWER, function() STATE.blower = true; fsx_variable_write("L:Swblower", "Number", 1) end, function() STATE.blower = false; fsx_variable_write("L:Swblower", "Number", 0) end)
hw_button_add(PINS_D.AFT_OUTLET, function() STATE.aft_outlet = true; fsx_variable_write("L:Swaftoutlet", "Number", 1) end, function() STATE.aft_outlet = false; fsx_variable_write("L:Swaftoutlet", "Number", 0) end)

hw_button_add(PINS_D.DOME, function() STATE.dome = 1; fsx_variable_write("L:Swutilitylight", "Number", 1) end, function() STATE.dome = 0; fsx_variable_write("L:Swutilitylight", "Number", 0) end)
hw_button_add(PINS_D.UTIL, function() STATE.util = true; fsx_variable_write("L:Swutilitylight", "Number", 1) end, function() STATE.util = false; fsx_variable_write("L:Swutilitylight", "Number", 0) end)

hw_button_add(PINS_D.FIRE1, function() STATE.fire1 = 1; fsx_variable_write("L:firethandl", "Number", 1); update_fire_leds(); update_oh_fire_leds() end, function() STATE.fire1 = 0; fsx_variable_write("L:firethandl", "Number", 0); update_fire_leds(); update_oh_fire_leds() end)
hw_button_add(PINS_D.FIRE2, function() STATE.fire2 = 1; fsx_variable_write("L:firethandr", "Number", 1); update_fire_leds(); update_oh_fire_leds() end, function() STATE.fire2 = 0; fsx_variable_write("L:firethandr", "Number", 0); update_fire_leds(); update_oh_fire_leds() end)
hw_button_add(PINS_D.FIRE_TEST, 
    function() 
        STATE.fire_test = true
        fsx_variable_write("L:Swfiretest", "Number", 1)
        fsx_variable_write("L:firetestbag", "Number", 1)
        update_fire_leds()
        update_oh_fire_leds()
        -- Force Master Caution
        hw_led_set(LEDS_B.mc_l, 1.0)
        hw_led_set(LEDS_B.mc_r, 1.0)
    end, 
    function() 
        STATE.fire_test = false
        fsx_variable_write("L:Swfiretest", "Number", 0)
        fsx_variable_write("L:firetestbag", "Number", 0)
        update_fire_leds()
        update_oh_fire_leds()
        -- Restore Master Caution
        if update_mc_reset then update_mc_reset() end
    end
)

hw_button_add(PINS_D.COMPASS, function() fsx_variable_write("L:SwMagDg", "Number", 1) end, function() fsx_variable_write("L:SwMagDg", "Number", 0) end)
hw_button_add(PINS_D.MAP_DIM_BTN, function() end, function() end)
hw_adc_input_add(PINS_D.MAP_DIM, function(val) STATE.map_dim_val = val; fsx_variable_write("L:platepilolight", "Number", val * 100) end)


-- =============================================================================
-- CHANNEL E: CAUTION PANEL HANDLERS
-- =============================================================================

hw_button_add(PINS_E.TEST_SW_POS1, function() STATE.cwp_test_state = 1; update_cwp_state_vars() end, function() if STATE.cwp_test_state == 1 then STATE.cwp_test_state = 0; update_cwp_state_vars() end end)
hw_button_add(PINS_E.TEST_BTN, function() STATE.cwp_test_state = 2; update_cwp_state_vars() end, function() if STATE.cwp_test_state == 2 then STATE.cwp_test_state = 0; update_cwp_state_vars() end end)
hw_button_add(PINS_E.TEST_SW_POS2, function() STATE.cwp_test_state = -1; update_cwp_state_vars() end, function() if STATE.cwp_test_state == -1 then STATE.cwp_test_state = 0; update_cwp_state_vars() end end)

hw_button_add(PINS_E.BRIGHT_DIM_POS1, function() STATE.cwp_bright_state = 1; STATE.led_brightness = 1.0; update_cwp_state_vars() end, function() if STATE.cwp_bright_state == 1 then STATE.cwp_bright_state = 0; STATE.led_brightness = 1.0; update_cwp_state_vars() end end)
hw_button_add(PINS_E.BRIGHT_DIM_POS2, function() STATE.cwp_bright_state = 2; STATE.led_brightness = 0.3; update_cwp_state_vars() end, function() if STATE.cwp_bright_state == 2 then STATE.cwp_bright_state = 0; STATE.led_brightness = 1.0; update_cwp_state_vars() end end)

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
fsx_variable_write("L:CWP_TestMode", "Number", 0)
fsx_variable_write("L:CWP_Brightness", "Number", 0)

update_sas_att()

update_fire_leds()
update_marker_leds()
update_overtq()
update_cyc_ctr()
update_extinguisher()
update_engine_leds()
update_elec_leds()
update_oh_fire_leds()
update_cwp_leds()

print("Bell 412 Combined Script Loaded - Channels A, B, C, D, E")