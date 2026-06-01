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
-- ENGINE N1 & ITT SIMULATION STATE
-- =============================================================================

-- Starter switch from collective.lua (1 = Eng1, -1 = Eng2, 0 = Off)
local starter_state = 0
fsx_variable_subscribe("L:starteng", "Number", function(val)
    starter_state = val or 0
end)

-- P3D internal engine states (read-only, used to safely fire toggle events)
local sim_starter_e1 = false
local sim_starter_e2 = false
local sim_fuel_valve_e1 = false
local sim_fuel_valve_e2 = false
local sim_combustion_e1 = false
local sim_combustion_e2 = false

fsx_variable_subscribe("GENERAL ENG STARTER:2", "Bool", function(val) sim_starter_e1 = val end)
fsx_variable_subscribe("GENERAL ENG STARTER:3", "Bool", function(val) sim_starter_e2 = val end)
fsx_variable_subscribe("GENERAL ENG FUEL VALVE:2", "Bool", function(val) sim_fuel_valve_e1 = val end)
fsx_variable_subscribe("GENERAL ENG FUEL VALVE:3", "Bool", function(val) sim_fuel_valve_e2 = val end)
fsx_variable_subscribe("ENG COMBUSTION:2", "Bool", function(val) sim_combustion_e1 = val end)
fsx_variable_subscribe("ENG COMBUSTION:3", "Bool", function(val) sim_combustion_e2 = val end)

-- Governor and Rotor Subscriptions
local sw_gov_a = 0
local sw_gov_b = 0
local rotor_rpm = 0.0
local current_altitude = 0.0
local collective_position = 0.0

fsx_variable_subscribe("L:SwGovA", "Number", function(val) sw_gov_a = val or 0 end)
fsx_variable_subscribe("L:SwGovB", "Number", function(val) sw_gov_b = val or 0 end)
fsx_variable_subscribe("ENG ROTOR RPM:1", "percent", function(val) rotor_rpm = val or 0.0 end)
fsx_variable_subscribe("INDICATED ALTITUDE", "feet", function(val) current_altitude = val or 0.0 end)
fsx_variable_subscribe("GENERAL ENG THROTTLE LEVER POSITION:1", "percent", function(val) collective_position = val or 0.0 end)

local gov_beep_switch = 0
local gov_beep_target = 100.0
fsx_variable_subscribe("L:GOVERNOR RPM SWITCH", "Number", function(val) gov_beep_switch = val or 0 end)

-- Overhead panel fuel valve switches (must be ON for fuel to flow)
local fuel_valve_sw_e1 = false
local fuel_valve_sw_e2 = false
fsx_variable_subscribe("L:SwvalveEng1", "Bool", function(val) fuel_valve_sw_e1 = (val == true or val == 1) end)
fsx_variable_subscribe("L:SwvalveEng2", "Bool", function(val) fuel_valve_sw_e2 = (val == true or val == 1) end)

-- Fire T-handles (pulling cuts fuel to that engine)
local fire_handle_e1 = false
local fire_handle_e2 = false
fsx_variable_subscribe("L:firethandl", "Number", function(val) fire_handle_e1 = (val ~= 0) end)
fsx_variable_subscribe("L:firethandr", "Number", function(val) fire_handle_e2 = (val ~= 0) end)

-- N1 Spool Rates (adjustable)
local SPOOL_RATE_LOW_RPM  = 5.0  -- % N1/sec from 0% to 60%
local SPOOL_RATE_HIGH_RPM = 6.6  -- % N1/sec from 60% to 100%

-- ITT Configuration (adjustable)
local ITT_HEAT_RATE       = 300.0 -- °C/sec when heating up
local ITT_COOL_RATE       = 250.0 -- °C/sec when cooling down (slower)
local AMBIENT_TEMP        = 15.0

-- Engine 1 State
local target_n1_e1 = 0.0
local current_n1_e1 = 0.0
local current_itt_e1 = AMBIENT_TEMP
local current_oil_temp_e1 = AMBIENT_TEMP

-- Engine 2 State
local target_n1_e2 = 0.0
local current_n1_e2 = 0.0
local current_itt_e2 = AMBIENT_TEMP
local current_oil_temp_e2 = AMBIENT_TEMP

-- Gearbox State
local current_xmsn_temp = AMBIENT_TEMP
local current_gbox_temp = AMBIENT_TEMP
local current_nr = 0.0 -- Internal Rotor State (Independent Physics)

-- Idle stop state is now handled via SI variables
-- Locking happens in the axis handler below. Unlocking happens in collective.lua.
local si_sol1 = si_variable_create("bell412_solenoid1", "BOOL", false)
local si_sol2 = si_variable_create("bell412_solenoid2", "BOOL", false)

local TIMER_INTERVAL_MS = 20

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
-- THROTTLE CALIBRATION PROFILES (Linear N1 0-100% Mapping)
-- =============================================================================

-- Engine 1 (Reversed Hardware)
local function calibrate_throttle_1(raw_pct)
    -- Physical Hardware Points
    local RAW_CLOSED = 99
    local RAW_IDLE   = 47.36
    local RAW_OPEN   = 1
    
    local out = 0
    
    -- Clamp raw input to valid hardware range (reversed: CLOSED is high, OPEN is low)
    raw_pct = clamp(raw_pct, RAW_OPEN, RAW_CLOSED)
    
    -- Stage 1: Cutoff to Idle Stop
    if raw_pct <= RAW_CLOSED and raw_pct > RAW_IDLE then
        out = map_range(raw_pct, RAW_CLOSED, RAW_IDLE, 0, 60)
        
    -- Stage 2: Idle Stop to Fully Open
    elseif raw_pct <= RAW_IDLE then
        out = map_range(raw_pct, RAW_IDLE, RAW_OPEN, 60, 100)
    end
    
    -- Modified: Allows full movement down to 0%
    return clamp(out, 0.0, 100)
end

-- Engine 2 (Standard Hardware - Not Reversed)
local function calibrate_throttle_2(raw_pct)
    -- Physical Hardware Points
    -- (Inverted from previous: 100 - 99 = 1, 100 - 40 = 60, 100 - 1 = 99)
    local RAW_CLOSED = 1
    local RAW_IDLE   = 47.32
    local RAW_OPEN   = 99
    
    local out = 0
    
    -- Clamp raw input to valid hardware range (standard: CLOSED is low, OPEN is high)
    raw_pct = clamp(raw_pct, RAW_CLOSED, RAW_OPEN)
    
    -- Stage 1: Cutoff to Idle Stop
    if raw_pct >= RAW_CLOSED and raw_pct < RAW_IDLE then
        out = map_range(raw_pct, RAW_CLOSED, RAW_IDLE, 0, 60)
        
    -- Stage 2: Idle Stop to Fully Open
    elseif raw_pct >= RAW_IDLE then
        out = map_range(raw_pct, RAW_IDLE, RAW_OPEN, 60, 100)
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
                
                -- Update target N1 instead of writing instantly
                target_n1_e1 = final_sim_pct
                
                -- Auto-lock Idle Stop if throttle advanced past 65%
                if final_sim_pct >= 65.0 then
                    print(string.format("DEBUG - Throttle 1 >= 65 (%.1f). Forcing Lock.", final_sim_pct))
                    si_variable_write(si_sol1, false)
                end
                
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
            print(string.format("ENG 2: True Raw %.2f%% -> Calibrated: %.1f%%", raw_pct, final_sim_pct))
            
            -- Deadband check to eliminate flickering
            if math.abs(final_sim_pct - last_t2_sent) >= DEADBAND_PCT then
                last_t2_sent = final_sim_pct
                
                -- Update target N1 instead of writing instantly
                target_n1_e2 = final_sim_pct
                
                -- Auto-lock Idle Stop if throttle advanced past 65%
                if final_sim_pct >= 70.0 then
                    print(string.format("DEBUG - Throttle 2 >= 65 (%.1f). Forcing Lock.", final_sim_pct))
                    si_variable_write(si_sol2, false)
                end
                
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
-- ENGINE PHYSICS LOOP (Runs 20 times per second)
-- =============================================================================

-- Sync P3D starter state to match our L:starteng switch
local function sync_starter(eng_index, want_starter, sim_starter_on)
    if want_starter and not sim_starter_on then
        -- Turn ON the P3D starter
        if eng_index == 1 then fsx_event("TOGGLE_STARTER2") end
        if eng_index == 2 then fsx_event("TOGGLE_STARTER3") end
    elseif not want_starter and sim_starter_on then
        -- Turn OFF the P3D starter
        if eng_index == 1 then fsx_event("TOGGLE_STARTER2") end
        if eng_index == 2 then fsx_event("TOGGLE_STARTER3") end
    end
end

-- Master Fuel Valve: combines fuel valve switch, throttle position, and fire handle
-- Returns true if fuel is ALLOWED to flow
local function is_fuel_allowed(eng_index, throttle_target)
    local valve_sw = (eng_index == 1) and fuel_valve_sw_e1 or fuel_valve_sw_e2
    local fire_pulled = (eng_index == 1) and fire_handle_e1 or fire_handle_e2
    local throttle_open = (throttle_target >= 15.0)
    
    -- Fuel is blocked if: valve switch OFF, or fire handle pulled, or throttle at cutoff
    if not valve_sw then return false end
    if fire_pulled then return false end
    if not throttle_open then return false end
    return true
end

-- Sync P3D fuel valve & mixture based on master fuel valve logic
local function sync_fuel(eng_index, fuel_allowed, sim_fuel_on)
    if fuel_allowed and not sim_fuel_on then
        -- Open fuel valve and enrich mixture
        if eng_index == 1 then
            fsx_event("TOGGLE_FUEL_VALVE_ENG2")
            fsx_event("MIXTURE2_RICH")
        else
            fsx_event("TOGGLE_FUEL_VALVE_ENG3")
            fsx_event("MIXTURE3_RICH")
        end
    elseif not fuel_allowed and sim_fuel_on then
        -- Close fuel valve and lean mixture (engine shutdown)
        if eng_index == 1 then
            fsx_event("TOGGLE_FUEL_VALVE_ENG2")
            fsx_event("MIXTURE2_LEAN")
        else
            fsx_event("TOGGLE_FUEL_VALVE_ENG3")
            fsx_event("MIXTURE3_LEAN")
        end
    end
end

-- Determine what N1 the engine should be targeting based on physics and governor
local function get_effective_target_n1(eng_index, throttle_target, fuel_allowed, current_torque)
    local starter_active = (eng_index == 1 and starter_state == 1)
                        or (eng_index == 2 and starter_state == -1)
    
    -- CASE 1: Throttle is closed (cutoff position below 15%)
    if throttle_target < 15.0 then
        if starter_active then
            return 15.0  -- Starter dry-motors the compressor to 15%
        else
            return 0.0   -- No starter, no rotation
        end
    end
    
    -- CASE 2: Throttle Mapping Logic
    -- CASE 2: Throttle Mapping and Governor Table Alignment
    -- Detect N1 Sharing Factor (How much the other engine is helping)
    -- 0% N1 = 100% OEI (Higher targets), 82% N1 = 100% AEO (Lower targets)
    local other_n1 = (eng_index == 1) and current_n1_e2 or current_n1_e1
    local other_n1_clean = (other_n1 < 50.0) and 0.0 or other_n1
    local effective_sharing = math.min(1.0, math.max(0.0, other_n1_clean / 82.0))

    -- Base N1 requirements from your Performance Table
    -- Collective 0% -> AEO: 82.0, OEI: 90.0
    -- Collective 100% -> AEO: 101.1, OEI: 104.5
    local base_flat = 90.0 - (effective_sharing * (90.0 - 82.0))
    local base_full = 104.5 - (effective_sharing * (104.5 - 101.1))
    local n1_table_target = base_flat + (collective_position / 100.0) * (base_full - base_flat)

    local adjusted_throttle = throttle_target
    if throttle_target >= 15.0 and throttle_target <= 45.0 then
        -- Stable Idle Zone
        adjusted_throttle = 45.0
    elseif throttle_target > 60.0 then
        -- DYNAMIC MAPPING: 100% Twist Grip = 100% of the Performance Table Target
        -- This eliminates the "Dead Gap" by aligning the lever with the Governor.
        local progress = (throttle_target - 60.0) / 40.0 
        adjusted_throttle = 60.0 + (progress * (n1_table_target - 60.0))
    end
    
    -- CASE 3: Engine Sustain and Safety Logic
    local current_n1 = (eng_index == 1) and current_n1_e1 or current_n1_e2
    
    if not starter_active and current_n1 < 40.0 then
        -- No starter and engine not yet self-sustaining (40% threshold)
        return 0.0
    end
    
    -- HUNG START SIMULATION
    -- If fuel is introduced before 12% N1, the engine hangs at ~18%
    if starter_active and fuel_allowed and current_n1 < 12.0 then
        return 18.0
    end
    
    -- CASE 4: PURE PERFORMANCE TABLE MAPPING (Hard Logic Only)
    -- This logic replaces the software governor entirely.
    
    local eff_target = math.min(adjusted_throttle, n1_table_target)
    
    -- Altitude Compensation (Synchropter)
    -- Thin air requires slightly higher N1 to maintain power
    if current_altitude >= 4000.0 and eff_target <= 80.0 then
        eff_target = eff_target + 3.0
    end
    
    -- Engine Overload (Droop) Penalty
    -- A PT6T-3B physically begins to stall (droop) heavily if pushed past 102% torque.
    local MAX_TORQUE_CAPACITY = 102.0
    -- [Torque Penalty Block Removed to enforce Pure Hard Logic]
    
    return eff_target
end

local function process_n1_spool(current_n1, target_n1)
    if math.abs(current_n1 - target_n1) < 0.1 then
        return target_n1
    end
    
    local rate_per_sec = SPOOL_RATE_LOW_RPM
    if current_n1 >= 60.0 then rate_per_sec = SPOOL_RATE_HIGH_RPM end
    
    local max_step = rate_per_sec * (TIMER_INTERVAL_MS / 1000.0)
    
    if current_n1 < target_n1 then
        current_n1 = current_n1 + max_step
        if current_n1 > target_n1 then current_n1 = target_n1 end
    elseif current_n1 > target_n1 then
        current_n1 = current_n1 - max_step
        if current_n1 < target_n1 then current_n1 = target_n1 end
    end
    return current_n1
end

local function get_base_itt(n1)
    if n1 <= 15.0 then return AMBIENT_TEMP end
    if n1 <= 60.0 then return AMBIENT_TEMP + ((n1 - 15.0) / 45.0) * (450.0 - AMBIENT_TEMP) end
    if n1 <= 100.0 then return 450.0 + ((n1 - 60.0) / 40.0) * (500.0 - 450.0) end
    return 500.0 + ((n1 - 100.0) / 5.0) * (810.0 - 500.0)
end

local function process_itt(current_itt, current_n1, fuel_allowed, starter_active, current_torque)
    local target_itt = get_base_itt(current_n1)
    
    -- Add Torque-based heat load (Engine working harder under aerodynamic load)
    -- Torque ranges 0-100%+. Adding ~4.0°C per percent of torque (e.g. 100% torque = +400°C ITT)
    if current_torque then
        target_itt = target_itt + (current_torque * 4.0)
    end
    
    -- Transient spike ONLY if there is combustion (fuel introduced)
    if fuel_allowed and current_n1 < 60.0 then
        if current_n1 < 12.0 then
            -- Hot start: Fuel introduced without sufficient cooling airflow
            target_itt = 1090.0
        else
            -- Normal start transient: Heat spike when ignition starts,
            -- which cools down as the compressor spins faster and pushes more air.
            local transient_heat = 0.0
            if current_n1 <= 25.0 then
                -- Ramp up to peak heat at 25% N1
                transient_heat = 650.0 * ((current_n1 - 12.0) / 13.0)
            else
                -- Fade out the heat spike as N1 climbs to 60% idle
                transient_heat = 650.0 * (1.0 - ((current_n1 - 25.0) / 35.0))
            end
            target_itt = target_itt + math.max(0, transient_heat)
        end
    end
    
    -- No combustion = no heat (fuel pooling in dead engine, no ignition)
    if fuel_allowed and not starter_active and current_n1 < 20.0 then
        -- Small allowance to drop ITT back to ambient if starter is released prematurely
        target_itt = AMBIENT_TEMP
    end
    
    -- Asymmetric thermal lag: heats up fast, cools down slowly
    local rate = (target_itt > current_itt) and ITT_HEAT_RATE or ITT_COOL_RATE
    local max_step = rate * (TIMER_INTERVAL_MS / 1000.0)
    
    if math.abs(current_itt - target_itt) <= max_step then
        return target_itt
    elseif current_itt < target_itt then
        return current_itt + max_step
    else
        return current_itt - max_step
    end
end

-- =============================================================================
-- OIL SYSTEMS PHYSICS
-- =============================================================================

local function calculate_engine_oil_psi(n1)
    if n1 < 10.0 then return 0.0 end
    if n1 < 60.0 then return 50.0 end
    return 115.0
end

local function process_engine_oil_temp(current_temp, n1, torque)
    local target_temp = AMBIENT_TEMP
    if n1 > 15.0 then
        target_temp = 70.0
    end
    
    local max_step = 0.5 * (TIMER_INTERVAL_MS / 1000.0)
    if math.abs(current_temp - target_temp) <= max_step then
        return target_temp
    elseif current_temp < target_temp then
        return current_temp + max_step
    else
        return current_temp - max_step
    end
end

local function calculate_xmsn_oil_psi(rotor_rpm)
    if rotor_rpm < 10.0 then return 0.0 end
    local psi = (rotor_rpm - 10.0) * 0.7
    return math.min(70.0, psi) 
end

local function calculate_cbox_oil_psi(n2_1, n2_2)
    local max_n2 = math.max(n2_1, n2_2)
    if max_n2 < 10.0 then return 0.0 end
    local psi = (max_n2 - 10.0) * 0.8
    return math.min(90.0, psi)
end

local function process_gearbox_temp(current_temp, is_spinning, torque)
    local target_temp = AMBIENT_TEMP
    if is_spinning then
        target_temp = 40.0 + (torque * 0.4)
    end
    
    local max_step = 0.5 * (TIMER_INTERVAL_MS / 1000.0)
    if math.abs(current_temp - target_temp) <= max_step then
        return target_temp
    elseif current_temp < target_temp then
        return current_temp + max_step
    else
        return current_temp - max_step
    end
end

local function process_n2_spool(current_n1)
    -- N2 (Power Turbine) freely spins but is linked to the rotor.
    -- At 60% N1 (Idle), N2 spins up to ~75% to lock the collective idle stops.
    -- At 100% N1, N2 matches the rotor RPM.
    if current_n1 < 15.0 then return 0.0 end
    
    local target_n2 = current_n1
    if current_n1 >= 60.0 then
        -- N2 is mechanically tied to our internal stable Rotor RPM
        target_n2 = math.max(75.0, current_nr)
    else
        -- Scaling up to 75% as N1 approaches 60%
        target_n2 = map_range(current_n1, 15.0, 60.0, 0.0, 75.0)
    end
    return target_n2
end

local function calculate_mast_torque()
    -- Base friction to keep transmission and blades spinning
    local base_friction = 15.0
    
    -- Induced drag from collective pitch (exponential curve)
    local collective_load = ((collective_position / 100.0) ^ 1.5) * 110.0
    
    -- Total torque is relative to rotor speed (no spin = no torque)
    local mast_torque = (base_friction + collective_load) * (rotor_rpm / 100.0)
    
    -- Only demand torque if the rotor is actually moving
    if rotor_rpm < 1.0 then return 0.0 end
    return mast_torque
end

local function calculate_engine_torque(mast_torque)
    local e1_alive = (current_n1_e1 >= 50.0)
    local e2_alive = (current_n1_e2 >= 50.0)
    
    local trq_e1 = 0.0
    local trq_e2 = 0.0
    
    -- Dual Engine Normal Operation
    if e1_alive and e2_alive then
        trq_e1 = mast_torque / 2.0
        trq_e2 = mast_torque / 2.0
        
    -- OEI (Engine 1 Survivor)
    elseif e1_alive and not e2_alive then
        trq_e1 = mast_torque
        
    -- OEI (Engine 2 Survivor)
    elseif not e1_alive and e2_alive then
        trq_e2 = mast_torque
    end
    
    return trq_e1, trq_e2
end

local function update_engine_physics()
    -- Update Beep Target
    if gov_beep_switch == 1 then
        gov_beep_target = math.min(103.0, gov_beep_target + 0.1)
    elseif gov_beep_switch == -1 then
        gov_beep_target = math.max(97.0, gov_beep_target - 0.1)
    end

    -- Calculate Aerodynamic Load (Torque) and N2
    local mast_torque = calculate_mast_torque()
    local trq_e1, trq_e2 = calculate_engine_torque(mast_torque)
    local n2_e1 = process_n2_spool(current_n1_e1)
    local n2_e2 = process_n2_spool(current_n1_e2)
    
    -- OEI Logic Flag
    local oei_e1 = (current_n1_e1 >= 50.0 and current_n1_e2 < 50.0)
    local oei_e2 = (current_n1_e2 >= 50.0 and current_n1_e1 < 50.0)
    
    fsx_variable_write("L:Trotor", "percent", mast_torque)
    fsx_variable_write("L:Eng1TQ", "percent", trq_e1)
    fsx_variable_write("L:Eng2TQ", "percent", trq_e2)
    
    -- Idle Stop states are now driven by collective.lua (Unlock) and axis handler (Lock)
    fsx_variable_write("L:Eng1N2", "percent", n2_e1)
    fsx_variable_write("L:Eng2N2", "percent", n2_e2)
    fsx_variable_write("L:OEIE1", "Bool", oei_e1)
    fsx_variable_write("L:OEIE2", "Bool", oei_e2)

    -- === ENGINE 1 (P3D Engine 2) ===
    local starter1_active = (starter_state == 1)
    local fuel1_allowed = is_fuel_allowed(1, target_n1_e1)
    
    sync_starter(1, starter1_active, sim_starter_e1)
    sync_fuel(1, fuel1_allowed, sim_fuel_valve_e1)
    
    -- If fuel is blocked (valve OFF / fire handle / cutoff), override target to 0
    local eff_throttle_1 = fuel1_allowed and target_n1_e1 or 0.0
    local eff_target_1 = get_effective_target_n1(1, eff_throttle_1, fuel1_allowed, trq_e1)
    local new_n1_1 = process_n1_spool(current_n1_e1, eff_target_1)
    local new_itt_1 = process_itt(current_itt_e1, new_n1_1, fuel1_allowed, starter1_active, trq_e1)
    
    local oil_psi_1 = calculate_engine_oil_psi(new_n1_1)
    current_oil_temp_e1 = process_engine_oil_temp(current_oil_temp_e1, new_n1_1, trq_e1)
    
    if new_n1_1 ~= current_n1_e1 then
        current_n1_e1 = new_n1_1
        fsx_variable_write("L:RPM N1 E1", "percent", current_n1_e1)
    end
    if new_itt_1 ~= current_itt_e1 then
        current_itt_e1 = new_itt_1
        fsx_variable_write("L:ITTE1", "celsius", current_itt_e1)
    end
    
    -- fsx_variable_write("L:OILE1", "psi", oil_psi_1)
    -- fsx_variable_write("L:OILE1T", "celsius", current_oil_temp_e1)
    
    -- Write fuel cutoff and master valve flags for other systems
    fsx_variable_write("L:FuelcutE1", "Bool", (target_n1_e1 < 3.0))
    fsx_variable_write("L:MvalveEng1", "Bool", fuel1_allowed)
    
    -- === ENGINE 2 (P3D Engine 3) ===
    local starter2_active = (starter_state == -1)
    local fuel2_allowed = is_fuel_allowed(2, target_n1_e2)
    
    sync_starter(2, starter2_active, sim_starter_e2)
    sync_fuel(2, fuel2_allowed, sim_fuel_valve_e2)
    
    -- If fuel is blocked (valve OFF / fire handle / cutoff), override target to 0
    local eff_throttle_2 = fuel2_allowed and target_n1_e2 or 0.0
    local eff_target_2 = get_effective_target_n1(2, eff_throttle_2, fuel2_allowed, trq_e2)
    local new_n1_2 = process_n1_spool(current_n1_e2, eff_target_2)
    local new_itt_2 = process_itt(current_itt_e2, new_n1_2, fuel2_allowed, starter2_active, trq_e2)
    
    local oil_psi_2 = calculate_engine_oil_psi(new_n1_2)
    current_oil_temp_e2 = process_engine_oil_temp(current_oil_temp_e2, new_n1_2, trq_e2)
    
    if new_n1_2 ~= current_n1_e2 then
        current_n1_e2 = new_n1_2
        fsx_variable_write("L:RPM N1 E2", "percent", current_n1_e2)
    end
    if new_itt_2 ~= current_itt_e2 then
        current_itt_e2 = new_itt_2
        fsx_variable_write("L:ITTE2", "celsius", current_itt_e2)
    end
    
    -- fsx_variable_write("L:OILE2", "psi", oil_psi_2)
    -- fsx_variable_write("L:OILE2T", "celsius", current_oil_temp_e2)
    
    -- Write fuel cutoff and master valve flags for other systems
    fsx_variable_write("L:FuelcutE2", "Bool", (target_n1_e2 < 3.0))
    fsx_variable_write("L:MvalveEng2", "Bool", fuel2_allowed)
    
    -- === TRANSMISSION & C-BOX PHYSICS ===
    local xmsn_psi = calculate_xmsn_oil_psi(rotor_rpm)
    current_xmsn_temp = process_gearbox_temp(current_xmsn_temp, (rotor_rpm > 10.0), mast_torque)
    fsx_variable_write("L:XMSN", "psi", xmsn_psi)
    fsx_variable_write("L:XMSNT", "celsius", current_xmsn_temp)
    
    local cbox_psi = calculate_cbox_oil_psi(n2_e1, n2_e2)
    current_gbox_temp = process_gearbox_temp(current_gbox_temp, (n2_e1 > 10.0 or n2_e2 > 10.0), mast_torque)
    fsx_variable_write("L:Gbox", "psi", cbox_psi)
    fsx_variable_write("L:GboxT", "celsius", current_gbox_temp)
    
    -- === MASTER ENGINE SYNC (BRIDGE TO P3D ENG 1) ===
    local e1_running = (current_n1_e1 >= 50.0)
    local e2_running = (current_n1_e2 >= 50.0)
    
    -- 0. CALCULATE INDEPENDENT ROTOR PHYSICS (NR)
    -- 1. Calculate "Engine Potential" (What speed the engine wants to provide)
    local function get_engine_potential(n1)
        if n1 < 15.0 then return 0.0 end
        if n1 >= 82.0 then
            -- Above the governed flat-pitch mark, the engine provides 100% NR potential
            return 100.0 
        elseif n1 >= 60.0 then
            -- Spooling from Flight Idle (75% NR) to Governed Flat Pitch (100% NR)
            return map_range(n1, 60.0, 82.0, 75.0, 100.0)
        else
            -- Spooling from 0 to Flight Idle (75% NR)
            return map_range(n1, 15.0, 60.0, 0.0, 75.0)
        end
    end

    local pot_n2_e1 = get_engine_potential(current_n1_e1)
    local pot_n2_e2 = get_engine_potential(current_n1_e2)
    local max_pot_n2 = math.max(pot_n2_e1, pot_n2_e2)

    -- 2. Rotor Target is now driven by the Engine Potential (Not a hardcoded 100)
    local target_nr = max_pot_n2
    
    -- Apply Droop Logic to the target if engines are at high power
    local max_n1 = math.max(current_n1_e1, current_n1_e2)
    local is_oei_active = (current_n1_e1 < 50.0 or current_n1_e2 < 50.0)
    
    if max_n1 > 0 then
        if is_oei_active then
            -- OEI Droop: If N1 > 98%, pull the NR target down
            if max_n1 > 98.0 then target_nr = max_pot_n2 - ((max_n1 - 98.0) * 1.5) end
        else
            -- AEO Droop: If N1 > 100%, pull the NR target down
            if max_n1 > 100.0 then target_nr = max_pot_n2 - ((max_n1 - 100.0) * 2.0) end
        end
    end

    -- 3. Update Visual N2 (Sprag Clutch Physics)
    -- If the engine power is lower than the rotor speed, the clutch overruns (Needle Split).
    -- If the rotor is slower than the engine, the engine is "bogged down" (Needles Married).
    local n2_e1 = math.min(pot_n2_e1, current_nr)
    local n2_e2 = math.min(pot_n2_e2, current_nr)

    -- 4. Apply Rotor Inertia (Spooling)
    local nr_rate = (current_nr < target_nr) and 3.0 or 1.5 -- 3%/s up, 1.5%/s down
    local nr_step = nr_rate * (TIMER_INTERVAL_MS / 1000.0)
    
    if math.abs(current_nr - target_nr) <= nr_step then
        current_nr = target_nr
    elseif current_nr < target_nr then
        current_nr = current_nr + nr_step
    else
        current_nr = current_nr - nr_step
    end
    
    -- Write to our "Boss" variable for external monitoring and gauges
    fsx_variable_write("L:RotorRPM_Target", "percent", current_nr)
    
    -- === SYNC LOOP (Optional Sync to Sim Physics) ===
    local nr_error = current_nr - rotor_rpm
    local sync_adjustment = nr_error * 2.0 
    
    -- Force simulator to follow our internal physics
    fsx_variable_write("ENG ROTOR RPM:1", "percent", current_nr)

    -- 1. Sync the highest demanding N1 to P3D Engine 1
    local master_n1_pct = math.max(
        e1_running and current_n1_e1 or 0.0,
        e2_running and current_n1_e2 or 0.0
    )
    
    -- Add the sync adjustment to the master power value
    local master_sim_val = math.floor(((master_n1_pct + sync_adjustment) / 100.0) * 16384)
    -- Allow up to 110% power command (18022) to support contingency N1 and NR droop
    master_sim_val = math.max(0, math.min(18022, master_sim_val))
    fsx_event("PROP_PITCH1_SET", master_sim_val)
    
    -- 2. Master Combustion Flag (If either engine is running with fuel, Master is rich)
    local master_combustion = (e1_running and fuel1_allowed) or (e2_running and fuel2_allowed)
    if master_combustion then
        fsx_variable_write("L:Combustionm", "Bool", true)
        fsx_event("MIXTURE1_RICH")
    else
        fsx_variable_write("L:Combustionm", "Bool", false)
        fsx_event("MIXTURE1_LEAN")
    end
end

-- Start the timer loop
timer_start(0, TIMER_INTERVAL_MS, update_engine_physics)

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