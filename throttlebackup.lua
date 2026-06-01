-- =============================================================================
-- BELL 412: BU0836X THROTTLES (Linear 0-100%, No Idle Lock)
-- Fixed: Removed Collective/Throttle crosstalk
-- =============================================================================

local BU0836X_INTERFACE_NAME = "BU0836X Interface"

-- Hardware Pin Assignments
local THROTTLE1_AXIS = 3 
local THROTTLE2_AXIS = 2 

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
-- THROTTLE CALIBRATION PROFILES (Two-Stage Curve)
-- =============================================================================

-- *** CHANGE THESE VALUES *** -- The 0-100% value in the simulator that makes each engine sit at exactly 60% N1
local SIM_IDLE_PCT_1 = 8.0 
local SIM_IDLE_PCT_2 = 8.0 

-- Engine 1 (Reversed Hardware)
local function calibrate_throttle_1(raw_pct)
    -- Physical Hardware Points
    local RAW_CLOSED = 99
    local RAW_IDLE   = 43.95
    local RAW_OPEN   = 1
    
    local out = 0
    
    -- Clamp raw input to valid hardware range (reversed: CLOSED is high, OPEN is low)
    raw_pct = clamp(raw_pct, RAW_OPEN, RAW_CLOSED)
    
    -- Stage 1: Cutoff to Idle Stop
    if raw_pct <= RAW_CLOSED and raw_pct > RAW_IDLE then
        out = map_range(raw_pct, RAW_CLOSED, RAW_IDLE, 0, SIM_IDLE_PCT_1)
        
    -- Stage 2: Idle Stop to Fully Open
    elseif raw_pct <= RAW_IDLE then
        out = map_range(raw_pct, RAW_IDLE, RAW_OPEN, SIM_IDLE_PCT_1, 100)
    end
    
    -- Modified: Allows full movement down to 0%
    return clamp(out, 0.0, 100)
end

-- Engine 2 (Standard Hardware - Not Reversed)
local function calibrate_throttle_2(raw_pct)
    -- Physical Hardware Points
    -- (Inverted from previous: 100 - 99 = 1, 100 - 40 = 60, 100 - 1 = 99)
    local RAW_CLOSED = 1
    local RAW_IDLE   = 46
    local RAW_OPEN   = 99
    
    local out = 0
    
    -- Clamp raw input to valid hardware range (standard: CLOSED is low, OPEN is high)
    raw_pct = clamp(raw_pct, RAW_CLOSED, RAW_OPEN)
    
    -- Stage 1: Cutoff to Idle Stop
    if raw_pct >= RAW_CLOSED and raw_pct < RAW_IDLE then
        out = map_range(raw_pct, RAW_CLOSED, RAW_IDLE, 0, SIM_IDLE_PCT_2)
        
    -- Stage 2: Idle Stop to Fully Open
    elseif raw_pct >= RAW_IDLE then
        out = map_range(raw_pct, RAW_IDLE, RAW_OPEN, SIM_IDLE_PCT_2, 100)
    end
    
    -- Modified: Allows full movement down to 0%
    return clamp(out, 0.0, 100)
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
             print(string.format("ENG 1: True Raw %.2f%% -> Calibrated: %.1f%%", raw_pct, final_sim_pct))
            
            -- Deadband check to eliminate flickering
            if math.abs(final_sim_pct - last_t1_sent) >= DEADBAND_PCT then
                last_t1_sent = final_sim_pct
                
                -- Custom Bell 412 L: Variables
                fsx_variable_write("L:throgas1", "percent", final_sim_pct)
                fsx_variable_write("L:Powern2E1", "percent", final_sim_pct)
                
                -- Send Helicopter Throttle commands (Mapped to Prop Pitch in P3D)
                fsx_variable_write("GENERAL ENG PROPELLER LEVER POSITION:2", "percent", final_sim_pct)
                
                -- Core Prepar3D Axis Events (0 to 16384 range)
                local sim_axis_val = math.floor((final_sim_pct / 100) * 16384)
                fsx_event("PROP_PITCH2_SET", sim_axis_val)
            end

        -- ==========================================
        -- ENGINE 2
        -- ==========================================
        elseif index == THROTTLE2_AXIS then
            local final_sim_pct = calibrate_throttle_2(raw_pct)
            --print(string.format("ENG 2: True Raw %.2f%% -> Calibrated: %.1f%%", raw_pct, final_sim_pct))
            
            -- Deadband check to eliminate flickering
            if math.abs(final_sim_pct - last_t2_sent) >= DEADBAND_PCT then
                last_t2_sent = final_sim_pct
                
                -- Custom Bell 412 L: Variables
                fsx_variable_write("L:throgas2", "percent", final_sim_pct)
                fsx_variable_write("L:Powern2E2", "percent", final_sim_pct)
                
                -- Send Helicopter Throttle commands (Mapped to Prop Pitch in P3D)
                fsx_variable_write("GENERAL ENG PROPELLER LEVER POSITION:3", "percent", final_sim_pct)
                
                -- Core Prepar3D Axis Events (0 to 16384 range)
                local sim_axis_val = math.floor((final_sim_pct / 100) * 16384)
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