--B412EP Txmn oil temp & Px--
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
-- img_add_fullscreen("TxmnBackplate.png")
img_add("TXMN_oil_gauge_faceplate.png", 25, 25, 250, 250)
-- img_add("TXMN_oil_gauge_bezel.png", 25, 25, 250, 250)
img_needle_1 = img_add("TXMN_oil_gauge_needle_1.png", 100.5, 80, 50, 140)
img_needle_2 = img_add("TXMN_oil_gauge_needle_2.png", 149.5, 80, 50, 140)
img_add("TXMN_oil_gauge_centre.png", 25, 25, 250, 250)


--Get data for needle--
-- Note: Subscribed to L:MasterDcBus for power, just like XMSN.xml
function data(px, temp, bus_power)

    --Set to run px on/off power--
    -- XML actually shows XMSN px has NO electrical requirement, but we'll tie it to bus for safety
    if bus_power == 0 then
        tgt_px = 0
    else
        tgt_px = px
    end
    
    --Set to run temp on/off power--
    if bus_power == 0 then
        tgt_temp = -50
    else
        tgt_temp = temp
    end
    
    --Maths for oil pressure--
    if tgt_px >= 42.0 then
        a = (32/22.86 * (-tgt_px + 42)-80)
    elseif tgt_px >= 0 then
        a = (60/42 * (-tgt_px) -20)
    end
    
    --Maths for oil temp--    
    if tgt_temp > 275.0 then
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
    
    --rotate oil pressure needle--
    cur_px = cur_px + ((a - cur_px) * factor)
    img_rotate(img_needle_2, cur_px)

    --rotate oil temp needle--    
    cur_temp = cur_temp + ((b - cur_temp) * factor)
    img_rotate(img_needle_1, cur_temp)
    
end

--timer start--
tmr_blink = timer_start(0, 50, timer_callback)

--DataRef Subscriptions--
fsx_variable_subscribe(
    "L:XMSN", "psi",             -- Corresponding to Transmission Pressure
    "L:XMSNT", "celsius",        -- Corresponding to Transmission Temp
    "L:MasterDcBus", "bool",     -- Electrical check based on XMSN.xml logic
    data 
)