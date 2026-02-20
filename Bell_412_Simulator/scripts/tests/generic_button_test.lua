-- Generic Button Test Script for Bell 412 Simulator
-- Scans all Digital Pins (D2-D53) and Analog Pins (A0-A15 as Digital)
-- on Channels A, B, C, D, E, F to identify pressed buttons.

print("Starting Generic Button Scanner...")

-- List of channels to scan
local channels = {"A", "B", "C", "D", "E", "F"}

-- Helper function to add a button callback
function add_scan_button(channel, piner)
    local pin_name = "ARDUINO_MEGA2560_" .. channel .. "_" .. piner
    -- We wrap in pcall in case the pin is invalid or already used by something else (though in a test script it should be fine)
    -- However, Air Manager might complain if a pin doesn't exist on a board type, but Mega 2560 is standard.
    
    -- Check if pin is valid for our standard list?
    -- We'll just try to add it.
    
    hw_button_add(pin_name, function()
        print("BUTTON PRESSED: " .. pin_name)
    end, function()
        print("BUTTON RELEASED: " .. pin_name)
    end)
end

-- Iterate through channels and pins
for _, channel in ipairs(channels) do
    -- Digital Pins D2 to D53
    for i = 2, 53 do
        local pin = "D" .. i
        add_scan_button(channel, pin)
    end

    -- Analog Pins A0 to A15 (used as Digital Inputs)
    for i = 0, 15 do
        local pin = "A" .. i
        add_scan_button(channel, pin)
    end
end

print("Scanner Ready. Press any button to identify its pin.")
