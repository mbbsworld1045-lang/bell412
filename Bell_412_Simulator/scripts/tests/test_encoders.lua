-- =============================================================================
-- UNIVERSAL ENCODER & BUTTON PIN FINDER
-- Description: Scans a list of target pins and prints to the console
-- whenever activity (a pulse or press) is detected.
-- =============================================================================

-- 1. CONFIGURE YOUR BOARD AND CHANNEL
-- Change the letter 'G' if your Arduino is assigned to a different channel in Air Manager.
local hardware_prefix = "ARDUINO_MEGA2560_G_"

-- 2. DEFINE THE PINS TO SCAN
-- Add every pin on the board you want to monitor. 
-- You can mix Digital (D) and Analog (A) pins.
local scan_list = {
    "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "D10", "D11", "D12", "D13",
    "D14", "D15", "D16", "D17", "D18", "D19", "D20", "D21", "D22", "D23", "D24",
    "A0", "A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8", "A9", "A10", "A11"
    -- Add more as needed!
}

print("=== Universal Pin Finder Initialized ===")
print("Scanning " .. #scan_list .. " pins on channel: " .. hardware_prefix)

-- 3. ATTACH LISTENERS TO ALL PINS
for i = 1, #scan_list do
    local test_pin = scan_list[i]
    local full_hw_id = hardware_prefix .. test_pin
    
    -- We use a button listener because encoder detents act like rapid, momentary button presses.
    hw_button_add(full_hw_id, function()
        print(">>> SIGNAL DETECTED ON PIN: " .. test_pin)
    end)
end

print("Ready. Turn an encoder or press a button to see its pin mapping.")