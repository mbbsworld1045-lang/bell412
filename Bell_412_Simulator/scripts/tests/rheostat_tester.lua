-- =============================================================================
-- RHEOSTAT/POTENTIOMETER TESTER
-- Purpose: Read raw analog values to find the exact Min/Max limits.
-- Platform: Air Manager
-- =============================================================================

-- Change these to the actual Arduino pins your rheostats are attached to.
-- Example: "ARDUINO_MEGA2560_C_A2"
local PIN_RHEO_1 = "ARDUINO_MEGA2560_A_A0"
local PIN_RHEO_2 = "ARDUINO_MEGA2560_A_A1"

-- =============================================================================

print("=== Rheostat Tester Started ===")
print("Watching Pins: " .. PIN_RHEO_1 .. " and " .. PIN_RHEO_2)

-- We use a small deadband to prevent the console from being flooded by minor electrical noise
local last_val1 = -999.0
local last_val2 = -999.0
local DEADBAND = 0.005 -- Only prints if the value changes by more than 0.5%

-- Rheostat 1
hw_adc_input_add(PIN_RHEO_1, function(val)
    if math.abs(val - last_val1) >= DEADBAND then
        last_val1 = val
        print(string.format("Rheostat 1 [%s]: Raw = %.3f  (%.1f%%)", PIN_RHEO_1, val, val * 100))
    end
end)

-- Rheostat 2
hw_adc_input_add(PIN_RHEO_2, function(val)
    if math.abs(val - last_val2) >= DEADBAND then
        last_val2 = val
        print(string.format("Rheostat 2 [%s]: Raw = %.3f  (%.1f%%)", PIN_RHEO_2, val, val * 100))
    end
end)

print("Move your rheostats now. Check the console for min/max values.")
