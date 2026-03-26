-- =============================================================================
-- BELL 412 - ALTIMETER GAUGE (Fixed)
-- Encoder: Channel G, Pin D2 & D51
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
-- 4. ENCODER INPUTS (Channel G)
--    Alt Meter Right: D15 & D16
--    Alt Meter Left:  A7  & D8
-- =============================================================================

-- Shared callback for both encoders (both control the same bug)
local function bug_dial_callback(direction)
    if direction == 1 then
        current_bug_position = current_bug_position + 50
        print("Altimeter Bug: CW  -> " .. current_bug_position .. " ft")
    elseif direction == -1 then
        current_bug_position = current_bug_position - 50
        print("Altimeter Bug: CCW -> " .. current_bug_position .. " ft")
    end
    current_bug_position = var_cap(current_bug_position, 0, 20000)
    update_bug()
end

-- Alt Meter Right Encoder
hw_dial_add("ARDUINO_MEGA2560_G_D15", "ARDUINO_MEGA2560_G_D16", "TYPE_1_DETENT_PER_PULSE", bug_dial_callback)

-- Alt Meter Left Encoder
hw_dial_add("ARDUINO_MEGA2560_G_A7", "ARDUINO_MEGA2560_G_D8", "TYPE_1_DETENT_PER_PULSE", bug_dial_callback)

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
