--B412EP #1 Hydraulic oil temp & Px--
--For use with X-Trident B412EP only--
--Px side of gauge runs with either AC1 or AC2 power--
--Temp side of gauge runs with either DC1 or DC2 power--
--I have modified the data to give a more realistic oil Temp & Px--


--Variables--
local a = -20
local cur_px = -20
local tgt_px = 0
local b = 20
local cur_temp = 20
local tgt_temp = 0
local factor = 0.09


--Add images--
-- img_add_fullscreen("Hyd1Backplate.png")
img_add("Hyd_Oil_Temp_&_Px_gauge_faceplate.png", 25, 25, 250, 250)
-- img_add("Hyd_Oil_Temp_&_Px_gauge_1_bezel.png", 25, 25, 250, 250)
img_needle_1 = img_add("Gauge_needle_1.png", 100.5, 80, 50, 140)
img_needle_2 = img_add("Gauge_needle_2.png", 149.5, 80, 50, 140)
img_add("Gauge_centre.png", 25, 25, 250, 250)


--Get data for needle--
function data(px, temp, ac1, ac2, dc1, dc2)

    --Set to run px on/off AC power--
    if ac1==0 and ac2==0 then
    tgt_px = 0
    else
    tgt_px = px
    end
    
    --Set to run temp on/off DC power--
    if dc1==0 and dc2==0 then
    tgt_temp = -0.5
    else
    tgt_temp = temp
    end
    
    --Maths for oil pressure--
    if tgt_px >982.1 then
    a = (23.333/230.78 * (-tgt_px + 982.1)- 110.667 )
    elseif tgt_px >=0 then
    a = (88/982.1 * (-tgt_px)-22)
    end

    --Maths for oil temp--
    if tgt_temp >275.0 then
    b = (14/85 * (tgt_temp - 275) + 118)
    elseif tgt_temp >= 175.0 then
    b = (7/100 * (tgt_temp - 175) + 111)
    elseif tgt_temp >= 50.0 then
    b = (90/125 * (tgt_temp - 50) + 90)
    elseif tgt_temp >= 0.0 then
    b = (42/60 * (tgt_temp) + 55)
    elseif tgt_temp >= -50.0 then
    b = (35/50 * (tgt_temp +50) + 20)
    end
    
end


--Animate needles--
function timer_callback()

    --Rotate oil pressure needle--
    rotate (img_needle_2, cur_px)
    cur_px = cur_px + ((a - cur_px) * factor)

    --Rotate oil temp needle--    
    cur_temp = cur_temp + ((b - cur_temp) * factor)
    rotate (img_needle_1, cur_temp)

end


--Timer start--
tmr_blink = timer_start(0, 50, timer_callback)


--DataRef Subscriptions--

fsx_variable_subscribe("L:HYDRS1","psi",
                        "L:HYDRT","celsius",
                        "ELECTRICAL MAIN BUS VOLTAGE", "Volts",
                        "ELECTRICAL MAIN BUS VOLTAGE", "Volts",                        
                        "ELECTRICAL MAIN BUS VOLTAGE", "Volts",
                        "ELECTRICAL MAIN BUS VOLTAGE", "Volts",
                       data)                             
                      