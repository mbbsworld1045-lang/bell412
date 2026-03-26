-- =============================================================================
-- RECEIVER: BELL 412 - CDI (Course Deviation Indicator) / VOR Gauge
-- Receives OBS encoder value via si_variable from Sender gauge
-- =============================================================================

-- USER PROPERTIES --
user_prop_source = user_prop_add_enum("Select the source for this instrument", "NAV1,NAV2", "NAV1", "You can select the navigational source, either NAV1 or NAV2.")
user_prop_backgr = user_prop_add_boolean("Background", false, "Show the black background with screws?")
user_prop_screws = user_prop_add_boolean("Screw set", true, "Show the screws or not?")

-- STATE --
local current_obs_position = 0

-- ADD IMAGES --
if user_prop_get(user_prop_backgr) then
    img_add_fullscreen("vorback.png")
else
    img_add_fullscreen("vorback_clear.png")
    if user_prop_get(user_prop_screws) then
        img_add_fullscreen("screwset.png")
    end
end
img_navflag = img_add_fullscreen("navflag.png", "visible:false")
img_gsflag  = img_add_fullscreen("gsflag.png",  "visible:false")
img_to      = img_add_fullscreen("to.png",  "visible:false")
img_fr      = img_add_fullscreen("fr.png",  "visible:false")
img_horbar  = img_add_fullscreen("horizontalbar.png")
img_verbar  = img_add_fullscreen("verticalbar.png")
img_mybug   = img_add_fullscreen("compassring.png")
img_add_fullscreen("compasspointers.png")
img_add_fullscreen("testbezel.png")

-- =============================================================================
-- SI VARIABLE SUBSCRIPTION (from Sender gauge)
-- =============================================================================
function on_cdi_obs_received(obs_val)
    current_obs_position = obs_val
    rotate(img_mybug, current_obs_position * -1)
end

si_variable_subscribe("si_cdi_obs", "INT", on_cdi_obs_received)

-- =============================================================================
-- SIM CALLBACKS
-- =============================================================================

-- OBS Heading from sim (keeps compass ring in sync)
function new_obsheading(obs1, obs2)
    local obs
    if user_prop_get(user_prop_source) == "NAV1" then
        obs = obs1
    elseif user_prop_get(user_prop_source) == "NAV2" then
        obs = obs2
    end
    current_obs_position = obs
    rotate(img_mybug, obs * -1)
end

-- Nav info (flags, to/from)
function new_info_fsx(tofromnav1, tofromnav2, glideslopeflag1, glideslopeflag2, avionics, backcourse, source_nav1)
    glideslopeflag1 = fif(glideslopeflag1, 0, 1)
    glideslopeflag2 = fif(glideslopeflag2, 0, 1)
    avionics = fif(avionics, 1, 0)
    backcourse = fif(backcourse, 1, 0)
    source_nav1 = fif(source_nav1, 2, 0)

    local tofromnav, glideslopeflag
    if user_prop_get(user_prop_source) == "NAV1" then
        tofromnav = tofromnav1
        glideslopeflag = glideslopeflag1
    elseif user_prop_get(user_prop_source) == "NAV2" then
        tofromnav = tofromnav2
        glideslopeflag = glideslopeflag2
    end

    visible(img_navflag, tofromnav == 0)
    visible(img_gsflag, glideslopeflag == 1)
    visible(img_to, tofromnav == 1)
    visible(img_fr, tofromnav == 2)
end

-- CDI/GS dots
function new_dots_fsx(vertical1, horizontal1, vertical2, horizontal2)
    local vertical  = 2 / 119 * fif(user_prop_get(user_prop_source) == "NAV1", vertical1, vertical2)
    local horizontal = 2 / 127 * fif(user_prop_get(user_prop_source) == "NAV1", horizontal1, horizontal2)

    move(img_horbar, (100 / 2 * horizontal) + 0, nil, nil, nil)
    move(img_verbar, nil, (100 / 2 * vertical) + 0, nil, nil)
end

-- =============================================================================
-- SIM SUBSCRIPTIONS
-- =============================================================================
fsx_variable_subscribe(
    "NAV OBS:1", "Degrees",
    "NAV OBS:2", "Degrees",
    new_obsheading
)

fsx_variable_subscribe(
    "NAV TOFROM:1", "Enum",
    "NAV TOFROM:2", "Enum",
    "NAV GS FLAG:1", "Bool",
    "NAV GS FLAG:2", "Bool",
    "CIRCUIT AVIONICS ON", "Bool",
    "AUTOPILOT BACKCOURSE HOLD", "Bool",
    "GPS DRIVES NAV1", "Bool",
    new_info_fsx
)

fsx_variable_subscribe(
    "NAV GSI:1", "Number",
    "NAV CDI:1", "Number",
    "NAV GSI:2", "Number",
    "NAV CDI:2", "Number",
    new_dots_fsx
)
