-- =============================================================================
-- BELL 412 - RADAR ALTIMETER GAUGE
-- Encoder: Channel G, Radar ALT Meter Right: D2 & D51
-- =============================================================================

-- =============================================================================
-- 1. IMAGES
-- =============================================================================
img_add_fullscreen("background.png")
img_add_fullscreen("radaraltimeter.png")
img_needle = img_add_fullscreen("radarneedle.png")
img_bug    = img_add_fullscreen("radarbug.png")
img_flag   = img_add_fullscreen("flag.png")

-- Flag hidden by default
visible(img_flag, false)

-- =============================================================================
-- 2. STATE
-- =============================================================================
local current_radiobug = 0

-- =============================================================================
-- 3. HELPER FUNCTIONS
-- =============================================================================

-- Convert altitude to degrees (non-linear scale matching real radar altimeter)
local function alt_to_degrees(altitude)
    if altitude <= 200 then
        -- Linear scale for 0-200 ft  (0° to 180°)
        return altitude * (180 / 200)
    elseif altitude <= 1500 then
        -- Compressed scale for 200-1500 ft  (180° to 297°)
        return 180 + ((altitude - 200) * (117 / 1300))
    else
        return 297
    end
end

-- Update the bug needle position
local function update_radiobug(value)
    value = var_cap(value, 0, 1500)
    rotate(img_bug, alt_to_degrees(value))
end

-- Update the altitude needle position
local function update_radioaltitude(altitude)
    altitude = var_cap(altitude, 0, 1500)
    rotate(img_needle, alt_to_degrees(altitude))
end

-- =============================================================================
-- 4. ENCODER INPUT (Channel G, Radar ALT Meter Right: D2 & D51)
-- =============================================================================
hw_dial_add("ARDUINO_MEGA2560_G_D2", "ARDUINO_MEGA2560_G_D51", "TYPE_1_DETENT_PER_PULSE", function(direction)
    if direction == 1 then
        current_radiobug = current_radiobug + 10
        print("Radar Alt Bug: CW  -> " .. current_radiobug .. " ft")
    elseif direction == -1 then
        current_radiobug = current_radiobug - 10
        print("Radar Alt Bug: CCW -> " .. current_radiobug .. " ft")
    end
    current_radiobug = var_cap(current_radiobug, 0, 1500)
    update_radiobug(current_radiobug)
end)

-- =============================================================================
-- 5. POWER FLAG LOGIC
-- =============================================================================
local function power_flag_callback(powerflag)
    if powerflag == true then
        visible(img_flag, false)
    else
        visible(img_flag, true)
    end
end

-- =============================================================================
-- 6. SIM DATA SUBSCRIPTIONS
-- =============================================================================
fsx_variable_subscribe("RADIO HEIGHT", "FEET", update_radioaltitude)
fsx_variable_subscribe("DECISION HEIGHT", "FEET", update_radiobug)
fsx_variable_subscribe("CIRCUIT AVIONICS ON", "BOOL", power_flag_callback)
