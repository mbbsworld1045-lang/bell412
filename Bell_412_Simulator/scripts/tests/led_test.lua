-- =============================================================================
-- BELL 412 - LED TEST SCRIPT
-- Platform: Air Manager + Arduino Mega 2560
-- Purpose: Test all LEDs one by one (10 seconds each)
-- =============================================================================

print("=============================================================================")
print("         BELL 412 LED TEST")
print("         Lighting each LED for 10 seconds")
print("=============================================================================")

-- Test duration
local TEST_DURATION_MS = 10000

-- =============================================================================
-- ALL LEDs BY ARDUINO CHANNEL
-- =============================================================================

local ALL_LEDS = {
    -- ARDUINO A - PEDESTAL (Digital LEDs)
    { pin = "ARDUINO_MEGA2560_A_D2",  name = "SAS LED",           channel = "A", type = "led" },
    { pin = "ARDUINO_MEGA2560_A_D3",  name = "ATT LED",           channel = "A", type = "led" },
    { pin = "ARDUINO_MEGA2560_A_D4",  name = "AP2 LED",           channel = "A", type = "led" },
    { pin = "ARDUINO_MEGA2560_A_D5",  name = "AP1 LED",           channel = "A", type = "led" },
    -- ARDUINO A - PEDESTAL (Analog as Output)
    { pin = "ARDUINO_MEGA2560_A_A1",  name = "TRIM LED",          channel = "A", type = "output" },
    { pin = "ARDUINO_MEGA2560_A_A2",  name = "TEST LED",          channel = "A", type = "output" },
    { pin = "ARDUINO_MEGA2560_A_A3",  name = "FD LED",            channel = "A", type = "output" },
    { pin = "ARDUINO_MEGA2560_A_A4",  name = "CPL LED",           channel = "A", type = "output" },
    
    -- ARDUINO B - FRONT PANEL
    { pin = "ARDUINO_MEGA2560_B_D2",  name = "Bag Fire Test LED",     channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D3",  name = "BRG PTR Left LED",      channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D4",  name = "Engine 1 Warning LED",  channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D5",  name = "Fire Handle 1 LED",     channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D9",  name = "Over Torque Right LED", channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D12", name = "Engine 2 Warning LED",  channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D13", name = "BRG PTR Right LED",     channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D23", name = "RPM Left LED",          channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D24", name = "Fire Handle 2 LED",     channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D26", name = "Marker Right White",     channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D27", name = "Marker Right Red",       channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D28", name = "Marker Right Blue",     channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D30", name = "Cyclic Center Right LED", channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D31", name = "Master Caution Right LED", channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D39", name = "Over Torque Left LED",  channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D42", name = "Cyclic Center Left LED", channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D43", name = "Master Caution Left LED", channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D46", name = "Marker Left White",     channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D47", name = "Marker Left Blue",      channel = "B", type = "led" },
    { pin = "ARDUINO_MEGA2560_B_D48", name = "Marker Left Red",       channel = "B", type = "led" },
    
    -- ARDUINO C - CAUTION PANEL
    { pin = "ARDUINO_MEGA2560_C_D2",  name = "55 NIGHTSUN",          channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D3",  name = "22 FUEL LOW",          channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D6",  name = "28 PART SEP 2",        channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D7",  name = "29 DC GEN 1",          channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D8",  name = "30 DC GEN 2",          channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D9",  name = "50 EMER FLOATS",       channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D10", name = "51 CARGO RELEASE",     channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D11", name = "52 BAG FIRE",          channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D12", name = "53 WSHLD HEAT",        channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D13", name = "54 20 FT CAUTION",     channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D14", name = "56 SPARE",             channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D25", name = "01 ENG 1 OUT",         channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D26", name = "02 ENG 2 OUT",         channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D27", name = "03 ROTOR BRAKE",       channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D28", name = "04 XMSN OIL PRESS",    channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D29", name = "05 XMSN OIL TEMP",     channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D30", name = "06 C BOX OIL PRESS",   channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D31", name = "07 C BOX OIL TEMP",    channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D32", name = "08 BATT 1 HOT",        channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D33", name = "09 BATT 2 HOT",        channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D34", name = "10 ENG OIL PRESS 1",   channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D35", name = "11 ENG OIL PRESS 2",   channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D36", name = "12 ENG CHIP 1",        channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D37", name = "13 ENG CHIP 2",        channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D38", name = "14 FUEL FILTER 1",     channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D39", name = "15 FUEL FILTER 2",     channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D40", name = "16 FUEL BOOST 1",      channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D41", name = "17 FUEL BOOST 2",      channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D42", name = "18 FUEL TRANS 1",      channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D43", name = "27 PART SEP 1",        channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D44", name = "26 GOV MANUAL 2",      channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D45", name = "25 GOV MANUAL 1",      channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D46", name = "24 FUEL XFEED",        channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D47", name = "23 FUEL INTCON",       channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D48", name = "21 FUEL VALVE 2",      channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D49", name = "20 FUEL VALVE 1",      channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D50", name = "19 FUEL TRANS 2",      channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D51", name = "42 OVER TORQ",         channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D52", name = "43 RPM",               channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_D53", name = "44 AFCS",              channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_A0",  name = "49 CAUTION PANEL",     channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_A1",  name = "48 HEATER AIR",        channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_A2",  name = "47 DOOR LOCK",         channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_A3",  name = "46 CYC CTR",           channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_A4",  name = "45 FT OFF",            channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_A5",  name = "41 42/90 CHIP",        channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_A6",  name = "40 C BOX CHIP",        channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_A7",  name = "39 XMSN CHIP",         channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_A8",  name = "38 EXT POWER",         channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_A9",  name = "37 HYDRAULIC 2",       channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_A10", name = "36 HYDRAULIC 1",       channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_A11", name = "35 GEN OVHT 2",        channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_A12", name = "34 GEN OVHT 1",        channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_A13", name = "33 BATTERY",           channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_A14", name = "32 INVERTER 2",        channel = "C", type = "led" },
    { pin = "ARDUINO_MEGA2560_C_A15", name = "31 INVERTER 1",        channel = "C", type = "led" },
}

-- =============================================================================
-- STORAGE
-- =============================================================================
local led_handles = {}
local output_handles = {}
local test_index = 0
local current_timer = nil

-- Extract pin number from pin string (e.g., "ARDUINO_MEGA2560_A_D2" -> "D2")
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
    
    -- Turn ON
    if led_info.type == "output" then
        hw_output_set(output_handles[led_info.pin], true)
    else
        hw_led_set(led_handles[led_info.pin], 1.0)
    end
    
    -- Turn OFF after 10 seconds
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
