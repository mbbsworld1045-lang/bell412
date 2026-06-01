-- =============================================================================
-- RECEIVER: BELL 412 - RADAR ALTIMETER GAUGE
-- Listens directly to Prepar3D/FSX variables (No SI variables needed)
-- =============================================================================

-- =============================================================================
-- 1. IMAGES
-- =============================================================================
img_add_fullscreen("background.png")
img_add_fullscreen("radaraltimeter.png")
img_dh_light = img_add_fullscreen("dh_light.png") -- NEW: Added DH Warning Light
img_needle   = img_add_fullscreen("radarneedle.png")
img_bug      = img_add_fullscreen("radarbug.png")
img_flag     = img_add_fullscreen("flag.png")

-- Default visibilities
visible(img_flag, false)
visible(img_dh_light, false)

-- =============================================================================
-- 2. NON-LINEAR SCALE (Extracted from B412 XML)
-- =============================================================================
-- Air Manager will automatically calculate smooth movement between these points
local alt_scale = {
    {  0,     0   },
    { 50,    45   },
    { 100,   85.7 },
    { 150,  132.4 },
    { 200,  180   },
    { 300,  189   },
    { 500,  207.2 },
    { 1000, 250.8 },
    { 1500, 294   },
    { 1600, 327   }
}

-- The missing custom interpolation function
function interpolate(tbl, value)
    local last_val = tbl[1][1]
    local last_deg = tbl[1][2]
    
    -- If value is below or equal to our lowest point, return lowest degree
    if value <= last_val then return last_deg end
    
    -- Loop through the table to find where our value fits
    for i = 2, #tbl do
        local next_val = tbl[i][1]
        local next_deg = tbl[i][2]
        
        if value <= next_val then
            -- Calculate the smooth fraction between the two points
            local fraction = (value - last_val) / (next_val - last_val)
            return last_deg + (fraction * (next_deg - last_deg))
        end
        
        last_val = next_val
        last_deg = next_deg
    end
    
    -- If value is above our highest point, return highest degree
    return last_deg
end

-- =============================================================================
-- 3. MASTER UPDATE FUNCTION
-- =============================================================================
local function update_radalt(radio_height, decision_height, bus_volts, test_mode)
    
    -- A. CAP VARIABLES
    -- Ensure values don't break the interpolation table
    radio_height = var_cap(radio_height, 0, 1600)
    decision_height = var_cap(decision_height, 0, 1500)

    -- B. POWER & FLAG LOGIC
    if bus_volts > 0 then
        visible(img_flag, false)
        
        -- If the test button is pressed, force the needle to read 100ft higher
        if test_mode == true then
            radio_height = radio_height + 100
        end
    else
        -- If power is off, show the flag and park the needle off-scale
        visible(img_flag, true)
        radio_height = 1600 
    end

    -- C. ROTATE NEEDLE & BUG
    rotate(img_needle, interpolate(alt_scale, radio_height))
    rotate(img_bug, interpolate(alt_scale, decision_height))

    -- D. DECISION HEIGHT WARNING LIGHT LOGIC
    -- Light turns on if powered AND (we are below DH OR the test button is pushed)
    if bus_volts > 0 and (radio_height <= decision_height or test_mode == true) then
        visible(img_dh_light, true)
    else
        visible(img_dh_light, false)
    end

end

-- =============================================================================
-- 4. SIM DATA SUBSCRIPTION
-- =============================================================================
-- We combine all variables into one master subscription so they update together in sync
fsx_variable_subscribe(
    "RADIO HEIGHT", "FEET",
    "DECISION HEIGHT", "FEET",
    "ELECTRICAL MAIN BUS VOLTAGE", "Volts",
    "L:Testradaralt", "BOOL",
    update_radalt
)