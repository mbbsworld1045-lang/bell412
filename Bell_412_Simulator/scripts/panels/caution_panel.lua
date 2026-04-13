-- Logic Script for Master Caution Panel (Test Code)
-- Implements XML Gauge Logic provided by User

-- Digital Output Pins (Channel E - Caution Panel)
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
    PAR_SEP_OFF_R   = "ARDUINO_MEGA2560_E_D12",
    GOV_MANUAL_L    = "ARDUINO_MEGA2560_E_D47", -- mc_cb2
    DC_GEN_L        = "ARDUINO_MEGA2560_E_D30", -- mc_cb3
    -- mc_cb4 (Gen Ovht) - No Pin
    AUTO_PILOT_1_L  = "ARDUINO_MEGA2560_E_D34", -- mc_cb5
    ROTOR_BRAKE_L   = "ARDUINO_MEGA2560_E_D32", -- mc_cb6
    ROTOR_BRAKE_R   = "ARDUINO_MEGA2560_E_D51", 
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
    
    -- IMPLIED MAPPINGS (User requested same logic for similar parameters)
    OIL_PRESS_R     = "ARDUINO_MEGA2560_E_A11",
    FUEL_VALVE_R    = "ARDUINO_MEGA2560_E_A12",
    ENG_CHIP_R      = "ARDUINO_MEGA2560_E_D8",
    AUTO_PILOT_2_R  = "ARDUINO_MEGA2560_E_A15",
}

-- Digital Input Pins (Channel E - Switches/Buttons)
local PINS_E_SWITCHES = {
    TEST_SW_POS1    = "ARDUINO_MEGA2560_E_D22",
    RESET_BTN       = "ARDUINO_MEGA2560_E_D23",
    TEST_SW_POS2    = "ARDUINO_MEGA2560_E_D24",
    LT_SW           = "ARDUINO_MEGA2560_E_D4",  -- Lamp Test
    TEST_PNL_SW     = "ARDUINO_MEGA2560_E_D5",  -- Test Panel
}

-- LED Handles
local LEDS = {}
-- Using hw_output_add for all pins (Digital Logic)
for k, v in pairs(PINS_E) do
    LEDS[k] = hw_output_add(v, false)
end

-- Simulator State Default Values
local STATE = {
    MasterDcBus = 1, -- Default ON for testing
    ResetMC = 0,
    TestMC = 0,
    
    -- Fault Conditions
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
    Swbatta = 1, Swbattb = 1, -- XML logic implies these affect Battery R
    Ignition = false, AutoPilot = 0, AutoPilot2 = 0
}

-- Global Synchronized Lamp Test Variable
local si_var_lamp_test = si_variable_create("bell412_lamp_test", "INT", 0)
-- Global Caution Count Variable (Reporting only)
local si_var_caution_count = si_variable_create("bell412_caution_count", "INT", 0)

-- Logic Update Loop
local refresh_active = false  -- Reset button flicker
local lamp_test_full = false   -- D5 (Test Panel) -> EVERYTHING ON
local lamp_test_lt   = false   -- D4 (LT Button)   -> FILTERED ON

-- List of LEDs approved for the D4 Lamp Test (Selective)
local LT_MAP = {
    OIL_PRESS_L = true, OIL_PRESS_R = true,
    PAR_SEP_OFF_L = true, PAR_SEP_OFF_R = true,
    GOV_MANUAL_L = true, GOV_MANUAL_R = true,
    FUEL_VALVE_L = true, FUEL_VALVE_R = true,
    DC_GEN_L = true, DC_GEN_R = true,
    FUEL_BOOST_1_L = true, FUEL_BOOST_2_R = true,
    FUEL_TRANS_1_L = true, FUEL_TRANS_2_R = true,
    CBOX_OIL_PRESS_L = true, CBOX_OIL_TEMP_L = true,
    XMSN_OIL_PRESS_R = true, XMSN_OIL_TEMP_R = true,
    ROTOR_BRAKE_L = true, ROTOR_BRAKE_R = true,
    BATTERY_R = true, FUEL_LOW_L = true,
    INVERTER_1_L = true, INVERTOR_2_R = true,
    NO_1_HYD_L = true, NO_2_HYD_R = true,
    FUEL_INTERCON_R = true, HEATER_AIR_L = true,
    EXT_POWER_L = true, DOOR_LOCK_R = true,
    FUEL_XFEED_R = true
}

function update_leds()
    local power = (STATE.MasterDcBus > 0)
    local test_full = (STATE.TestMC ~= 0) or lamp_test_full
    local test_lt   = lamp_test_lt
    local reset     = (STATE.ResetMC == 0) -- 0 means Not Reset (Active)
    
    local any_active = false
    local current_fault_count = 0
    local faults_seen = {} -- Used to avoid double-counting multi-pin logic (like Rotor Brake)
    
    -- Logic Helper: Checks Power, Test, Reset(if req), and Fault
    -- key: LED identifier to check against LT_MAP
    local function check(key, fault, use_reset)
        if not power or refresh_active then return false end
        
        local result = false
        -- Full Test (D5 or Sim TestMC)
        if test_full then 
            result = true 
        -- Filtered Lamp Test (D4)
        elseif test_lt and LT_MAP[key] then 
            result = true 
        -- Normal Logic (ignore STATE.ResetMC for segments to prevent flicker)
        elseif fault then
            result = true
        end
        
        -- Tracking for Master Caution Logic
        if result then 
            any_active = true 
            -- Count this fault if it's the first time we've seen it in this loop
            if not faults_seen[key] then
                current_fault_count = current_fault_count + 1
                faults_seen[key] = true
            end
        end
        
        return result
    end
    
    -- COLUMN A
    hw_output_set(LEDS.OIL_PRESS_L, check("OIL_PRESS_L", STATE.OILE1 < 50, true))      -- mc_ca1
    hw_output_set(LEDS.ENG_CHIP_L, check("ENG_CHIP_L", false, false))                 -- mc_ca2 (Test Only)
    hw_output_set(LEDS.FUEL_VALVE_L, check("FUEL_VALVE_L", STATE.SwvalveEng1 == 0, true))-- mc_ca3
    hw_output_set(LEDS.FUEL_BOOST_1_L, check("FUEL_BOOST_1_L", STATE.SwboostpuEng1 == 0, true)) -- mc_ca4
    hw_output_set(LEDS.FUEL_TRANS_1_L, check("FUEL_TRANS_1_L", STATE.SwfueltransengA == 0, true)) -- mc_ca5
    hw_output_set(LEDS.BATT_TEMP_L, check("BATT_TEMP_L", false, false))                -- mc_ca6 (Test Only)
    hw_output_set(LEDS.FUEL_FILTER_1_L, check("FUEL_FILTER_1_L", false, false))            -- mc_ca7 (Test Only)
    hw_output_set(LEDS.FUEL_LOW_L, check("FUEL_LOW_L", STATE.FuelCenter < 9.2, true)) -- mc_ca8
    hw_output_set(LEDS.EFIS_FAN_1_L, check("EFIS_FAN_1_L", false, false))               -- mc_ca9 (Test Only)
    
    -- COLUMN B
    hw_output_set(LEDS.PAR_SEP_OFF_L, check("PAR_SEP_OFF_L", STATE.CSepP1 ~= 0, true))   -- mc_cb1
    hw_output_set(LEDS.PAR_SEP_OFF_R, check("PAR_SEP_OFF_R", STATE.CSepP2 ~= 0, true))
    hw_output_set(LEDS.GOV_MANUAL_L, check("GOV_MANUAL_L", STATE.SwGovA ~= 0, true))    -- mc_cb2
    hw_output_set(LEDS.DC_GEN_L, check("DC_GEN_L", STATE.CGenel == 0, true))        -- mc_cb3
    -- mc_cb4 (Gen Ovht) Test Only
    hw_output_set(LEDS.AUTO_PILOT_1_L, check("AUTO_PILOT_1_L", false, false))             -- mc_cb5 (Test Only)
    
    local rb_led_on_lt = check("ROTOR_BRAKE_L", STATE.RotorBrake, true)
    hw_output_set(LEDS.ROTOR_BRAKE_L, rb_led_on_lt)    -- mc_cb6
    hw_output_set(LEDS.ROTOR_BRAKE_R, rb_led_on_lt)
    
    hw_output_set(LEDS.INVERTER_1_L, check("INVERTER_1_L", STATE.Swinva == 0, true))    -- mc_cb7
    hw_output_set(LEDS.HEATER_AIR_L, check("HEATER_AIR_L", STATE.SwHeater ~= 0, true))  -- mc_cb8
    
    -- COLUMN C
    hw_output_set(LEDS.IGNITION_L, check("IGNITION_L", false, false))                 -- mc_cc1 (Test Only)
    hw_output_set(LEDS.CBOX_OIL_PRESS_L, check("CBOX_OIL_PRESS_L", STATE.Gbox < 40, true))  -- mc_cc2
    hw_output_set(LEDS.CBOX_OIL_TEMP_L, check("CBOX_OIL_TEMP_L", STATE.GboxT < 0, true))   -- mc_cc3
    hw_output_set(LEDS.CBOX_CHIP_L, check("CBOX_CHIP_L", false, false))                -- mc_cc4 (Test Only)
    hw_output_set(LEDS.NO_1_HYD_L, check("NO_1_HYD_L", STATE.SwHydA ~= 0, true))      -- mc_cc5
    hw_output_set(LEDS.EXT_POWER_L, check("EXT_POWER_L", STATE.ExtPower ~= 0, true))   -- mc_cc6
    
    -- COLUMN D
    hw_output_set(LEDS.XMSN_OIL_PRESS_R, check("XMSN_OIL_PRESS_R", STATE.XMSN < 30, true))  -- mc_cd1
    hw_output_set(LEDS.XMSN_OIL_TEMP_R, check("XMSN_OIL_TEMP_R", STATE.XMSNT < 0, true))   -- mc_cd2
    hw_output_set(LEDS.XMSN_CHIP_R, check("XMSN_CHIP_R", false, false))                -- mc_cd3 (Test Only)
    hw_output_set(LEDS.NO_2_HYD_R, check("NO_2_HYD_R", STATE.SwHydB ~= 0, true))      -- mc_cd4
    hw_output_set(LEDS.BOX_CHIP_4290_R, check("BOX_CHIP_4290_R", false, false))            -- mc_cd5 (Test Only)
    
    -- COLUMN E
    hw_output_set(LEDS.DC_GEN_R, check("DC_GEN_R", STATE.CGener == 0, true))                   -- mc_ce1
    
    hw_output_set(LEDS.CAUTION_PANEL_R, check("CAUTION_PANEL_R", false, false))            -- mc_ce2 (Test Only)
    hw_output_set(LEDS.INVERTOR_2_R, check("INVERTOR_2_R", STATE.Swinvb == 0, true))    -- mc_ce3
    local door_open = (STATE.DoorL > 0) or (STATE.DoorR > 0) or (STATE.DoorBag > 0)
    hw_output_set(LEDS.DOOR_LOCK_R, check("DOOR_LOCK_R", door_open, true))             -- mc_ce4
    
    -- COLUMN F
    hw_output_set(LEDS.FUEL_BOOST_2_R, check("FUEL_BOOST_2_R", STATE.SwboostpuEng2 == 0, true)) -- mc_cf1
    hw_output_set(LEDS.FUEL_TRANS_2_R, check("FUEL_TRANS_2_R", STATE.SwfueltransengB == 0, true)) -- mc_cf2
    
    -- Battery R (mc_cf3): XML says (Swbatta && Swbattb == 1)
    local batt_cond = (STATE.Swbatta == 1 and STATE.Swbattb == 1)
    hw_output_set(LEDS.BATTERY_R, check("BATTERY_R", batt_cond, true))               -- mc_cf3
    
    hw_output_set(LEDS.FUEL_FILTER_2_R, check("FUEL_FILTER_2_R", false, false))            -- mc_cf4 (Test Only)
    hw_output_set(LEDS.FUEL_INTERCON_R, check("FUEL_INTERCON_R", STATE.Swfuelintcon ~= 0, true)) -- mc_cf5
    hw_output_set(LEDS.FUEL_XFEED_R, check("FUEL_XFEED_R", STATE.SwFuelxfeed ~= 0, true)) -- mc_cf6
    
    -- IMPLIED MAPPINGS (Right Engine Logic)
    hw_output_set(LEDS.OIL_PRESS_R, check("OIL_PRESS_R", STATE.OILE2 < 50, true))
    hw_output_set(LEDS.FUEL_VALVE_R, check("FUEL_VALVE_R", STATE.SwvalveEng2 == 0, true))
    hw_output_set(LEDS.ENG_CHIP_R, check("ENG_CHIP_R", false, false)) -- Test Only
    -- Simplify: Just broadcast the raw count of faults
    -- Intelligence is now handled by the Front Panel
    si_variable_write(si_var_caution_count, (test_full) and 99 or current_fault_count)
end

-- =============================================================================
-- SUBSCRIPTIONS
-- =============================================================================

fsx_variable_subscribe("L:MasterDcBus", "Bool", function(val) STATE.MasterDcBus = val and 1 or 0; update_leds() end)
fsx_variable_subscribe("L:ResetMC", "Bool", function(val) STATE.ResetMC = val and 1 or 0; update_leds() end)
fsx_variable_subscribe("L:TestMC", "Enum", function(val) STATE.TestMC = val; update_leds() end)

fsx_variable_subscribe("L:OILE1", "PSI", function(val) STATE.OILE1 = val; update_leds() end)
fsx_variable_subscribe("L:OILE2", "PSI", function(val) STATE.OILE2 = val; update_leds() end)
fsx_variable_subscribe("L:SwvalveEng1", "Bool", function(val) STATE.SwvalveEng1 = val and 1 or 0; update_leds() end)
fsx_variable_subscribe("L:SwvalveEng2", "Bool", function(val) STATE.SwvalveEng2 = val and 1 or 0; update_leds() end)
fsx_variable_subscribe("L:SwboostpuEng1", "Bool", function(val) STATE.SwboostpuEng1 = val and 1 or 0; update_leds() end)
fsx_variable_subscribe("L:SwboostpuEng2", "Bool", function(val) STATE.SwboostpuEng2 = val and 1 or 0; update_leds() end)
fsx_variable_subscribe("L:SwfueltransengA", "Bool", function(val) STATE.SwfueltransengA = val and 1 or 0; update_leds() end)
fsx_variable_subscribe("L:SwfueltransengB", "Bool", function(val) STATE.SwfueltransengB = val and 1 or 0; update_leds() end)
fsx_variable_subscribe("L:Swbatta", "Bool", function(val) STATE.Swbatta = val and 1 or 0; update_leds() end)
fsx_variable_subscribe("L:Swbattb", "Bool", function(val) STATE.Swbattb = val and 1 or 0; update_leds() end)
fsx_variable_subscribe("A:FUEL TANK CENTER LEVEL", "Percent", function(val) STATE.FuelCenter = val; update_leds() end)
fsx_variable_subscribe("L:Swfuelintcon", "Bool", function(val) STATE.Swfuelintcon = val and 1 or 0; update_leds() end)
fsx_variable_subscribe("L:SwFuelxfeed", "Bool", function(val) STATE.SwFuelxfeed = val and 1 or 0; update_leds() end)
fsx_variable_subscribe("L:CSepP1", "Bool", function(val) STATE.CSepP1 = val and 1 or 0; update_leds() end)
fsx_variable_subscribe("L:CSepP2", "Bool", function(val) STATE.CSepP2 = val and 1 or 0; update_leds() end)
fsx_variable_subscribe("L:SwGovA", "Bool", function(val) STATE.SwGovA = val and 1 or 0; update_leds() end)
fsx_variable_subscribe("L:CGenel", "Bool", function(val) STATE.CGenel = val and 1 or 0; update_leds() end)
fsx_variable_subscribe("L:CGener", "Bool", function(val) STATE.CGener = val and 1 or 0; update_leds() end)
si_variable_subscribe("bell412_rotor_brake", "INT", function(val) STATE.RotorBrake = (val == 1); update_leds() end)

-- CAUTION: Reset subscription removed. 
-- Caution Panel segments stay lit based on faults only.

fsx_variable_subscribe("L:Swinva", "Bool", function(val) STATE.Swinva = val and 1 or 0; update_leds() end)
fsx_variable_subscribe("L:Swinvb", "Bool", function(val) STATE.Swinvb = val and 1 or 0; update_leds() end)
fsx_variable_subscribe("L:SwHeater", "Bool", function(val) STATE.SwHeater = val and 1 or 0; update_leds() end)
fsx_variable_subscribe("L:Door passenger l", "Percent", function(val) STATE.DoorL = val; update_leds() end)
fsx_variable_subscribe("L:Door passenger r", "Percent", function(val) STATE.DoorR = val; update_leds() end)
fsx_variable_subscribe("L:Door baggage", "Percent", function(val) STATE.DoorBag = val; update_leds() end)
fsx_variable_subscribe("L:Gbox", "PSI", function(val) STATE.Gbox = val; update_leds() end)
fsx_variable_subscribe("L:XMSN", "PSI", function(val) STATE.XMSN = val; update_leds() end)
fsx_variable_subscribe("L:GboxT", "Celsius", function(val) STATE.GboxT = val; update_leds() end)
fsx_variable_subscribe("L:XMSNT", "Celsius", function(val) STATE.XMSNT = val; update_leds() end)
fsx_variable_subscribe("L:Sw hydsysA", "Bool", function(val) STATE.SwHydA = val and 1 or 0; update_leds() end)
fsx_variable_subscribe("L:Sw hydsysB", "Bool", function(val) STATE.SwHydB = val and 1 or 0; update_leds() end)
fsx_variable_subscribe("L:ExternalPower", "Bool", function(val) STATE.ExternalPower = val and 1 or 0; update_leds() end)

-- =============================================================================
-- HARDWARE INPUTS (Test Switches/Buttons)
-- =============================================================================

local test_pos1 = false
local test_pos2 = false
local test_pnl  = false
local lt_active = false

local function update_test_state()
    local val = 0
    if test_pos1 then 
        val = 1 
    elseif test_pos2 then 
        val = -1 
    end
    
    -- Update Global Lamp Test SI Variable (Broadcast the FULL test state)
    lamp_test_full = test_pnl
    lamp_test_lt   = lt_active
    
    -- Provide a combined signal for Front Panel/FD (Full Test only for other panels)
    si_variable_write(si_var_lamp_test, lamp_test_full and 1 or 0)
    
    -- Update Local Caution Panel Test State
    fsx_variable_write("L:TestMC", "Number", val)
    update_leds() 
end

-- TEST SWITCH POSITION 1
hw_button_add(PINS_E_SWITCHES.TEST_SW_POS1, 
    function() 
        print("HARDWARE: Caution Test Switch -> POS 1")
        test_pos1 = true
        update_test_state()
    end, 
    function() 
        test_pos1 = false
        update_test_state()
    end
)

-- TEST SWITCH POSITION 2
hw_button_add(PINS_E_SWITCHES.TEST_SW_POS2, 
    function() 
        print("HARDWARE: Caution Test Switch -> POS 2")
        test_pos2 = true
        update_test_state()
    end, 
    function() 
        test_pos2 = false
        update_test_state()
    end
)

-- RESET BUTTON (Momentary)
hw_button_add(PINS_E_SWITCHES.RESET_BTN, 
    function() 
        print("HARDWARE: Caution Reset Button -> PRESSED (Refreshing LEDs)")
        fsx_variable_write("L:ResetMC", "Number", 1)
        
        -- Refresh Flicker Logic: Briefly turn OFF all LEDs
        refresh_active = true
        update_leds()
        
        timer_start(200, function()
            refresh_active = false
            update_leds()
            print("HARDWARE: Caution Reset Button -> Refresh Complete")
        end)
    end, 
    function() 
        print("HARDWARE: Caution Reset Button -> RELEASED")
        fsx_variable_write("L:ResetMC", "Number", 0)
    end
)

-- LT (Lamp Test) SWITCH
hw_button_add(PINS_E_SWITCHES.LT_SW, 
    function() 
        print("HARDWARE: Caution Lamp Test (LT) -> ACTIVE (Filtered List)")
        lt_active = true
        update_test_state()
    end, 
    function() 
        print("HARDWARE: Caution Lamp Test (LT) -> OFF")
        lt_active = false
        update_test_state()
    end
)

-- TEST PANEL SWITCH
hw_button_add(PINS_E_SWITCHES.TEST_PNL_SW, 
    function() 
        print("HARDWARE: Caution Test Panel -> ACTIVE (All lights ON)")
        test_pnl = true
        update_test_state()
    end, 
    function() 
        print("HARDWARE: Caution Test Panel -> OFF")
        test_pnl = false
        update_test_state()
    end
)

print("Master Caution Logic (XML) Loaded.")
