-- =============================================================================
-- SENDER: BELL 412 GAUGE ENCODER HUB
-- All hardware encoder inputs (Channel G) in one place.
-- Broadcasts values via si_variable to receiver gauge instruments.
-- =============================================================================

print("=== SI-VAR Encoder Sender Loading ===")

-- =============================================================================
-- 1. STATE VARIABLES
-- =============================================================================
local adi_cage    = 0    -- ADI cage knob (G:Var1), range -12 to +12
local adi_heading = 0    -- ADI heading knob (G:Var2), range -30 to +30
local hsi_bug     = 0    -- HSI heading bug, 0-359 degrees
local hsi_obs     = 0    -- HSI OBS/course needle, 0-359 degrees
local cdi_obs     = 0    -- CDI OBS compass ring, 0-359 degrees
local alt_bug     = 0    -- Altimeter bug, 0-20000 feet
local radalt_bug  = 0    -- Radar altimeter bug, 0-1500 feet

-- =============================================================================
-- 2. CREATE SI VARIABLES (broadcast channels)
-- =============================================================================
local si_adi_cage    = si_variable_create("si_adi_cage",    "INT", adi_cage)
local si_adi_heading = si_variable_create("si_adi_heading", "INT", adi_heading)
local si_hsi_bug     = si_variable_create("si_hsi_bug",     "INT", hsi_bug)
local si_hsi_obs     = si_variable_create("si_hsi_obs",     "INT", hsi_obs)
local si_cdi_obs     = si_variable_create("si_cdi_obs",     "INT", cdi_obs)
local si_alt_bug     = si_variable_create("si_alt_bug",     "INT", alt_bug)
local si_radalt_bug  = si_variable_create("si_radalt_bug",  "INT", radalt_bug)

-- =============================================================================
-- 3. ENCODER CALLBACKS
-- =============================================================================

-- ---- ADI: CAGE KNOB (Right Encoders on both ADI units) ----
local function adi_cage_callback(direction)
    adi_cage = adi_cage + direction
    adi_cage = var_cap(adi_cage, -12, 12)
    fsx_variable_write("L:ATT_CAGE_VAR", "Number", adi_cage)
    si_variable_write(si_adi_cage, adi_cage)
    print("SENDER ADI Cage: " .. adi_cage)
end

-- ---- ADI: HEADING KNOB (Left Encoders on both ADI units) ----
local function adi_heading_callback(direction)
    adi_heading = adi_heading + direction
    adi_heading = var_cap(adi_heading, -30, 30)
    fsx_variable_write("L:ATT_KNOB_VAR", "Number", adi_heading)
    si_variable_write(si_adi_heading, adi_heading)
    print("SENDER ADI Heading: " .. adi_heading)
end

-- ---- HSI: HEADING BUG (Right Encoders on both HSI units) ----
local function hsi_bug_callback(direction)
    hsi_bug = hsi_bug + (direction * 5)
    hsi_bug = hsi_bug % 360
    fsx_variable_write("AUTOPILOT HEADING LOCK DIR", "Degrees", hsi_bug)
    si_variable_write(si_hsi_bug, hsi_bug)
    print("SENDER HSI Bug: " .. hsi_bug)
end

-- ---- HSI: OBS/COURSE NEEDLE (Left Encoders on both HSI units) ----
local function hsi_obs_callback(direction)
    hsi_obs = hsi_obs + (direction * 5)
    hsi_obs = hsi_obs % 360
    fsx_variable_write("NAV OBS:1", "Degrees", hsi_obs)
    si_variable_write(si_hsi_obs, hsi_obs)
    print("SENDER HSI OBS: " .. hsi_obs)
end

-- ---- CDI: OBS COMPASS RING ----
local function cdi_obs_callback(direction)
    cdi_obs = cdi_obs + (direction * 5)
    cdi_obs = cdi_obs % 360
    -- Send VOR OBI events to sim
    if direction == -1 then
        fsx_event("VOR1_OBI_INC")
    elseif direction == 1 then
        fsx_event("VOR1_OBI_DEC")
    end
    si_variable_write(si_cdi_obs, cdi_obs)
    print("SENDER CDI OBS: " .. cdi_obs)
end


-- ---- ALTIMETER: KOLLSMAN (Baro) ----
local function alt_kollsman_callback(direction)
    if direction == 1 then
        fsx_event("KOHLSMAN_INC")
    elseif direction == -1 then
        fsx_event("KOHLSMAN_DEC")
    end
    print("SENDER Altimeter Baro Adjusted")
end

-- ---- RADAR ALTIMETER: BUG ----

local function radalt_bug_callback(direction)
    if direction == 1 then
        fsx_event("INCREASE_DECISION_HEIGHT")
        print("SENDER RadAlt Bug: Increased")
    elseif direction == -1 then
        fsx_event("DECREASE_DECISION_HEIGHT")
        print("SENDER RadAlt Bug: Decreased")
    end
end

-- =============================================================================
-- 4. HARDWARE BINDINGS (Channel G)
-- =============================================================================

-- ---- ADI Encoders ----
-- ADI Right - Right Encoder (Cage Knob): D52 & D17
hw_dial_add("ARDUINO_MEGA2560_G_D17", "ARDUINO_MEGA2560_G_D52", "TYPE_1_DETENT_PER_PULSE", adi_cage_callback)
-- ADI Right - Left Encoder (Heading Knob): D14 & A15
hw_dial_add("ARDUINO_MEGA2560_G_A15", "ARDUINO_MEGA2560_G_D14", "TYPE_1_DETENT_PER_PULSE", adi_heading_callback)
-- ADI Left - Right Encoder (Cage Knob): A6 & A2
hw_dial_add("ARDUINO_MEGA2560_G_A6", "ARDUINO_MEGA2560_G_A2", "TYPE_1_DETENT_PER_PULSE", adi_cage_callback)
-- ADI Left - Left Encoder (Heading Knob): D12 & A5
hw_dial_add("ARDUINO_MEGA2560_G_A5", "ARDUINO_MEGA2560_G_D12", "TYPE_1_DETENT_PER_PULSE", adi_heading_callback)

-- ---- HSI Encoders ----
-- HSI Right - Right Encoder (Heading Bug): A13 & A14
hw_dial_add("ARDUINO_MEGA2560_G_A14", "ARDUINO_MEGA2560_G_A13", "TYPE_1_DETENT_PER_PULSE", hsi_bug_callback)
-- HSI Right - Left Encoder (OBS Needle): D19 & A11
hw_dial_add("ARDUINO_MEGA2560_G_D19", "ARDUINO_MEGA2560_G_A11", "TYPE_1_DETENT_PER_PULSE", hsi_obs_callback)
-- HSI Left - Right Encoder (Heading Bug): A4 & D9
hw_dial_add("ARDUINO_MEGA2560_G_D9", "ARDUINO_MEGA2560_G_A4", "TYPE_1_DETENT_PER_PULSE", hsi_bug_callback)
-- HSI Left - Left Encoder (OBS Needle): D7 & D6 
hw_dial_add("ARDUINO_MEGA2560_G_D7", "ARDUINO_MEGA2560_G_D6", "TYPE_1_DETENT_PER_PULSE", hsi_obs_callback)

-- ---- CDI Encoder ----
-- CDI Right: D18 & A12
hw_dial_add("ARDUINO_MEGA2560_G_D18", "ARDUINO_MEGA2560_G_A12", "TYPE_1_DETENT_PER_PULSE", cdi_obs_callback)

-- ---- Altimeter Encoders ----
-- Alt Meter Right: D15 & D16
hw_dial_add("ARDUINO_MEGA2560_G_D15", "ARDUINO_MEGA2560_G_D16", "TYPE_1_DETENT_PER_PULSE", alt_kollsman_callback)
-- Alt Meter Left: A7 & D8
hw_dial_add("ARDUINO_MEGA2560_G_A7", "ARDUINO_MEGA2560_G_D8", "TYPE_1_DETENT_PER_PULSE", alt_kollsman_callback)

-- ---- Radar Altimeter Encoder ----
-- Radar Alt Right: D2 & D51
hw_dial_add("ARDUINO_MEGA2560_G_D2", "ARDUINO_MEGA2560_G_D51", "TYPE_1_DETENT_PER_PULSE", radalt_bug_callback)

print("=== SI-VAR Encoder Sender Loaded (12 encoders, 7 SI variables) ===")
