-- =============================================================================
-- RECEIVER: BELL 412 - RADAR ALTIMETER GAUGE
-- Receives bug encoder value via si_variable from Sender gauge
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
-- 2. HELPER FUNCTIONS
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

-- Update the altitude needle position
local function update_radioaltitude(altitude)
    altitude = var_cap(altitude, 0, 1500)
    rotate(img_needle, alt_to_degrees(altitude))
end

-- =============================================================================
-- 3. SI VARIABLE SUBSCRIPTION (from Sender gauge)
-- =============================================================================
function on_radalt_bug_received(bug_val)
    bug_val = var_cap(bug_val, 0, 1500)
    rotate(img_bug, alt_to_degrees(bug_val))
end

si_variable_subscribe("si_radalt_bug", "INT", on_radalt_bug_received)

-- =============================================================================
-- 4. POWER FLAG LOGIC
-- =============================================================================
local function power_flag_callback(powerflag)
    if powerflag == true then
        visible(img_flag, false)
    else
        visible(img_flag, true)
    end
end

-- =============================================================================
-- 5. SIM DATA SUBSCRIPTIONS
-- =============================================================================
fsx_variable_subscribe("RADIO HEIGHT", "FEET", update_radioaltitude)
fsx_variable_subscribe("DECISION HEIGHT", "FEET", function(dh)
    dh = var_cap(dh, 0, 1500)
    rotate(img_bug, alt_to_degrees(dh))
end)
fsx_variable_subscribe("CIRCUIT AVIONICS ON", "BOOL", power_flag_callback)
