-- =============================================================================
-- RECEIVER: BELL 412 - ALTIMETER GAUGE (Fixed)
-- Receives bug encoder value via si_variable from Sender gauge
-- =============================================================================

-- =============================================================================
-- 1. IMAGES
-- =============================================================================
img_add_fullscreen("bgBazel.png")
img_mybug   = img_add("kohl_dial_dy.png", 0, 0, 800, 800)
back_dy     = img_add_fullscreen("face_dy.png")
mb_dial_dy  = img_add_fullscreen("mb-dy.png")
dmil_dy     = img_add("10K_dy.png", 0, 0, 800, 800)
mil_dy      = img_add("1K_dy.png", 0, 0, 800, 800)
cent_dy     = img_add("100s_dy.png", 0, 0, 800, 800)

-- =============================================================================
-- 2. STATE
-- =============================================================================
local current_bug_position = 0

-- =============================================================================
-- 3. HELPER FUNCTIONS
-- =============================================================================

-- Convert altitude (feet) to dial degrees (360° per 1500 ft)
local function alt_to_degrees(altitude)
    return altitude * (360 / 1500)
end

-- Update the bug needle to match the current bug position
local function update_bug()
    local degrees = alt_to_degrees(current_bug_position)
    rotate(img_mybug, degrees)
    rotate(mb_dial_dy, degrees)
end

-- =============================================================================
-- 4. SI VARIABLE SUBSCRIPTION (replaces hw_dial_add encoders)
--    Alt Meter Right: D15 & D16  -> now via si_variable
--    Alt Meter Left:  A7  & D8   -> now via si_variable
-- =============================================================================
function on_alt_bug_received(bug_val)
    current_bug_position = bug_val
    update_bug()
end

si_variable_subscribe("si_alt_bug", "INT", on_alt_bug_received)

-- =============================================================================
-- 5. SIM DATA CALLBACK
-- =============================================================================
local function altitude_callback(light_cond, alt, baro)
    baro = var_cap(baro, 28.10, 31.00)

    -- Calculate dial positions from altitude
    local dmil_set = (alt / 10000) * 36
    local mil_set  = ((alt - math.floor(alt / 10000) * 10000) / 1000) * 36
    local cent_set = (alt - math.floor(alt / 10000) * 10000) * 0.36

    -- Rotate baro-linked elements
    local baro_offset = (baro - 28.1) * -120
    rotate(img_mybug,  baro_offset, "LOG", 0.05)
    rotate(mb_dial_dy, baro_offset, "LOG", 0.05)

    -- Rotate altitude needles
    rotate(dmil_dy, dmil_set, "LOG", 0.05, "FASTEST")
    rotate(mil_dy,  mil_set,  "LOG", 0.05, "FASTEST")
    rotate(cent_dy, cent_set, "LOG", 0.05, "FASTEST")
end

-- Subscribe to simulator data
fsx_variable_subscribe(
    "AUTOPILOT FLIGHT DIRECTOR ACTIVE", "Bool",
    "Indicated Altitude", "feet",
    "Kohlsman setting hg", "inHg",
    altitude_callback
)
