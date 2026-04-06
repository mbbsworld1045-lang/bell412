--B412EP #1 Engine ITT --
--For use with X-Trident B412EP only--
--Gauge runs with either DC1 or DC2--
--Shows a higher ITT reading when starting to try to simulate a real start cycle--


--Variables--
local a = 40
local cur_temp = 40
local tgt_temp = 0
local factor = 0.015
local starter_switch = 0


--Add images--
-- img_add_fullscreen("ITTbackplate1.png")
img_add("ITT_faceplate.png", 25, 25, 250, 250)
-- img_add("Bezel.png", 25, 25, 250, 250)
img_needle = img_add("ITT_needle.png", 125, 72.5, 50, 155)


--Get data for needle--
function data(ITT, starter, dc1, dc2)
	
	--Set to run temp on/off DC power--
	if dc1==0 and dc2==0 then
	tgt_temp = 0
	else
	tgt_temp = ITT[1]
	end
	
	--Starter 1--
	if (starter[1] == 4) then
	starter_switch = 1
	else
	starter_switch = 0
	end

	--Maths for ITT--
	if starter_switch == 0 and tgt_temp >= 920 then
	a = (115/160 * (tgt_temp - 920) + 303)
	elseif starter_switch == 0 and tgt_temp >= 900 then
	a = (15/20 * (tgt_temp - 900) + 288)
	elseif starter_switch == 0 and tgt_temp >= 797 then
	a = (75/100 * (tgt_temp - 797) + 210)
	elseif starter_switch == 0 and tgt_temp >= 700 then
	a = (150/190 * (tgt_temp - 645) + 95)
	elseif starter_switch == 1 and tgt_temp >= 700 then
-- 	a = (150/190 * (tgt_temp - 645) + 95)
-- 	elseif starter_switch == 0 and tgt_temp >= 516 then
-- 	a = (60/281 * (tgt_temp - 650) + 130)
-- 	elseif starter_switch == 1 and tgt_temp >= 516 then
	a = (70/340 * (tgt_temp - 470) + 94)
	elseif starter_switch == 0 and tgt_temp >= 300 then
	a = (70/340 * (tgt_temp - 470) + 94)
	elseif starter_switch == 1 and tgt_temp >= 300 then
-- 	a = (118/84 * (tgt_temp - 516) + 110)
-- 	elseif starter_switch == 0 and tgt_temp >= 391 then
-- 	a = (15/125 * (tgt_temp - 391) + 95)
-- 	elseif starter_switch == 1 and tgt_temp >= 391 then
-- 	a = (15/125 * (tgt_temp - 391) + 95)
-- 	elseif starter_switch == 0 and tgt_temp >= 373 then
-- 	a = (6/18 * (tgt_temp - 373) + 89)
-- 	elseif starter_switch == 1 and tgt_temp >= 373 then
-- 	a = (6/18 * (tgt_temp - 373) + 89)
-- 	elseif starter_switch == 0 and tgt_temp >= 193 then
-- 	a = (29/180 * (tgt_temp - 193) + 60)
-- 	elseif starter_switch == 1 and tgt_temp >= 193 then
-- 	a = (29/180 * (tgt_temp - 193) + 60)
	elseif starter_switch == 0 and tgt_temp >= 0 then
	a = ((20/300 * (tgt_temp - 0)) + 40)
	elseif starter_switch == 1 and tgt_temp >= 0 then
	a = ((20/300 * (tgt_temp - 0)) + 40)
	end 
		
end

function data_fsx(ITT, volts)

	data({ITT}, {0}, volts, volts)
	
end
	
--Animate needle--
function timer_callback()
				
	--Rotate ITT needle--	
	rotate (img_needle, cur_temp)
	cur_temp = cur_temp + ((a - cur_temp) * factor)
			
end


--Timer start--
tmr_blink = timer_start(0, 50, timer_callback)
	

--DataRef Subscriptions--

-- xpl_dataref_subscribe("sim/cockpit2/engine/indicators/ITT_deg_C", "FLOAT[2]",
-- 						"sim/cockpit2/engine/actuators/ignition_key", "INT[2]",
-- 						"412/electrical/gauge_DC1_volts", "FLOAT",
-- 						"412/electrical/gauge_DC2_volts", "FLOAT", data)
fsx_variable_subscribe("L:ITTE1", "Celsius",
                       "ELECTRICAL MAIN BUS VOLTAGE", "Volts", data_fsx)
-- fs2020_variable_subscribe("TURB ENG ITT:1", "Celsius",
--                           "ELECTRICAL MAIN BUS VOLTAGE", "Volts", data_fsx)					   