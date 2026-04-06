-- B412EP Voltmeter #2
-- For use with X-Trident B412EP only
-- AC voltmeter runs off AC2
-- DC voltmeter runs off DC2

-- ==========================================
-- VALUE TO ANGLE CALIBRATION TABLES
-- Format: { Simulator_Value, Needle_Angle }
-- ==========================================
local ac2_table = {
    { 100, 20 },      -- 100V mark
    { 111, 95 },      -- We know from your observation that 95 deg points to 111
    { 115, 112 },     -- Adjusted angle to push the needle up to the actual 115 mark
    { 120, 132 },     -- Estimated angle for 120
    { 130, 170 }      -- 130V mark
}

local dc2_table = {
    { 15,   -20 },      -- Min value
    { 26.5, -136.67 },  -- Normal Operating Max
    { 37,   -172.17 }   -- Hard Cap Max
}

-- Local Variables
local cur_angle_ac2 = 20  
local tgt_angle_ac2 = 20
local cur_angle_dc2 = -20 
local tgt_angle_dc2 = -20
local factor = 0.09

-- Add images
-- img_add_fullscreen("VoltmeterBackplate.png")
img_add("volt_meter_faceplate.png", 25, 25, 250, 250)
-- img_add("volt_meter_2_bezel.png", 25, 25, 250, 250)

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
function data(ac2, dc2, batt2_on)
    -- Gauge only responds when Battery 2 switch (L:Swbattb) is ON
    if not batt2_on or batt2_on == 0 then
        tgt_angle_ac2 = interpolate(ac2_table, 100)
        tgt_angle_dc2 = interpolate(dc2_table, 15)
        return
    end

    local tgt_ac2 = ac2
    local tgt_dc2 = dc2
    
    -- Set to drop to bottom if power is lost
    if ac2 == 0 then tgt_ac2 = 100 end
    if dc2 == 0 then tgt_dc2 = 15 end

    -- Cap values just in case of simulator spikes
    tgt_ac2 = var_cap(tgt_ac2, 100, 130)
    tgt_dc2 = var_cap(tgt_dc2, 15, 30)

    -- Look up the target angle from the tables
    tgt_angle_ac2 = interpolate(ac2_table, tgt_ac2)
    tgt_angle_dc2 = interpolate(dc2_table, tgt_dc2)
end

-- Animate needles
function timer_callback()
    
    -- Smooth and rotate AC2 needle
    cur_angle_ac2 = cur_angle_ac2 + ((tgt_angle_ac2 - cur_angle_ac2) * factor)
    rotate(img_needle_1, cur_angle_ac2)
            
    -- Smooth and rotate DC2 needle
    cur_angle_dc2 = cur_angle_dc2 + ((tgt_angle_dc2 - cur_angle_dc2) * factor)
    rotate(img_needle_2, cur_angle_dc2)
    
end

-- Timer start
local tmr_blink = timer_start(0, 50, timer_callback)

-- DataRef Subscriptions
xpl_dataref_subscribe(
    "412/electrical/gauge_AC2_volts", "FLOAT",
    "412/electrical/gauge_DC2_volts", "FLOAT", 
    data
)
                      
-- Gauge only activates when Battery 2 (L:Swbattb) is ON
fsx_variable_subscribe(
    "L:VoltAC2", "volt",                        
    "L:VoltDC2", "volt",
    "L:Swbattb", "Bool",
    data
)