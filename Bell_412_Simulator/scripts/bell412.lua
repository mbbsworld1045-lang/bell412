-- =============================================================================
-- BELL 412 - MASTER COMBINED SCRIPT
-- Panels: Pedestal (A), Front (B), Collective (C), Overhead (D), Caution (E), FD (F)
-- Platform: Air Manager + Arduino Mega 2560
-- =============================================================================

print("Bell 412 - Master Combined Script Loading...")

-- =============================================================================
-- 1. PIN DEFINITIONS (Channels A-F)
-- =============================================================================

-- Channel A: Pedestal / AFCS / Misc
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
    -- LEDs (Analog as Digital)
    LED_TRIM = "ARDUINO_MEGA2560_A_A1",
    LED_TEST = "ARDUINO_MEGA2560_A_A2",
    LED_FD = "ARDUINO_MEGA2560_A_A3",
    LED_CPL = "ARDUINO_MEGA2560_A_A4",
    LED_SAS = "ARDUINO_MEGA2560_A_D2",
    LED_ATT = "ARDUINO_MEGA2560_A_D3",
    LED_AP2 = "ARDUINO_MEGA2560_A_D4",
    LED_AP1 = "ARDUINO_MEGA2560_A_D5",
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
    FT_RELEASE = "ARDUINO_MEGA2560_C_D47",
}

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
    COMPASS = "ARDUINO_MEGA2560_D_D27",
    MAP_DIM = "ARDUINO_MEGA2560_D_A0",
    -- Circuit Breakers
    CB_INV1 = "ARDUINO_MEGA2560_D_D34",
    CB_INV2 = "ARDUINO_MEGA2560_D_A7",
    CB_NON_ESS1 = "ARDUINO_MEGA2560_D_D29",
    CB_NON_ESS2 = "ARDUINO_MEGA2560_D_D30",
    CB_ITT1 = "ARDUINO_MEGA2560_D_D26",
    CB_ITT2 = "ARDUINO_MEGA2560_D_A2",
    CB_GEN1_RESET = "ARDUINO_MEGA2560_D_D22",
    CB_GEN2_RESET = "ARDUINO_MEGA2560_D_A4",
    CB_IGNITION1 = "ARDUINO_MEGA2560_D_D23",
    CB_IGNITION2 = "ARDUINO_MEGA2560_D_A3",
    CB_ENG_TRQ = "ARDUINO_MEGA2560_D_A5",
    CB_MSTR_TRQ = "ARDUINO_MEGA2560_D_A6",
    CB_GEN2_FIELD = "ARDUINO_MEGA2560_D_A8",
    CB_IDLE_STOP = "ARDUINO_MEGA2560_D_D24",
    -- Rotor Brake
    ROTOR_BRAKE = "ARDUINO_MEGA2560_D_D69",
    -- Logic Relays
    RELAY_NON_ESS = "ARDUINO_MEGA2560_D_D40",
    RELAY_BAT1_OFF = "ARDUINO_MEGA2560_D_D41",
    -- LEDs
    LED_GEN1 = "ARDUINO_MEGA2560_D_D30", -- REQ CHECK
    LED_GEN2 = "ARDUINO_MEGA2560_D_D31",
    LED_INV1 = "ARDUINO_MEGA2560_D_D32",
    LED_INV2 = "ARDUINO_MEGA2560_D_D33",
    LED_BATT = "ARDUINO_MEGA2560_D_D34", -- REQ CHECK
    LED_FIRE1 = "ARDUINO_MEGA2560_D_D35",
    LED_FIRE2 = "ARDUINO_MEGA2560_D_D36", -- REQ CHECK
    LED_BAG = "ARDUINO_MEGA2560_D_D37", -- REQ CHECK
    -- Instrument Lighting
    INST_CONSOLE = "ARDUINO_MEGA2560_D_D42",
    INST_SEC = "ARDUINO_MEGA2560_D_D45",
    INST_ENG = "ARDUINO_MEGA2560_D_D47",
}

-- Channel E: Caution Panel (New Digital Mappings)
local PINS_E = {
    -- COLUMN A
    OIL_PRESS_L     = "ARDUINO_MEGA2560_E_D37", -- mc_ca1
    ENG_CHIP_L      = "ARDUINO_MEGA2560_E_D28", -- mc_ca2
    FUEL_VALVE_L    = "ARDUINO_MEGA2560_E_D27", -- mc_ca3
    FUEL_BOOST_1_L  = "ARDUINO_MEGA2560_E_D45", -- mc_ca4
    FUEL_TRANS_1_L  = "ARDUINO_MEGA2560_E_D40", -- mc_ca5
    BATT_TEMP_L     = "ARDUINO_MEGA2560_E_D42", -- mc_ca6
    FUEL_FILTER_1_L = "ARDUINO_MEGA2560_E_D48", -- mc_ca7
    FUEL_LOW_L      = "ARDUINO_MEGA2560_E_D41", -- mc_ca8
    EFIS_FAN_1_L    = "ARDUINO_MEGA2560_E_D38", -- mc_ca9
    -- COLUMN B
    PAR_SEP_OFF_L   = "ARDUINO_MEGA2560_E_D49", -- mc_cb1
    GOV_MANUAL_L    = "ARDUINO_MEGA2560_E_D47", -- mc_cb2
    DC_GEN_L        = "ARDUINO_MEGA2560_E_D30", -- mc_cb3
    AUTO_PILOT_1_L  = "ARDUINO_MEGA2560_E_D34", -- mc_cb5
    ROTOR_BRAKE_L   = "ARDUINO_MEGA2560_E_D32", -- mc_cb6
    INVERTER_1_L    = "ARDUINO_MEGA2560_E_D46", -- mc_cb7
    HEATER_AIR_L    = "ARDUINO_MEGA2560_E_D39", -- mc_cb8
    -- COLUMN C
    IGNITION_L      = "ARDUINO_MEGA2560_E_D25", -- mc_cc1
    CBOX_OIL_PRESS_L= "ARDUINO_MEGA2560_E_D35", -- mc_cc2
    CBOX_OIL_TEMP_L = "ARDUINO_MEGA2560_E_D50", -- mc_cc3
    CBOX_CHIP_L     = "ARDUINO_MEGA2560_E_D43", -- mc_cc4
    NO_1_HYD_L      = "ARDUINO_MEGA2560_E_D26", -- mc_cc5
    EXT_POWER_L     = "ARDUINO_MEGA2560_E_D3",  -- mc_cc6
    -- COLUMN D
    XMSN_OIL_PRESS_R= "ARDUINO_MEGA2560_E_A0",  -- mc_cd1
    XMSN_OIL_TEMP_R = "ARDUINO_MEGA2560_E_A4",  -- mc_cd2
    XMSN_CHIP_R     = "ARDUINO_MEGA2560_E_D11", -- mc_cd3
    NO_2_HYD_R      = "ARDUINO_MEGA2560_E_D13", -- mc_cd4
    BOX_CHIP_4290_R = "ARDUINO_MEGA2560_E_D53", -- mc_cd5
    -- COLUMN E
    DC_GEN_R        = "ARDUINO_MEGA2560_E_A14", -- mc_ce1
    CAUTION_PANEL_R = "ARDUINO_MEGA2560_E_A8",  -- mc_ce2
    INVERTOR_2_R    = "ARDUINO_MEGA2560_E_A7",  -- mc_ce3
    DOOR_LOCK_R     = "ARDUINO_MEGA2560_E_D6",  -- mc_ce4
    -- COLUMN F
    FUEL_BOOST_2_R  = "ARDUINO_MEGA2560_E_A13", -- mc_cf1
    FUEL_TRANS_2_R  = "ARDUINO_MEGA2560_E_A5",  -- mc_cf2
    BATTERY_R       = "ARDUINO_MEGA2560_E_A6",  -- mc_cf3
    FUEL_FILTER_2_R = "ARDUINO_MEGA2560_E_A10", -- mc_cf4
    FUEL_INTERCON_R = "ARDUINO_MEGA2560_E_D52", -- mc_cf5
    FUEL_XFEED_R    = "ARDUINO_MEGA2560_E_D9",  -- mc_cf6
    -- IMPLIED MAPPINGS
    OIL_PRESS_R     = "ARDUINO_MEGA2560_E_A11",
    FUEL_VALVE_R    = "ARDUINO_MEGA2560_E_A12",
    ENG_CHIP_R      = "ARDUINO_MEGA2560_E_D8",
    AUTO_PILOT_2_R  = "ARDUINO_MEGA2560_E_A15",
    -- Switches
    TEST_SW_POS1 = "ARDUINO_MEGA2560_E_D22",
    TEST_BTN = "ARDUINO_MEGA2560_E_D23",
    TEST_SW_POS2 = "ARDUINO_MEGA2560_E_D24",
    BRIGHT_DIM_POS1 = "ARDUINO_MEGA2560_E_D4",
    BRIGHT_DIM_POS2 = "ARDUINO_MEGA2560_E_D5",
}

-- Channel F: Flight Director
local PINS_F = {
    -- FD 1
    FD1_ALT = "ARDUINO_MEGA2560_F_D46",
    FD1_IAS = "ARDUINO_MEGA2560_F_D47",
    FD1_VS = "ARDUINO_MEGA2560_F_D48",
    FD1_HDG = "ARDUINO_MEGA2560_F_D49",
    FD1_NAV = "ARDUINO_MEGA2560_F_D50",
    FD1_ILS = "ARDUINO_MEGA2560_F_D51",
    FD1_BC = "ARDUINO_MEGA2560_F_D52",
    FD1_VOR_APR = "ARDUINO_MEGA2560_F_D53",
    FD1_GA = "ARDUINO_MEGA2560_F_D13",
    FD1_SBY = "ARDUINO_MEGA2560_F_A1",
    -- FD 1 LEDs
    LED_FD1_VS = "ARDUINO_MEGA2560_F_A4",
    LED_FD1_IAS = "ARDUINO_MEGA2560_F_A2",
    LED_FD1_ALT = "ARDUINO_MEGA2560_F_A3",
    LED_FD1_ILS_1 = "ARDUINO_MEGA2560_F_A5",
    LED_FD1_ILS_2 = "ARDUINO_MEGA2560_F_A6",
    LED_FD1_NAV_1 = "ARDUINO_MEGA2560_F_A7",
    LED_FD1_NAV_2 = "ARDUINO_MEGA2560_F_A8",
    LED_FD1_HDG = "ARDUINO_MEGA2560_F_A9",
    LED_FD1_GA = "ARDUINO_MEGA2560_F_A10",
    LED_FD1_VOR_APR_1 = "ARDUINO_MEGA2560_F_A11",
    LED_FD1_VOR_APR_2 = "ARDUINO_MEGA2560_F_A12",
    LED_FD1_BC_1 = "ARDUINO_MEGA2560_F_A13",
    LED_FD1_BC_2 = "ARDUINO_MEGA2560_F_A14",
    LED_FD1_SBY = "ARDUINO_MEGA2560_F_A15",
    -- FD 2
    FD2_ALT = "ARDUINO_MEGA2560_F_D25",
    FD2_IAS = "ARDUINO_MEGA2560_F_D26",
    FD2_VS = "ARDUINO_MEGA2560_F_D27",
    FD2_HDG = "ARDUINO_MEGA2560_F_D33",
    FD2_NAV = "ARDUINO_MEGA2560_F_D34",
    FD2_ILS = "ARDUINO_MEGA2560_F_D35",
    FD2_BC = "ARDUINO_MEGA2560_F_D42",
    FD2_VOR_APR = "ARDUINO_MEGA2560_F_D41",
    FD2_GA = "ARDUINO_MEGA2560_F_D43",
    FD2_SBY = "ARDUINO_MEGA2560_F_D45",
}

-- =============================================================================
-- 2. HARDWARE HANDLES (LEDs & Servos)
-- =============================================================================

-- Channel A LEDs
local LEDS_A = {
    trim = hw_output_add(PINS_A.LED_TRIM, false),
    test = hw_output_add(PINS_A.LED_TEST, false),
    fd = hw_output_add(PINS_A.LED_FD, false),
    cpl = hw_output_add(PINS_A.LED_CPL, false),
    sas = hw_led_add(PINS_A.LED_SAS, 0.0),
    att = hw_led_add(PINS_A.LED_ATT, 0.0),
    ap2 = hw_led_add(PINS_A.LED_AP2, 0.0),
    ap1 = hw_led_add(PINS_A.LED_AP1, 0.0),
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

-- Channel D (Overhead) LEDs & Relays & PWM
local LEDS_D = {
    gen2_fail = hw_led_add(PINS_D.LED_GEN2_FAIL, 0.0),
    inv1_fail = hw_led_add(PINS_D.LED_INV1_FAIL, 0.0),
    inv2_fail = hw_led_add(PINS_D.LED_INV2_FAIL, 0.0),
    fire1 = hw_led_add(PINS_D.LED_FIRE1, 0.0),
    relay_non_ess = hw_output_add(PINS_D.RELAY_NON_ESS, false),
    relay_bat1_off = hw_output_add(PINS_D.RELAY_BAT1_OFF, false),
    inst_console = hw_output_pwm_add(PINS_D.INST_CONSOLE, 100, 0.0),
    inst_sec = hw_output_pwm_add(PINS_D.INST_SEC, 100, 0.0),
    inst_eng = hw_output_pwm_add(PINS_D.INST_ENG, 100, 0.0),
    -- Conflicted/Commented LEDs
    -- gen1_fail = hw_led_add(PINS_D.LED_GEN1_FAIL, 0.0),
    -- batt_caut = hw_led_add(PINS_D.LED_BATT_CAUT, 0.0),
    -- fire2 = hw_led_add(PINS_D.LED_FIRE2, 0.0),
    -- bag_fire = hw_led_add(PINS_D.LED_BAG_FIRE, 0.0),
}

-- Channel E (Caution) LEDs - Using hw_output_add for Digital Pins
local LEDS_E = {}
for k, v in pairs(PINS_E) do
    if k ~= "TEST_SW_POS1" and k ~= "TEST_BTN" and k ~= "TEST_SW_POS2" and k ~= "BRIGHT_DIM_POS1" and k ~= "BRIGHT_DIM_POS2" then
        LEDS_E[k] = hw_output_add(v, false)
    end
end

-- Channel F (Flight Director) LEDs
local LEDS_F = {
    fd1_vs = hw_led_add(PINS_F.LED_FD1_VS, 0.0),
    fd1_ias = hw_led_add(PINS_F.LED_FD1_IAS, 0.0),
    fd1_alt = hw_led_add(PINS_F.LED_FD1_ALT, 0.0),
    fd1_ils1 = hw_led_add(PINS_F.LED_FD1_ILS_1, 0.0),
    fd1_ils2 = hw_led_add(PINS_F.LED_FD1_ILS_2, 0.0),
    fd1_nav1 = hw_led_add(PINS_F.LED_FD1_NAV_1, 0.0),
    fd1_nav2 = hw_led_add(PINS_F.LED_FD1_NAV_2, 0.0),
    fd1_hdg = hw_led_add(PINS_F.LED_FD1_HDG, 0.0),
    fd1_ga = hw_led_add(PINS_F.LED_FD1_GA, 0.0),
    fd1_vo1 = hw_led_add(PINS_F.LED_FD1_VOR_APR_1, 0.0),
    fd1_vo2 = hw_led_add(PINS_F.LED_FD1_VOR_APR_2, 0.0),
    fd1_bc1 = hw_led_add(PINS_F.LED_FD1_BC_1, 0.0),
    fd1_bc2 = hw_led_add(PINS_F.LED_FD1_BC_2, 0.0),
    fd1_sby = hw_led_add(PINS_F.LED_FD1_SBY, 0.0),
}

-- =============================================================================
-- 3. STATE VARIABLES
-- =============================================================================
local STATE = {
    -- Electrical
    MasterDcBus = 1,
    batt1 = false, batt2 = false,
    gen1 = false, gen2 = false, gen1_prod = false, gen2_prod = false,
    inv1 = false, inv2 = false,
    non_bus = false, emer_load = false, stby_att = false,
    
    -- Caution Panel Logic
    ResetMC = 0, TestMC = 0,
    OILE1 = 100, OILE2 = 100,
    SwvalveEng1 = 1, SwvalveEng2 = 1,
    SwboostpuEng1 = 1, SwboostpuEng2 = 1,
    SwfueltransengA = 1, SwfueltransengB = 1,
    FuelCenter = 100,
    Swfuelintcon = 0, SwFuelxfeed = 0,
    CSepP1 = 0, CSepP2 = 0,
    SwGovA = 0, SwGovB = 0,
    CGenel = 1, CGener = 1,
    RotorBrake = false,
    Swinva = 1, Swinvb = 1,
    SwHeater = 0,
    DoorL = 0, DoorR = 0, DoorBag = 0,
    Gbox = 100, XMSN = 100,
    GboxT = 10, XMSNT = 10,
    SwHydA = 1, SwHydB = 1,
    ExtPower = 0,
    Swbatta = 1, Swbattb = 1,
    
    -- Pedestal / Overhead
    ap1 = false, ap2 = false,
    sas_mode = "SAS",
    cpl = false,
    trim_cycle = 0,
    mag_dg_state = 0,
    ahrs_test_state = 0,
    
    -- Fire
    fire1 = 0, fire2 = 0, fire_test = false, bag_fire = 0, bag_fire_test = 0,
    
    -- Fuel Quantity 
    fuel_digit_test = 0, fuel_qty_test_fwd = false, fuel_qty_test_mid = false,
    
    -- Collective
    idle_stop_1 = false, idle_stop_2 = false,
    
    -- FD Switches
    fd1_alt_sw = false,
    
    -- Overhead
    pitot = false, nav = false, anticoll = false, wiper_pi = false, wiper_co = false,
    heater = false, blower = false, aft_outlet = false,
    map_dim_val = 0.0,
}

-- =============================================================================
-- 4. LOGIC FUNCTIONS
-- =============================================================================

-- Master Caution Logic (Updated from Caution Panel Script)
function update_cwp_leds()
    local power = (STATE.MasterDcBus > 0)
    local test = (STATE.TestMC > 0)
    local reset = (STATE.ResetMC == 0) -- 0=Active

    local function check(fault, use_reset)
        if not power then return false end
        if test then return true end
        if use_reset and reset and fault then return true end -- Suppressed if Reset active? No wait, logic reversed
        -- XML: (Reset==0) means BUTTON PRESSED/ACTIVE. If reset==0, and fault, we show light? 
        -- Re-reading logic_master_caution:
        -- if (Reset==0) if (Test || Fault) -> Light ON.
        -- Wait, usually Reset suppresses Master Caution *Indicator*, but individual lights stay on?
        -- XML says: (L:MasterDcBus,bool) if{ (L:ResetMC,bool) 0 == if{ (L:TestMC,enum) || (L:OILE1,psi) 50 < || } }
        -- This says: Light ON IF Power AND (Reset==0) AND (Test OR Fault).
        -- So if Reset==1 (Not Pressed? Or Reset Active?), Light OFF.
        -- Standard Bell 412: Reset extinguishes Master Caution, but individual segments stay on.
        -- BUT, the User's XML specifically gates the individual segments with ResetMC == 0.
        -- So I will follow the User's XML logic exactly.
        
        if use_reset then
            if reset then -- ResetMC == 0
                 if fault then return true end
            end
        else
            if fault then return true end
        end
        return false
    end
    
    -- Using LEDS_E handles
    hw_output_set(LEDS_E.OIL_PRESS_L, check(STATE.OILE1 < 50, true))
    hw_output_set(LEDS_E.ENG_CHIP_L, check(false, false)) -- Test Only
    hw_output_set(LEDS_E.FUEL_VALVE_L, check(STATE.SwvalveEng1 == 0, true))
    hw_output_set(LEDS_E.FUEL_BOOST_1_L, check(STATE.SwboostpuEng1 == 0, true))
    hw_output_set(LEDS_E.FUEL_TRANS_1_L, check(STATE.SwfueltransengA == 0, true))
    hw_output_set(LEDS_E.BATT_TEMP_L, check(false, false))
    hw_output_set(LEDS_E.FUEL_FILTER_1_L, check(false, false))
    hw_output_set(LEDS_E.FUEL_LOW_L, check(STATE.FuelCenter < 9.2, true))
    hw_output_set(LEDS_E.EFIS_FAN_1_L, check(false, false))
    
    hw_output_set(LEDS_E.PAR_SEP_OFF_L, check(STATE.CSepP1 ~= 0, true))
    hw_output_set(LEDS.GOV_MANUAL_L, check(STATE.SwGovA ~= 0, true))
    hw_output_set(LEDS_E.DC_GEN_L, check(STATE.CGenel == 0, true))
    hw_output_set(LEDS_E.AUTO_PILOT_1_L, check(false, false))
    hw_output_set(LEDS_E.ROTOR_BRAKE_L, check(STATE.RotorBrake, true))
    hw_output_set(LEDS.INVERTER_1_L, check(STATE.Swinva == 0, true))
    hw_output_set(LEDS.HEATER_AIR_L, check(STATE.SwHeater ~= 0, true))

    hw_output_set(LEDS_E.IGNITION_L, check(false, false))
    hw_output_set(LEDS_E.CBOX_OIL_PRESS_L, check(STATE.Gbox < 40, true))
    hw_output_set(LEDS_E.CBOX_OIL_TEMP_L, check(STATE.GboxT < 0, true))
    hw_output_set(LEDS_E.CBOX_CHIP_L, check(false, false))
    hw_output_set(LEDS_E.NO_1_HYD_L, check(STATE.SwHydA ~= 0, true))
    hw_output_set(LEDS.EXT_POWER_L, check(STATE.ExtPower ~= 0, true))

    hw_output_set(LEDS_E.XMSN_OIL_PRESS_R, check(STATE.XMSN < 30, true))
    hw_output_set(LEDS_E.XMSN_OIL_TEMP_R, check(STATE.XMSNT < 0, true))
    hw_output_set(LEDS_E.XMSN_CHIP_R, check(false, false))
    hw_output_set(LEDS_E.NO_2_HYD_R, check(STATE.SwHydB ~= 0, true))
    hw_output_set(LEDS.BOX_CHIP_4290_R, check(false, false))

    hw_output_set(LEDS_E.DC_GEN_R, check(STATE.CGener == 0, true))
    hw_output_set(LEDS_E.CAUTION_PANEL_R, check(false, false))
    hw_output_set(LEDS_E.INVERTOR_2_R, check(STATE.Swinvb == 0, true))
    local door = (STATE.DoorL > 0) or (STATE.DoorR > 0) or (STATE.DoorBag > 0)
    hw_output_set(LEDS_E.DOOR_LOCK_R, check(door, true))

    hw_output_set(LEDS_E.FUEL_BOOST_2_R, check(STATE.SwboostpuEng2 == 0, true))
    hw_output_set(LEDS.FUEL_TRANS_2_R, check(STATE.SwfueltransengB == 0, true))
    local batt = (STATE.Swbatta == 1 and STATE.Swbattb == 1)
    hw_output_set(LEDS_E.BATTERY_R, check(batt, true))
    hw_output_set(LEDS_E.FUEL_FILTER_2_R, check(false, false))
    hw_output_set(LEDS_E.FUEL_INTERCON_R, check(STATE.Swfuelintcon ~= 0, true))
    hw_output_set(LEDS_E.FUEL_XFEED_R, check(STATE.SwFuelxfeed ~= 0, true))

    hw_output_set(LEDS_E.OIL_PRESS_R, check(STATE.OILE2 < 50, true))
    hw_output_set(LEDS_E.FUEL_VALVE_R, check(STATE.SwvalveEng2 == 0, true))
    hw_output_set(LEDS_E.ENG_CHIP_R, check(false, false))
    hw_output_set(LEDS_E.AUTO_PILOT_2_R, check(false, false))
end

-- Overhead Logic
function update_overhead_logic()
    -- Electrical LEDs (Legacy/Conflict Check)
    local g2 = ((not STATE.gen2_prod) or (not STATE.gen2)) and 1.0 or 0.0
    local i1 = (not STATE.inv1) and 1.0 or 0.0
    local i2 = (not STATE.inv2) and 1.0 or 0.0
    hw_led_set(LEDS_D.gen2_fail, g2)
    hw_led_set(LEDS_D.inv1_fail, i1)
    hw_led_set(LEDS_D.inv2_fail, i2)
    hw_led_set(LEDS_D.fire1, (STATE.fire1 == 1) and 1.0 or 0.0)

    -- Relay Logic
    -- Non-Essential Bus (D40) gets GND if Gen1+Gen2+Switch ON
    local non_ess_active = (STATE.gen1 and STATE.gen2 and STATE.non_bus)
    hw_output_set(LEDS_D.relay_non_ess, non_ess_active)

    -- Bat 1 Off (D41) gets GND if Batt1 Switch is OFF
    hw_output_set(LEDS_D.relay_bat1_off, not STATE.batt1)
    
    -- Map Dimmer PWM
    local dim = STATE.map_dim_val -- 0.0 to 1.0
    -- Map Light Dimmer Button (Digital Step) overrides or interacts?
    -- User wanted simple dimming usually. Assuming Potentiometer control mainly.
end

-- Pedestal Logic (SAS/ATT)
function update_sas_att()
    if STATE.ap1 or STATE.ap2 then
        if STATE.sas_mode == "SAS" then
            hw_led_set(LEDS_A.sas, 1.0)
            hw_led_set(LEDS_A.att, 0.0)
        else
            hw_led_set(LEDS_A.sas, 0.0)
            hw_led_set(LEDS_A.att, 1.0)
        end
    else
        hw_led_set(LEDS_A.sas, 0.0)
        hw_led_set(LEDS_A.att, 0.0)
    end
end

-- =============================================================================
-- 5. HARDWARE INPUT CALLBACKS (Consolidated)
-- =============================================================================

-- Channel C Throttle
local function process_throttle_input(raw_val, is_release_active)
    if is_release_active then return raw_val end
    if raw_val < 0.12 then return 0.12 else return raw_val end
end

hw_adc_input_add(PINS_C.THROTTLE1, function(val)
    local t = process_throttle_input(val, STATE.idle_stop_1)
    fsx_variable_write("L:throgas1", "Number", t * 100)
end)
hw_adc_input_add(PINS_C.THROTTLE2, function(val)
    local t = process_throttle_input(val, STATE.idle_stop_2)
    fsx_variable_write("L:throgas2", "Number", t * 100)
end)

-- Channel F Buttons (Flight Director)
local function create_fd_button(pin, name, lvar)
    hw_button_add(pin, function()
        print(name .. " Pressed")
        -- Simple toggle logic placeholder or event
        -- fsx_event(lvar) or toggle
    end)
end
create_fd_button(PINS_F.FD1_ALT, "FD1 ALT", "L:FD1_ALT_Switch")
create_fd_button(PINS_F.FD1_IAS, "FD1 IAS", "L:FD1_IAS_Switch")
create_fd_button(PINS_F.FD1_VS, "FD1 VS", "L:FD1_VS_Switch")
create_fd_button(PINS_F.FD1_HDG, "FD1 HDG", "L:FD1_HDG_Switch")
create_fd_button(PINS_F.FD1_NAV, "FD1 NAV", "L:FD1_NAV_Switch")
create_fd_button(PINS_F.FD1_ILS, "FD1 ILS", "L:FD1_ILS_Switch")
create_fd_button(PINS_F.FD1_BC, "FD1 BC", "L:FD1_BC_Switch")
create_fd_button(PINS_F.FD1_VOR_APR, "FD1 VOR APR", "L:FD1_VORAPR_Switch")
create_fd_button(PINS_F.FD1_GA, "FD1 GA", "L:FD1_GA_Switch")
create_fd_button(PINS_F.FD1_SBY, "FD1 SBY", "L:FD1_SBY_Switch")
create_fd_button(PINS_F.FD2_ALT, "FD2 ALT", "L:FD2_ALT_Switch")
create_fd_button(PINS_F.FD2_IAS, "FD2 IAS", "L:FD2_IAS_Switch")
create_fd_button(PINS_F.FD2_VS, "FD2 VS", "L:FD2_VS_Switch")
create_fd_button(PINS_F.FD2_HDG, "FD2 HDG", "L:FD2_HDG_Switch")
create_fd_button(PINS_F.FD2_NAV, "FD2 NAV", "L:FD2_NAV_Switch")
create_fd_button(PINS_F.FD2_ILS, "FD2 ILS", "L:FD2_ILS_Switch")
create_fd_button(PINS_F.FD2_BC, "FD2 BC", "L:FD2_BC_Switch")
create_fd_button(PINS_F.FD2_VOR_APR, "FD2 VOR APR", "L:FD2_VORAPR_Switch")
create_fd_button(PINS_F.FD2_GA, "FD2 GA", "L:FD2_GA_Switch")
create_fd_button(PINS_F.FD2_SBY, "FD2 SBY", "L:FD2_SBY_Switch")

-- =============================================================================
-- 6. SUBSCRIPTIONS
-- =============================================================================

fsx_variable_subscribe("L:MasterDcBus", "Bool", function(val) STATE.MasterDcBus = val and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:ResetMC", "Bool", function(val) STATE.ResetMC = val and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:TestMC", "Enum", function(val) STATE.TestMC = val; update_cwp_leds() end)

-- CWP Params
fsx_variable_subscribe("L:OILE1", "PSI", function(val) STATE.OILE1 = val; update_cwp_leds() end)
fsx_variable_subscribe("L:OILE2", "PSI", function(val) STATE.OILE2 = val; update_cwp_leds() end)
fsx_variable_subscribe("L:SwvalveEng1", "Bool", function(val) STATE.SwvalveEng1 = val and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:SwvalveEng2", "Bool", function(val) STATE.SwvalveEng2 = val and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:SwboostpuEng1", "Bool", function(val) STATE.SwboostpuEng1 = val and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:SwboostpuEng2", "Bool", function(val) STATE.SwboostpuEng2 = val and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:SwfueltransengA", "Bool", function(val) STATE.SwfueltransengA = val and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:SwfueltransengB", "Bool", function(val) STATE.SwfueltransengB = val and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:Swbatta", "Bool", function(val) STATE.Swbatta = val and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:Swbattb", "Bool", function(val) STATE.Swbattb = val and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("A:FUEL TANK CENTER LEVEL", "Percent", function(val) STATE.FuelCenter = val; update_cwp_leds() end)
fsx_variable_subscribe("L:Swfuelintcon", "Bool", function(val) STATE.Swfuelintcon = val and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:SwFuelxfeed", "Bool", function(val) STATE.SwFuelxfeed = val and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:CSepP1", "Bool", function(val) STATE.CSepP1 = val and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:SwGovA", "Bool", function(val) STATE.SwGovA = val and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:CGenel", "Bool", function(val) STATE.CGenel = val and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:CGener", "Bool", function(val) STATE.CGener = val and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("A:Rotor Brake Active", "Bool", function(val) STATE.RotorBrake = val; update_cwp_leds() end)
fsx_variable_subscribe("L:Swinva", "Bool", function(val) STATE.Swinva = val and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:Swinvb", "Bool", function(val) STATE.Swinvb = val and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:SwHeater", "Bool", function(val) STATE.SwHeater = val and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:Door passenger l", "Percent", function(val) STATE.DoorL = val; update_cwp_leds() end)
fsx_variable_subscribe("L:Door passenger r", "Percent", function(val) STATE.DoorR = val; update_cwp_leds() end)
fsx_variable_subscribe("L:Door baggage", "Percent", function(val) STATE.DoorBag = val; update_cwp_leds() end)
fsx_variable_subscribe("L:Gbox", "PSI", function(val) STATE.Gbox = val; update_cwp_leds() end)
fsx_variable_subscribe("L:XMSN", "PSI", function(val) STATE.XMSN = val; update_cwp_leds() end)
fsx_variable_subscribe("L:GboxT", "Celsius", function(val) STATE.GboxT = val; update_cwp_leds() end)
fsx_variable_subscribe("L:XMSNT", "Celsius", function(val) STATE.XMSNT = val; update_cwp_leds() end)
fsx_variable_subscribe("L:Sw hydsysA", "Bool", function(val) STATE.SwHydA = val and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:Sw hydsysB", "Bool", function(val) STATE.SwHydB = val and 1 or 0; update_cwp_leds() end)
fsx_variable_subscribe("L:ExternalPower", "Bool", function(val) STATE.ExtPower = val and 1 or 0; update_cwp_leds() end)

-- Initial Update
update_cwp_leds()
update_overhead_logic()
update_sas_att()

print("Bell 412 - Master Script Loaded & Running")