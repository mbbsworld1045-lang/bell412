--B412EP #1 Engine fuel Px--
--For use with X-Trident B412EP only--
--Gauge runs with either AC1 or AC2 power--
--Normal operating pressure differs from the Trident Bell 412. I have set a more realistic pressure based on experience--

--Variables--
local a = -35
local cur_px = -35		--current pressure (0 psi = start angle -35)--
local tgt_px = 0		--target pressure from data--
local factor = 0.1		--factor for animation speed--

--Add images--
-- img_add_fullscreen("FuelPxBackplate1.png")
img_add("faceplate.png", 25, 25, 250, 250)
-- img_add("Bezel.png", 25, 25, 250, 250)
img_needle = img_add("needle.png", 117.5, 75, 65, 150)


--Get data for needle--
function data(px, power)
	
	--Set to run on/off AC power--
    -- XML uses L:MasterACDC for Fuel Pressure logic
	if power == 0 then
		tgt_px = 0
	else
		tgt_px = px
	end

	--Gauge will only operate 0-20psi
    if tgt_px > 20 then tgt_px = 20 end
    if tgt_px < 0 then tgt_px = 0 end

	--Maths for fuel Px--
	if tgt_px >= 12.139 then
		a = (180/34.5 * (tgt_px - 12.139) + 25)
	elseif tgt_px >= 0 then
		a = (60/12.139 * (tgt_px) - 35)
	end
	
end

--Animate needle--
function timer_callback()	

	--Calculate current px--
	cur_px = cur_px + ((a - cur_px) * factor)

	--Rotate needle--
    -- Error fix: 'rotate' was causing a crash. Must be 'img_rotate' in Air Manager.
	img_rotate(img_needle, cur_px)
	
end
	

--Timer start--
tmr_blink = timer_start(0, 50, timer_callback)


--DataRef Subscriptions--
-- Corrected variables for the MSFS Bell 412 based on FUELP1.xml
fsx_variable_subscribe(
    "L:fuelp1", "PSI",
    "L:MasterACDC", "bool", 
    data
)