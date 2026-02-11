-- =============================================================================
-- BELL 412 - CAUTION PANEL LED TEST (ALL PINS ON)
-- Platform: Air Manager + Arduino Mega 2560
-- Hardware: Arduino Channel E (Caution Panel)
-- Purpose: Turn ON *EVERY* available pin on Channel E to find unconnected LEDs.
-- WARNING: EXCLUDES KNOWN INPUT PINS TO PREVENT SHORT CIRCUITS.
-- =============================================================================

print("=============================================================================")
print("         BELL 412 CAUTION PANEL - ALL PINS TEST")
print("         Turning ON every pin on Arduino Channel E")
print("         (Except known inputs: D4, D5, D22, D23, D24)")
print("=============================================================================")

-- =============================================================================
-- EXCLUDED PINS (INPUTS)
-- =============================================================================
-- These pins are wired as switches to Ground. Driving them HIGH as Outputs could cause damage if pressed.
local EXCLUDED_PINS = {
    ["D4"] = true,  -- Bright/Dim
    ["D5"] = true,  -- Bright/Dim
    ["D22"] = true, -- Test Switch
    ["D23"] = true, -- Test Button
    ["D24"] = true, -- Test Switch
}

-- =============================================================================
-- PIN GENERATION & ACTIVATION
-- =============================================================================
local led_handles = {}
local count = 0

-- Function to add a pin if not excluded
local function add_test_pin(pin_name, arduino_id)
    -- Check exclusion
    if EXCLUDED_PINS[pin_name] then
        print(string.format("  [SKIP] Pin %s is an INPUT (Excluded)", pin_name))
        return
    end

    -- Add as LED and turn ON
    led_handles[count] = hw_led_add(arduino_id, 1.0)
    print(string.format("  [ON]   Pin %s -> %s", pin_name, arduino_id))
    count = count + 1
end

-- 1. Digital Pins D2 - D53
print("\nScanning Digital Pins (D2 - D53)...")
for i = 2, 53 do
    local pin_name = "D" .. i
    local arduino_id = "ARDUINO_MEGA2560_E_" .. pin_name
    add_test_pin(pin_name, arduino_id)
end

-- 2. Analog Pins A0 - A15 (Digital 54-69)
print("\nScanning Analog Pins (A0 - A15)...")
for i = 0, 15 do
    local pin_name = "A" .. i
    local arduino_id = "ARDUINO_MEGA2560_E_" .. pin_name
    add_test_pin(pin_name, arduino_id)
end

print("=============================================================================")
print(string.format("         %d Pins Initialized and turned ON.", count))
print("=============================================================================")
