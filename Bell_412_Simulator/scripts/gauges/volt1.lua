--B412EP Voltmeter #1--
--For use with X-Trident B412EP only--
--AC voltmeter runs off AC1--
--DC voltmeter runs off DC1--


--Variables--
local cur_ac1 = 100
local tgt_ac1 = 100
local cur_dc1 = 15
local tgt_dc1 = 0
local factor = 0.09


--Add images--
-- img_add_fullscreen("VoltmeterBackplate.png")
img_add("volt_meter_faceplate.png", 25, 25, 250, 250)
-- img_add("volt_meter_1_bezel.png", 25, 25, 250, 250)
img_needle_1 = img_add("Gauge_needle_1.png", 100.5, 80, 50, 140)
img_needle_2 = img_add("Gauge_needle_2.png", 149.5, 80, 50, 140)
img_add("Gauge_centre_blank.png", 25, 25, 250, 250)


--Get data for needle--
function data(ac1, dc1)

    --Set to run px on/off AC power--
    if ac1==0 then
        tgt_ac1 = 100
    else
        tgt_ac1 = ac1
    end
    
    --Set to run temp on/off DC power--
    if dc1==0 then
        tgt_dc1 = 15
    else
        tgt_dc1 = dc1
    end
    
end


--Animate needles--
function timer_callback()

    --Rotate AC1 needle--
    tgt_ac1 = math.max(100, math.min(130, tgt_ac1))
    cur_ac1 = cur_ac1 + ((tgt_ac1 - cur_ac1) * factor)
    rotate(img_needle_1, (150/30 * (cur_ac1 - 100)) + 20 )
    
    --Rotate DC1 needle--
    tgt_dc1 = math.max(15, math.min(30, tgt_dc1))
    cur_dc1 = cur_dc1 + ((tgt_dc1 - cur_dc1) * factor)
    rotate(img_needle_2, (116.667/11.5 * (-cur_dc1 + 15)) -20)
    
end


--Timer start--
tmr_blink = timer_start(0, 50, timer_callback)


--DataRef Subscriptions--
-- Using custom L-vars computed by NAV_GPS.xml (AC1 = 115V from inverter, DC1 = battery+gen voltage)
fsx_variable_subscribe(
    "L:VoltAC1", "volt",                        
    "L:VoltDC1", "volt",
    data
)