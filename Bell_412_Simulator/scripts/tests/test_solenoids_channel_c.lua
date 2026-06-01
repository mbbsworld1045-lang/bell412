-- =============================================================================
-- Solenoid Test Script (Re-created)
-- Platform: Air Manager + Arduino Mega 2560
-- Hardware: Arduino Channel C (Pins D52, D53)
-- =============================================================================

print("Solenoid Test Script Loaded")

local PIN_SOL1 = "ARDUINO_MEGA2560_C_D52"
local PIN_SOL2 = "ARDUINO_MEGA2560_C_D53"

-- Check if hardware handles can be created
local sol1 = hw_output_add(PIN_SOL1, false)
local sol2 = hw_output_add(PIN_SOL2, false)

if sol1 and sol2 then
    print("Hardware Outputs Initialized on D52 & D53")
else
    print("ERROR: Failed to initialize outputs. Check Channel/Pin config.")
end

local state = false

-- Toggle every 1 second (1000 ms)
timer_start(0, 1000, function()
    state = not state
    hw_output_set(sol1, state)
    hw_output_set(sol2, state)
    
    print("Solenoids Set to: " .. (state and "ON" or "OFF"))
end)
