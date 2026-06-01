-- Bell 412 EP Airspeed indicator --
img_add_fullscreen("B412_Faceplate_ASI.png")
img_needle = img_add("B412_Gauge_ASI_Needle.png", 235, 95, 30, 310)
bezel_prop = user_prop_add_boolean("Show bezel", true, "Show the bezel or just the background")
if user_prop_get(bezel_prop) then
    -- img_add_fullscreen("B412_Housing.png")
end

function data_xpl(ASI)
    if ASI > 150 then
        ASI = 150
    end

    if ASI >= 50 then
        rotate (img_needle, 220/100 * (ASI - 50) + 122)
    elseif ASI >= 30 and ASI < 50 then
        rotate (img_needle, 86/20 * (ASI -30) + 36)
    elseif ASI >= 20 and ASI < 30 then
        rotate (img_needle, 28/10 * (ASI - 20) + 8)
    elseif ASI >= 0 and ASI < 20 then
        rotate (img_needle, 8/20 * (ASI - 0) + 0)
    end
end

--DataRef Subscriptions--
fsx_variable_subscribe("AIRSPEED INDICATED", "Knots", data_xpl)
