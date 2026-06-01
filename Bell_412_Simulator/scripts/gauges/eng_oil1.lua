--B412EP #2 Engine oil temp & Px--
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
-- img_add_fullscreen("EngOilBackplate2.png")
img_add("Engine_oil_gauge_faceplate.png", 25, 25, 250, 250)
-- img_add("Engine_2_oil_gauge_bezel.png", 25, 25, 250, 250)
img_needle_1 = img_add("Gauge_needle_1.png", 100.5, 80, 50, 140)
img_needle_2 = img_add("Gauge_needle_2.png", 149.5, 80, 50, 140)
img_add("Gauge_centre.png", 25, 25, 250, 250)


--Get data for needle--
function data(px, temp, ac1, ac2, dc1, dc2)

	--Set to run px on/off AC power--
	if ac1==0 and ac2==0 then
		tgt_px = 0
	else
		tgt_px = px[2]
	end
	
	--Set to run temp on/off DC power--
	if dc1==0 and dc2==0 then
		tgt_temp = -50
	else
		tgt_temp = temp[2]
	end
	
	--Maths for oil pressure--
	tgt_px = var_cap((tgt_px), 0, 110.23)
		
	if tgt_px >=103.95 then
	a = (28/6.28 * (-tgt_px + 103.95) - 90.0)
	elseif tgt_px >= 68.5 then
	a = (23.333/35.45 * (-tgt_px + 68.5) - 66.667)
	elseif tgt_px >= 0 then
	a = (46.667/68.5 * (-tgt_px)-20)
	end

	--Maths for oil temp--	
	if tgt_temp >132.0 then
	b = (17.5/43 * (tgt_temp - 132) + 97)
	elseif tgt_temp >=0 then
	b = (42/132 * (tgt_temp) + 55)
	elseif tgt_temp >=-50.0 then
	b = (35/50 * (tgt_temp + 50) + 20)
	end
	
end

function data_fsx(oilp, oilt, volts)

	data({0, oilp}, {0, oilt}, volts, volts, volts, volts)
	
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

xpl_dataref_subscribe("sim/cockpit2/engine/indicators/oil_pressure_psi", "FLOAT[8]",
						"sim/cockpit2/engine/indicators/oil_temperature_deg_C", "FLOAT[8]",
						"412/electrical/gauge_AC1_volts", "FLOAT",
						"412/electrical/gauge_AC2_volts", "FLOAT",
						"412/electrical/gauge_DC1_volts", "FLOAT",
						"412/electrical/gauge_DC2_volts", "FLOAT",data)
fsx_variable_subscribe("L:OILE1", "psi",
                       "L:OILE1T", "celsius",
					   "ELECTRICAL MAIN BUS VOLTAGE", "Volts", data_fsx)
fs2020_variable_subscribe("L:OILE1", "psi",
                          "L:OILE1T", "celsius",
					      "ELECTRICAL MAIN BUS VOLTAGE", "Volts", data_fsx)					   