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
    GOV_MANUAL_L    = "ARDUINO_MEGA2560_E_D47", -- mc_cb2
    DC_GEN_L        = "ARDUINO_MEGA2560_E_D30", -- mc_cb3
    -- mc_cb4 (Gen Ovht) - No Pin
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
    
    -- IMPLIED MAPPINGS (User requested same logic for similar parameters)
    OIL_PRESS_R     = "ARDUINO_MEGA2560_E_A11",
    FUEL_VALVE_R    = "ARDUINO_MEGA2560_E_A12",
    ENG_CHIP_R      = "ARDUINO_MEGA2560_E_D8",
    AUTO_PILOT_2_R  = "ARDUINO_MEGA2560_E_A15",
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

-- Logic Update Loop
function update_leds()
    local power = (STATE.MasterDcBus > 0)
    local test = (STATE.TestMC > 0)
    local reset = (STATE.ResetMC == 0) -- 0 means Not Reset (Active)
    
    -- Logic Helper: Checks Power, Test, Reset(if req), and Fault
    -- If use_reset is true, Fault is suppressed if ResetMC=1
    local function check(fault, use_reset)
        if not power then return false end
        if test then return true end
        
        -- If Reset is required (use_reset=true) and ResetMC=1 (reset=false), 
        -- then Fault is suppressed.
        if use_reset then
            if reset and fault then return true end
        else
            -- If Reset not used (use_reset=false), Fault passes through 
            -- (Assuming XML meant strict mapping)
            if fault then return true end
        end
        return false
    end
    
    -- XML Logic: "Test Only" usually implies NO Reset Check in XML structure
    -- XML Logic: "Standard" has (L:ResetMC,bool) 0 ==
    
    -- COLUMN A
    hw_output_set(LEDS.OIL_PRESS_L, check(STATE.OILE1 < 50, true))      -- mc_ca1
    hw_output_set(LEDS.ENG_CHIP_L, check(false, false))                 -- mc_ca2 (Test Only)
    hw_output_set(LEDS.FUEL_VALVE_L, check(STATE.SwvalveEng1 == 0, true))-- mc_ca3
    hw_output_set(LEDS.FUEL_BOOST_1_L, check(STATE.SwboostpuEng1 == 0, true)) -- mc_ca4
    hw_output_set(LEDS.FUEL_TRANS_1_L, check(STATE.SwfueltransengA == 0, true)) -- mc_ca5
    hw_output_set(LEDS.BATT_TEMP_L, check(false, false))                -- mc_ca6 (Test Only)
    hw_output_set(LEDS.FUEL_FILTER_1_L, check(false, false))            -- mc_ca7 (Test Only)
    hw_output_set(LEDS.FUEL_LOW_L, check(STATE.FuelCenter < 9.2, true)) -- mc_ca8
    hw_output_set(LEDS.EFIS_FAN_1_L, check(false, false))               -- mc_ca9 (Test Only)
    
    -- COLUMN B
    hw_output_set(LEDS.PAR_SEP_OFF_L, check(STATE.CSepP1 ~= 0, true))   -- mc_cb1
    hw_output_set(LEDS.GOV_MANUAL_L, check(STATE.SwGovA ~= 0, true))    -- mc_cb2
    hw_output_set(LEDS.DC_GEN_L, check(STATE.CGenel == 0, true))        -- mc_cb3
    -- mc_cb4 (Gen Ovht) Test Only
    hw_output_set(LEDS.AUTO_PILOT_1_L, check(false, false))             -- mc_cb5 (Test Only in XML)
    hw_output_set(LEDS.ROTOR_BRAKE_L, check(STATE.RotorBrake, true))    -- mc_cb6
    hw_output_set(LEDS.INVERTER_1_L, check(STATE.Swinva == 0, true))    -- mc_cb7
    hw_output_set(LEDS.HEATER_AIR_L, check(STATE.SwHeater ~= 0, true))  -- mc_cb8
    
    -- COLUMN C
    hw_output_set(LEDS.IGNITION_L, check(false, false))                 -- mc_cc1 (Test Only)
    hw_output_set(LEDS.CBOX_OIL_PRESS_L, check(STATE.Gbox < 40, true))  -- mc_cc2
    hw_output_set(LEDS.CBOX_OIL_TEMP_L, check(STATE.GboxT < 0, true))   -- mc_cc3
    hw_output_set(LEDS.CBOX_CHIP_L, check(false, false))                -- mc_cc4 (Test Only)
    hw_output_set(LEDS.NO_1_HYD_L, check(STATE.SwHydA ~= 0, true))      -- mc_cc5
    hw_output_set(LEDS.EXT_POWER_L, check(STATE.ExtPower ~= 0, true))   -- mc_cc6
    
    -- COLUMN D
    hw_output_set(LEDS.XMSN_OIL_PRESS_R, check(STATE.XMSN < 30, true))  -- mc_cd1
    hw_output_set(LEDS.XMSN_OIL_TEMP_R, check(STATE.XMSNT < 0, true))   -- mc_cd2
    hw_output_set(LEDS.XMSN_CHIP_R, check(false, false))                -- mc_cd3 (Test Only)
    hw_output_set(LEDS.NO_2_HYD_R, check(STATE.SwHydB ~= 0, true))      -- mc_cd4
    hw_output_set(LEDS.BOX_CHIP_4290_R, check(false, false))            -- mc_cd5 (Test Only)
    
    -- COLUMN E
    hw_output_set(LEDS.DC_GEN_R, check(false, false))                   -- mc_ce1 (Test Only in XML Logic!)
    -- Note: User CSV maps this to DC Generator R. 
    -- XML Logic for mc_ce1 is Test Only. 
    -- XML Logic for mc_cb3 is Left AND Right Gen (shared image).
    -- User Requested: "If logic missing... use same logic".
    -- I will stick to strict XML mc_ce1 logic (Test Only) unless user corrects, 
    -- BUT typically R Gen has logic. Let's assume the user wants funcationality.
    -- Override: Apply Gen Logic to R Gen (Implied Logic)
    hw_output_set(LEDS.DC_GEN_R, check(STATE.CGener == 0, true))        -- Overridden (Implied)
    
    hw_output_set(LEDS.CAUTION_PANEL_R, check(false, false))            -- mc_ce2 (Test Only)
    hw_output_set(LEDS.INVERTOR_2_R, check(STATE.Swinvb == 0, true))    -- mc_ce3
    local door_open = (STATE.DoorL > 0) or (STATE.DoorR > 0) or (STATE.DoorBag > 0)
    hw_output_set(LEDS.DOOR_LOCK_R, check(door_open, true))             -- mc_ce4
    
    -- COLUMN F
    hw_output_set(LEDS.FUEL_BOOST_2_R, check(STATE.SwboostpuEng2 == 0, true)) -- mc_cf1
    hw_output_set(LEDS.FUEL_TRANS_2_R, check(STATE.SwfueltransengB == 0, true)) -- mc_cf2
    
    -- Battery R (mc_cf3): XML says (Swbatta && Swbattb == 1)
    local batt_cond = (STATE.Swbatta == 1 and STATE.Swbattb == 1)
    hw_output_set(LEDS.BATTERY_R, check(batt_cond, true))               -- mc_cf3
    
    hw_output_set(LEDS.FUEL_FILTER_2_R, check(false, false))            -- mc_cf4 (Test Only)
    hw_output_set(LEDS.FUEL_INTERCON_R, check(STATE.Swfuelintcon ~= 0, true)) -- mc_cf5
    hw_output_set(LEDS.FUEL_XFEED_R, check(STATE.SwFuelxfeed ~= 0, true)) -- mc_cf6
    
    -- IMPLIED MAPPINGS (Right Engine Logic)
    hw_output_set(LEDS.OIL_PRESS_R, check(STATE.OILE2 < 50, true))
    hw_output_set(LEDS.FUEL_VALVE_R, check(STATE.SwvalveEng2 == 0, true))
    hw_output_set(LEDS.ENG_CHIP_R, check(false, false)) -- Test Only
    hw_output_set(LEDS.AUTO_PILOT_2_R, check(false, false)) -- Test Only (Implied from AP1)
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
fsx_variable_subscribe("L:SwGovA", "Bool", function(val) STATE.SwGovA = val and 1 or 0; update_leds() end)
fsx_variable_subscribe("L:CGenel", "Bool", function(val) STATE.CGenel = val and 1 or 0; update_leds() end)
fsx_variable_subscribe("L:CGener", "Bool", function(val) STATE.CGener = val and 1 or 0; update_leds() end)
fsx_variable_subscribe("A:Rotor Brake Active", "Bool", function(val) STATE.RotorBrake = val; update_leds() end)
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
fsx_variable_subscribe("L:ExternalPower", "Bool", function(val) STATE.ExtPower = val and 1 or 0; update_leds() end)

print("Master Caution Logic (XML) Loaded.")
