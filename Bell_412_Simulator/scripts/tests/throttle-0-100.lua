-- =============================================================================
-- BELL 412: BU0836X THROTTLES (Linear 0-100%, No Idle Lock)
-- =============================================================================

local BU0836X_INTERFACE_NAME = "BU0836X Interface"

-- Hardware Pin Assignments
local THROTTLE1_AXIS = 0 
local THROTTLE2_AXIS = 1 

-- =============================================================================
-- HELPER FUNCTIONS
-- =============================================================================

-- Translates a number from one range to another
local function map_range(x, in_min, in_max, out_min, out_max)
    return out_min + (x - in_min) * (out_max - out_min) / (in_max - in_min)
end

-- Ensures the final output never exceeds the safe 0 to 100 limits
local function clamp(val, min_val, max_val)
    if val < min_val then return min_val end
    if val > max_val then return max_val end
    return val
end

-- =============================================================================
-- THROTTLE CALIBRATION PROFILES
-- =============================================================================

-- Engine 1 (Wired Normally)
local function calibrate_throttle_1(raw_pct)
    -- Maps your physical 0.2% - 38.5% directly to 0% - 100%
    local out = map_range(raw_pct, 0.2, 38.5, 0, 100)
    return clamp(out, 0, 100)
end

-- Engine 2 (Wired Backwards)
local function calibrate_throttle_2(raw_pct)
    -- Maps your physical 79.5% - 55.0% directly to 0% - 100%
    -- (The math automatically handles the inversion)
    local out = map_range(raw_pct, 79.5, 55.0, 0, 100)
    return clamp(out, 0, 100)
end

-- =============================================================================
-- MAIN HARDWARE HANDLER
-- =============================================================================

function bu0836x_master_handler(type, index, value)
    
    -- --- AXIS INPUTS (Type 0) ---
    if type == 0 then
        
        -- Get the raw 0-100% directly from the board
        local raw_pct = ((value + 1) / 2) * 100

        -- ==========================================
        -- ENGINE 1
        -- ==========================================
        if index == THROTTLE1_AXIS then
            -- Run through linear calibration
            local final_sim_pct = calibrate_throttle_1(raw_pct)
            
            -- Calculate 0-16384 scale for Prepar3D
            local sim_axis_val = math.floor((final_sim_pct / 100) * 16384)
            
            -- Print to console for debugging
            print(string.format("ENG 1: Raw %.1f%% -> Linear Sim: %.1f%%", raw_pct, final_sim_pct))
            
            -- Send to Sim
            fsx_variable_write("L:throgas1", "Number", final_sim_pct)
            fsx_event("PROP_PITCH2_SET", sim_axis_val)

        -- ==========================================
        -- ENGINE 2
        -- ==========================================
        elseif index == THROTTLE2_AXIS then
            -- Run through linear calibration (fixes the backwards wiring)
            local final_sim_pct = calibrate_throttle_2(raw_pct)
            
            -- Calculate 0-16384 scale for Prepar3D
            local sim_axis_val = math.floor((final_sim_pct / 100) * 16384)
            
            -- Print to console for debugging
            print(string.format("ENG 2: Raw %.1f%% -> Linear Sim: %.1f%%", raw_pct, final_sim_pct))
            
            -- Send to Sim
            fsx_variable_write("L:throgas2", "Number", final_sim_pct)
            fsx_event("PROP_PITCH3_SET", sim_axis_val)
        end
    end
end

-- =============================================================================
-- BOARD DETECTION & STARTUP
-- =============================================================================
local controllers = game_controller_list()
for _, name in pairs(controllers) do
    if name == BU0836X_INTERFACE_NAME then
        print("--- Bell 412: Linear 0-100% Throttles Connected ---")
        game_controller_add(name, bu0836x_master_handler)
    end
end