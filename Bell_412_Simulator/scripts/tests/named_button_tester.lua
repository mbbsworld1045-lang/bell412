-- =============================================================================
-- BELL 412 - NAMED BUTTON / SWITCH TESTER
-- Tests all input pins across all channels (A-F) directly from panel scripts
-- =============================================================================

print("Starting Named Button / Switch Test...")

-- =============================================================================
-- PIN DEFINITIONS (Sourced strictly from individual panel scripts)
-- =============================================================================

-- Channel A: Pedestal (pedestal.lua)
local PINS_A = {
    AP1_SW            = "ARDUINO_MEGA2560_A_D13",
    AP2_SW            = "ARDUINO_MEGA2560_A_D12",
    AFCS_SAS_SW       = "ARDUINO_MEGA2560_A_D10",
    AFCS_TEST_SW      = "ARDUINO_MEGA2560_A_D9",
    AFCS_TRIM_FD_SW   = "ARDUINO_MEGA2560_A_D7",
    AFCS_CPL_SW       = "ARDUINO_MEGA2560_A_D6",
    AFCS_SYS2         = "ARDUINO_MEGA2560_A_D43",
    AHRS_TEST_1       = "ARDUINO_MEGA2560_A_D53",
    AHRS_TEST_2       = "ARDUINO_MEGA2560_A_D49",
    MAG_DG_MAG1       = "ARDUINO_MEGA2560_A_D51",
    MAG_DG_MAG2       = "ARDUINO_MEGA2560_A_D47",
    MAG_DG_DG1        = "ARDUINO_MEGA2560_A_D52",
    MAG_DG_DG2        = "ARDUINO_MEGA2560_A_D48",
    VALVE1            = "ARDUINO_MEGA2560_A_D30",
    VALVE2            = "ARDUINO_MEGA2560_A_D32",
    XFEED             = "ARDUINO_MEGA2560_A_D28",
    XFEED_POS2        = "ARDUINO_MEGA2560_A_D31",
    FUEL_XFEED        = "ARDUINO_MEGA2560_A_D33",
    FUEL_TRANS1       = "ARDUINO_MEGA2560_A_D34",
    BOOST1            = "ARDUINO_MEGA2560_A_D35",
    FUEL_INTCON       = "ARDUINO_MEGA2560_A_D36",
    FUEL_TRANS2       = "ARDUINO_MEGA2560_A_D37",
    BOOST2            = "ARDUINO_MEGA2560_A_D38",
    HYD1_SW           = "ARDUINO_MEGA2560_A_D39",
    HYD2_SW           = "ARDUINO_MEGA2560_A_D42",
    GOV_ENG1          = "ARDUINO_MEGA2560_A_D23",
    GOV_ENG2          = "ARDUINO_MEGA2560_A_D29",
    PARTSEP1          = "ARDUINO_MEGA2560_A_D25",
    PARTSEP2          = "ARDUINO_MEGA2560_A_D27",
    FORCE_TRIM        = "ARDUINO_MEGA2560_A_D40",
    RPM_AUDIO         = "ARDUINO_MEGA2560_A_D41",
}

-- Channel B: Front Panel (front_panel.lua)
local PINS_B = {
    BRG_PTR           = "ARDUINO_MEGA2560_B_D38",
    BRG_PTR2          = "ARDUINO_MEGA2560_B_D10",
    FIRE_PULL1        = "ARDUINO_MEGA2560_B_D50",
    FIRE_PULL2        = "ARDUINO_MEGA2560_B_D35",
    FIRE_TEST         = "ARDUINO_MEGA2560_B_D51",
    BAG_FIRE_TEST     = "ARDUINO_MEGA2560_B_D52",
    EXTINGUISHER_POS1 = "ARDUINO_MEGA2560_B_D7",
    EXTINGUISHER_POS2 = "ARDUINO_MEGA2560_B_D8",
    MARKER_TEST       = "ARDUINO_MEGA2560_B_D45",
    MARKER_TEST2      = "ARDUINO_MEGA2560_B_D37",
    OVERTQ_TEST       = "ARDUINO_MEGA2560_B_D49",
    OVERTQ_TEST2      = "ARDUINO_MEGA2560_B_D33",
    CYC_CTR_TEST_L    = "ARDUINO_MEGA2560_B_D40",
    CYC_CTR_TEST_R    = "ARDUINO_MEGA2560_B_D32",
    MC_RESET_L        = "ARDUINO_MEGA2560_B_D41",
    MC_RESET_R        = "ARDUINO_MEGA2560_B_D36",
    FUEL_SYS_TEST_FWD = "ARDUINO_MEGA2560_B_D53",
    FUEL_SYS_TEST_MID = "ARDUINO_MEGA2560_B_D34",
    FUEL_DIGIT_TEST   = "ARDUINO_MEGA2560_B_D44",
    NAV_GPS_BTN_R     = "ARDUINO_MEGA2560_B_D11",
    NAV_GPS_BTN_L     = "ARDUINO_MEGA2560_B_D25",
}

-- Channel C: Collective (collective.lua)
local PINS_C = {
    LDG_LT_LT         = "ARDUINO_MEGA2560_C_D22",
    LDG_LT_EXT        = "ARDUINO_MEGA2560_C_D26",
    LDG_LT_RETR       = "ARDUINO_MEGA2560_C_D25",
    SRCH_LT_ON        = "ARDUINO_MEGA2560_C_D23",
    SRCH_LT_STOW      = "ARDUINO_MEGA2560_C_D24",
    SRCH_LT_EXT       = "ARDUINO_MEGA2560_C_D39",
    SRCH_LT_L         = "ARDUINO_MEGA2560_C_D37",
    SRCH_LT_R         = "ARDUINO_MEGA2560_C_D38",
    SRCH_LT_RETR      = "ARDUINO_MEGA2560_C_D40",
    IDLE_STOP_ENG1    = "ARDUINO_MEGA2560_C_D28",
    IDLE_STOP_ENG2    = "ARDUINO_MEGA2560_C_D29",
    START_ENG1        = "ARDUINO_MEGA2560_C_D31",
    START_ENG2        = "ARDUINO_MEGA2560_C_D30",
    RPM_INC_RH        = "ARDUINO_MEGA2560_C_D34",
    RPM_DEC_RH        = "ARDUINO_MEGA2560_C_D35",
    RPM_PLUS2         = "ARDUINO_MEGA2560_C_D36",
    RPM_MINUS2        = "ARDUINO_MEGA2560_C_D33",
    YAW_UP_RH         = "ARDUINO_MEGA2560_C_D48",
    YAW_DOWN_RH       = "ARDUINO_MEGA2560_C_D32",
    GO_AROUND_RH      = "ARDUINO_MEGA2560_C_D41",
    RPM_INC_LH        = "ARDUINO_MEGA2560_C_D45",
    RPM_DEC_LH        = "ARDUINO_MEGA2560_C_D46",
    YAW_UP_LH         = "ARDUINO_MEGA2560_C_D44",
    YAW_DOWN_LH       = "ARDUINO_MEGA2560_C_D43",
    GO_AROUND_LH      = "ARDUINO_MEGA2560_C_D42",
    FT_RELEASE        = "ARDUINO_MEGA2560_C_D47",
}

-- Channel D: Overhead Panel (over_head.lua)
local PINS_D = {
    BATT1_SW      = "ARDUINO_MEGA2560_D_D44",
    BATT2_SW      = "ARDUINO_MEGA2560_D_D49",
    GEN1_SW_ON    = "ARDUINO_MEGA2560_D_D50",
    GEN1_SW_RESET = "ARDUINO_MEGA2560_D_D51",
    GEN2_SW_ON    = "ARDUINO_MEGA2560_D_A9",
    GEN2_SW_RESET = "ARDUINO_MEGA2560_D_A10",
    INV1_SW       = "ARDUINO_MEGA2560_D_A12",
    INV2_SW       = "ARDUINO_MEGA2560_D_A11",
    NONESNTL_SW   = "ARDUINO_MEGA2560_D_A13",
    EMERGLOAD_SW  = "ARDUINO_MEGA2560_D_A14",
    STBYATT_SW    = "ARDUINO_MEGA2560_D_D10",
    MAP_DIM_BTN   = "ARDUINO_MEGA2560_D_D11",
    PITOT_HEAT    = "ARDUINO_MEGA2560_D_D53",
    NAV_LIGHTS    = "ARDUINO_MEGA2560_D_D15",
    ANTICOLL      = "ARDUINO_MEGA2560_D_D16",
    WIPER_PI      = "ARDUINO_MEGA2560_D_D17",
    WIPER_CO      = "ARDUINO_MEGA2560_D_D18",
    HEATER        = "ARDUINO_MEGA2560_D_D43",
    VENT_BLOWER   = "ARDUINO_MEGA2560_D_D36",
    AFT_OUTLET    = "ARDUINO_MEGA2560_D_D37",
    DOME_LIGHT    = "ARDUINO_MEGA2560_D_D22",
    UTILITY_LT    = "ARDUINO_MEGA2560_D_D23",
    FIRE_PULL1    = "ARDUINO_MEGA2560_D_D24",
    FIRE_PULL2    = "ARDUINO_MEGA2560_D_D25",
    FIRE_TEST     = "ARDUINO_MEGA2560_D_D26",
    COMPASS_SLAVE = "ARDUINO_MEGA2560_D_D27",
    CB_INV1       = "ARDUINO_MEGA2560_D_D34",
    CB_INV2       = "ARDUINO_MEGA2560_D_A7",
    CB_NON_ESS1   = "ARDUINO_MEGA2560_D_D29",
    CB_NON_ESS2   = "ARDUINO_MEGA2560_D_D30",
    CB_ITT1       = "ARDUINO_MEGA2560_D_D26",
    CB_ITT2       = "ARDUINO_MEGA2560_D_A2",
    CB_GEN1_RESET = "ARDUINO_MEGA2560_D_D22",
    CB_GEN2_RESET = "ARDUINO_MEGA2560_D_A4",
    CB_IGNITION1  = "ARDUINO_MEGA2560_D_D23",
    CB_IGNITION2  = "ARDUINO_MEGA2560_D_A3",
    CB_ENG_TRQ    = "ARDUINO_MEGA2560_D_A5",
    CB_MSTR_TRQ   = "ARDUINO_MEGA2560_D_A6",
    CB_GEN2_FIELD = "ARDUINO_MEGA2560_D_A8",
    CB_IDLE_STOP  = "ARDUINO_MEGA2560_D_D24",
    ROTOR_BRAKE   = "ARDUINO_MEGA2560_D_D69",
    INST_CONSOLE  = "ARDUINO_MEGA2560_D_D42",
    INST_SEC      = "ARDUINO_MEGA2560_D_D45",
    INST_ENG      = "ARDUINO_MEGA2560_D_D47",
}

-- Channel E: Caution Panel System (caution_panel.lua uses these for testing inputs)
local PINS_E_SWITCHES = {
    TEST_SW_POS1    = "ARDUINO_MEGA2560_E_D22",
    TEST_BTN        = "ARDUINO_MEGA2560_E_D23",
    TEST_SW_POS2    = "ARDUINO_MEGA2560_E_D24",
    BRIGHT_DIM_POS1 = "ARDUINO_MEGA2560_E_D4",
    BRIGHT_DIM_POS2 = "ARDUINO_MEGA2560_E_D5",
}

-- Channel F: Flight Director (flight_director.lua)
local PINS_F = {
    -- FD 1
    FD1_ALT     = "ARDUINO_MEGA2560_F_D46",
    FD1_IAS     = "ARDUINO_MEGA2560_F_D47",
    FD1_VS      = "ARDUINO_MEGA2560_F_D48",
    FD1_HDG     = "ARDUINO_MEGA2560_F_D49",
    FD1_NAV     = "ARDUINO_MEGA2560_F_D50",
    FD1_ILS     = "ARDUINO_MEGA2560_F_D51",
    FD1_BC      = "ARDUINO_MEGA2560_F_D52",
    FD1_VOR_APR = "ARDUINO_MEGA2560_F_D53",
    FD1_GA      = "ARDUINO_MEGA2560_F_D13",
    FD1_SBY     = "ARDUINO_MEGA2560_F_A1",
    -- FD 2
    FD2_ALT     = "ARDUINO_MEGA2560_F_D25",
    FD2_IAS     = "ARDUINO_MEGA2560_F_D26",
    FD2_VS      = "ARDUINO_MEGA2560_F_D27",
    FD2_HDG     = "ARDUINO_MEGA2560_F_D33",
    FD2_NAV     = "ARDUINO_MEGA2560_F_D34",
    FD2_ILS     = "ARDUINO_MEGA2560_F_D35",
    FD2_BC      = "ARDUINO_MEGA2560_F_D42",
    FD2_VOR_APR = "ARDUINO_MEGA2560_F_D41",
    FD2_GA      = "ARDUINO_MEGA2560_F_D43",
    FD2_SBY     = "ARDUINO_MEGA2560_F_D45",
}

-- =============================================================================
-- LOGIC SETUP
-- =============================================================================

-- Master list of all pin tables and their specific Channel prefix
local all_channels = {
    { prefix = "A_Pedestal",   pins = PINS_A },
    { prefix = "B_Front",      pins = PINS_B },
    { prefix = "C_Collective", pins = PINS_C },
    { prefix = "D_Overhead",   pins = PINS_D },
    { prefix = "E_Caution",    pins = PINS_E_SWITCHES },
    { prefix = "F_FlighDir",   pins = PINS_F },
}

local function setup_listeners()
    for _, channel in ipairs(all_channels) do
        for name, pin in pairs(channel.pins) do
            
            -- Add switch listener: Tracks both ON (pressed) and OFF (released) states
            hw_switch_add(pin, function(state)
                local state_str = state and "ON (Pressed/Active)" or "OFF (Released/Inactive)"
                print(string.format("[%s] Input: %s -> State: %s  (Pin: %s)", channel.prefix, name, state_str, pin))
            end)
            
        end
    end
    print("All input listeners have been registered. Waiting for button presses...")
end

-- Initialize all listeners
setup_listeners()
