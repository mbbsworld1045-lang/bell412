-- =============================================================================
-- BELL 412 - ALL PINS HIGH TEST
-- Platform: Air Manager + Arduino Mega 2560
-- Purpose: Set ALL pins (0-69 / D0-A15) to HIGH (3.3V/5V) on a selected Channel.
-- WARNING: ENSURE NO SWITCHES ARE CONNECTED TO GROUND BEFORE RUNNING!
--          DRIVING A PIN HIGH WHILE GROUNDED WILL CAUSE A SHORT CIRCUIT!
-- =============================================================================

-- CONFIGURATION
local CHANNEL = "E" -- Change this to A, B, C, D, or E as needed

-- =============================================================================
-- LOGIC
-- =============================================================================
print("=============================================================================")
print(string.format("         BELL 412 ALL PINS HIGH TEST - CHANNEL %s", CHANNEL))
print("         WARNING: Driving ALL pins HIGH.")
print("         Ensure no switches are closed to Ground!")
print("=============================================================================")

local pin_count = 0

-- Function to set a pin HIGH
local function set_pin_high(pin_name, arduino_id)
    -- We use hw_output_add and set to true (High)
    -- Note: This overrides any existing input/output setting for this script run.
    hw_output_add(arduino_id, true)
    -- hw_output_set is redundant if we initialize to true, but good practice.
    -- hw_output_set(output_id, true) 
    print(string.format("  [HIGH] Pin %s -> %s", pin_name, arduino_id))
    pin_count = pin_count + 1
end

-- 1. Digital Pins D0 - D53 (Covering the full range)
print("\nSetting Digital Pins D0 - D53 HIGH...")
for i = 0, 53 do
    local pin_name = "D" .. i
    local arduino_id = "ARDUINO_MEGA2560_" .. CHANNEL .. "_" .. pin_name
    set_pin_high(pin_name, arduino_id)
end

-- 2. Analog Pins A0 - A15 (Can be used as Digital Output D54-D69)
print("\nSetting Analog Pins A0 - A15 HIGH...")
for i = 0, 15 do
    local pin_name = "A" .. i
    local arduino_id = "ARDUINO_MEGA2560_" .. CHANNEL .. "_" .. pin_name
    set_pin_high(pin_name, arduino_id)
end

print("=============================================================================")
print(string.format("         %d Pins set to HIGH on Channel %s.", pin_count, CHANNEL))
print("=============================================================================")
