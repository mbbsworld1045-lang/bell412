-- =============================================================================
-- BELL 412: BU0836X THROTTLES (Linear 0-100%, No Idle Lock)
-- =============================================================================

local BU0836X_INTERFACE_NAME = "BU0836X Interface"

-- Hardware Pin Assignments
local THROTTLE1_AXIS = 0 
local THROTTLE2_AXIS = 1 

-- =============================================================================
-- JITTER FILTER (DEADBAND)
-- Prevents the hardware analog needle from flickering visually in the simulator.
-- Increase this value (e.g. 1.0 or 1.5) if the needle continues to flicker.
-- =============================================================================
local DEADBAND_PCT = 1.0 

local last_t1_sent = -999.0
local last_t2_sent = -999.0

-- =============================================================================
-- HELPER FUNCTIONS
-- =============================================================================

-- Translates a number from one range to another
local function map_range(x, in_min, in_max, out_min, out_max)
    return out_min + (x - in_min) * (out_max - out_min) / (in_max - in_min)
end

-- Ensures the final output never exceeds the safe limits
local function clamp(val, min_val, max_val)
    if val < min_val then return min_val end
    if val > max_val then return max_val end
    return val
end

-- =============================================================================
-- THROTTLE CALIBRATION PROFILES (Per User Specs)
-- =============================================================================

-- Engine 1 (Wired Normally)
local function calibrate_throttle_1(raw_pct)
    -- Maps physical 0.2% - 38.5% directly to 0% - 100%
    local out = map_range(raw_pct, 0.2, 38.5, 0, 100)
    -- Cutoff below 4.99 per request
    return clamp(out, 4.99, 100)
end

-- Engine 2 (Wired Backwards)
local function calibrate_throttle_2(raw_pct)
    -- Maps physical 92.0% - 84.0% directly to 0% - 100%
    -- (The math automatically handles the inversion)
    local out = map_range(raw_pct, 92, 84, 0, 100)
    -- Cutoff below 4.99 per request
    return clamp(out, 4.99, 100)
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
            local final_sim_pct = calibrate_throttle_1(raw_pct)
            
            -- Deadband check to eliminate flickering
            if math.abs(final_sim_pct - last_t1_sent) >= DEADBAND_PCT then
                last_t1_sent = final_sim_pct
                
                print(string.format("ENG 1: Raw %.1f%% -> Filtered Sim: %.1f%%", raw_pct, final_sim_pct))
                
                -- Custom Bell 412 L: Variables
                fsx_variable_write("L:throgas1", "percent", final_sim_pct)
                fsx_variable_write("L:Powern2E1", "percent", final_sim_pct)
                
                -- Force Air Manager to simulate the A: vars the XML reads
                fsx_variable_write("GENERAL ENG THROTTLE LEVER POSITION:1", "percent", final_sim_pct)
                fsx_variable_write("GENERAL ENG PROPELLER LEVER POSITION:2", "percent", final_sim_pct)
                
                -- Core Prepar3D Axis Events (0 to 16384 range)
                local sim_axis_val = math.floor((final_sim_pct / 100) * 16384)
                fsx_event("THROTTLE1_SET", sim_axis_val)
                fsx_event("PROP_PITCH2_SET", sim_axis_val)
            end

        -- ==========================================
        -- ENGINE 2
        -- ==========================================
        elseif index == THROTTLE2_AXIS then
            local final_sim_pct = calibrate_throttle_2(raw_pct)
            
            -- Deadband check to eliminate flickering
            if math.abs(final_sim_pct - last_t2_sent) >= DEADBAND_PCT then
                last_t2_sent = final_sim_pct
                
                print(string.format("ENG 2: Raw %.1f%% -> Filtered Sim: %.1f%%", raw_pct, final_sim_pct))
                
                -- Custom Bell 412 L: Variables
                fsx_variable_write("L:throgas2", "percent", final_sim_pct)
                fsx_variable_write("L:Powern2E2", "percent", final_sim_pct)
                
                -- Force Air Manager to simulate the A: vars the XML reads
                fsx_variable_write("GENERAL ENG THROTTLE LEVER POSITION:2", "percent", final_sim_pct)
                fsx_variable_write("GENERAL ENG PROPELLER LEVER POSITION:3", "percent", final_sim_pct)
                
                -- Core Prepar3D Axis Events (0 to 16384 range)
                local sim_axis_val = math.floor((final_sim_pct / 100) * 16384)
                fsx_event("THROTTLE2_SET", sim_axis_val)
                fsx_event("PROP_PITCH3_SET", sim_axis_val)
            end
        end
    end
end

-- =============================================================================
-- BOARD DETECTION & STARTUP
-- =============================================================================
local controllers = game_controller_list()
for _, name in pairs(controllers) do
    if name == BU0836X_INTERFACE_NAME then
        print("--- Bell 412: Filtered 0-100% Throttles Connected ---")
        game_controller_add(name, bu0836x_master_handler)
    end
end