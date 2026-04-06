-- Bell 412EP Triple Tachometer - Complete Working Version
-- For use with X-Trident B412EP only

img_add_fullscreen("B412_Triple_Tach_Markings.png")
img_needle_1 = img_add("B412_Triple_Tach_Needle_1.png", 233, 91, 34, 318)
img_needle_2 = img_add("B412_Triple_Tach_Needle_2.png", 233, 91, 34, 318)
img_needle_R = img_add("B412_Triple_Tach_Needle_R.png", 233, 91, 34, 318)

-- Calibration points for rotor RPM (NR) needle
local NR_CALIBRATION = {
    {value = 0,     angle = -5},    -- 0 RPM
    {value = 207.5, angle = 170},   -- Base of green arc
    {value = 242.0, angle = 201},   
    {value = 284.0, angle = 235},   
    {value = 303.5, angle = 253},   
    {value = 324.0, angle = 270},   -- 100% (324 RPM)
    {value = 389.0, angle = 325}    -- Maximum range
}

-- Calibration points for engine N2 needles
local N2_CALIBRATION = {
    {value = 0,     angle = -5},    -- 0%
    {value = 63.5,  angle = 169.5}, 
    {value = 74.0,  angle = 198}, 
    {value = 87.0,  angle = 234},   
    {value = 93.0,  angle = 251}, 
    {value = 100,   angle = 287},   -- 100%
    {value = 110,   angle = 300}    -- Maximum range
}

-- Smoothing variables
local current_nr_angle = -5
local current_n2_1_angle = -5
local current_n2_2_angle = -5

-- Smoothing parameters
local SMOOTHING = {
    base_speed = 4,              -- Degrees per second
    min_movement = 0.05,         -- Minimum movement
    timer_interval = 0.05,       -- 50ms timer interval
    dynamic_factor = 0.35        -- Smoothing factor
}

-- Interpolation function (MUST BE DEFINED BEFORE USE)
local function interpolate(value, calibration)
    if value >= calibration[#calibration].value then
        return calibration[#calibration].angle
    end
    
    for i = 1, #calibration - 1 do
        if value >= calibration[i].value and value < calibration[i+1].value then
            local ratio = (value - calibration[i].value) / (calibration[i+1].value - calibration[i].value)
            return calibration[i].angle + ratio * (calibration[i+1].angle - calibration[i].angle)
        end
    end
    
    return calibration[1].angle
end

-- Smoothing function
local degrees_per_frame = (SMOOTHING.base_speed * SMOOTHING.timer_interval)
local function smooth_value(current, target)
    local diff = target - current
    local abs_diff = math.abs(diff)
    
    local movement = diff * SMOOTHING.dynamic_factor
    if abs_diff > degrees_per_frame then
        movement = degrees_per_frame * (diff > 0 and 1 or -1)
    end
    
    if abs_diff > 0 and abs_diff < SMOOTHING.min_movement then
        movement = diff > 0 and SMOOTHING.min_movement or -SMOOTHING.min_movement
    end
    
    return current + movement
end

function data(NR, N2)
    local nr_value = NR[1]  -- Actual RPM value
    local n2_1_value = N2[1]
    local n2_2_value = N2[2]
    
    -- Calculate target angles
    local target_nr_angle = interpolate(nr_value, NR_CALIBRATION)
    local target_n2_1_angle = interpolate(n2_1_value, N2_CALIBRATION)
    local target_n2_2_angle = interpolate(n2_2_value, N2_CALIBRATION)
    
    -- Apply smoothing
    current_nr_angle = smooth_value(current_nr_angle, target_nr_angle)
    current_n2_1_angle = smooth_value(current_n2_1_angle, target_n2_1_angle)
    current_n2_2_angle = smooth_value(current_n2_2_angle, target_n2_2_angle)
    
    -- Rotate needles
    rotate(img_needle_R, current_nr_angle)
    rotate(img_needle_1, current_n2_1_angle)
    rotate(img_needle_2, current_n2_2_angle)
end

function data_fsx(NR_percent, N21, N22)
    -- Convert percentage to actual RPM (324 RPM = 100%)
    local actual_rpm = (324 * NR_percent) / 100
    
    -- Add the +10 RPM adjustment
    local adjusted_rpm = actual_rpm - 0.4 
    
    -- Write back to simulator (convert back to percentage)
    local adjusted_percent = (adjusted_rpm * 100) / 324
    fsx_variable_write("Eng Rotor Rpm", "percent", adjusted_percent)
    
    -- Process with actual RPM values
    data({adjusted_rpm}, {N21, N22})
end

-- Subscribe to variables
fsx_variable_subscribe("Eng Rotor Rpm", "percent",
                      "L:Eng1N2", "percent",
                      "L:Eng2N2", "percent", data_fsx)