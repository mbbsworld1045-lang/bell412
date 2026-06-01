-- === Variables ===
-- These store current and target values for the torque needles (mast, engine 1, engine 2)
local cur_mast, tgt_mast = 0, 0
local cur_eng1, tgt_eng1 = 0, 0
local cur_eng2, tgt_eng2 = 0, 0
local factor = 0.03  -- Smoothing factor for gradual needle movement (0 = no movement, 1 = instant jump)

local overtq_test_active = 0
si_variable_subscribe("bell412_overtq_test", "INT", function(val)
    overtq_test_active = val
end)

-- === Image Loading ===
-- Adds background and needle images. Needle origins are aligned at center (236,129) with size 28x242.
img_add_fullscreen("B412_Faceplate_Tq.png")
img_needle_2 = img_add("B412_Needle_Tq_2.png", 236, 129, 28, 242)
img_needle_1 = img_add("B412_Needle_Tq_1.png", 236, 129, 28, 242)
img_needle_M = img_add("B412_Needle_Tq_Mast.png", 236, 129, 28, 242)
-- img_add_fullscreen("B412_Housing_Tq.png")  -- Optional overlay (disabled for now)

-- === Angle Conversion Functions ===

-- Converts mast torque (0–110%) to rotation angle (0°–165°)
function mast_to_angle(tq)
    tq = math.min(math.max(tq, 0), 110)
    return (tq / 100) * 150
end

-- Converts engine torque (0–100%) to rotation angle (0° to -180°) with an offset for alignment
function eng_to_angle(tq)
    tq = math.min(math.max(tq, 0), 100)
    return -(tq / 100) * 150 - 15
end

-- === Data Input Handler ===
-- Called every time data is updated from FSX
function data(mast, eng1, eng2, dc1, dc2)
    if dc1 == 0 and dc2 == 0 then
        -- No power: zero all target values
        tgt_mast, tgt_eng1, tgt_eng2 = 0, 0, 0
    else
        -- Update target values
        tgt_mast = mast
        tgt_eng1 = eng1
        tgt_eng2 = eng2
    end
end

-- === Needle Animation Callback ===
-- Runs every 50ms to update the needle positions gradually toward target
function timer_callback()
    -- Mast needle
    local actual_tgt_mast = tgt_mast
    local actual_factor = factor
    
    if overtq_test_active == 1 then
        actual_tgt_mast = 105
        actual_factor = 0.20 -- Faster movement when testing
    end

    rotate(img_needle_M, mast_to_angle(cur_mast))
    cur_mast = cur_mast + ((actual_tgt_mast - cur_mast) * actual_factor)

    -- Engine 1 needle
    rotate(img_needle_1, eng_to_angle(cur_eng1))
    cur_eng1 = cur_eng1 + ((tgt_eng1 - cur_eng1) * factor)

    -- Engine 2 needle
    rotate(img_needle_2, eng_to_angle(cur_eng2))
    cur_eng2 = cur_eng2 + ((tgt_eng2 - cur_eng2) * factor)
end

-- === Start Animation Timer ===
-- Calls timer_callback every 50ms
tmr_blink = timer_start(0, 50, timer_callback)

-- === DataRef Subscription ===
-- Subscribes to FSX simulation variables. The data() function will be called when these values change.
fsx_variable_subscribe("L:Trotor", "percent", 
                       "L:Eng1TQ", "percent", 
                       "L:Eng2TQ", "percent",  
                       "ELECTRICAL MAIN BUS VOLTAGE", "Volts", 
                       "ELECTRICAL MAIN BUS VOLTAGE", "Volts", 
                       data)
