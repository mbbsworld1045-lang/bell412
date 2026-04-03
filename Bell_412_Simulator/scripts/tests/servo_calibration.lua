-- =============================================================================
-- TEST SCRIPT: SIMPLE SERVO CALIBRATION (WIDE RANGE)
-- Press ANY hardware button on your pedestal to cycle the servos!
-- Sequence: Center -> Minimum -> Maximum
-- =============================================================================

print("=== WIDE RANGE SERVO CALIBRATOR LOADED ===")
print("Press ANY physical hardware button on your pedestal to cycle all 3 servos.")

-- =============================================================================
-- TUNE THESE VALUES IF YOU NEED MORE/LESS ROTATION
-- Standard servos use 0.050 to 0.100.
-- Extended servos can often go from ~0.025 (Min) to ~0.125 (Max).
-- Modify these values if they are still not moving far enough!
-- =============================================================================
local PWM_MIN = 0.030   -- Pushing lower than standard 0.050 for more travel
local PWM_MAX = 0.120   -- Pushing higher than standard 0.100 for more travel
local PWM_MID = 0.075   -- True mechanical center is almost always 0.075
-- =============================================================================

-- HARDWARE HANDLES (CHANNEL B)
local servo_yaw   = hw_output_pwm_add("ARDUINO_MEGA2560_B_D44", 50, PWM_MID)
local servo_roll  = hw_output_pwm_add("ARDUINO_MEGA2560_B_D45", 50, PWM_MID)
local servo_pitch = hw_output_pwm_add("ARDUINO_MEGA2560_B_D46", 50, PWM_MID)

-- STATE (0 = Center, 1 = Minimum, 2 = Maximum)
local sequence_state = 0

-- CYCLE FUNCTION
local function cycle_servos()
    if sequence_state == 0 then
        -- Go to MINIMUM
        hw_output_pwm_duty_cycle(servo_yaw, PWM_MIN)
        hw_output_pwm_duty_cycle(servo_roll, PWM_MIN)
        hw_output_pwm_duty_cycle(servo_pitch, PWM_MIN)
        print(">>> MINIMUM POSITION (Duty " .. tostring(PWM_MIN) .. ") <<<")
        sequence_state = 1
        
    elseif sequence_state == 1 then
        -- Go to MAXIMUM
        hw_output_pwm_duty_cycle(servo_yaw, PWM_MAX)
        hw_output_pwm_duty_cycle(servo_roll, PWM_MAX)
        hw_output_pwm_duty_cycle(servo_pitch, PWM_MAX)
        print(">>> MAXIMUM POSITION (Duty " .. tostring(PWM_MAX) .. ") <<<")
        sequence_state = 2
        
    else
        -- Go to CENTER
        hw_output_pwm_duty_cycle(servo_yaw, PWM_MID)
        hw_output_pwm_duty_cycle(servo_roll, PWM_MID)
        hw_output_pwm_duty_cycle(servo_pitch, PWM_MID)
        print(">>> CENTER POSITION (Duty " .. tostring(PWM_MID) .. ") <<<")
        sequence_state = 0
    end
end

-- =============================================================================
-- BIND ALL PEDESTAL HARDWARE SWITCHES (CHANNEL B) TO TRIGGER THE TEST
-- =============================================================================
local known_input_pins = {
    "D13", "D12", "D10", "D9", "D7", "D6", "D43", -- AFCS
    "D53", "D49", "D51", "D47", "D52", "D48",       -- AHRS & Mag
    "D30", "D32", "D28", "D31", "D33", "D34", "D35",-- Fuel
    "D36", "D37", "D38", "D39", "D42"
}

for _, input_pin in ipairs(known_input_pins) do
    hw_button_add("ARDUINO_MEGA2560_B_" .. input_pin, function()
        cycle_servos()
    end)
end

print("Servos initialized at Center. Ready for testing.")
