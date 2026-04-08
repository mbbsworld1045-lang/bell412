-- =============================================================================
-- RECEIVER: BELL 412 - ADI (Attitude Direction Indicator)
-- Receives encoder values via si_variable from Sender gauge
-- =============================================================================

-- =============================================================================
-- 1. USER PROPERTIES
-- =============================================================================
user_prop_source = user_prop_add_enum("Select the source for this instrument", "NAV1,NAV2,HSI", "HSI", "You can select the HSI which is usually NAV1 or GPS, or select a different source.")

-- =============================================================================
-- 2. IMAGES
-- =============================================================================
img_horizon       = img_add_fullscreen("horizon.png")
img_add_fullscreen("inner_frame.png")
img_fd_vertical   = img_add_fullscreen("fd_vertical.png")
img_fd_horizontal = img_add_fullscreen("fd_horizontal.png")
img_ring          = img_add_fullscreen("bank_pointer.png")
img_add_fullscreen("gp.png")
img_att_flag      = img_add_fullscreen("ATT_flag.png")
img_fd_flag       = img_add_fullscreen("FD_flag.png")
img_gs_flag       = img_add_fullscreen("GS_flag.png")
img_rt_flag       = img_add_fullscreen("RT_Flag.png")
img_gs_needle     = img_add_fullscreen("GS_needle.png")
img_loc_needle    = img_add_fullscreen("loc_needle.png")
img_add_fullscreen("outer_frame.png")
img_slip_back     = img_add_fullscreen("side_slip_backdrop.png")
img_slip_glass    = img_add_fullscreen("side_slip_glass.png")
img_slip_ball     = img_add_fullscreen("side_slip_ball.png")

-- =============================================================================
-- 3. SI VARIABLE SUBSCRIPTIONS (from Sender gauge)
-- =============================================================================

-- Cage knob -> moves aircraft symbol vertically (pitch trim)
function on_cage_received(gvar1_val)
    move(img_fd_horizontal, nil, gvar1_val * -5, nil, nil)
end

-- Heading knob -> rotates bank pointer offset
function on_heading_received(gvar2_val)
    rotate(img_ring, gvar2_val)
end

si_variable_subscribe("si_adi_cage",    "INT", on_cage_received)
si_variable_subscribe("si_adi_heading", "INT", on_heading_received)

-- =============================================================================
-- 4. ATTITUDE DISPLAY LOGIC
-- =============================================================================
function PT_atitude_xpl(roll, pitch, slip, APmode, GS_1, GS_2, GS_hsi, LC_1, LC_2, LC_hsi, glide_1, glide_2, glide_hsi, loc_1, loc_2, loc_hsi, ADIfail, FDpitch, FDroll)

    -- Select NAV source
    if user_prop_get(user_prop_source) == "NAV1" then
        GS = GS_1; LC = LC_1; glide = glide_1; loc = loc_1
    elseif user_prop_get(user_prop_source) == "NAV2" then
        GS = GS_2; LC = LC_2; glide = glide_2; loc = loc_2
    elseif user_prop_get(user_prop_source) == "HSI" then
        GS = GS_hsi; LC = LC_hsi; glide = glide_hsi; loc = loc_hsi
    end

    -- Roll outer ring
    rotate(img_ring, roll * -1)

    -- Roll horizon
    rotate(img_horizon, roll * -1)

    -- Pitch horizon
    pitch = var_cap(pitch, -50, 50)
    local radial = math.rad(roll * -1)
    local x = -(math.sin(radial) * pitch * 3.85)
    local y = (math.cos(radial) * pitch * 3.85)
    move(img_horizon, x, y, nil, nil)

    -- Slip ball
    slip = var_cap(slip * 10, -69, 69)
    local tube_width = 70
    local vertical_offset = -7
    local ball_position = -slip
    if slip == 0 then vertical_offset = 0 end
    ball_position = var_cap(ball_position, -tube_width, tube_width)
    move(img_slip_ball, ball_position, vertical_offset, nil, nil)

    -- Flight Director Horizontal (pitch)
    if APmode < 1 then
        move(img_fd_horizontal, nil, 400, nil, nil)
    else
        move(img_fd_horizontal, nil, (FDpitch - pitch) * -3, nil, nil)
    end

    -- Flight Director Vertical (roll)
    if APmode < 1 then
        move(img_fd_vertical, 400, nil, nil, nil)
    else
        move(img_fd_vertical, (FDroll - roll) * 3, nil, nil, nil)
    end

    -- FD flag
    if APmode >= 1 then
        move(img_fd_flag, -130, nil, nil, nil)
    else
        move(img_fd_flag, 1, nil, nil, nil)
    end

    -- RT flag
    if GS == 0 then
        move(img_rt_flag, nil, 180, nil, nil)
    else
        move(img_rt_flag, nil, 1, nil, nil)
    end

    -- GS flag
    if GS == 0 then
        move(img_gs_flag, nil, 290, nil, nil)
    else
        move(img_gs_flag, nil, 1, nil, nil)
    end

    -- ATT flag
    if ADIfail < 1 then
        move(img_att_flag, -150, nil, nil, nil)
    else
        move(img_att_flag, -1, nil, nil, nil)
    end

    -- GS needle
    glide = var_cap(glide, -2.5, 2.5)
    local dm = glide * 32
    if GS < 1 then
        move(img_gs_needle, nil, -100, nil, nil)
    else
        move(img_gs_needle, nil, dm * 1.23, nil, nil)
    end

    -- LOC needle
    loc = var_cap(loc, -3, 3)
    local lm = loc * 32
    move(img_loc_needle, lm * 0.90, nil, nil, nil)
    if LC < 1 then
        move(img_loc_needle, -120, nil, nil, nil)
    else
        move(img_loc_needle, nil, 1, nil, nil)
    end
end

-- =============================================================================
-- 5. FSX/MSFS CALLBACK WRAPPER
-- =============================================================================
function PT_atitude_fsx(roll, pitch, slip, f_director, gs_flag_1, gs_flag_2, gs_flag_hsi, cdi_flag_1, cdi_flag_2, cdi_flag_hsi, gsi_1, gsi_2, gsi_hsi, cdi_1, cdi_2, cdi_hsi, adi_fail, fd_pitch, fd_roll)
    f_director   = fif(f_director, 1, 0)
    gs_flag_1    = fif(gs_flag_1, 1, 0)
    gs_flag_2    = fif(gs_flag_2, 1, 0)
    gs_flag_hsi  = fif(gs_flag_hsi, 0, 1)
    cdi_flag_1   = fif(cdi_flag_1, 1, 0)
    cdi_flag_2   = fif(cdi_flag_2, 1, 0)
    cdi_flag_hsi = fif(cdi_flag_hsi, 1, 0)

    gsi_1   = 2.5 / 119 * gsi_1
    gsi_2   = 2.5 / 119 * gsi_2
    gsi_hsi = 2.5 / 119 * gsi_hsi
    cdi_1   = 2.5 / 127 * cdi_1
    cdi_2   = 2.5 / 127 * cdi_2
    cdi_hsi = 2.5 / 127 * cdi_hsi

    adi_fail = var_cap(adi_fail, 0, 1)

    PT_atitude_xpl(roll * -1, pitch * -1, slip * -230, f_director, gs_flag_1, gs_flag_2, gs_flag_hsi, cdi_flag_1, cdi_flag_2, cdi_flag_hsi, gsi_1, gsi_2, gsi_hsi, cdi_1, cdi_2, cdi_hsi, adi_fail, fd_pitch * -1, fd_roll * -1)
end

-- =============================================================================
-- 6. SIM DATA SUBSCRIPTION
-- =============================================================================
fsx_variable_subscribe(
    "PLANE BANK DEGREES", "Degrees",
    "PLANE PITCH DEGREES", "Degrees",
    "INCIDENCE BETA", "Radians",
    "AUTOPILOT FLIGHT DIRECTOR ACTIVE", "Bool",
    "NAV GS FLAG:1", "Bool",
    "NAV GS FLAG:2", "Bool",
    "HSI GSI NEEDLE VALID", "Bool",
    "NAV HAS NAV:1", "Bool",
    "NAV HAS NAV:2", "Bool",
    "HSI CDI NEEDLE VALID", "Bool",
    "NAV GSI:1", "Number",
    "NAV GSI:2", "Number",
    "HSI GSI NEEDLE", "Number",
    "NAV CDI:1", "Number",
    "NAV CDI:2", "Number",
    "HSI CDI NEEDLE", "Number",
    "PARTIAL PANEL ATTITUDE", "Enum",
    "AUTOPILOT FLIGHT DIRECTOR PITCH", "Degrees",
    "AUTOPILOT FLIGHT DIRECTOR BANK", "Degrees",
    PT_atitude_fsx
)
