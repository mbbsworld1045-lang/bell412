-- =============================================================================
-- BELL 412 - OVERHEAD PANEL SCRIPT
-- Platform: Air Manager + Arduino Mega 2560
-- Hardware: Arduino Channel D (Overhead Panel)
-- =============================================================================

print("Over Head Script Running")

-- =============================================================================
-- 1. HARDWARE CONFIGURATION HEADER
-- =============================================================================

-- INPUTS (Digital)
local PIN_BATT1_SW      = "ARDUINO_MEGA2560_D_D44"    -- Battery 1
local PIN_BATT2_SW      = "ARDUINO_MEGA2560_D_D49"    -- Battery 2
local PIN_GEN1_SW_ON    = "ARDUINO_MEGA2560_D_D50"    -- Generator 1 ON
local PIN_GEN1_SW_RESET = "ARDUINO_MEGA2560_D_D51"    -- Generator 1 RESET
local PIN_GEN2_SW_ON    = "ARDUINO_MEGA2560_D_A9"    -- Generator 2 ON
local PIN_GEN2_SW_RESET = "ARDUINO_MEGA2560_D_A10"   -- Generator 2 RESET
local PIN_INV1_SW       = "ARDUINO_MEGA2560_D_A12"   -- Inverter 1
local PIN_INV2_SW       = "ARDUINO_MEGA2560_D_A11"   -- Inverter 2
local PIN_NONESNTL_SW   = "ARDUINO_MEGA2560_D_A13"   -- Non-Essential Bus
local PIN_EMERGLOAD_SW  = "ARDUINO_MEGA2560_D_A14"   -- Emergency Load
local PIN_STBYATT_SW    = "ARDUINO_MEGA2560_D_D10"   -- Standby Attitude
local PIN_MAP_DIM_BTN   = "ARDUINO_MEGA2560_D_D11"   -- Map Light Dimmer Button
local PIN_PITOT_HEAT    = "ARDUINO_MEGA2560_D_D53"   -- Pitot Heat
local PIN_NAV_LIGHTS    = "ARDUINO_MEGA2560_D_D15"   -- Nav Lights
local PIN_ANTICOLL      = "ARDUINO_MEGA2560_D_D16"   -- Anti-Collision Lights
local PIN_WIPER_PI      = "ARDUINO_MEGA2560_D_D17"   -- Pilot Wiper
local PIN_WIPER_CO      = "ARDUINO_MEGA2560_D_D18"   -- Co-Pilot Wiper
local PIN_HEATER        = "ARDUINO_MEGA2560_D_D43"   -- Heater
local PIN_VENT_BLOWER   = "ARDUINO_MEGA2560_D_D36"   -- Vent Blower
local PIN_AFT_OUTLET    = "ARDUINO_MEGA2560_D_D37"   -- Aft Outlet
local PIN_DOME_LIGHT    = "ARDUINO_MEGA2560_D_D22"   -- Dome Light
local PIN_UTILITY_LT    = "ARDUINO_MEGA2560_D_D23"   -- Utility Light
local PIN_FIRE_PULL1    = "ARDUINO_MEGA2560_D_D24"   -- Fire Handle 1
local PIN_FIRE_PULL2    = "ARDUINO_MEGA2560_D_D25"   -- Fire Handle 2
local PIN_FIRE_TEST     = "ARDUINO_MEGA2560_D_D26"   -- Fire/Bag Test
local PIN_COMPASS_SLAVE = "ARDUINO_MEGA2560_D_D27"   -- Compass Mag/Slave

-- INPUTS (Analog)
local PIN_MAP_DIMMER    = "ARDUINO_MEGA2560_D_A0"    -- Map Light Dimmer Pot

-- OUTPUTS (LEDs)
local PIN_GEN1_FAIL_LED = "ARDUINO_MEGA2560_D_D30"
local PIN_GEN2_FAIL_LED = "ARDUINO_MEGA2560_D_D31"
local PIN_INV1_FAIL_LED = "ARDUINO_MEGA2560_D_D32"
local PIN_INV2_FAIL_LED = "ARDUINO_MEGA2560_D_D33"
local PIN_BATT_CAUT_LED = "ARDUINO_MEGA2560_D_D34"
local PIN_FIRE_ENG1_LED = "ARDUINO_MEGA2560_D_D35"
local PIN_FIRE_ENG2_LED = "ARDUINO_MEGA2560_D_D36"
local PIN_BAG_FIRE_LED  = "ARDUINO_MEGA2560_D_D37"

-- =============================================================================
-- LED HANDLES
-- =============================================================================
local led_gen1_fail = hw_led_add(PIN_GEN1_FAIL_LED, 0.0)
local led_gen2_fail = hw_led_add(PIN_GEN2_FAIL_LED, 0.0)
local led_inv1_fail = hw_led_add(PIN_INV1_FAIL_LED, 0.0)
local led_inv2_fail = hw_led_add(PIN_INV2_FAIL_LED, 0.0)
local led_batt_caut = hw_led_add(PIN_BATT_CAUT_LED, 0.0)
local led_fire_eng1 = hw_led_add(PIN_FIRE_ENG1_LED, 0.0)
local led_fire_eng2 = hw_led_add(PIN_FIRE_ENG2_LED, 0.0)
local led_bag_fire  = hw_led_add(PIN_BAG_FIRE_LED, 0.0)

-- =============================================================================
-- STATE VARIABLES
-- =============================================================================
local STATE = {
    -- Electrical
    batt1 = false, batt2 = false,
    gen1 = false, gen2 = false, gen1_prod = false, gen2_prod = false,
    inv1 = false, inv2 = false,
    non_bus = false, emer_load = false, stby_att = false,
    
    -- Ancillary
    pitot = false, nav = false, anticoll = false,
    wiper_pi = false, wiper_co = false,
    heater = false, blower = false, aft_outlet = false,
    dome = 0, util = false, map_dim_val = 0.0,
    
    -- Fire
    fire1 = 0, fire2 = 0, fire_test = false, bag_fire = 0,
    
    -- System
    dc_bus = 0,
}

local last_elec_print = ""
local last_fire_print = ""

-- =============================================================================
-- HELPER FUNCTIONS
-- =============================================================================

-- Update Electrical LEDs
local function update_elec_leds()
    local g1 = ((not STATE.gen1_prod) or (not STATE.gen1)) and 1.0 or 0.0
    local g2 = ((not STATE.gen2_prod) or (not STATE.gen2)) and 1.0 or 0.0
    local i1 = (not STATE.inv1) and 1.0 or 0.0
    local i2 = (not STATE.inv2) and 1.0 or 0.0
    
    hw_led_set(led_gen1_fail, g1)
    hw_led_set(led_gen2_fail, g2)
    hw_led_set(led_inv1_fail, i1)
    hw_led_set(led_inv2_fail, i2)
    
    -- Battery Caution: Batts ON but no Gens
    local batts_on = STATE.batt1 or STATE.batt2
    local gens_on = STATE.gen1_prod or STATE.gen2_prod
    local b_caut = (batts_on and not gens_on) and 1.0 or 0.0
    hw_led_set(led_batt_caut, b_caut)

    local current_print = string.format("LED UPDATE: Gen1Fail=%.0f Gen2Fail=%.0f Inv1Fail=%.0f Inv2Fail=%.0f BattCaut=%.0f", g1, g2, i1, i2, b_caut)
    if current_print ~= last_elec_print then
        print(current_print)
        last_elec_print = current_print
    end
end

-- Update Fire LEDs
local function update_fire_leds()
    if STATE.dc_bus == 0 then
        hw_led_set(led_fire_eng1, 0.0)
        hw_led_set(led_fire_eng2, 0.0)
        hw_led_set(led_bag_fire, 0.0)
        
        local current_print = "LED UPDATE: Fire LEDs OFF (No DC Bus)"
        if current_print ~= last_fire_print then
            print(current_print)
            last_fire_print = current_print
        end
        return
    end
    
    local test = STATE.fire_test
    local f1 = (test or (STATE.fire1 == 1)) and 1.0 or 0.0
    local f2 = (test or (STATE.fire2 == 1)) and 1.0 or 0.0
    local bf = (test or (STATE.bag_fire == 1)) and 1.0 or 0.0
    
    hw_led_set(led_fire_eng1, f1)
    hw_led_set(led_fire_eng2, f2)
    hw_led_set(led_bag_fire, bf)
    
    local current_print = string.format("LED UPDATE: Fire1=%.0f Fire2=%.0f BagFire=%.0f", f1, f2, bf)
    if current_print ~= last_fire_print then
        print(current_print)
        last_fire_print = current_print
    end
end

-- =============================================================================
-- HARDWARE INPUTS: ELECTRICAL
-- =============================================================================

-- BATTERY 1
hw_button_add(PIN_BATT1_SW,
    function() print("BTN: BATT 1 ON"); STATE.batt1 = true; fsx_variable_write("L:Swbatta", "Number", 1); update_elec_leds() end,
    function() print("BTN: BATT 1 OFF"); STATE.batt1 = false; fsx_variable_write("L:Swbatta", "Number", 0); update_elec_leds() end
)

-- BATTERY 2
hw_button_add(PIN_BATT2_SW,
    function() print("BTN: BATT 2 ON"); STATE.batt2 = true; fsx_variable_write("L:Swbattb", "Number", 1); update_elec_leds() end,
    function() print("BTN: BATT 2 OFF"); STATE.batt2 = false; fsx_variable_write("L:Swbattb", "Number", 0); update_elec_leds() end
)

-- GENERATOR 1
-- GENERATOR 1
hw_button_add(PIN_GEN1_SW_ON,
    function() print("BTN: GEN 1 ON"); STATE.gen1 = true; fsx_variable_write("L:Genel", "Number", 1); fsx_event("TOGGLE_ALTERNATOR1"); update_elec_leds() end,
    function() print("BTN: GEN 1 OFF"); STATE.gen1 = false; fsx_variable_write("L:Genel", "Number", 0); fsx_event("TOGGLE_ALTERNATOR1"); update_elec_leds() end
)
hw_button_add(PIN_GEN1_SW_RESET, function() print("BTN: GEN 1 RESET") end, function() end)

-- GENERATOR 2
hw_button_add(PIN_GEN2_SW_ON,
    function() print("BTN: GEN 2 ON"); STATE.gen2 = true; fsx_variable_write("L:Gener", "Number", 1); fsx_event("TOGGLE_ALTERNATOR2"); update_elec_leds() end,
    function() print("BTN: GEN 2 OFF"); STATE.gen2 = false; fsx_variable_write("L:Gener", "Number", 0); fsx_event("TOGGLE_ALTERNATOR2"); update_elec_leds() end
)
hw_button_add(PIN_GEN2_SW_RESET, function() print("BTN: GEN 2 RESET") end, function() end)
-- GENERATOR 2
hw_button_add(PIN_GEN2_SW,
    function() print("BTN: GEN 2 ON"); STATE.gen2 = true; fsx_variable_write("L:Gener", "Number", 1); fsx_event("TOGGLE_ALTERNATOR2"); update_elec_leds() end,
    function() print("BTN: GEN 2 OFF"); STATE.gen2 = false; fsx_variable_write("L:Gener", "Number", 0); fsx_event("TOGGLE_ALTERNATOR2"); update_elec_leds() end
)

-- INVERTER 1
hw_button_add(PIN_INV1_SW,
    function() print("BTN: INV 1 ON"); STATE.inv1 = true; fsx_variable_write("L:Swinva", "Number", 1); update_elec_leds() end,
    function() print("BTN: INV 1 OFF"); STATE.inv1 = false; fsx_variable_write("L:Swinva", "Number", 0); update_elec_leds() end
)

-- INVERTER 2
hw_button_add(PIN_INV2_SW,
    function() print("BTN: INV 2 ON"); STATE.inv2 = true; fsx_variable_write("L:Swinvb", "Number", 1); update_elec_leds() end,
    function() print("BTN: INV 2 OFF"); STATE.inv2 = false; fsx_variable_write("L:Swinvb", "Number", 0); update_elec_leds() end
)

-- NON-ESSENTIAL BUS
hw_button_add(PIN_NONESNTL_SW,
    function() print("BTN: NON-ESS BUS ON"); STATE.non_bus = true; fsx_variable_write("L:Swnonbus", "Number", 1) end,
    function() print("BTN: NON-ESS BUS OFF"); STATE.non_bus = false; fsx_variable_write("L:Swnonbus", "Number", 0) end
)

-- EMERGENCY LOAD
hw_button_add(PIN_EMERGLOAD_SW,
    function() print("BTN: EMER LOAD ON"); STATE.emer_load = true; fsx_variable_write("L:Swemerload", "Number", 1) end,
    function() print("BTN: EMER LOAD OFF"); STATE.emer_load = false; fsx_variable_write("L:Swemerload", "Number", 0) end
)

-- STANDBY ATTITUDE
hw_button_add(PIN_STBYATT_SW,
    function() print("BTN: STBY ATT ON"); STATE.stby_att = true; fsx_variable_write("L:Swstbyatt", "Number", 1); fsx_variable_write("L:stbatt", "Number", 1) end,
    function() print("BTN: STBY ATT OFF"); STATE.stby_att = false; fsx_variable_write("L:Swstbyatt", "Number", 0); fsx_variable_write("L:stbatt", "Number", 0) end
)

-- =============================================================================
-- HARDWARE INPUTS: ANCILLARY (LIGHTING/ENV)
-- =============================================================================

-- PITOT HEAT
hw_button_add(PIN_PITOT_HEAT,
    function() print("BTN: PITOT HEAT ON"); STATE.pitot = true; fsx_variable_write("L:Swpitot", "Number", 1); fsx_event("PITOT_HEAT_ON") end,
    function() print("BTN: PITOT HEAT OFF"); STATE.pitot = false; fsx_variable_write("L:Swpitot", "Number", 0); fsx_event("PITOT_HEAT_OFF") end
)

-- NAV LIGHTS (Swposition)
hw_button_add(PIN_NAV_LIGHTS,
    function() print("BTN: NAV LIGHTS ON"); STATE.nav = true; fsx_variable_write("L:Swposition", "Number", 1); fsx_event("NAV_LIGHTS_ON") end,
    function() print("BTN: NAV LIGHTS OFF"); STATE.nav = false; fsx_variable_write("L:Swposition", "Number", 0); fsx_event("NAV_LIGHTS_OFF") end
)

-- ANTI-COLLISION (Swanticoll)
hw_button_add(PIN_ANTICOLL,
    function() print("BTN: ANTI-COLL ON"); STATE.anticoll = true; fsx_variable_write("L:Swanticoll", "Number", 1); fsx_event("BEACON_LIGHTS_ON") end,
    function() print("BTN: ANTI-COLL OFF"); STATE.anticoll = false; fsx_variable_write("L:Swanticoll", "Number", 0); fsx_event("BEACON_LIGHTS_OFF") end
)

-- WIPERS
hw_button_add(PIN_WIPER_PI,
    function() print("BTN: PILOT WIPER ON"); STATE.wiper_pi = true; fsx_variable_write("L:Swpiwiper", "Number", 1) end,
    function() print("BTN: PILOT WIPER OFF"); STATE.wiper_pi = false; fsx_variable_write("L:Swpiwiper", "Number", 0) end
)
hw_button_add(PIN_WIPER_CO,
    function() print("BTN: CO-PILOT WIPER ON"); STATE.wiper_co = true; fsx_variable_write("L:Swcowiper", "Number", 1) end,
    function() print("BTN: CO-PILOT WIPER OFF"); STATE.wiper_co = false; fsx_variable_write("L:Swcowiper", "Number", 0) end
)

-- HEATER/BLOWER/OUTLET
hw_button_add(PIN_HEATER,
    function() print("BTN: HEATER ON"); STATE.heater = true; fsx_variable_write("L:SwHeater", "Number", 1) end,
    function() print("BTN: HEATER OFF"); STATE.heater = false; fsx_variable_write("L:SwHeater", "Number", 0) end
)
hw_button_add(PIN_VENT_BLOWER,
    function() print("BTN: VENT BLOWER ON"); STATE.blower = true; fsx_variable_write("L:Swblower", "Number", 1) end,
    function() print("BTN: VENT BLOWER OFF"); STATE.blower = false; fsx_variable_write("L:Swblower", "Number", 0) end
)
hw_button_add(PIN_AFT_OUTLET,
    function() print("BTN: AFT OUTLET ON"); STATE.aft_outlet = true; fsx_variable_write("L:Swaftoutlet", "Number", 1) end,
    function() print("BTN: AFT OUTLET OFF"); STATE.aft_outlet = false; fsx_variable_write("L:Swaftoutlet", "Number", 0) end
)

-- DOME/UTILITY LIGHTS
hw_button_add(PIN_DOME_LIGHT,
    function() print("BTN: DOME LIGHT ON"); STATE.dome = 1; fsx_variable_write("L:Swutilitylight", "Number", 1) end, 
    function() print("BTN: DOME LIGHT OFF"); STATE.dome = 0; fsx_variable_write("L:Swutilitylight", "Number", 0) end
)
hw_button_add(PIN_UTILITY_LT,
    function() print("BTN: UTILITY LIGHT ON"); STATE.util = true; fsx_variable_write("L:Swutilitylight", "Number", 1) end,
    function() print("BTN: UTILITY LIGHT OFF"); STATE.util = false; fsx_variable_write("L:Swutilitylight", "Number", 0) end
)

-- MAP LIGHT DIMMER (Analog)
hw_adc_input_add(PIN_MAP_DIMMER, function(val)
    STATE.map_dim_val = val
    print(string.format("ADC: MAP DIMMER = %.2f", val))
    fsx_variable_write("L:platepilolight", "Number", val * 100) 
end)
hw_button_add(PIN_MAP_DIM_BTN, function() print("BTN: MAP DIM BUTTON PRESSED") end, function() end)

-- COMPASS SLAVE
hw_button_add(PIN_COMPASS_SLAVE,
    function() print("BTN: COMPASS SLAVE MAG"); fsx_variable_write("L:SwMagDg", "Number", 1) end,
    function() print("BTN: COMPASS SLAVE DG"); fsx_variable_write("L:SwMagDg", "Number", 0) end
)

-- =============================================================================
-- HARDWARE INPUTS: FIRE PROTECTION
-- =============================================================================

-- FIRE HANDLES
hw_button_add(PIN_FIRE_PULL1,
    function() print("BTN: FIRE PULL 1 (PULLED)"); STATE.fire1 = 1; fsx_variable_write("L:firethandl", "Number", 1); update_fire_leds() end,
    function() print("BTN: FIRE PULL 1 (RESET)"); STATE.fire1 = 0; fsx_variable_write("L:firethandl", "Number", 0); update_fire_leds() end
)
hw_button_add(PIN_FIRE_PULL2,
    function() print("BTN: FIRE PULL 2 (PULLED)"); STATE.fire2 = 1; fsx_variable_write("L:firethandr", "Number", 1); update_fire_leds() end,
    function() print("BTN: FIRE PULL 2 (RESET)"); STATE.fire2 = 0; fsx_variable_write("L:firethandr", "Number", 0); update_fire_leds() end
)

-- FIRE/BAG TEST
hw_button_add(PIN_FIRE_TEST,
    function() 
        print("BTN: FIRE TEST ON")
        STATE.fire_test = true
        fsx_variable_write("L:Swfiretest", "Number", 1)
        fsx_variable_write("L:firetestbag", "Number", 1)
        update_fire_leds() 
    end,
    function() 
        print("BTN: FIRE TEST OFF")
        STATE.fire_test = false
        fsx_variable_write("L:Swfiretest", "Number", 0)
        fsx_variable_write("L:firetestbag", "Number", 0)
        update_fire_leds() 
    end
)

-- =============================================================================
-- SIMULATOR SUBSCRIPTIONS
-- =============================================================================

-- Master DC Bus (Power Availability)
fsx_variable_subscribe("L:MasterDcBus", "Number", function(val)
    STATE.dc_bus = (val ~= 0) and 1 or 0
    update_fire_leds()
end)

-- Generator Status
fsx_variable_subscribe("L:CGenel", "Number", function(val) STATE.gen1_prod = (val ~= 0); update_elec_leds() end)
fsx_variable_subscribe("L:CGener", "Number", function(val) STATE.gen2_prod = (val ~= 0); update_elec_leds() end)

-- Fire Handle Feedback
fsx_variable_subscribe("L:firethandl", "Number", function(val) STATE.fire1 = (val ~= 0) and 1 or 0; update_fire_leds() end)
fsx_variable_subscribe("L:firethandr", "Number", function(val) STATE.fire2 = (val ~= 0) and 1 or 0; update_fire_leds() end)
fsx_variable_subscribe("L:firetestbag", "Number", function(val) STATE.bag_fire = (val ~= 0) and 1 or 0; update_fire_leds() end)

-- =============================================================================
-- INITIALIZATION
-- =============================================================================
fsx_variable_write("L:Swbatta", "Number", 0)
fsx_variable_write("L:Swbattb", "Number", 0)
fsx_variable_write("L:Genel", "Number", 0)
fsx_variable_write("L:Gener", "Number", 0)
fsx_variable_write("L:Swinva", "Number", 0)
fsx_variable_write("L:Swinvb", "Number", 0)
fsx_variable_write("L:Swnonbus", "Number", 0)
fsx_variable_write("L:Swemerload", "Number", 0)
fsx_variable_write("L:Swstbyatt", "Number", 0)
fsx_variable_write("L:Swpitot", "Number", 0)
fsx_variable_write("L:Swposition", "Number", 0)
fsx_variable_write("L:Swanticoll", "Number", 0)
fsx_variable_write("L:Swpiwiper", "Number", 0)
fsx_variable_write("L:Swcowiper", "Number", 0)
fsx_variable_write("L:SwHeater", "Number", 0)
fsx_variable_write("L:Swblower", "Number", 0)
fsx_variable_write("L:Swaftoutlet", "Number", 0)
fsx_variable_write("L:Swutilitylight", "Number", 0)
fsx_variable_write("L:platepilolight", "Number", 0)
fsx_variable_write("L:SwMagDg", "Number", 0)
fsx_variable_write("L:Swfiretest", "Number", 0)

update_elec_leds()
update_fire_leds()
