--Variables--
local a = 0
local cur_n1_tens = 0
local b = 0
local cur_n1_ones = 0
local tgt_n1 = 0
local factor = 0.04

-- Linear calibration constants
local tens_scale = 2.7  -- degrees per %N1 (280° full scale - capped)
local ones_scale = 48   -- degrees per %N1 (2880° full scale)
local tens_offset = 0    -- degrees offset for tens needle
local ones_offset = 0    -- degrees offset for ones needle
local tens_max_rotation = 280 -- Maximum allowed rotation for tens needle

--Add images--
img_add("N1_faceplate.png", 25, 75, 250, 250)
img_needle_2 = img_add("N1_needle_ones.png", 97, 118.5, 50, 50)
img_needle_1 = img_add("N1_needle_tens.png", 127.5, 119, 45, 162)

--Get data for needles--
function data_N1(N1)
    tgt_n1 = N1[2]
    
    -- Calculate tens rotation but cap at maximum
    a = math.min((tgt_n1 * tens_scale) + tens_offset, tens_max_rotation)
    
    -- Ones needle gets full rotation
    b = (tgt_n1 * ones_scale) + ones_offset
end

function data_N1_fsx(N1)
    data_N1({0, N1})
end

--animate needles--
function timer_callback()
    --Rotate tens needle (with capped rotation)--
    local target_tens = math.min(a, tens_max_rotation)
    rotate(img_needle_1, cur_n1_tens)
    cur_n1_tens = cur_n1_tens + ((target_tens - cur_n1_tens) * factor)

    --Rotate ones needle--
    rotate(img_needle_2, cur_n1_ones)
    cur_n1_ones = cur_n1_ones + ((b - cur_n1_ones) * factor)
end

--Timer start--
tmr_blink = timer_start(0, 50, timer_callback)

--DataRef Subscription--
fsx_variable_subscribe("L:RPM N1 E1","percent",data_N1_fsx)