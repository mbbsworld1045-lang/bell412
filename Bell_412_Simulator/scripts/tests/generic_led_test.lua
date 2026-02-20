-- Generic LED Test Script for Bell 412 Simulator
-- Sets all Digital Pins (D2-D53) and Analog Pins (A0-A15 as Digital)
-- on Channels A, B, C, D, E, F to HIGH (ON).

print("Starting Generic LED Tester (All ON)...")

-- List of channels to test
local channels = {"A", "B", "C", "D", "E", "F"}

-- Helper function to add an LED/Output
function add_scan_led(channel, piner)
    local pin_name = "ARDUINO_MEGA2560_" .. channel .. "_" .. piner
    
    -- We use hw_output_add for universality (works for PWM pins too if used as digital on/off)
    -- Initialize to TRUE (ON)
    hw_output_add(pin_name, true)
end

-- Iterate through channels and pins
for _, channel in ipairs(channels) do
    -- Digital Pins D2 to D53
    for i = 2, 53 do
        local pin = "D" .. i
        add_scan_led(channel, pin)
    end

    -- Analog Pins A0 to A15 (used as Digital Outputs)
    for i = 0, 15 do
        local pin = "A" .. i
        add_scan_led(channel, pin)
    end
end

print("All Pins initialized to ON. Check your panels.")
