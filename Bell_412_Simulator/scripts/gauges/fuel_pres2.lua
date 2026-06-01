--B412EP #1 Engine fuel Px--
--For use with X-Trident B412EP only--
--Gauge runs with either AC1 or AC2 power--
--Normal operating pressure differs from the Trident Bell 412. I have set a more realistic pressure based on experience--


--Variables--
a = -35
local cur_px = -35		--current pressure (0 psi = start angle -35)--
local tgt_px = 0		--target pressure from x-plane data--
local factor = 0.1		--factor for animation speed--


--Add images--
-- img_add_fullscreen("FuelPxBackplate1.png")
img_add("faceplate.png", 25, 25, 250, 250)
-- img_add("Bezel.png", 25, 25, 250, 250)
img_needle = img_add("needle.png", 117.5, 75, 65, 150)


--Get data for needle--
function data(px, ac1, ac2)
	
	--Set to run on/off AC power--
	if ac1==0 and ac2==0 then
		tgt_px = 0
	else
		tgt_px = px
	end

	--Gauge will only operate 0-20psi)
	tgt_px = var_cap(tgt_px, 0, 20)

	--Maths for fuel Px--
	if tgt_px >= 12.139 then
		a = (180/34.5 * (tgt_px - 12.139) + 25)
	elseif tgt_px >= 0 then
		a = (60/12.139 * (tgt_px) - 35)
	end
	
end

function data_fsx(px, ac)

	data(px, ac, ac)
	
end

--Animate needle--
function timer_callback()	

	--Rotate needle--
	rotate(img_needle, cur_px)
	
	--Calculate current px--
	cur_px = cur_px + ((a - cur_px) * factor)
	
	end
	

--Timer start--
tmr_blink = timer_start(0, 50, timer_callback)


--DataRef Subscriptions--

-- xpl_dataref_subscribe("412/fuel/fuel_press_gauge_1", "FLOAT", 
-- 					  "412/electrical/gauge_AC1_volts", "FLOAT",
-- 					  "412/electrical/gauge_AC2_volts", "FLOAT", data)
fsx_variable_subscribe("L:fuelp2", "PSI",
					   "ELECTRICAL MAIN BUS VOLTAGE", "Volts", data_fsx)
-- fs2020_variable_subscribe("GENERAL ENG FUEL PRESSURE:1", "PSI",
-- 					      "ELECTRICAL MAIN BUS VOLTAGE", "Volts", data_fsx)					   