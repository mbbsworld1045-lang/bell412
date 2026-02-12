-- =============================================================================
-- BELL 412 - LED TEST SCRIPT
-- Platform: Air Manager + Arduino Mega 2560
-- Purpose: Test all LEDs one by one (10 seconds each)
-- Channels: A (Pedestal), B (Front), D (Overhead), E (Caution), F (Flight Dir)
-- =============================================================================

print("=============================================================================")
print("         BELL 412 LED TEST")
print("         Lighting each LED for 10 seconds")
print("=============================================================================")

local TEST_DURATION_MS = 10000

-- =============================================================================
-- ALL LEDs BY ARDUINO CHANNEL
-- =============================================================================

local ALL_LEDS = {
    -- =========================================================================
    -- ARDUINO A - PEDESTAL (pedestal.lua)
    -- =========================================================================
    { pin = "ARDUINO_MEGA2560_A_D2",  name = "SAS LED",              channel = "A", type = "led" },
    { pin = "ARDUINO_MEGA2560_A_D3",  name = "ATT LED",              channel = "A", type = "led" },
    { pin = "ARDUINO_MEGA2560_A_D4",  name = "AP2 LED",              channel = "A", type = "led" },
    { pin = "ARDUINO_MEGA2560_A_D5",  name = "AP1 LED",              channel = "A", type = "led" },
    { pin = "ARDUINO_MEGA2560_A_A1",  name = "TRIM LED",             channel = "A", type = "output" },
    { pin = "ARDUINO_MEGA2560_A_A2",  name = "TEST LED",             channel = "A", type = "output" },
    { pin = "ARDUINO_MEGA2560_A_A3",  name = "FD LED",               channel = "A", type = "output" },
    { pin = "ARDUINO_MEGA2560_A_A4",  name = "CPL LED",              channel = "A", type = "output" },
    
    -- =========================================================================
    -- ARDUINO B - FRONT PANEL (front_panel.lua)
    -- =========================================================================
    { pin = "ARDUINO_MEGA2560_B_D2",  name = "Bag Fire Test LED",    channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D3",  name = "BRG PTR Left LED",     channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D4",  name = "Engine 1 Warning LED", channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D5",  name = "Fire Handle 1 LED",    channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D9",  name = "Over Torque Right LED",channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D12", name = "Engine 2 Warning LED", channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D13", name = "BRG PTR Right LED",    channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D24", name = "Fire Handle 2 LED",    channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D26", name = "Marker Right White",   channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D27", name = "Marker Right Red",     channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D28", name = "Marker Right Blue",    channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D30", name = "Cyclic Center Right",  channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D31", name = "Master Caution Right", channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D39", name = "Over Torque Left LED", channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D42", name = "Cyclic Center Left",   channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D43", name = "Master Caution Left",  channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D46", name = "Marker Left White",    channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D47", name = "Marker Left Blue",     channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D48", name = "Marker Left Red",      channel = "B", type = "led" },
    
    -- =========================================================================
    -- ARDUINO D - OVERHEAD (over_head.lua)
    -- =========================================================================
    -- { pin = "ARDUINO_MEGA2560_D_D30", name = "GEN 1 FAIL LED (Disabled - Pin D30 used by CB)", channel = "D", type = "led" },
    { pin = "ARDUINO_MEGA2560_D_D31", name = "GEN 2 FAIL LED",       channel = "D", type = "led" },
    { pin = "ARDUINO_MEGA2560_D_D32", name = "INV 1 FAIL LED",       channel = "D", type = "led" },
    { pin = "ARDUINO_MEGA2560_D_D33", name = "INV 2 FAIL LED",       channel = "D", type = "led" },
    -- { pin = "ARDUINO_MEGA2560_D_D34", name = "BATT CAUT LED (Disabled - Pin D34 used by CB)", channel = "D", type = "led" },
    { pin = "ARDUINO_MEGA2560_D_D35", name = "FIRE ENG 1 LED",       channel = "D", type = "led" },
    -- { pin = "ARDUINO_MEGA2560_D_D36", name = "FIRE ENG 2 LED (Disabled - Pin D36 used by Blower)", channel = "D", type = "led" },
    -- { pin = "ARDUINO_MEGA2560_D_D37", name = "BAG FIRE LED (Disabled - Pin D37 used by Outlet)", channel = "D", type = "led" },

    -- =========================================================================
    -- ARDUINO E - CAUTION PANEL (caution_panel.lua)
    -- =========================================================================
    -- RJ1 Connector LEDs
    { pin = "ARDUINO_MEGA2560_E_D25", name = "01 ENG 1 OUT",         channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D26", name = "02 ENG 2 OUT",         channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D27", name = "03 ROTOR BRAKE",       channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D28", name = "04 XMSN OIL PRESS",    channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D29", name = "05 XMSN OIL TEMP",     channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D30", name = "06 C BOX OIL PRESS",   channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D31", name = "07 C BOX OIL TEMP",    channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D32", name = "08 BATT 1 HOT",        channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D33", name = "09 BATT 2 HOT",        channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D34", name = "10 ENG OIL PRESS 1",   channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D35", name = "11 ENG OIL PRESS 2",   channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D36", name = "12 ENG CHIP 1",        channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D37", name = "13 ENG CHIP 2",        channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D38", name = "14 FUEL FILTER 1",     channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D39", name = "15 FUEL FILTER 2",     channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D40", name = "16 FUEL BOOST 1",      channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D41", name = "17 FUEL BOOST 2",      channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D42", name = "18 FUEL TRANS 1",      channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D50", name = "19 FUEL TRANS 2",      channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D49", name = "20 FUEL VALVE 1",      channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D48", name = "21 FUEL VALVE 2",      channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D3",  name = "22 FUEL LOW",          channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D47", name = "23 FUEL INTCON",       channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D46", name = "24 FUEL XFEED",        channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D45", name = "25 GOV MANUAL 1",      channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D44", name = "26 GOV MANUAL 2",      channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D43", name = "27 PART SEP 1",        channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D6",  name = "28 PART SEP 2",        channel = "E", type = "led" },
    
    -- RJ2 Connector LEDs
    { pin = "ARDUINO_MEGA2560_E_D7",  name = "29 DC GEN 1",          channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D8",  name = "30 DC GEN 2",          channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_A15", name = "31 INVERTER 1",        channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_A14", name = "32 INVERTER 2",        channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_A13", name = "33 BATTERY",           channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_A12", name = "34 GEN OVHT 1",        channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_A11", name = "35 GEN OVHT 2",        channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_A10", name = "36 HYDRAULIC 1",       channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_A9",  name = "37 HYDRAULIC 2",       channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_A8",  name = "38 EXT POWER",         channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_A7",  name = "39 XMSN CHIP",         channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_A6",  name = "40 C BOX CHIP",        channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_A5",  name = "41 42/90 CHIP",        channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D51", name = "42 OVER TORQ",         channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D52", name = "43 RPM",               channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D53", name = "44 AFCS",              channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_A4",  name = "45 FT OFF",            channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_A3",  name = "46 CYC CTR",           channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_A2",  name = "47 DOOR LOCK",         channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_A1",  name = "48 HEATER AIR",        channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_A0",  name = "49 CAUTION PANEL",     channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D9",  name = "50 EMER FLOATS",       channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D10", name = "51 CARGO RELEASE",     channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D11", name = "52 BAG FIRE",          channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D12", name = "53 WSHLD HEAT",        channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D13", name = "54 20 FT CAUTION",     channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D2",  name = "55 NIGHTSUN",          channel = "E", type = "led" },
    { pin = "ARDUINO_MEGA2560_E_D14", name = "56 SPARE",             channel = "E", type = "led" },

    -- =========================================================================
    -- ARDUINO F - FLIGHT DIRECTOR (flight_director.lua)
    -- =========================================================================
    { pin = "ARDUINO_MEGA2560_F_A4",  name = "FD1 VS Light",         channel = "F", type = "led" },
    { pin = "ARDUINO_MEGA2560_F_A2",  name = "FD1 IAS Light",        channel = "F", type = "led" },
    { pin = "ARDUINO_MEGA2560_F_A3",  name = "FD1 ALT Light",        channel = "F", type = "led" },
    { pin = "ARDUINO_MEGA2560_F_A5",  name = "FD1 ILS Light 1",      channel = "F", type = "led" },
    { pin = "ARDUINO_MEGA2560_F_A6",  name = "FD1 ILS Light 2",      channel = "F", type = "led" },
    { pin = "ARDUINO_MEGA2560_F_A7",  name = "FD1 NAV Light 1",      channel = "F", type = "led" },
    { pin = "ARDUINO_MEGA2560_F_A8",  name = "FD1 NAV Light 2",      channel = "F", type = "led" },
    { pin = "ARDUINO_MEGA2560_F_A9",  name = "FD1 HDG Light",        channel = "F", type = "led" },
    { pin = "ARDUINO_MEGA2560_F_A10", name = "FD1 GA Light",         channel = "F", type = "led" },
    { pin = "ARDUINO_MEGA2560_F_A11", name = "FD1 VOR APR Light 1",  channel = "F", type = "led" },
    { pin = "ARDUINO_MEGA2560_F_A12", name = "FD1 VOR APR Light 2",  channel = "F", type = "led" },
    { pin = "ARDUINO_MEGA2560_F_A13", name = "FD1 BC Light 1",       channel = "F", type = "led" },
    { pin = "ARDUINO_MEGA2560_F_A14", name = "FD1 BC Light 2",       channel = "F", type = "led" },
    { pin = "ARDUINO_MEGA2560_F_A15", name = "FD1 SBY Light",        channel = "F", type = "led" },
}

-- =============================================================================
-- STORAGE
-- =============================================================================
local led_handles = {}
local output_handles = {}
local test_index = 0
local current_timer = nil

local function get_pin_number(pin_str)
    return pin_str:match("_([DA]%d+)$") or pin_str
end

-- =============================================================================
-- INITIALIZE ALL LEDs
-- =============================================================================
print("\nInitializing LEDs...")
for _, led in ipairs(ALL_LEDS) do
    if led.type == "output" then
        output_handles[led.pin] = hw_output_add(led.pin, false)
    else
        led_handles[led.pin] = hw_led_add(led.pin, 0.0)
    end
end
print(string.format("Initialized %d LEDs", #ALL_LEDS))

-- =============================================================================
-- TEST FUNCTIONS
-- =============================================================================
local run_next_led

local function test_led(led_info, callback)
    local pin_num = get_pin_number(led_info.pin)
    
    print("\n=============================================================================")
    print(string.format("LED TEST %d/%d", test_index, #ALL_LEDS))
    print(string.format("  Name:    %s", led_info.name))
    print(string.format("  Channel: Arduino %s", led_info.channel))
    print(string.format("  Pin:     %s", pin_num))
    print("  Status:  ON for 10 seconds...")
    print("=============================================================================")
    
    if led_info.type == "output" then
        hw_output_set(output_handles[led_info.pin], true)
    else
        hw_led_set(led_handles[led_info.pin], 1.0)
    end
    
    current_timer = timer_start(TEST_DURATION_MS, nil, function()
        if led_info.type == "output" then
            hw_output_set(output_handles[led_info.pin], false)
        else
            hw_led_set(led_handles[led_info.pin], 0.0)
        end
        print(string.format("  %s -> OFF", led_info.name))
        callback()
    end)
end

run_next_led = function()
    test_index = test_index + 1
    
    if test_index > #ALL_LEDS then
        print("\n=============================================================================")
        print("         ALL LED TESTS COMPLETE!")
        print(string.format("         Tested %d LEDs", #ALL_LEDS))
        print("=============================================================================")
        return
    end
    
    test_led(ALL_LEDS[test_index], run_next_led)
end

-- =============================================================================
-- START TESTS
-- =============================================================================
print("\n>>> LED tests starting in 3 seconds...")
timer_start(3000, nil, function()
    test_index = 0
    run_next_led()
end)

print("\nLED Test Script Loaded")
print("Channels: A (Pedestal), B (Front), D (Overhead), E (Caution), F (Flight Dir)")
