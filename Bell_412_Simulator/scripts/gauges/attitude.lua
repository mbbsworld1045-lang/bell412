img_add_fullscreen("attitude_background.png")
img_horizon = img_add_fullscreen("horizon.png")
img_circle = img_add_fullscreen("attitude_circle.png")
img_roll= img_add_fullscreen("attitude_center.png")
-- img_hoop = img_add_fullscreen("attitude_bar.png")
img_add_fullscreen("attitude_overlay.png")
warning_off_flag = img_add_fullscreen("warning_off.png")
function new_attitude_xpl(bus_volts, roll, pitch)

local power = bus_volts >= 8
    visible(warning_off_flag, bus_volts < 8)

    -- Roll outer ring
    rotate(img_roll, roll *-1)

    -- Roll horizon
    rotate(img_horizon  , roll * -1)
    -- rotate(img_roll  , roll * -1)

    -- Move horizon pitch
    pitch = var_cap(pitch, -20, 20)
    radial = math.rad(roll * -1)
    x = -(math.sin(radial) * pitch * 3.7)
    y = (math.cos(radial) * pitch * 3.7)
    move(img_horizon, x, y, nil, nil)
end

function new_attitude_fsx(bus_volts, roll, pitch)
    new_attitude_xpl(bus_volts, roll * -1, pitch * -1)
end


local hoop_adjust = 0
function dial_callback(direction)
    hoop_adjust = var_cap(hoop_adjust + direction, -34, 34)
    move(img_hoop, nil, hoop_adjust, nil, nil)
end

dial_add(nil, 216, 406, 80, 80, dial_callback)


fsx_variable_subscribe(
    "ELECTRICAL MAIN BUS VOLTAGE", "Volts",
    "ATTITUDE INDICATOR BANK DEGREES", "Degrees",
    "ATTITUDE INDICATOR PITCH DEGREES", "Degrees",
    new_attitude_fsx
)

