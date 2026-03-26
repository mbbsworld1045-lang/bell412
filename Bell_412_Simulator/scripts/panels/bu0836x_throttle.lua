-- =============================================================================
-- BU0836X THROTTLE SCRIPT
-- Purpose: Read throttle axes from BU0836X and write to sim
-- Platform: Air Manager
-- =============================================================================
--
-- THROTTLE PARAMETER CHAIN (from XML gauges):
--   BU0836X Axis (0-1.0) -> L:throgas1/L:throgas2 (0-100%)
--                         -> GENERAL ENG PROPELLER LEVER POSITION:2/3 (0-100%)
--   XML gauge then applies:
--     (L:throgas1,percent) 100 / 16384 * (>K:THROTTLE2_SET)
--     (L:throgas2,percent) 100 / 16384 * (>K:THROTTLE3_SET)
-- =============================================================================

print("=== BU0836X Throttle Script Loading ===")

-- =============================================================================
-- CONFIGURATION
-- =============================================================================
local BU0836X_INTERFACE_NAME = "BU0836X Interface"

-- Debug: print axis values to console (set false to reduce spam)
local DEBUG_VERBOSE = true

-- =============================================================================
-- THROTTLE HANDLER
-- =============================================================================
function bu0836x_handler(type, index, value)
    -- Type 0 = Axes, Type 1 = Buttons
    if type == 0 then
        -- Normalize axis (-1..1) to 0-100%
        local percent_val = ((value + 1) / 2) * 100
        if percent_val < 0 then percent_val = 0 end
        if percent_val > 100 then percent_val = 100 end

        -- ENGINE 1 THROTTLE (Axis X / Index 0)
        if index == 0 then
            fsx_variable_write("GENERAL ENG PROPELLER LEVER POSITION:2", "percent", percent_val)
            fsx_variable_write("L:throgas1", "percent", percent_val)
            if DEBUG_VERBOSE then
                print(string.format("THROTTLE1: axis=%.3f -> %.1f%%", value, percent_val))
            end

        -- ENGINE 2 THROTTLE (Axis Y / Index 1)
        elseif index == 1 then
            fsx_variable_write("GENERAL ENG PROPELLER LEVER POSITION:3", "percent", percent_val)
            fsx_variable_write("L:throgas2", "percent", percent_val)
            if DEBUG_VERBOSE then
                print(string.format("THROTTLE2: axis=%.3f -> %.1f%%", value, percent_val))
            end

        -- Log other axes for discovery
        elseif DEBUG_VERBOSE then
            print(string.format("  OTHER axis %d = %.3f", index, value))
        end

    elseif type == 1 and DEBUG_VERBOSE then
        print(string.format("  BUTTON %d = %s", index, tostring(value)))
    end
end

-- =============================================================================
-- CONTROLLER DETECTION & REGISTRATION
-- =============================================================================
local controllers = game_controller_list()

for _, name in pairs(controllers) do
    if name == BU0836X_INTERFACE_NAME then
        print("BU0836X Throttle Test Connected to: " .. name)
        game_controller_add(name, bu0836x_handler)
    end
end

-- =============================================================================
-- SIM READBACK (verification)
-- =============================================================================
fsx_variable_subscribe(
    "L:throgas1", "percent",
    "L:throgas2", "percent",
    function(t1, t2)
        if DEBUG_VERBOSE then
            print(string.format("SIM READBACK: throgas1=%.1f%%  throgas2=%.1f%%", t1 or 0, t2 or 0))
        end
    end
)

fsx_variable_subscribe(
    "L:Eng1N2", "percent",
    "L:Eng2N2", "percent",
    function(n1, n2)
        if DEBUG_VERBOSE then
            print(string.format("ENGINE N2: Eng1=%.1f%%  Eng2=%.1f%%", n1 or 0, n2 or 0))
        end
    end
)

print("=== BU0836X Throttle Test Script Loaded ===")
print("  Axis 0 -> L:throgas1 + PROP LEVER POS:2")
print("  Axis 1 -> L:throgas2 + PROP LEVER POS:3")
