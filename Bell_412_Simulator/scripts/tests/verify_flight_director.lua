-- =============================================================================
-- BELL 412 - FLIGHT DIRECTOR VERIFICATION SCRIPT
-- Platform: Air Manager + Arduino Mega 2560
-- Purpose: 
--    1. Test all Flight Director BUTTONS (FD1 & FD2) - prints to console on press.
--    2. Test all Flight Director LEDs (FD1) - cycles through them one by one.
-- Usage: Run this script. Press buttons to verify inputs. Watch LEDs to verify outputs.
-- =============================================================================

print("=============================================================================")
print("         FLIGHT DIRECTOR VERIFICATION STARTED")
print("         1. Press Buttons to see them in the console.")
print("         2. LEDs will cycle automatically every 1.5 seconds.")
print("=============================================================================")

-- =============================================================================
-- 1. BUTTON DEFINITIONS (FD1 & FD2)
-- =============================================================================
local BUTTONS = {
    -- Flight Director 1 (FD1)
    { pin = "ARDUINO_MEGA2560_F_D46", name = "FD1 ALT" },
    { pin = "ARDUINO_MEGA2560_F_D47", name = "FD1 IAS" },
    { pin = "ARDUINO_MEGA2560_F_D48", name = "FD1 VS" },
    { pin = "ARDUINO_MEGA2560_F_D49", name = "FD1 HDG" },
    { pin = "ARDUINO_MEGA2560_F_D50", name = "FD1 NAV" },
    { pin = "ARDUINO_MEGA2560_F_D51", name = "FD1 ILS" },
    { pin = "ARDUINO_MEGA2560_F_D52", name = "FD1 BC" },
    { pin = "ARDUINO_MEGA2560_F_D53", name = "FD1 VOR APR" },
    { pin = "ARDUINO_MEGA2560_F_D13", name = "FD1 GA" },
    { pin = "ARDUINO_MEGA2560_F_A1",  name = "FD1 SBY" },

    -- Flight Director 2 (FD2)
    { pin = "ARDUINO_MEGA2560_F_D25", name = "FD2 ALT" },
    { pin = "ARDUINO_MEGA2560_F_D26", name = "FD2 IAS" },
    { pin = "ARDUINO_MEGA2560_F_D27", name = "FD2 VS" },
    { pin = "ARDUINO_MEGA2560_F_D33", name = "FD2 HDG" },
    { pin = "ARDUINO_MEGA2560_F_D34", name = "FD2 NAV" },
    { pin = "ARDUINO_MEGA2560_F_D35", name = "FD2 ILS" },
    { pin = "ARDUINO_MEGA2560_F_D42", name = "FD2 BC" },
    { pin = "ARDUINO_MEGA2560_F_D41", name = "FD2 VOR APR" },
    { pin = "ARDUINO_MEGA2560_F_D43", name = "FD2 GA" },
    { pin = "ARDUINO_MEGA2560_F_D45", name = "FD2 SBY" },
}

-- Initialize Buttons
local btn_count = 0
for _, btn in ipairs(BUTTONS) do
    hw_button_add(btn.pin, function()
        print(string.format("BUTTON PRESSED: %-15s (Pin: %s)", btn.name, btn.pin:gsub("ARDUINO_MEGA2560_F_", "")))
    end)
    btn_count = btn_count + 1
end
print(string.format("DEBUG: Initialized %d Buttons (FD1 & FD2).", btn_count))


-- =============================================================================
-- 2. LED DEFINITIONS (FD1 Only)
-- =============================================================================
local LEDS = {
    { pin = "ARDUINO_MEGA2560_F_A4",  name = "FD1 VS Light" },
    { pin = "ARDUINO_MEGA2560_F_A2",  name = "FD1 IAS Light" },
    { pin = "ARDUINO_MEGA2560_F_A3",  name = "FD1 ALT Light" },
    { pin = "ARDUINO_MEGA2560_F_A5",  name = "FD1 ILS Light 1" },
    { pin = "ARDUINO_MEGA2560_F_A6",  name = "FD1 ILS Light 2" },
    { pin = "ARDUINO_MEGA2560_F_A7",  name = "FD1 NAV Light 1" },
    { pin = "ARDUINO_MEGA2560_F_A8",  name = "FD1 NAV Light 2" },
    { pin = "ARDUINO_MEGA2560_F_A9",  name = "FD1 HDG Light" },
    { pin = "ARDUINO_MEGA2560_F_A10", name = "FD1 GA Light" },
    { pin = "ARDUINO_MEGA2560_F_A11", name = "FD1 VOR APR Light 1" },
    { pin = "ARDUINO_MEGA2560_F_A12", name = "FD1 VOR APR Light 2" },
    { pin = "ARDUINO_MEGA2560_F_A13", name = "FD1 BC Light 1" },
    { pin = "ARDUINO_MEGA2560_F_A14", name = "FD1 BC Light 2" },
    { pin = "ARDUINO_MEGA2560_F_A15", name = "FD1 SBY Light" },
}

-- Initialize LEDs
local led_handles = {}
local led_valid_count = 0
for i, led_def in ipairs(LEDS) do
    local handle = hw_led_add(led_def.pin, 0.0)
    led_handles[i] = handle
    if handle then led_valid_count = led_valid_count + 1 end
end
print(string.format("DEBUG: Initialized %d/%d LED handles.", led_valid_count, #LEDS))

-- =============================================================================
-- 3. LED CYCLE LOGIC
-- =============================================================================
local current_index = 0
local timer_id = nil

local function next_led()
    -- Turn OFF previous LED
    if current_index > 0 and current_index <= #led_handles then
        local prev_handle = led_handles[current_index]
        if prev_handle then hw_led_set(prev_handle, 0.0) end
    end

    -- Increment
    current_index = current_index + 1

    -- Check if done
    if current_index > #LEDS then
        print("--- LED Cycle Complete. Restarting in 3 seconds... ---")
        current_index = 0 
        if timer_id then timer_stop(timer_id) end
        timer_id = timer_start(3000, function() 
            timer_id = timer_start(1500, next_led) -- Restart regular timer (1.5s)
            next_led()
        end)
        return
    end

    -- Turn ON current LED
    local led = LEDS[current_index]
    local handle = led_handles[current_index]
    
    if handle then
        hw_led_set(handle, 1.0)
        -- Print Info
        print(string.format("LED ON [%02d/%02d]:     %-20s  (Pin: %s)", 
            current_index, #LEDS, led.name, led.pin:gsub("ARDUINO_MEGA2560_F_", "")))
    else
        print(string.format("SKIPPING LED [%02d]:    %-20s  (Pin: %s) - INVALID HANDLE", 
            current_index, led.name, led.pin:gsub("ARDUINO_MEGA2560_F_", "")))
    end
        
    -- Schedule NEXT step
    timer_id = timer_start(1500, next_led) -- 1.5 seconds per LED
end

-- Start Logic
print("Starting LED Cycle...")
next_led()
