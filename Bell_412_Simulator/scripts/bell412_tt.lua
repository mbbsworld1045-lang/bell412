-- Bell 412EP Triple Tachometer
-- Final calibrated version with smoothed needle movement

img_add_fullscreen("B412_Triple_Tach_Markings.png")
img_needle_1 = img_add("B412_Triple_Tach_Needle_1.png", 233, 91, 34, 318)
img_needle_2 = img_add("B412_Triple_Tach_Needle_2.png", 233, 91, 34, 318)
img_needle_R = img_add("B412_Triple_Tach_Needle_R.png", 233, 91, 34, 318)

-- Calibration points for rotor RPM (NR) needle
local NR_CALIBRATION = {
    {value = 0,     angle = -5},    -- 0%
    {value = 207.5, angle = 170},   -- Base of green arc (~64%)
    {value = 242.0, angle = 201},   -- 
    {value = 284.0, angle = 235},   -- 
    {value = 303.5, angle = 253},   -- 
    {value = 324.0, angle = 270},   -- 100%
    {value = 389.0, angle = 325}    -- Maximum range
}

-- Calibration points for engine N2 needles
local N2_CALIBRATION = {
    {value = 0,     angle = -5},    -- 0%
    {value = 63.5,  angle = 165.5}, -- 
    {value = 74.0,  angle = 187.5}, -- 
    {value = 87.0,  angle = 215},   -- 
    {value = 93.0,  angle = 242.5}, -- 
    {value = 99.24, angle = 270},   -- 100%
    {value = 110,   angle = 300}    -- Maximum range
}

-- Needle animation smoothing
local SMOOTHING_FACTOR = 0.2  -- Lower values = smoother but slower (0.1 to 0.3 recommended)
local current_nr_angle = -5
local current_n2_1_angle = -5
local current_n2_2_angle = -5

-- Generic interpolation function
local function interpolate(value, calibration)
    if value >= calibration[#calibration].value then
        return calibration[#calibration].angle
    end
    
    for i = 1, #calibration - 1 do
        if value >= calibration[i].value and value < calibration[i+1].value then
            local value_range = calibration[i+1].value - calibration[i].value
            local angle_range = calibration[i+1].angle - calibration[i].angle
            local ratio = (value - calibration[i].value) / value_range
            return calibration[i].angle + ratio * angle_range
        end
    end
    
    return calibration[1].angle  -- Below minimum value
end

function data(NR, N2)
    local nr_value = NR[1]
    local n2_1_value = N2[1]
    local n2_2_value = N2[2]
    
    -- Calculate target angles
    local target_nr = interpolate(nr_value, NR_CALIBRATION)
    local target_n2_1 = interpolate(n2_1_value, N2_CALIBRATION)
    local target_n2_2 = interpolate(n2_2_value, N2_CALIBRATION)
    
    -- Apply smoothing to needle movements
    current_nr_angle = current_nr_angle + (target_nr - current_nr_angle) * SMOOTHING_FACTOR
    current_n2_1_angle = current_n2_1_angle + (target_n2_1 - current_n2_1_angle) * SMOOTHING_FACTOR
    current_n2_2_angle = current_n2_2_angle + (target_n2_2 - current_n2_2_angle) * SMOOTHING_FACTOR
    
    -- Rotate needles
    img_rotate(img_needle_R, current_nr_angle)
    img_rotate(img_needle_1, current_n2_1_angle)
    img_rotate(img_needle_2, current_n2_2_angle)
    
    -- Debug output (comment out when not needed)
--     print(string.format("NR: %.1f → %.1f° (smoothed: %.1f°)", 
--           nr_value, target_nr, current_nr_angle))
end

function data_fsx(NR, N21, N22)
    data({324 / 100 * NR}, {N21, N22})
end

fsx_variable_subscribe("ROTOR RPM PCT:1", "percent",
                      "L:Eng1N2", "percent",
                      "L:Eng2N2", "percent", data_fsx)