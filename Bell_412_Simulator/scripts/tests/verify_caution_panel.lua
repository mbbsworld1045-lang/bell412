-- =============================================================================
-- BELL 412 - CAUTION PANEL VERIFICATION SCRIPT
-- Platform: Air Manager + Arduino Mega 2560
-- Purpose: Light up Caution Panel LEDs ONE BY ONE to verify Pin/Name mappings.
-- Usage: Run this script and watch your hardware panel while reading the console.
-- =============================================================================

print("=============================================================================")
print("         CAUTION PANEL VERIFICATION STARTED")
print("         Each LED will light up for 3 seconds.")
print("=============================================================================")

-- LED Definitions (Channel E) - User provided order 
local CAUTION_LEDS = {
    { pin = "ARDUINO_MEGA2560_E_D25", name = "Ignition L" },
    { pin = "ARDUINO_MEGA2560_E_D26", name = "No 1 Hyd L" },
    { pin = "ARDUINO_MEGA2560_E_D27", name = "Fuel Valve L" },
    { pin = "ARDUINO_MEGA2560_E_D28", name = "Eng Chip L" },
    { pin = "ARDUINO_MEGA2560_E_D29", name = "Auto Cont ON L" },
    { pin = "ARDUINO_MEGA2560_E_D30", name = "DC Generator L" },
    { pin = "ARDUINO_MEGA2560_E_D31", name = "-" },
    { pin = "ARDUINO_MEGA2560_E_D32", name = "Rotor Brake L" },
    { pin = "ARDUINO_MEGA2560_E_D33", name = "-" },
    { pin = "ARDUINO_MEGA2560_E_D34", name = "Auto Pilot 1 L" },
    { pin = "ARDUINO_MEGA2560_E_D35", name = "C box Oil Pressure L" },
    { pin = "ARDUINO_MEGA2560_E_D36", name = "-" },
    { pin = "ARDUINO_MEGA2560_E_D37", name = "Oil Pressure L" },
    { pin = "ARDUINO_MEGA2560_E_D38", name = "EFIS Fan 1 L" },
    { pin = "ARDUINO_MEGA2560_E_D39", name = "Heater Air Line L" },
    { pin = "ARDUINO_MEGA2560_E_D40", name = "Fuel Trans 1 L" },
    { pin = "ARDUINO_MEGA2560_E_D41", name = "Fuel Low L" },
    { pin = "ARDUINO_MEGA2560_E_D42", name = "Battery Temp L" },
    { pin = "ARDUINO_MEGA2560_E_D50", name = "Cbox Oil Temp L" },
    { pin = "ARDUINO_MEGA2560_E_D49", name = "Par Sep Off L" },
    { pin = "ARDUINO_MEGA2560_E_D48", name = "Fuel Filter 1 L" },
    { pin = "ARDUINO_MEGA2560_E_D3",  name = "External Power L" },
    { pin = "ARDUINO_MEGA2560_E_D47", name = "Gov Manual L" },
    { pin = "ARDUINO_MEGA2560_E_D46", name = "Inverter 1 L" },
    { pin = "ARDUINO_MEGA2560_E_D45", name = "Fuel Boost 1 L" },
    { pin = "ARDUINO_MEGA2560_E_D44", name = "-" },
    { pin = "ARDUINO_MEGA2560_E_D43", name = "Cbox Chip L" },
    { pin = "ARDUINO_MEGA2560_E_D6",  name = "Door Lock R" },
    { pin = "ARDUINO_MEGA2560_E_D7",  name = "-" },
    { pin = "ARDUINO_MEGA2560_E_D8",  name = "Eng Chip R" },
    { pin = "ARDUINO_MEGA2560_E_A15", name = "Auto Pilot 2 R" },
    { pin = "ARDUINO_MEGA2560_E_A14", name = "DC Generator R" },
    { pin = "ARDUINO_MEGA2560_E_A13", name = "Fuel Boost 2 R" },
    { pin = "ARDUINO_MEGA2560_E_A12", name = "Fuel Valve R" },
    { pin = "ARDUINO_MEGA2560_E_A11", name = "Oil Pressure R" },
    { pin = "ARDUINO_MEGA2560_E_A10", name = "Fuel Filter 2 R" },
    { pin = "ARDUINO_MEGA2560_E_A9",  name = "Empty" },
    { pin = "ARDUINO_MEGA2560_E_A8",  name = "Caution Panel R" },
    { pin = "ARDUINO_MEGA2560_E_A7",  name = "Invertor 2 R" },
    { pin = "ARDUINO_MEGA2560_E_A6",  name = "Battery R" },
    { pin = "ARDUINO_MEGA2560_E_A5",  name = "Fuel Trans 2 R" },
    { pin = "ARDUINO_MEGA2560_E_D51", name = "Rotor Brake R" },
    { pin = "ARDUINO_MEGA2560_E_D52", name = "Fuel Intercon R" },
    { pin = "ARDUINO_MEGA2560_E_D53", name = "42/90 Box Chip R" },
    { pin = "ARDUINO_MEGA2560_E_A4",  name = "Xmsn Oil Temp R" },
    { pin = "ARDUINO_MEGA2560_E_A3",  name = "EFIS FAN 2 R" },
    { pin = "ARDUINO_MEGA2560_E_A2",  name = "CLTV R" },
    { pin = "ARDUINO_MEGA2560_E_A1",  name = "Auto Trim R" },
    { pin = "ARDUINO_MEGA2560_E_A0",  name = "XMSN Oil Pressure R" },
    { pin = "ARDUINO_MEGA2560_E_D9",  name = "Fuel Xfeed R" },
    { pin = "ARDUINO_MEGA2560_E_D10", name = "AHRS Fan R" },
    { pin = "ARDUINO_MEGA2560_E_D11", name = "XMSN Chip R" },
    { pin = "ARDUINO_MEGA2560_E_D12", name = "Par Sep Off R" },
    { pin = "ARDUINO_MEGA2560_E_D13", name = "No 2 Hyd R" },
    { pin = "ARDUINO_MEGA2560_E_D2",  name = "Empty" },
    { pin = "ARDUINO_MEGA2560_E_D14", name = "Empty" },
}

-- Initialize all LEDs to OFF using DIGITAL OUTPUTS
local led_handles = {}
local valid_count = 0
for i, led_def in ipairs(CAUTION_LEDS) do
    local handle = hw_output_add(led_def.pin, false)
    led_handles[i] = handle -- Store even if nil (though usually returns handle or errors)
    if handle then valid_count = valid_count + 1 end
end

print(string.format("DEBUG: Initialized %d/%d Output handles.", valid_count, #CAUTION_LEDS))

-- Timer Logic
local current_index = 0
local timer_id = nil

local function next_led()
    -- Turn OFF previous LED
    if current_index > 0 and current_index <= #led_handles then
        local prev_handle = led_handles[current_index]
        if prev_handle then hw_output_set(prev_handle, false) end
    end

    -- Increment
    current_index = current_index + 1

    -- Check if done
    if current_index > #CAUTION_LEDS then
        print("=============================================================================")
        print("         VERIFICATION COMPLETE")
        print("=============================================================================")
        -- Restart?
        current_index = 0 
        print("Restarting sequence in 5 seconds...")
        if timer_id then timer_stop(timer_id) end
        timer_id = timer_start(5000, function() 
            timer_id = timer_start(3000, next_led) -- Restart regular timer
            next_led()
        end)
        return
    end

    -- Turn ON current LED
    local led = CAUTION_LEDS[current_index]
    local handle = led_handles[current_index]
    
    -- Determine Duration based on Name
    -- Defined: 3 seconds. Missing/Empty: 15 seconds.
    local duration = 3000
    if led.name == "-" or led.name == "Empty" or led.name:find("Unmapped") then
        duration = 15000 -- 15 seconds for unknown/missing to trace
    end
    
    -- First LED for 20 seconds (as requested)
    if current_index == 1 then 
        duration = 20000 
        print("    --> EXTENDED DURATION (20s) for First LED")
    end

    if handle then
        hw_output_set(handle, true)
        -- Print Info
        print(string.format("TESTING [%02d/%02d]:  %-20s  (Pin: %s)", 
            current_index, #CAUTION_LEDS, led.name, led.pin:gsub("ARDUINO_MEGA2560_E_", "")))
    else
        print(string.format("SKIPPING [%02d/%02d]:  %-20s  (Pin: %s) - INVALID HANDLE", 
            current_index, #CAUTION_LEDS, led.name, led.pin:gsub("ARDUINO_MEGA2560_E_", "")))
        duration = 500 -- Skip fast if handle invalid
    end
        
    -- Schedule NEXT step
    timer_id = timer_start(duration, next_led)
end

-- Start the sequence immediately
next_led()
