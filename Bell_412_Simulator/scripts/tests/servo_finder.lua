-- =============================================================================
-- TEST SCRIPT: SERVO PIN FINDER V3 (Arduino Mega 2560 - Channel B)
-- Sweeps ALL UNUSED Analog and Digital pins to find the last 2 servos.
-- D44, D45, D46 are known. D2-D43 are mostly used by the Pedestal buttons/LEDs.
-- =============================================================================

print("=== DEEP SEARCH SERVO FINDER LOADED ===")
print("Press ANY hardware button on the pedestal to sweep the next possible pin.")
print("Watch your 2 missing servos closely!")

-- We are going to test all Analog pins (A0-A15) 
-- and the upper Digital pins (D54-D69 which are aliases for A0-A15)
-- plus any remaining upper digital pins that aren't buttons
local test_pins = {
    -- Analog pins (referenced as Analog axes)
    "A0", "A1", "A2", "A3", "A4", "A5", "A6", "A7",
    "A8", "A9", "A10", "A11", "A12", "A13", "A14", "A15",
    
    -- Upper Digital Pins (often used for PWM on custom shields)
    "D54", "D55", "D56", "D57", "D58", "D59", 
    "D60", "D61", "D62", "D63", "D64", "D65", "D66", "D67", "D68", "D69"
}

-- We sweep from duty cycle 0.05 (0 degrees) to 0.10 (180 degrees)
local DUTY_MIN = 0.05
local DUTY_MAX = 0.10

-- Hardware handles array
local servo_handles = {}

-- Initialize all test pins to center
-- Note: hw_output_pwm_add will fail silently in Air Manager if a pin doesn't support PWM,
-- but on an Arduino Mega with SoftPWM libraries (which Air Manager uses internally), 
-- almost ANY pin can output PWM!
for i, pin in ipairs(test_pins) do
    local hw_port = "ARDUINO_MEGA2560_B_" .. pin
    servo_handles[pin] = hw_output_pwm_add(hw_port, 50, 0.075)
end

-- State variables for the sweeping test
local current_pin_index = 1
local current_duty = DUTY_MIN
local sweeping_up = true
local test_timer = nil

-- The sweep function
local function handle_hardware_button_press()
    local pin = test_pins[current_pin_index]
    
    if test_timer == nil then
        -- Start sweeping this pin
        print(">>> NOW SWEEPING PIN: " .. pin)
        sweeping_up = true
        current_duty = DUTY_MIN
        
        test_timer = timer_start(0, 50, function()
            local handle = servo_handles[pin]
            if handle then
                hw_output_pwm_duty_cycle(handle, current_duty)
            end
            
            if sweeping_up then
                current_duty = current_duty + 0.005
                if current_duty >= DUTY_MAX then sweeping_up = false end
            else
                current_duty = current_duty - 0.005
                if current_duty <= DUTY_MIN then sweeping_up = true end
            end
        end)
    else
        -- Stop sweeping, advance to next pin
        print("<<< STOPPED PIN " .. pin)
        timer_stop(test_timer)
        test_timer = nil
        
        if servo_handles[pin] then
            hw_output_pwm_duty_cycle(servo_handles[pin], 0.075)
        end
        
        current_pin_index = current_pin_index + 1
        if current_pin_index > #test_pins then
            current_pin_index = 1
            print("=== SEARCH COMPLETE. RESTARTING FAST PINS ===")
        end
        local next_pin = test_pins[current_pin_index]
        print("Next pin is: " .. next_pin .. " (Press any hardware button to sweep)")
    end
end

-- =============================================================================
-- BIND ALL HARDWARE BUTTONS
-- =============================================================================
local known_input_pins = {
    "D13", "D12", "D10", "D9", "D7", "D6", "D43", -- AFCS
    "D53", "D49", "D51", "D47", "D52", "D48",       -- AHRS & Mag
    "D30", "D32", "D28", "D31", "D33", "D34", "D35",-- Fuel
    "D36", "D37", "D38", "D39", "D42"
}

for _, input_pin in ipairs(known_input_pins) do
    hw_button_add("ARDUINO_MEGA2560_B_" .. input_pin, function()
        handle_hardware_button_press()
    end)
end

print("First search pin ready: " .. test_pins[current_pin_index])
print("Press ANY hardware button on the pedestal to start sweeping it!")
