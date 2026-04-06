-- B412EP Voltmeter #1
-- For use with X-Trident B412EP only
-- AC voltmeter runs off AC1
-- DC voltmeter runs off DC1

-- ==========================================
-- VALUE TO ANGLE CALIBRATION TABLES
-- Format: { Simulator_Value, Needle_Angle }
-- ==========================================
local ac1_table = {
    { 100, 20 },      -- 100V mark
    { 111, 95 },      -- Observation point: 95 deg points to 111
    { 115, 112 },     -- Calibrated angle to hit the 115 mark
    { 120, 132 },     -- Estimated angle for 120
    { 130, 170 }      -- 130V mark
}

local dc1_table = {
    { 15,   -20 },      -- Min value
    { 26.5, -136.67 },  -- Normal Operating Max
    { 37,   -172.17 }   -- Hard Cap Max
}

-- Local Variables
local cur_angle_ac1 = 20  
local tgt_angle_ac1 = 20
local cur_angle_dc1 = -20 
local tgt_angle_dc1 = -20
local factor = 0.09

-- Add images
-- img_add_fullscreen("VoltmeterBackplate.png")
img_add("volt_meter_faceplate.png", 25, 25, 250, 250)
-- img_add("volt_meter_1_bezel.png", 25, 25, 250, 250)

-- Declared as 'local' to prevent cross-gauge conflicts
local img_needle_1 = img_add("Gauge_needle_1.png", 100.5, 80, 50, 140)
local img_needle_2 = img_add("Gauge_needle_2.png", 149.5, 80, 50, 140)
img_add("Gauge_centre_blank.png", 25, 25, 250, 250)

-- Interpolation Helper Function
local function interpolate(tbl, value)
    local last_v, last_a
    for i, pair in ipairs(tbl) do
        local v = pair[1]
        local a = pair[2]
        if value <= v then
            if i == 1 then return a end
            local pct = (value - last_v) / (v - last_v)
            return last_a + (pct * (a - last_a))
        end
        last_v = v
        last_a = a
    end
    return last_a 
end

-- Get data from Simulator
function data(ac1, dc1, batt1_on)
    -- Gauge only responds when Battery 1 switch (L:Swbatta) is ON
    if not batt1_on or batt1_on == 0 then
        tgt_angle_ac1 = interpolate(ac1_table, 100)
        tgt_angle_dc1 = interpolate(dc1_table, 15)
        return
    end

    local tgt_ac1 = ac1
    local tgt_dc1 = dc1
    
    -- Set to drop to bottom if power is lost
    if ac1 == 0 then tgt_ac1 = 100 end
    if dc1 == 0 then tgt_dc1 = 15 end

    -- Cap values just in case of simulator spikes
    tgt_ac1 = var_cap(tgt_ac1, 100, 130)
    tgt_dc1 = var_cap(tgt_dc1, 15, 30)

    -- Look up the target angle from the tables
    tgt_angle_ac1 = interpolate(ac1_table, tgt_ac1)
    tgt_angle_dc1 = interpolate(dc1_table, tgt_dc1)
end

-- Animate needles
function timer_callback()
    
    -- Smooth and rotate AC1 needle
    cur_angle_ac1 = cur_angle_ac1 + ((tgt_angle_ac1 - cur_angle_ac1) * factor)
    rotate(img_needle_1, cur_angle_ac1)
            
    -- Smooth and rotate DC1 needle
    cur_angle_dc1 = cur_angle_dc1 + ((tgt_angle_dc1 - cur_angle_dc1) * factor)
    rotate(img_needle_2, cur_angle_dc1)
    
end

-- Timer start
local tmr_blink = timer_start(0, 50, timer_callback)

-- DataRef Subscriptions
-- Using custom L-vars computed by NAV_GPS.xml (AC1 = 115V from inverter, DC1 = battery+gen voltage)
-- Gauge only activates when Battery 1 (L:Swbatta) is ON
fsx_variable_subscribe(
    "L:VoltAC1", "volt",                        
    "L:VoltDC1", "volt",
    "L:Swbatta", "Bool",
    data
)