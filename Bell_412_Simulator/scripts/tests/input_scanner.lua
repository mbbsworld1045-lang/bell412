-- =============================================================================
-- BELL 412 - INPUT SCANNER (PIN FINDER)
-- Platform: Air Manager + Arduino Mega 2560
-- Purpose: Monitor ALL pins on a selected Channel to find connected buttons/switches.
-- Usage:   Run this script, then flip a switch or press a button. 
--          The console will show which Pin ID was triggered.
-- =============================================================================

-- CONFIGURATION
local CHANNEL = "E" -- Change this to A, B, C, D, or E to scan that board

-- =============================================================================
-- LOGIC
-- =============================================================================
print("=============================================================================")
print(string.format("         BELL 412 INPUT SCANNER - CHANNEL %s", CHANNEL))
print("         Monitoring all pins (0-53, A0-A15) for activity...")
print("         Toggle any switch/button to see its Pin ID.")
print("=============================================================================")

local pin_count = 0

-- Callback for switch change
local function switch_callback(pin_name, arduino_id, state)
    -- State: true = Pressed (Grounded), false = Released (Open)
    -- Note: This depends on wiring (pull-up vs pull-down). 
    -- Assuming standard Air Manager "switch" (input_pullup):
    -- Grounded = Pressed (true/1), Open = Released (false/0)
    
    local state_str = state and "PRESSED (Grounded)" or "RELEASED (Open)"
    print(string.format(">>> INPUT DETECTED: %s (%s) -> %s", pin_name, arduino_id, state_str))
end

-- Function to add a pin listener
local function add_pin_listener(pin_name, arduino_id)
    -- We use hw_switch_add which automatically handles deboucing and logic
    hw_switch_add(arduino_id, function(state)
        switch_callback(pin_name, arduino_id, state)
    end)
    pin_count = pin_count + 1
end

-- 1. Digital Pins D2 - D53 (Pins 0/1 usually Serial, skipped to avoid interference)
-- If you need 0/1, change loop start to 0.
print("\nScanning Digital Pins D2 - D53...")
for i = 2, 53 do
    local pin_name = "D" .. i
    local arduino_id = "ARDUINO_MEGA2560_" .. CHANNEL .. "_" .. pin_name
    add_pin_listener(pin_name, arduino_id)
end

-- 2. Analog Pins A0 - A15
print("Scanning Analog Pins A0 - A15...")
for i = 0, 15 do
    local pin_name = "A" .. i
    local arduino_id = "ARDUINO_MEGA2560_" .. CHANNEL .. "_" .. pin_name
    add_pin_listener(pin_name, arduino_id)
end

print("=============================================================================")
print(string.format("         %d Pins are now being monitored on Channel %s.", pin_count, CHANNEL))
print("=============================================================================")
