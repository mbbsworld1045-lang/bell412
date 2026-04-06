--B412EP Voltmeter #2--
--For use with X-Trident B412EP only--
--AC voltmeter runs off AC1--
--DC voltmeter runs off DC1--


--Variables--
local cur_ac2 = 100
local tgt_ac2 = 100
local cur_dc2 = 15
local tgt_dc2 = 0
local factor = 0.09


--Add images--
-- img_add_fullscreen("VoltmeterBackplate.png")
img_add("volt_meter_faceplate.png", 25, 25, 250, 250)
-- img_add("volt_meter_2_bezel.png", 25, 25, 250, 250)
img_needle_1 = img_add("Gauge_needle_1.png", 100.5, 80, 50, 140)
img_needle_2 = img_add("Gauge_needle_2.png", 149.5, 80, 50, 140)
img_add("Gauge_centre_blank.png", 25, 25, 250, 250)


--Get data for needle--
function data(ac2, dc2)

    --Set to run px on/off AC power--
    if ac2==0 then
    tgt_ac2 = 100
    else
    tgt_ac2 = ac2
    end
    
    --Set to run temp on/off DC power--
    if dc2==0 then
    tgt_dc2 = 15
    else
    tgt_dc2 = dc2
    end

end


--Animate needles--
function timer_callback()
    
    --Rotate AC2 needle--
    tgt_ac2 = var_cap(tgt_ac2, 100, 130)
    rotate(img_needle_1, (150/30 * (cur_ac2 - 100)) + 20 )
    cur_ac2 = cur_ac2 + ((tgt_ac2 - cur_ac2) * factor)
            
    --Rotate DC2 needle--
    tgt_dc2 = var_cap(tgt_dc2, 15, 30)
    rotate(img_needle_2, (116.667/11.5 * (-cur_dc2 + 15)) -20)
    cur_dc2 = cur_dc2 + ((tgt_dc2 - cur_dc2) * factor)
    
end

    
--Timer start--
tmr_blink = timer_start(0, 50, timer_callback)


--DataRef Subscriptions--

xpl_dataref_subscribe("412/electrical/gauge_AC2_volts", "FLOAT",
                      "412/electrical/gauge_DC2_volts", "FLOAT", data)
                      
fsx_variable_subscribe("L:VoltAC2", "volt",                        
                       "L:VoltDC2", "volt",
                       data)