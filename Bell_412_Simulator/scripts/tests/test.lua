-- =============================================================================
-- BELL 412 - HARDWARE TEST SCRIPT
-- Platform: Air Manager + Arduino Mega 2560
-- Purpose: Interactive testing of all hardware components
-- NOTE: All hardware must be initialized at script load time
-- =============================================================================

print("=============================================================================")
print("         BELL 412 HARDWARE TEST SCRIPT")
print("         Testing: Arduino A (Pedestal), B (Front Panel), C (Caution Panel)")
print("=============================================================================")

-- =============================================================================
-- TEST CONFIGURATION
-- =============================================================================
local TEST_DURATION_MS = 10000  -- 10 seconds per test

-- Test state
local test_index = 0
local tests = {}
local current_timer = nil
local servo_timer = nil

-- =============================================================================
-- HARDWARE DEFINITIONS
-- =============================================================================

-- ARDUINO A - PEDESTAL
local ARDUINO_A = {
    leds = {
        { pin = "ARDUINO_MEGA2560_A_D2",  name = "SAS LED" },
        { pin = "ARDUINO_MEGA2560_A_D3",  name = "ATT LED" },
        { pin = "ARDUINO_MEGA2560_A_D4",  name = "AP2 LED" },
        { pin = "ARDUINO_MEGA2560_A_D5",  name = "AP1 LED" },
    },
    outputs = {
        { pin = "ARDUINO_MEGA2560_A_A1",  name = "TRIM LED" },
        { pin = "ARDUINO_MEGA2560_A_A2",  name = "TEST LED" },
        { pin = "ARDUINO_MEGA2560_A_A3",  name = "FD LED" },
        { pin = "ARDUINO_MEGA2560_A_A4",  name = "CPL LED" },
    },
    buttons = {
        { pin = "ARDUINO_MEGA2560_A_D13", name = "AP1 Switch" },
        { pin = "ARDUINO_MEGA2560_A_D12", name = "AP2 Switch" },
        { pin = "ARDUINO_MEGA2560_A_D10", name = "AFCS SAS Switch" },
        { pin = "ARDUINO_MEGA2560_A_D9",  name = "AFCS TEST Switch" },
        { pin = "ARDUINO_MEGA2560_A_D7",  name = "AFCS TRIM/FD Switch" },
        { pin = "ARDUINO_MEGA2560_A_D6",  name = "AFCS CPL Switch" },
        { pin = "ARDUINO_MEGA2560_A_D43", name = "AFCS SYS2 Switch" },
        { pin = "ARDUINO_MEGA2560_A_D53", name = "AHRS Test 1" },
        { pin = "ARDUINO_MEGA2560_A_D49", name = "AHRS Test 2" },
        { pin = "ARDUINO_MEGA2560_A_D51", name = "MAG/DG MAG1" },
        { pin = "ARDUINO_MEGA2560_A_D47", name = "MAG/DG MAG2" },
        { pin = "ARDUINO_MEGA2560_A_D52", name = "MAG/DG DG1" },
        { pin = "ARDUINO_MEGA2560_A_D48", name = "MAG/DG DG2" },
        { pin = "ARDUINO_MEGA2560_A_D30", name = "Fuel Valve 1" },
        { pin = "ARDUINO_MEGA2560_A_D32", name = "Fuel Valve 2" },
        { pin = "ARDUINO_MEGA2560_A_D28", name = "XFEED Bus Test" },
        { pin = "ARDUINO_MEGA2560_A_D31", name = "XFEED Pos 2" },
        { pin = "ARDUINO_MEGA2560_A_D33", name = "Fuel Crossfeed" },
        { pin = "ARDUINO_MEGA2560_A_D34", name = "Fuel Trans 1" },
        { pin = "ARDUINO_MEGA2560_A_D35", name = "Boost Pump 1" },
        { pin = "ARDUINO_MEGA2560_A_D36", name = "Fuel Intercon" },
        { pin = "ARDUINO_MEGA2560_A_D37", name = "Fuel Trans 2" },
        { pin = "ARDUINO_MEGA2560_A_D38", name = "Boost Pump 2" },
        { pin = "ARDUINO_MEGA2560_A_D39", name = "Hydraulic 1" },
        { pin = "ARDUINO_MEGA2560_A_D42", name = "Hydraulic 2" },
        { pin = "ARDUINO_MEGA2560_A_D23", name = "Governor Eng 1" },
        { pin = "ARDUINO_MEGA2560_A_D29", name = "Governor Eng 2" },
        { pin = "ARDUINO_MEGA2560_A_D25", name = "Part Sep 1" },
        { pin = "ARDUINO_MEGA2560_A_D27", name = "Part Sep 2" },
        { pin = "ARDUINO_MEGA2560_A_D40", name = "Force Trim" },
        { pin = "ARDUINO_MEGA2560_A_D41", name = "RPM Audio" },
    },
}

-- ARDUINO B - FRONT PANEL
local ARDUINO_B = {
    leds = {
        { pin = "ARDUINO_MEGA2560_B_D3",  name = "BRG PTR Left LED" },
        { pin = "ARDUINO_MEGA2560_B_D13", name = "BRG PTR Right LED" },
        { pin = "ARDUINO_MEGA2560_B_D5",  name = "Fire Handle 1 LED" },
        { pin = "ARDUINO_MEGA2560_B_D24", name = "Fire Handle 2 LED" },
        { pin = "ARDUINO_MEGA2560_B_D2",  name = "Bag Fire Test LED" },
        { pin = "ARDUINO_MEGA2560_B_D25", name = "Nav GPS White Left" },
        { pin = "ARDUINO_MEGA2560_B_D11", name = "Nav GPS White Right" },
        { pin = "ARDUINO_MEGA2560_B_D26", name = "Marker Right Red" },
        { pin = "ARDUINO_MEGA2560_B_D27", name = "Marker Right White" },
        { pin = "ARDUINO_MEGA2560_B_D28", name = "Marker Right Blue" },
        { pin = "ARDUINO_MEGA2560_B_D46", name = "Marker Left White" },
        { pin = "ARDUINO_MEGA2560_B_D47", name = "Marker Left Blue" },
        { pin = "ARDUINO_MEGA2560_B_D48", name = "Marker Left Red" },
        { pin = "ARDUINO_MEGA2560_B_D39", name = "Over Torque Left LED" },
        { pin = "ARDUINO_MEGA2560_B_D9",  name = "Over Torque Right LED" },
        { pin = "ARDUINO_MEGA2560_B_D42", name = "Cyclic Center Left LED" },
        { pin = "ARDUINO_MEGA2560_B_D30", name = "Cyclic Center Right LED" },
        { pin = "ARDUINO_MEGA2560_B_D43", name = "Master Caution LED" },
        { pin = "ARDUINO_MEGA2560_B_D4",  name = "Engine 1 Warning LED" },
        { pin = "ARDUINO_MEGA2560_B_D12", name = "Engine 2 Warning LED" },
    },
    buttons = {
        { pin = "ARDUINO_MEGA2560_B_D38", name = "BRG PTR Left" },
        { pin = "ARDUINO_MEGA2560_B_D10", name = "BRG PTR Right" },
        { pin = "ARDUINO_MEGA2560_B_D50", name = "Fire Pull Left" },
        { pin = "ARDUINO_MEGA2560_B_D35", name = "Fire Pull Right" },
        { pin = "ARDUINO_MEGA2560_B_D51", name = "Fire Detection Test" },
        { pin = "ARDUINO_MEGA2560_B_D52", name = "Baggage Fire Test" },
        { pin = "ARDUINO_MEGA2560_B_D7",  name = "Extinguisher Main" },
        { pin = "ARDUINO_MEGA2560_B_D8",  name = "Extinguisher Reserve" },
        { pin = "ARDUINO_MEGA2560_B_D45", name = "Marker Test Left" },
        { pin = "ARDUINO_MEGA2560_B_D37", name = "Marker Test Right" },
        { pin = "ARDUINO_MEGA2560_B_D49", name = "Over Torque Left" },
        { pin = "ARDUINO_MEGA2560_B_D33", name = "Over Torque Right" },
        { pin = "ARDUINO_MEGA2560_B_D40", name = "Cyclic Center Left" },
        { pin = "ARDUINO_MEGA2560_B_D32", name = "Cyclic Center Right" },
        { pin = "ARDUINO_MEGA2560_B_D41", name = "Master Caution Left" },
        { pin = "ARDUINO_MEGA2560_B_D36", name = "Master Caution Right" },
        { pin = "ARDUINO_MEGA2560_B_D53", name = "Fuel Sys Test FWD" },
        { pin = "ARDUINO_MEGA2560_B_D34", name = "Fuel Sys Test MID" },
        { pin = "ARDUINO_MEGA2560_B_D44", name = "Fuel Digit Test" },
    },
}

-- ARDUINO C - CAUTION PANEL
local ARDUINO_C = {
    leds = {
        { pin = "ARDUINO_MEGA2560_C_D25", name = "01 ENG 1 OUT" },
        { pin = "ARDUINO_MEGA2560_C_D26", name = "02 ENG 2 OUT" },
        { pin = "ARDUINO_MEGA2560_C_D27", name = "03 ROTOR BRAKE" },
        { pin = "ARDUINO_MEGA2560_C_D28", name = "04 XMSN OIL PRESS" },
        { pin = "ARDUINO_MEGA2560_C_D29", name = "05 XMSN OIL TEMP" },
        { pin = "ARDUINO_MEGA2560_C_D30", name = "06 C BOX OIL PRESS" },
        { pin = "ARDUINO_MEGA2560_C_D31", name = "07 C BOX OIL TEMP" },
        { pin = "ARDUINO_MEGA2560_C_D32", name = "08 BATT 1 HOT" },
        { pin = "ARDUINO_MEGA2560_C_D33", name = "09 BATT 2 HOT" },
        { pin = "ARDUINO_MEGA2560_C_D34", name = "10 ENG OIL PRESS 1" },
        { pin = "ARDUINO_MEGA2560_C_D35", name = "11 ENG OIL PRESS 2" },
        { pin = "ARDUINO_MEGA2560_C_D36", name = "12 ENG CHIP 1" },
        { pin = "ARDUINO_MEGA2560_C_D37", name = "13 ENG CHIP 2" },
        { pin = "ARDUINO_MEGA2560_C_D38", name = "14 FUEL FILTER 1" },
        { pin = "ARDUINO_MEGA2560_C_D39", name = "15 FUEL FILTER 2" },
        { pin = "ARDUINO_MEGA2560_C_D40", name = "16 FUEL BOOST 1" },
        { pin = "ARDUINO_MEGA2560_C_D41", name = "17 FUEL BOOST 2" },
        { pin = "ARDUINO_MEGA2560_C_D42", name = "18 FUEL TRANS 1" },
        { pin = "ARDUINO_MEGA2560_C_D50", name = "19 FUEL TRANS 2" },
        { pin = "ARDUINO_MEGA2560_C_D49", name = "20 FUEL VALVE 1" },
        { pin = "ARDUINO_MEGA2560_C_D48", name = "21 FUEL VALVE 2" },
        { pin = "ARDUINO_MEGA2560_C_D3",  name = "22 FUEL LOW" },
        { pin = "ARDUINO_MEGA2560_C_D47", name = "23 FUEL INTCON" },
        { pin = "ARDUINO_MEGA2560_C_D46", name = "24 FUEL XFEED" },
        { pin = "ARDUINO_MEGA2560_C_D45", name = "25 GOV MANUAL 1" },
        { pin = "ARDUINO_MEGA2560_C_D44", name = "26 GOV MANUAL 2" },
        { pin = "ARDUINO_MEGA2560_C_D43", name = "27 PART SEP 1" },
        { pin = "ARDUINO_MEGA2560_C_D6",  name = "28 PART SEP 2" },
        { pin = "ARDUINO_MEGA2560_C_D7",  name = "29 DC GEN 1" },
        { pin = "ARDUINO_MEGA2560_C_D8",  name = "30 DC GEN 2" },
        { pin = "ARDUINO_MEGA2560_C_A15", name = "31 INVERTER 1" },
        { pin = "ARDUINO_MEGA2560_C_A14", name = "32 INVERTER 2" },
        { pin = "ARDUINO_MEGA2560_C_A13", name = "33 BATTERY" },
        { pin = "ARDUINO_MEGA2560_C_A12", name = "34 GEN OVHT 1" },
        { pin = "ARDUINO_MEGA2560_C_A11", name = "35 GEN OVHT 2" },
        { pin = "ARDUINO_MEGA2560_C_A10", name = "36 HYDRAULIC 1" },
        { pin = "ARDUINO_MEGA2560_C_A9",  name = "37 HYDRAULIC 2" },
        { pin = "ARDUINO_MEGA2560_C_A8",  name = "38 EXT POWER" },
        { pin = "ARDUINO_MEGA2560_C_A7",  name = "39 XMSN CHIP" },
        { pin = "ARDUINO_MEGA2560_C_A6",  name = "40 C BOX CHIP" },
        { pin = "ARDUINO_MEGA2560_C_A5",  name = "41 42/90 CHIP" },
        { pin = "ARDUINO_MEGA2560_C_D51", name = "42 OVER TORQ" },
        { pin = "ARDUINO_MEGA2560_C_D52", name = "43 RPM" },
        { pin = "ARDUINO_MEGA2560_C_D53", name = "44 AFCS" },
        { pin = "ARDUINO_MEGA2560_C_A4",  name = "45 FT OFF" },
        { pin = "ARDUINO_MEGA2560_C_A3",  name = "46 CYC CTR" },
        { pin = "ARDUINO_MEGA2560_C_A2",  name = "47 DOOR LOCK" },
        { pin = "ARDUINO_MEGA2560_C_A1",  name = "48 HEATER AIR" },
        { pin = "ARDUINO_MEGA2560_C_A0",  name = "49 CAUTION PANEL" },
        { pin = "ARDUINO_MEGA2560_C_D9",  name = "50 EMER FLOATS" },
        { pin = "ARDUINO_MEGA2560_C_D10", name = "51 CARGO RELEASE" },
        { pin = "ARDUINO_MEGA2560_C_D11", name = "52 BAG FIRE" },
        { pin = "ARDUINO_MEGA2560_C_D12", name = "53 WSHLD HEAT" },
        { pin = "ARDUINO_MEGA2560_C_D13", name = "54 20 FT CAUTION" },
        { pin = "ARDUINO_MEGA2560_C_D2",  name = "55 NIGHTSUN" },
        { pin = "ARDUINO_MEGA2560_C_D14", name = "56 SPARE" },
    },
    buttons = {
        { pin = "ARDUINO_MEGA2560_C_D22", name = "CWP Test Switch PNL" },
        { pin = "ARDUINO_MEGA2560_C_D23", name = "CWP Test Button" },
        { pin = "ARDUINO_MEGA2560_C_D24", name = "CWP Test Switch Pos2" },
        { pin = "ARDUINO_MEGA2560_C_D4",  name = "Bright/Dim Bright" },
        { pin = "ARDUINO_MEGA2560_C_D5",  name = "Bright/Dim Dim" },
    },
}

-- =============================================================================
-- HANDLE STORAGE
-- =============================================================================
local led_handles = {}
local output_handles = {}
local servo_ahrs_h = nil

-- =============================================================================
-- BUILD TEST LIST (at load time)
-- =============================================================================
local function build_tests()
    local count = 0
    
    -- Arduino A LEDs
    for _, led in ipairs(ARDUINO_A.leds) do
        count = count + 1
        table.insert(tests, { type = "led", arduino = "A", name = led.name, pin = led.pin, index = count })
    end
    
    -- Arduino A Outputs
    for _, out in ipairs(ARDUINO_A.outputs) do
        count = count + 1
        table.insert(tests, { type = "output", arduino = "A", name = out.name, pin = out.pin, index = count })
    end
    
    -- Arduino A Buttons
    for _, btn in ipairs(ARDUINO_A.buttons) do
        count = count + 1
        table.insert(tests, { type = "button", arduino = "A", name = btn.name, pin = btn.pin, index = count })
    end
    
    -- Arduino A Servo
    count = count + 1
    table.insert(tests, { type = "servo", arduino = "A", name = "AHRS Servo", pin = "ARDUINO_MEGA2560_A_D60", index = count })
    
    -- Arduino B LEDs
    for _, led in ipairs(ARDUINO_B.leds) do
        count = count + 1
        table.insert(tests, { type = "led", arduino = "B", name = led.name, pin = led.pin, index = count })
    end
    
    -- Arduino B Buttons
    for _, btn in ipairs(ARDUINO_B.buttons) do
        count = count + 1
        table.insert(tests, { type = "button", arduino = "B", name = btn.name, pin = btn.pin, index = count })
    end
    
    -- Arduino C LEDs
    for _, led in ipairs(ARDUINO_C.leds) do
        count = count + 1
        table.insert(tests, { type = "led", arduino = "C", name = led.name, pin = led.pin, index = count })
    end
    
    -- Arduino C Buttons
    for _, btn in ipairs(ARDUINO_C.buttons) do
        count = count + 1
        table.insert(tests, { type = "button", arduino = "C", name = btn.name, pin = btn.pin, index = count })
    end
    
    print(string.format("\nTotal tests configured: %d", count))
end

-- =============================================================================
-- INITIALIZE ALL HARDWARE (at load time)
-- =============================================================================
local function init_hardware()
    print("\nInitializing hardware...")
    
    -- Arduino A LEDs
    for _, led in ipairs(ARDUINO_A.leds) do
        led_handles[led.pin] = hw_led_add(led.pin, 0.0)
    end
    
    -- Arduino A Outputs
    for _, out in ipairs(ARDUINO_A.outputs) do
        output_handles[out.pin] = hw_output_add(out.pin, false)
    end
    
    -- Arduino A Buttons (registered at load time!)
    for _, btn in ipairs(ARDUINO_A.buttons) do
        local btn_name = btn.name
        hw_button_add(btn.pin,
            function() print(">>> PRESSED: " .. btn_name) end,
            function() print(">>> RELEASED: " .. btn_name) end
        )
    end
    
    -- Arduino A Servo
    servo_ahrs_h = hw_output_pwm_add("ARDUINO_MEGA2560_A_D60", 50, 0.075)
    
    -- Arduino B LEDs
    for _, led in ipairs(ARDUINO_B.leds) do
        led_handles[led.pin] = hw_led_add(led.pin, 0.0)
    end
    
    -- Arduino B Buttons (registered at load time!)
    for _, btn in ipairs(ARDUINO_B.buttons) do
        local btn_name = btn.name
        hw_button_add(btn.pin,
            function() print(">>> PRESSED: " .. btn_name) end,
            function() print(">>> RELEASED: " .. btn_name) end
        )
    end
    
    -- Arduino C LEDs
    for _, led in ipairs(ARDUINO_C.leds) do
        led_handles[led.pin] = hw_led_add(led.pin, 0.0)
    end
    
    -- Arduino C Buttons (registered at load time!)
    for _, btn in ipairs(ARDUINO_C.buttons) do
        local btn_name = btn.name
        hw_button_add(btn.pin,
            function() print(">>> PRESSED: " .. btn_name) end,
            function() print(">>> RELEASED: " .. btn_name) end
        )
    end
    
    print("Hardware initialized!")
end

-- =============================================================================
-- FORWARD DECLARATION
-- =============================================================================
local run_next_test

-- =============================================================================
-- TEST FUNCTIONS
-- =============================================================================

local function test_led(test_info, callback)
    print("\n=============================================================================")
    print(string.format("TEST %d/%d: LED [%s] on Arduino %s", test_info.index, #tests, test_info.name, test_info.arduino))
    print("LED ON for 10 seconds...")
    print("=============================================================================")
    
    local handle = led_handles[test_info.pin]
    if handle then
        hw_led_set(handle, 1.0)
        current_timer = timer_start(TEST_DURATION_MS, nil, function()
            hw_led_set(handle, 0.0)
            print("LED OFF")
            callback()
        end)
    else
        print("ERROR: LED handle not found")
        callback()
    end
end

local function test_output(test_info, callback)
    print("\n=============================================================================")
    print(string.format("TEST %d/%d: OUTPUT [%s] on Arduino %s", test_info.index, #tests, test_info.name, test_info.arduino))
    print("Output ON for 10 seconds...")
    print("=============================================================================")
    
    local handle = output_handles[test_info.pin]
    if handle then
        hw_output_set(handle, true)
        current_timer = timer_start(TEST_DURATION_MS, nil, function()
            hw_output_set(handle, false)
            print("Output OFF")
            callback()
        end)
    else
        print("ERROR: Output handle not found")
        callback()
    end
end

local function test_button(test_info, callback)
    print("\n=============================================================================")
    print(string.format("TEST %d/%d: BUTTON [%s] on Arduino %s", test_info.index, #tests, test_info.name, test_info.arduino))
    print(">>> Press the button within 10 seconds (check console for response)")
    print("=============================================================================")
    
    -- Just wait - buttons are already registered
    current_timer = timer_start(TEST_DURATION_MS, nil, function()
        print("Button test timeout - next...")
        callback()
    end)
end

local function test_servo(test_info, callback)
    print("\n=============================================================================")
    print(string.format("TEST %d/%d: SERVO [%s] on Arduino %s", test_info.index, #tests, test_info.name, test_info.arduino))
    print("Servo sweeping...")
    print("=============================================================================")
    
    if not servo_ahrs_h then
        print("ERROR: Servo not initialized")
        callback()
        return
    end
    
    local duty = 0.025
    local direction = 1
    local sweeps = 0
    
    servo_timer = timer_start(nil, 100, function()
        duty = duty + (0.005 * direction)
        
        if duty >= 0.125 then
            direction = -1
            sweeps = sweeps + 1
        elseif duty <= 0.025 then
            direction = 1
            sweeps = sweeps + 1
        end
        
        hw_output_pwm_duty_cycle(servo_ahrs_h, duty)
        
        if sweeps >= 2 then
            if servo_timer then
                timer_stop(servo_timer)
                servo_timer = nil
            end
            print("Servo test complete")
            callback()
        end
    end)
end

-- =============================================================================
-- TEST SEQUENCER
-- =============================================================================
run_next_test = function()
    test_index = test_index + 1
    
    if test_index > #tests then
        print("\n=============================================================================")
        print("         ALL TESTS COMPLETE!")
        print("=============================================================================")
        return
    end
    
    local test = tests[test_index]
    
    if test.type == "led" then
        test_led(test, run_next_test)
    elseif test.type == "output" then
        test_output(test, run_next_test)
    elseif test.type == "button" then
        test_button(test, run_next_test)
    elseif test.type == "servo" then
        test_servo(test, run_next_test)
    else
        run_next_test()
    end
end

local function start_tests()
    print("\n>>> Tests starting in 3 seconds...")
    timer_start(3000, nil, function()
        test_index = 0
        run_next_test()
    end)
end

-- =============================================================================
-- MAIN INITIALIZATION (runs at script load time)
-- =============================================================================
build_tests()
init_hardware()
start_tests()

print("\nHardware Test Script Loaded - All buttons registered")
