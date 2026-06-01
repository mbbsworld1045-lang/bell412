--B412EP Fuel gauge--
--For use with X-Trident B412EP only--
--Gauge runs with L:MasterDcBus (per MSFS FUELQ.xml)--


--Variables--
local cur_l = 0
local tgt_l = 0
local cur_r = 0
local tgt_r = 0
local factor = 0.09


--Add images--
-- img_add_fullscreen("B412_fuel_gauge_housing.png")
img_add("B412_fuel_gauge_back_plate.png", 25, 25, 250, 250)
img_add("B412_fuel_gauge_centre_plate.png", 25, 25, 250, 250)
img_add("B412_fuel_gauge_bezel.png", 25, 25, 250, 250)
img_needle_1 = img_add("B412_fuel_gauge_needle.png", 112, 79, 24, 106)
img_needle_2 = img_add("B412_fuel_gauge_needle.png", 164, 79, 24, 106)


--Digit Text 
-- Added a 1000s digit since capacity goes up to 2200 lbs in FUELQ.xml
txt_digit_1000 = txt_add("0", "font:DSEG7Classic-Regular.ttf; size:28; color:green; halign:center;", 78, 208, 27, 44)
txt_digit_100  = txt_add("0", "font:DSEG7Classic-Regular.ttf; size:28; color:green; halign:center;", 107, 208, 27, 44)
txt_digit_10   = txt_add("0", "font:DSEG7Classic-Regular.ttf; size:28; color:green; halign:center;", 136, 208, 27, 44)
txt_digit_1    = txt_add("0", "font:DSEG7Classic-Regular.ttf; size:28; color:green; halign:center;", 165, 208, 27, 44)


--Get needle, power, and digit data--
function data(fuel_q, fuel_qtc, dc_bus)

    -- In FUELQ.xml both needles display total fuel (fuelq + fuelqtc)
    local total_fuel = (fuel_q or 0) + (fuel_qtc or 0)

    --Set to run on/off DC power--
    if dc_bus == true or dc_bus == 1 then
        tgt_l = total_fuel
        tgt_r = total_fuel
        
        visible(txt_digit_1, true)
        visible(txt_digit_10, true)
        visible(txt_digit_100, true)
        visible(txt_digit_1000, true)
    else    
        tgt_l = 0
        tgt_r = 0    
        
        visible(txt_digit_1, false)
        visible(txt_digit_10, false)
        visible(txt_digit_100, false)    
        visible(txt_digit_1000, false)
    end
    
    --Digit maths (Per FUELQ.xml, the digit block reads raw L:fuelq,pound)
    local digit = math.floor(fuel_q or 0)
    
    txt_set(txt_digit_1, math.floor(digit % 10))
    txt_set(txt_digit_10, math.floor((digit / 10) % 10))
    txt_set(txt_digit_100, math.floor((digit / 100) % 10))
    txt_set(txt_digit_1000, math.floor((digit / 1000) % 10))
    
end


--Animate needle--
function timer_callback()
    -- Calculate smoothing first
    cur_l = cur_l + ((tgt_l - cur_l) * factor)
    cur_r = cur_r + ((tgt_r - cur_r) * factor)

    -- Replace 'rotate' with AM's 'img_rotate'
    img_rotate(img_needle_1, ((120 / 2000) * (cur_l) + 48))
    img_rotate(img_needle_2, ((120 / 2000) * (-cur_r) - 48))
end

--Timer start--
tmr_blink = timer_start(0, 50, timer_callback)


--DataRef Subscriptions based on FUELQ.xml--
fsx_variable_subscribe(
    "L:fuelq", "pound", 
    "L:fuelqtc", "pound",
    "L:MasterDcBus", "Bool", 
    data
)