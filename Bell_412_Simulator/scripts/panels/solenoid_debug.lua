-- =============================================================================
-- BELL 412 - SOLENOID DEBUG SCRIPT
-- This script toggles the Idle Stop solenoids on and off every 2 seconds
-- to test the hardware independently of the simulator logic.
-- =============================================================================

print("Solenoid Debug Script Running...")

-- Hardware Pins (from collective.lua)
local PIN_SOLENOID_ENG1     = "ARDUINO_MEGA2560_C_D53"
local PIN_SOLENOID_ENG2     = "ARDUINO_MEGA2560_C_D52"

-- Register Outputs (Requires initial state)
local solenoid_1 = hw_output_add(PIN_SOLENOID_ENG1, false)
local solenoid_2 = hw_output_add(PIN_SOLENOID_ENG2, false)

if solenoid_1 == nil or solenoid_2 == nil then
    print("CRITICAL: Could not connect to the Arduino pins! Make sure you have STOPPED collective.lua before running this script.")
end

-- Create SI Variables for communication
local si_sol1 = si_variable_create("bell412_solenoid1_test", "BOOL", false)
local si_sol2 = si_variable_create("bell412_solenoid2_test", "BOOL", false)

-- Subscribe to SI variables to drive physical hardware
si_variable_subscribe("bell412_solenoid1_test", "BOOL", function(val)
    print("SI Sub: Solenoid 1 -> " .. tostring(val))
    if solenoid_1 ~= nil then
        hw_output_set(solenoid_1, val)
    end
end)

si_variable_subscribe("bell412_solenoid2_test", "BOOL", function(val)
    print("SI Sub: Solenoid 2 -> " .. tostring(val))
    if solenoid_2 ~= nil then
        hw_output_set(solenoid_2, val)
    end
end)

local state = false

-- Timer callback function
local function toggle_solenoids()
    state = not state
    print("--- Solenoid Test Cycle ---")
    print("Writing SI Solenoid 1: " .. tostring(state))
    print("Writing SI Solenoid 2: " .. tostring(state))
    
    -- Write to SI variables instead of driving hardware directly
    si_variable_write(si_sol1, state)
    si_variable_write(si_sol2, state)
end

-- Start a timer to run every 2000 milliseconds (2 seconds)
timer_id = timer_start(0, 2000, toggle_solenoids)

print("Timer started. Solenoids will toggle via SI variables every 2 seconds.")
