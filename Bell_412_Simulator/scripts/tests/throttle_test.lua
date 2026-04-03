-- =============================================================================
-- THROTTLE POSITION TEST SCRIPT
-- Purpose: Cycle both Eng 1 and Eng 2 throttles through 0%, 12% (Idle), and 100%
-- Trigger: Click the on-screen area (Top Left) to cycle positions
-- =============================================================================

print("=== Throttle Position Test Loaded ===")
print("Click the top-left area to cycle between 0%, 12% (Idle), and 100%")

-- Positions: 0.0 (Off), 0.61 (Idle Stop), 1.0 (Full)
local test_positions = {0.0, 0.61, 1.0}
local current_index = 1

local function update_throttle_test()
    local val = test_positions[current_index]
    local pct = val * 100
    
    print(string.format(">>> TEST COMMAND: %.0f%% (Val: %.2f) <<<", pct, val))
    
    -- Write to sim variables (Eng 1 and Eng 2)
    fsx_variable_write("L:throgas1", "percent", pct)
    fsx_variable_write("L:throgas2", "percent", pct)
    
    -- Also write to Propeller Lever positions (used by the Bell 412 engine model)
    fsx_variable_write("GENERAL ENG PROPELLER LEVER POSITION:2", "percent", pct)
    fsx_variable_write("GENERAL ENG PROPELLER LEVER POSITION:3", "percent", pct)

    -- Advance to next position for next click
    current_index = current_index + 1
    if current_index > #test_positions then
        current_index = 1
    end
end

-- Create an invisible button in the top-left (100x100) to trigger the cycle
-- No images needed, so we use nil for images
button_add(nil, nil, 0, 0, 200, 200, function()
    update_throttle_test()
end)

-- Initial Print
print("Ready. Current position: " .. tostring(test_positions[current_index] * 100) .. "%")
