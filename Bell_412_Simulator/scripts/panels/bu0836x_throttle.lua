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

-- Idle Stop Status
local idle_stop_1 = false
local idle_stop_2 = false

-- =============================================================================
-- CALIBRATION TABLES (Raw % from BU0836X -> Sim %)
-- =============================================================================
-- Format: { {raw, sim}, {raw, sim}, ... }
local CALIBRATION_ENG1 = {
    { 0.2,   0.0 },    -- Off/Cutoff
    { 11.9,  61.0 },   -- Idle Stop
    { 38.5,  100.0 }   -- Full
}

local CALIBRATION_ENG2 = {
    { 79.5,  0.0 },    -- Off/Cutoff (Reversed wiring)
    { 65.6,  61.0 },   -- Idle Stop
    { 55.0,  100.0 }   -- Full
}

-- HELPER: Multi-point Linear Interpolation
local function interpolate_axis(val, table)
    -- Clamp to table bounds
    if val <= table[1][1] and val <= table[#table][1] then
        -- Handle reversed vs normal tables for at-bound clamping
        if table[1][1] < table[#table][1] then return table[1][2] else return table[#table][2] end
    end
    if val >= table[1][1] and val >= table[#table][1] then
        if table[1][1] > table[#table][1] then return table[1][2] else return table[#table][2] end
    end

    -- Find the segment
    for i = 1, #table - 1 do
        local p1 = table[i]
        local p2 = table[i+1]
        
        -- Check if val is between p1[1] and p2[1]
        local min_raw = math.min(p1[1], p2[1])
        local max_raw = math.max(p1[1], p2[1])
        
        if val >= min_raw and val <= max_raw then
            -- Linear interpolation formula: y = y1 + (x - x1) * (y2 - y1) / (x2 - x1)
            local raw_range = p2[1] - p1[1]
            local sim_range = p2[2] - p1[2]
            if raw_range == 0 then return p1[2] end
            return p1[2] + (val - p1[1]) * (sim_range / raw_range)
        end
    end
    return 0
end

-- =============================================================================
-- THROTTLE HANDLER
-- =============================================================================
function bu0836x_handler(type, index, value)
    -- Type 0 = Axes
    if type == 0 then
        -- Raw value from axis is -1..1, convert to 0-100% raw
        local raw_pct = ((value + 1) / 2) * 100

        -- ENGINE 1 THROTTLE (Axis 0)
        if index == 0 then
            local cal_val = interpolate_axis(raw_pct, CALIBRATION_ENG1)
            fsx_variable_write("GENERAL ENG PROPELLER LEVER POSITION:2", "percent", cal_val)
            fsx_variable_write("L:throgas1", "percent", cal_val)
            if DEBUG_VERBOSE then
                print(string.format("THROTTLE1: raw=%.1f%% -> cal=%.1f%%", raw_pct, cal_val))
            end

        -- ENGINE 2 THROTTLE (Axis 1)
        elseif index == 1 then
            local cal_val = interpolate_axis(raw_pct, CALIBRATION_ENG2)
            fsx_variable_write("GENERAL ENG PROPELLER LEVER POSITION:3", "percent", cal_val)
            fsx_variable_write("L:throgas2", "percent", cal_val)
            if DEBUG_VERBOSE then
                print(string.format("THROTTLE2: raw=%.1f%% -> cal=%.1f%%", raw_pct, cal_val))
            end

        -- Log other axes for discovery
        elseif DEBUG_VERBOSE then
            print(string.format("  OTHER axis %d = %.3f", index, value))
        end

    -- Type 1 = Buttons
    elseif type == 1 then
        -- SWAPPED IDLE STOP BUTTONS (User's reversed hardware)
        -- Button index 0 -> ENGINE 2 IDLE STOP
        if index == 0 then
            idle_stop_2 = (value == 1)
            if idle_stop_2 then
                print("BU0836X: IDLE STOP ENG 2 ON")
                fsx_variable_write("L:idle eng", "Number", -1)
            else
                print("BU0836X: IDLE STOP ENG 2 OFF")
                fsx_variable_write("L:idle eng", "Number", 0)
            end

        -- Button index 1 -> ENGINE 1 IDLE STOP
        elseif index == 1 then
            idle_stop_1 = (value == 1)
            if idle_stop_1 then
                print("BU0836X: IDLE STOP ENG 1 ON")
                fsx_variable_write("L:idle eng", "Number", 1)
            else
                print("BU0836X: IDLE STOP ENG 1 OFF")
                fsx_variable_write("L:idle eng", "Number", 0)
            end
        end

        if DEBUG_VERBOSE then
            print(string.format("  BUTTON %d = %s", index, tostring(value)))
        end
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
