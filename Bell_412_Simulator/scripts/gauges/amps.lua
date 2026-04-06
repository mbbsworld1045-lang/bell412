--B412EP Ammeter--
--For use with X-Trident B412EP only--


--Variables--
local cur_amp_1 = 0
local tgt_amp_1 = 0
local cur_amp_2 = 0
local tgt_amp_2 = 0
local factor = 0.1


--Add images--
-- img_add_fullscreen("AmmeterBackplate.png")
img_add("ammeter_faceplate.png", 25, 25, 250, 250)
img_add("ammeter_bezel.png", 25, 25, 250, 250)
img_needle_1 = img_add("Gauge_needle_1.png", 100.5, 80, 50, 140)
img_needle_2 = img_add("Gauge_needle_2.png", 149.5, 80, 50, 140)
img_add("Gauge_centre_blank.png", 25, 25, 250, 250)


--Get data for AMPS needles--
function data_amps(AMPS)

	tgt_amp_1 = AMPS[1]
	tgt_amp_2 = AMPS[2]

end

function data_amps_fsx(amps1, amps2, gen1_on, gen2_on)

	-- XML: (L:Genel,bool) 1 == if{ (L:Ampsg1,amp) }
	if gen1_on then
		tgt_amp_1 = amps1
	else
		tgt_amp_1 = 0
	end

	-- XML: (L:Gener,bool) 1 == if{ (L:Ampsg2,amp) }
	if gen2_on then
		tgt_amp_2 = amps2
	else
		tgt_amp_2 = 0
	end
	
end

--Animate needles--
function timer_callback()

	--Rotate #1 AMPS needle--
	rotate (img_needle_1, (46.667/124 * (cur_amp_1))+ 20.00)
	cur_amp_1 = cur_amp_1 + ((tgt_amp_1 - cur_amp_1) * factor)

	--Rotate #2 AMPS needle--
	rotate (img_needle_2, (46.667/124 * (-cur_amp_2))- 20.00)
	cur_amp_2 = cur_amp_2 + ((tgt_amp_2 - cur_amp_2) * factor)
	
	end


--Timer start--
tmr_blink = timer_start(0, 50, timer_callback)


--DataRef Subscriptions--

xpl_dataref_subscribe("sim/cockpit2/electrical/generator_amps", "FLOAT[10]", data_amps)
fsx_variable_subscribe("L:Ampsg1", "amp",
                       "L:Ampsg2", "amp",
                       "L:Genel", "Bool",
                       "L:Gener", "Bool", data_amps_fsx)
fs2020_variable_subscribe("L:Ampsg1", "amp",
                          "L:Ampsg2", "amp",
                          "L:Genel", "Bool",
                          "L:Gener", "Bool", data_amps_fsx)