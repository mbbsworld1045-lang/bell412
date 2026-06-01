-- Test Sequence for Specific LEDs
-- 1. EFIS 2 Fan (Pin: E_A3)
-- 2. No 2 Autopilot (Pin: E_A15)
-- 3. Gov Manual Right (Pin: E_A9)

local test_leds = {
    { pin = "ARDUINO_MEGA2560_E_A3",  name = "EFIS 2 Fan" },
    { pin = "ARDUINO_MEGA2560_E_A15", name = "No 2 Autopilot" },
    { pin = "ARDUINO_MEGA2560_E_A9",  name = "Gov Manual Right" }
}

-- Initialize all handles to OFF
local handles = {}
for i, led in ipairs(test_leds) do
    handles[i] = hw_output_add(led.pin, false)
end

print("=====================================================")
print("Sequence Test Started")
print("Lighting up EFIS 2 Fan, No 2 Autopilot, Gov Manual Right.")
print("Each LED will stay on for 3 seconds.")
print("=====================================================")

local current_index = 0

local function next_led()
    -- Turn off the previous LED
    if current_index > 0 and current_index <= #handles then
        hw_output_set(handles[current_index], false)
    end
    
    -- Increment the index
    current_index = current_index + 1
    
    -- Wrap around to loop continuously
    if current_index > #handles then
        current_index = 1
        print("-----------------------------------------------------")
        print("Repeating sequence...")
    end
    
    -- Turn on the current LED
    hw_output_set(handles[current_index], true)
    print(string.format(">>> LED ON: %s (Pin: %s)", test_leds[current_index].name, test_leds[current_index].pin))
    
    -- Schedule next change in 3 seconds
    timer_start(3000, next_led)
end

-- Start immediately
next_led()
