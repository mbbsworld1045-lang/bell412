-- =============================================================================
-- RECEIVER: BELL 412 - HSI (Horizontal Situation Indicator)
-- Receives encoder values via si_variable from Sender gauge
-- =============================================================================

-- USER PROPERTIES --
gyro_spinup_prop_time = user_prop_add_integer("Spin up duration", 1, 60, 15, "Time in seconds before electric gyro is at full speed when master switch has been switched on (default 10-15 seconds)")

-- GLOBAL VARIABLES --
local gbl_spin_up_lvl = 0
local cdi_dots = 0
local current_bug = 0
local current_obs = 0
local timer_spin_up = nil
local timer_spin_down = nil

-- PERSISTENCE --
prs_heading = persist_add("heading", 0)

-- GRAPHICS --
img_add_fullscreen("1. HSI_background frame.png")
imgheading = img_add_fullscreen("2. HSI_background.png")
Powerflag = img_add_fullscreen("3. Power Failure Warning Indication.png")
img_rose = img_add_fullscreen("4. HSI_compas rose.png")
rotate(img_rose, persist_get(prs_heading))

img_needle = img_add_fullscreen("6.HSI_Needle arrow.png")
Alarmflag = img_add_fullscreen("14. Alarm Flag.png")
img_cntr_to = img_add_fullscreen("7. HSI_to flag.png", "visible:false")
img_cntr_from = img_add_fullscreen("8. HSI_from flag.png", "visible:false")
img_cntr = img_add_fullscreen("9. HSI_loc scale.png")
img_cntr_needle = img_add_fullscreen("10. HSI_Needle center.png")
img_nav_flag = img_add_fullscreen("11 . Relative Bearing (Radio 2).png")
img_hdg_flag = img_add_fullscreen("12. Relative Bearing (Radio 1).png")
img_add_fullscreen("13. Fixed Glideslope Deviation Scale.png")
img_add_fullscreen("15. HSI_Bezel ext.png")
DisplacementWarningFlag = img_add_fullscreen("16. GlideSlope_Displacemnet_Flag.png")
img_gls_markers = img_add_fullscreen("17. HSI_ILS.png")
img_bug = img_add_fullscreen("5. HSI_headingbug.png")

-- Heading display text
mytext1 = txt_add("360", "font:digital-7 (italic).ttf; size:40; color: White; halign:left;", 675, 188, 300, 300)

-- =============================================================================
-- SI VARIABLE SUBSCRIPTIONS (from Sender gauge)
-- =============================================================================

-- Heading Bug received from sender
function on_hsi_bug_received(bug_val)
    current_bug = bug_val
    rotate(img_bug, current_bug, "LINEAR", 0.1)
end

-- OBS/Course Needle received from sender
function on_hsi_obs_received(obs_val)
    current_obs = obs_val
    rotate(img_needle, current_obs, "LINEAR", 0.1)
    rotate(img_cntr_needle, current_obs, "LINEAR", 0.1)
    rotate(img_cntr, current_obs, "LINEAR", 0.1)
    rotate(img_cntr_to, current_obs, "LINEAR", 0.1)
    rotate(img_cntr_from, current_obs, "LINEAR", 0.1)
end

-- si_variable_subscribe("si_hsi_bug", "INT", on_hsi_bug_received)
-- si_variable_subscribe("si_hsi_obs", "INT", on_hsi_obs_received)

-- =============================================================================
-- SIM DATA CALLBACK
-- =============================================================================
function new_data_fsx(bus_volts, heading, obs, to_from, gsi_dots, gsi_signal, cdi_dots_value, nav_signal, ap_heading, time_seconds, radio1_bearing, radio2_bearing)
    cdi_dots = cdi_dots_value

    -- Update heading bug position
    current_bug = ap_heading
    rotate(img_bug, current_bug - heading + 90, "LINEAR", 0.1, "FASTEST")

    -- Update OBS needle position
    current_obs = obs
    rotate(img_needle, -heading + current_obs, "LINEAR", 0.1, "FASTEST")
    rotate(img_cntr_needle, -heading + current_obs, "LINEAR", 0.1, "FASTEST")

    -- To/from flags and localizer scale
    rotate(img_cntr_to, -heading + current_obs, "LINEAR", 0.1, "FASTEST")
    rotate(img_cntr_from, -heading + current_obs, "LINEAR", 0.1, "FASTEST")
    rotate(img_cntr, -heading + current_obs, "LINEAR", 0.1, "FASTEST")

    -- Course deviation
    cdi_dots = 2.5 / 127 * cdi_dots
    local dh = cdi_dots * 32 * math.cos((-heading + current_obs) * math.pi / 180)
    local dv = cdi_dots * 32 * math.sin((-heading + current_obs) * math.pi / 180)
    move(img_cntr_needle, 0 + dh, 0 + dv, nil, nil, "LOG", 0.5)

    -- Power management
    local power = bus_volts >= 8
    visible(Powerflag, bus_volts < 8)

    -- Alarm Flag visibility
    local invalid_deviation = not cdi_dots or not gsi_signal
    visible(Alarmflag, invalid_deviation)

    -- Gyro spin up/down cycles
    if power and not timer_running(timer_spin_up) then
        timer_stop(timer_spin_down)
        timer_spin_up = timer_start(nil, 1000, function(count)
            gbl_spin_up_lvl = var_cap(gbl_spin_up_lvl + (1 / user_prop_get(gyro_spinup_prop_time)), 0, 1)
        end)
    elseif not power and not timer_running(timer_spin_down) then
        timer_stop(timer_spin_up)
        timer_spin_down = timer_start(nil, 1000, function(count)
            gbl_spin_up_lvl = var_cap(gbl_spin_up_lvl - ((1 / user_prop_get(gyro_spinup_prop_time)) / 5), 0, 1)
        end)
    end

    -- HDG flag
    if power and gbl_spin_up_lvl == 1 then
        rotate(img_hdg_flag, 40, "LINEAR", 0.1)
    else
        rotate(img_hdg_flag, 0, "LINEAR", 0.1)
    end

    -- Compass rose rotation
    if gbl_spin_up_lvl < 1 and gbl_spin_up_lvl > 0 then
        rotate(img_rose, heading * -1, "LINEAR", gbl_spin_up_lvl ^ 10 / 10, "FASTEST")
        persist_put(prs_heading, heading * -1)
    elseif gbl_spin_up_lvl == 1 then
        rotate(img_rose, heading * -1)
    end

    -- Rotate HSI background according to heading
    rotate(imgheading, heading * -1)
    rotate(Alarmflag, heading * -1)

    -- NAV flag
    if power and gbl_spin_up_lvl == 1 and nav_signal then
        rotate(img_nav_flag, -40, "LINEAR", 0.1)
    else
        rotate(img_nav_flag, 0, "LINEAR", 0.1)
    end

    -- To/from flags visibility
    visible(img_cntr_to, to_from == 1)
    visible(img_cntr_from, to_from == 2)
    visible(img_cntr, to_from == 0)

    -- Glide slope
    gsi_dots = 2.5 / 96 * gsi_dots
    local displacement_threshold = 2.8

    if power and gsi_signal then
        move(img_gls_markers, nil, 10 + (81 / 2 * gsi_dots), nil, nil, "LOG", 0.05)
        visible(DisplacementWarningFlag, math.abs(gsi_dots) > displacement_threshold)
    else
        if gsi_dots == 0 then
            move(img_gls_markers, nil, 100, nil, nil, "LOG", 0.05)
        elseif gsi_dots < 0 then
            move(img_gls_markers, nil, 100 + (81 / 2 * gsi_dots * 1.5), nil, nil, "LOG", 0.05)
        else
            move(img_gls_markers, nil, 100 + (81 / 2 * gsi_dots), nil, nil, "LOG", 0.05)
        end

        if not gsi_signal then
            move(img_gls_markers, nil, -800, nil, nil, "LOG", 0.05)
        end
        visible(DisplacementWarningFlag, false)
    end

    -- Relative Bearings
    rotate(img_nav_flag, radio1_bearing + 30, "LINEAR", 0.1)
    rotate(img_hdg_flag, radio2_bearing - 30, "LINEAR", 0.1)

    -- Update heading display
    local heading_text = string.format("%03d", math.floor(heading))
    txt_set(mytext1, heading_text)
end

-- =============================================================================
-- SIM DATA SUBSCRIPTION
-- =============================================================================
fsx_variable_subscribe(
    "ELECTRICAL MAIN BUS VOLTAGE", "Volts",
    "HEADING INDICATOR", "Degrees",
    "NAV OBS:1", "Degrees",
    "HSI TF FLAGS", "Enum",
    "HSI GSI NEEDLE", "Number",
    "HSI GSI NEEDLE VALID", "Bool",
    "HSI CDI NEEDLE", "Number",
    "HSI CDI NEEDLE VALID", "Bool",
    "AUTOPILOT HEADING LOCK DIR", "Degrees",
    "LOCAL TIME", "Seconds",
    "NAV RELATIVE BEARING TO STATION:1", "Degrees",
    "NAV RELATIVE BEARING TO STATION:2", "Degrees",
    new_data_fsx
)
