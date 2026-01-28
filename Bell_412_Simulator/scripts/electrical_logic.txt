-- =============================================================================
-- BELL 412 - ELECTRICAL SYSTEM LOGIC
-- Platform: Air Manager + Arduino Mega 2560
-- Hardware: Arduino Channel A (Overhead Panel)
-- Logic: Buttons Only (Active Low)
-- =============================================================================

-- =============================================================================
-- 1. HARDWARE CONFIGURATION HEADER
-- =============================================================================
-- INPUTS (Switches converted to Buttons)
local PIN_BATT1_SW      = "ARDUINO_MEGA2560_A_D2"
local PIN_BATT2_SW      = "ARDUINO_MEGA2560_A_D3"
local PIN_GEN1_SW       = "ARDUINO_MEGA2560_A_D4"
local PIN_GEN2_SW       = "ARDUINO_MEGA2560_A_D5"
local PIN_INV1_SW       = "ARDUINO_MEGA2560_A_D6"
local PIN_INV2_SW       = "ARDUINO_MEGA2560_A_D7"
local PIN_NONESNTL_SW   = "ARDUINO_MEGA2560_A_D8"
local PIN_EMERGLOAD_SW  = "ARDUINO_MEGA2560_A_D9"
local PIN_STBYATT_SW    = "ARDUINO_MEGA2560_A_D10"

-- OUTPUTS (LEDs)
local PIN_GEN1_FAIL_LED = "ARDUINO_MEGA2560_A_D30"
local PIN_GEN2_FAIL_LED = "ARDUINO_MEGA2560_A_D31"
local PIN_INV1_FAIL_LED = "ARDUINO_MEGA2560_A_D32"
local PIN_INV2_FAIL_LED = "ARDUINO_MEGA2560_A_D33"
local PIN_BATT_CAUT_LED = "ARDUINO_MEGA2560_A_D34"

-- =============================================================================
-- 2. INITIALIZE HARDWARE LEDS
-- =============================================================================
local led_gen1_h = hw_led_add(PIN_GEN1_FAIL_LED, 0.0)
local led_gen2_h = hw_led_add(PIN_GEN2_FAIL_LED, 0.0)
local led_inv1_h = hw_led_add(PIN_INV1_FAIL_LED, 0.0)
local led_inv2_h = hw_led_add(PIN_INV2_FAIL_LED, 0.0)
local led_batt_h = hw_led_add(PIN_BATT_CAUT_LED, 0.0)

-- =============================================================================
-- 3. INTERNAL VARIABLES & CONSTANTS
-- =============================================================================
-- Logic Constants
local V_GEN  = 28.0
local V_BATT = 24.0
local V_LOAD = 18.0 -- Voltage drop during cranking

-- Local State Tracking (Matches Switch Positions)
local sw_batt1 = 0
local sw_batt2 = 0
local sw_gen1  = 0
local sw_gen2  = 0
local sw_inv1  = 0
local sw_inv2  = 0

-- Sim Feedback Variables
local gen1_producing = 0
local gen2_producing = 0
local ext_power_on   = 0
local is_starting    = 0

-- =============================================================================
-- 4. SYSTEM LOGIC FUNCTIONS
-- =============================================================================

-- HELPER: Update LED states based on calculated logic
local function update_led_states()
    -- Gen Fails: ON if switch is ON but Gen is NOT producing (or switch is OFF)
    -- Simplified: In real 412, Light ON if Bus Voltage < Limit or Gen Offline
    hw_led_set(led_gen1_h, (gen1_producing == 0) and 1.0 or 0.0)
    hw_led_set(led_gen2_h, (gen2_producing == 0) and 1.0 or 0.0)

    -- Inv Fails: ON if Switch is OFF
    hw_led_set(led_inv1_h, (sw_inv1 == 0) and 1.0 or 0.0)
    hw_led_set(led_inv2_h, (sw_inv2 == 0) and 1.0 or 0.0)

    -- Battery Caution: ON if Batts ON but No Generators/GPU
    local power_sources = (gen1_producing == 1) or (gen2_producing == 1) or (ext_power_on == 1)
    local batts_on = (sw_batt1 == 1) or (sw_batt2 == 1)
    
    if batts_on and not power_sources then
        hw_led_set(led_batt_h, 1.0)
    else
        hw_led_set(led_batt_h, 0.0)
    end
end

-- CORE LOGIC: Calculate Bus Voltage and Master State
local function update_electrical_logic()
    local bus_volts = 0.0
    local dc_master = 0
    local gen_master = 0

    -- 1. Determine Power Source Hierarchy (GPU > GEN > BATT)
    if ext_power_on == 1 then
        bus_volts = V_GEN
        dc_master = 1
        gen_master = 1
    elseif (gen1_producing == 1) or (gen2_producing == 1) then
        bus_volts = V_GEN
        dc_master = 1
        gen_master = 1
    elseif (sw_batt1 == 1) or (sw_batt2 == 1) then
        dc_master = 1
        -- Voltage drop physics
        if is_starting == 1 then
            bus_volts = V_LOAD
        else
            bus_volts = V_BATT
        end
    else
        -- Dead Ship
        bus_volts = 0.0
        dc_master = 0
        gen_master = 0
    end

    -- 2. Write Results to Simulator
    fsx_variable_write("L:MasterDcBus", "Number", dc_master)
    fsx_variable_write("L:Genmast", "Number", gen_master)
    fsx_variable_write("L:VoltDC_Essential", "Volts", bus_volts)
    fsx_variable_write("L:VoltDC_NonEssential", "Volts", bus_volts)

    -- 3. Update Hardware LEDs
    update_led_states()
end

-- =============================================================================
-- 5. HARDWARE INPUTS (BUTTONS)
-- =============================================================================

-- BATTERY 1
hw_button_add(PIN_BATT1_SW,
    function() -- PRESSED (ON)
        print("ACTION: Battery 1 ON")
        sw_batt1 = 1
        fsx_variable_write("L:Swbatta", "Number", 1)
        update_electrical_logic()
    end,
    function() -- RELEASED (OFF)
        print("ACTION: Battery 1 OFF")
        sw_batt1 = 0
        fsx_variable_write("L:Swbatta", "Number", 0)
        update_electrical_logic()
    end
)

-- BATTERY 2
hw_button_add(PIN_BATT2_SW,
    function() -- PRESSED (ON)
        print("ACTION: Battery 2 ON")
        sw_batt2 = 1
        fsx_variable_write("L:Swbattb", "Number", 1)
        update_electrical_logic()
    end,
    function() -- RELEASED (OFF)
        print("ACTION: Battery 2 OFF")
        sw_batt2 = 0
        fsx_variable_write("L:Swbattb", "Number", 0)
        update_electrical_logic()
    end
)

-- GENERATOR 1
hw_button_add(PIN_GEN1_SW,
    function() -- PRESSED (ON)
        print("ACTION: Gen 1 ON")
        sw_gen1 = 1
        fsx_variable_write("L:Genel", "Number", 1)
        fsx_event("TOGGLE_ALTERNATOR1") -- Send event to Sim
        update_electrical_logic()
    end,
    function() -- RELEASED (OFF)
        print("ACTION: Gen 1 OFF")
        sw_gen1 = 0
        fsx_variable_write("L:Genel", "Number", 0)
        fsx_event("TOGGLE_ALTERNATOR1")
        update_electrical_logic()
    end
)

-- GENERATOR 2
hw_button_add(PIN_GEN2_SW,
    function() -- PRESSED (ON)
        print("ACTION: Gen 2 ON")
        sw_gen2 = 1
        fsx_variable_write("L:Gener", "Number", 1)
        fsx_event("TOGGLE_ALTERNATOR2")
        update_electrical_logic()
    end,
    function() -- RELEASED (OFF)
        print("ACTION: Gen 2 OFF")
        sw_gen2 = 0
        fsx_variable_write("L:Gener", "Number", 0)
        fsx_event("TOGGLE_ALTERNATOR2")
        update_electrical_logic()
    end
)

-- INVERTER 1
hw_button_add(PIN_INV1_SW,
    function() -- PRESSED (ON)
        print("ACTION: Inv 1 ON")
        sw_inv1 = 1
        fsx_variable_write("L:Swinva", "Number", 1)
        -- AC Logic: If either Inv is on, AC bus is powered
        local ac_state = (sw_inv1 == 1 or sw_inv2 == 1) and 1 or 0
        fsx_variable_write("L:ACBus", "Number", ac_state)
        update_led_states()
    end,
    function() -- RELEASED (OFF)
        print("ACTION: Inv 1 OFF")
        sw_inv1 = 0
        fsx_variable_write("L:Swinva", "Number", 0)
        local ac_state = (sw_inv1 == 1 or sw_inv2 == 1) and 1 or 0
        fsx_variable_write("L:ACBus", "Number", ac_state)
        update_led_states()
    end
)

-- INVERTER 2
hw_button_add(PIN_INV2_SW,
    function() -- PRESSED (ON)
        print("ACTION: Inv 2 ON")
        sw_inv2 = 1
        fsx_variable_write("L:Swinvb", "Number", 1)
        local ac_state = (sw_inv1 == 1 or sw_inv2 == 1) and 1 or 0
        fsx_variable_write("L:ACBus", "Number", ac_state)
        update_led_states()
    end,
    function() -- RELEASED (OFF)
        print("ACTION: Inv 2 OFF")
        sw_inv2 = 0
        fsx_variable_write("L:Swinvb", "Number", 0)
        local ac_state = (sw_inv1 == 1 or sw_inv2 == 1) and 1 or 0
        fsx_variable_write("L:ACBus", "Number", ac_state)
        update_led_states()
    end
)

-- NON-ESSENTIAL BUS
hw_button_add(PIN_NONESNTL_SW,
    function() -- PRESSED (ON)
        print("ACTION: Non-Ess Bus ON")
        fsx_variable_write("L:Swnonbus", "Number", 1)
        fsx_variable_write("L:SwNonEsntl", "Number", 1)
    end,
    function() -- RELEASED (OFF)
        print("ACTION: Non-Ess Bus OFF")
        fsx_variable_write("L:Swnonbus", "Number", 0)
        fsx_variable_write("L:SwNonEsntl", "Number", 0)
    end
)

-- EMERGENCY LOAD
hw_button_add(PIN_EMERGLOAD_SW,
    function() -- PRESSED (ON)
        print("ACTION: Emer Load ON")
        fsx_variable_write("L:Swemerload", "Number", 1)
    end,
    function() -- RELEASED (OFF)
        print("ACTION: Emer Load OFF")
        fsx_variable_write("L:Swemerload", "Number", 0)
    end
)

-- STANDBY ATTITUDE POWER
hw_button_add(PIN_STBYATT_SW,
    function() -- PRESSED (ON/TEST)
        print("ACTION: Stby Att ON")
        fsx_variable_write("L:stbatt", "Number", 1)
    end,
    function() -- RELEASED (OFF)
        print("ACTION: Stby Att OFF")
        fsx_variable_write("L:stbatt", "Number", 0)
    end
)

-- =============================================================================
-- 6. SIMULATOR SUBSCRIPTIONS (Data In -> LED Out)
-- =============================================================================

-- Listen for Generator Output status (Requires Engine Run + Switch ON)
fsx_variable_subscribe("L:CGenel", "Number", "L:CGener", "Number", function(g1, g2)
    -- Convert Sim value to 0/1 boolean
    gen1_producing = (g1 ~= 0) and 1 or 0
    gen2_producing = (g2 ~= 0) and 1 or 0
    update_electrical_logic()
end)

-- Listen for External Power (GPU)
fsx_variable_subscribe("L:ExternalPower", "Number", function(val)
    ext_power_on = (val ~= 0) and 1 or 0
    update_electrical_logic()
end)

-- Listen for Start Cycle (To dim lights/voltage)
fsx_variable_subscribe("L:StartSwitch", "Number", function(val)
    is_starting = (val ~= 0) and 1 or 0
    update_electrical_logic()
end)

-- =============================================================================
-- 7. STARTUP INITIALIZATION
-- =============================================================================
-- Run logic once at start to set LEDs correctly
update_electrical_logic()