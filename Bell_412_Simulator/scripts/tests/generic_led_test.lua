-- =============================================================================
-- BELL 412 - GENERIC LED TEST (ALL LEDS ON)
-- Platform: Air Manager + Arduino Mega 2560
-- Purpose: Turn ON *EVERY* pin (Digital 0-53, Analog A0-A15) on a selected Arduino
--          channel, treating them as LEDs.
-- WARNING: Ensure pins are connected to LEDs (via resistors) and NOT INPUTS!
-- =============================================================================

-- CONFIGURATION: Set the Arduino Channel you want to test (A, B, C, D, E, F, etc.)
local CHANNEL = "F" 

-- =============================================================================
-- LOGIC
-- =============================================================================
print("=============================================================================")
print(string.format("         GENERIC LED TEST - CHANNEL %s", CHANNEL))
print("         Setting all pins (0-69) to LED ON (1.0)")
print("=============================================================================")

local led_count = 0

-- Function to add and light an LED
local function enable_led_pin(pin_name, arduino_id)
    -- hw_led_add(id, initial_value) -> initial_value 1.0 = Max Brightness
    hw_led_add(arduino_id, 1.0)
    print(string.format("  [ON]   Pin %s -> %s", pin_name, arduino_id))
    led_count = led_count + 1
end

-- 1. Digital Pins D0 - D53
-- Note: D0/D1 are Serial RX/TX. If you use USB serial, this might interfere.
-- However, for a pure hardware test, we include them if requested "all pins".
print("\nScanning Digital Pins (D0 - D53)...")
for i = 0, 53 do
    local pin_name = "D" .. i
    local arduino_id = "ARDUINO_MEGA2560_" .. CHANNEL .. "_" .. pin_name
    enable_led_pin(pin_name, arduino_id)
end

-- 2. Analog Pins A0 - A15 (Digital 54-69)
print("\nScanning Analog Pins (A0 - A15)...")
for i = 0, 15 do
    local pin_name = "A" .. i
    local arduino_id = "ARDUINO_MEGA2560_" .. CHANNEL .. "_" .. pin_name
    enable_led_pin(pin_name, arduino_id)
end

print("=============================================================================")
print(string.format("         %d LEDs turned ON on Channel %s.", led_count, CHANNEL))
print("=============================================================================")
