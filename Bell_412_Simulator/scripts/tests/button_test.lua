-- =============================================================================
-- BELL 412 - BUTTON TEST SCRIPT
-- Platform: Air Manager + Arduino Mega 2560
-- Purpose: Test all buttons - press to see info and light associated LED(s)
-- LED mappings verified from front_panel.lua, pedestal.lua, caution_panel.lua
-- =============================================================================

print("=============================================================================")
print("         BELL 412 BUTTON TEST")
print("         Press any button to see its info and light its LED(s)")
print("=============================================================================")

-- =============================================================================
-- ALL BUTTONS WITH CORRECT LED MAPPINGS
-- Verified from source scripts
-- =============================================================================

local ALL_BUTTONS = {
    -- =========================================================================
    -- ARDUINO A - PEDESTAL (from pedestal.lua)
    -- =========================================================================
    -- AFCS Buttons -> LEDs
    { pin = "ARDUINO_MEGA2560_A_D13", name = "AP1 Switch",         channel = "A", 
      leds = {"ARDUINO_MEGA2560_A_D5"} },  -- AP1 LED
    { pin = "ARDUINO_MEGA2560_A_D12", name = "AP2 Switch",         channel = "A", 
      leds = {"ARDUINO_MEGA2560_A_D4"} },  -- AP2 LED
    { pin = "ARDUINO_MEGA2560_A_D10", name = "AFCS SAS Switch",    channel = "A", 
      leds = {"ARDUINO_MEGA2560_A_D2", "ARDUINO_MEGA2560_A_D3"} },  -- SAS + ATT LEDs
    { pin = "ARDUINO_MEGA2560_A_D9",  name = "AFCS TEST Switch",   channel = "A", 
      leds = {"ARDUINO_MEGA2560_A_A2"}, output = true },  -- TEST LED (output)
    { pin = "ARDUINO_MEGA2560_A_D7",  name = "AFCS TRIM/FD Switch",channel = "A", 
      leds = {"ARDUINO_MEGA2560_A_A1", "ARDUINO_MEGA2560_A_A3"}, output = true },  -- TRIM + FD LEDs
    { pin = "ARDUINO_MEGA2560_A_D6",  name = "AFCS CPL Switch",    channel = "A", 
      leds = {"ARDUINO_MEGA2560_A_A4"}, output = true },  -- CPL LED
    { pin = "ARDUINO_MEGA2560_A_D43", name = "AFCS SYS2 Switch",   channel = "A", 
      leds = {} },  -- No direct LED
    
    -- AHRS & Mag/DG (no LEDs)
    { pin = "ARDUINO_MEGA2560_A_D53", name = "AHRS Test 1",        channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D49", name = "AHRS Test 2",        channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D51", name = "MAG/DG MAG1",        channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D47", name = "MAG/DG MAG2",        channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D52", name = "MAG/DG DG1",         channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D48", name = "MAG/DG DG2",         channel = "A", leds = {} },
    
    -- Fuel & Hydraulics (no direct LEDs on pedestal, monitored via CWP)
    { pin = "ARDUINO_MEGA2560_A_D30", name = "Fuel Valve 1",       channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D32", name = "Fuel Valve 2",       channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D28", name = "XFEED Bus Test",     channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D31", name = "XFEED Pos 2",        channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D33", name = "Fuel Crossfeed",     channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D34", name = "Fuel Trans 1",       channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D35", name = "Boost Pump 1",       channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D36", name = "Fuel Intercon",      channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D37", name = "Fuel Trans 2",       channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D38", name = "Boost Pump 2",       channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D39", name = "Hydraulic 1",        channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D42", name = "Hydraulic 2",        channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D23", name = "Governor Eng 1",     channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D29", name = "Governor Eng 2",     channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D25", name = "Part Sep 1",         channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D27", name = "Part Sep 2",         channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D40", name = "Force Trim",         channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D41", name = "RPM Audio",          channel = "A", leds = {} },
    
    -- =========================================================================
    -- ARDUINO B - FRONT PANEL (from front_panel.lua)
    -- =========================================================================
    -- BRG PTR
    { pin = "ARDUINO_MEGA2560_B_D38", name = "BRG PTR Left",       channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D3"} },  -- BRG PTR Left LED
    { pin = "ARDUINO_MEGA2560_B_D10", name = "BRG PTR Right",      channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D13"} },  -- BRG PTR Right LED
    
    -- Fire System
    { pin = "ARDUINO_MEGA2560_B_D50", name = "Fire Pull Left",     channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D5"} },  -- Fire Handle 1 LED
    { pin = "ARDUINO_MEGA2560_B_D35", name = "Fire Pull Right",    channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D24"} },  -- Fire Handle 2 LED
    { pin = "ARDUINO_MEGA2560_B_D51", name = "Fire Detection Test",channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D5", "ARDUINO_MEGA2560_B_D24"} },  -- Both Fire Handle LEDs
    { pin = "ARDUINO_MEGA2560_B_D52", name = "Baggage Fire Test",  channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D2"} },  -- Baggage Fire LED
    { pin = "ARDUINO_MEGA2560_B_D7",  name = "Extinguisher Main",  channel = "B", leds = {} },
    { pin = "ARDUINO_MEGA2560_B_D8",  name = "Extinguisher Reserve",channel = "B", leds = {} },
    
    -- Marker Test - Both buttons light ALL beacon LEDs (Global L:TestMarker)
    { pin = "ARDUINO_MEGA2560_B_D45", name = "Marker Test Left",   channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D46", "ARDUINO_MEGA2560_B_D47", "ARDUINO_MEGA2560_B_D48", 
              "ARDUINO_MEGA2560_B_D26", "ARDUINO_MEGA2560_B_D27", "ARDUINO_MEGA2560_B_D28"} }, 
    { pin = "ARDUINO_MEGA2560_B_D37", name = "Marker Test Right",  channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D46", "ARDUINO_MEGA2560_B_D47", "ARDUINO_MEGA2560_B_D48", 
              "ARDUINO_MEGA2560_B_D26", "ARDUINO_MEGA2560_B_D27", "ARDUINO_MEGA2560_B_D28"} },
    
    -- Over Torque - Left button lights LEFT LED, Right button lights RIGHT LED
    { pin = "ARDUINO_MEGA2560_B_D49", name = "Over Torque Left",   channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D39"} },  -- Over Torque Left LED
    { pin = "ARDUINO_MEGA2560_B_D33", name = "Over Torque Right",  channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D9"} },   -- Over Torque Right LED
    
    -- Cyclic Center - Left button lights LEFT LED, Right button lights RIGHT LED
    { pin = "ARDUINO_MEGA2560_B_D40", name = "Cyclic Center Left", channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D42"} },  -- Cyclic Center Left LED
    { pin = "ARDUINO_MEGA2560_B_D32", name = "Cyclic Center Right",channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D30"} },  -- Cyclic Center Right LED
    
    -- Master Caution - Left button (D41) lights Left LED (D43), Right button (D36) lights Right LED (D31)
    { pin = "ARDUINO_MEGA2560_B_D41", name = "Master Caution Left",channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D43"} },  -- MC Left LED
    { pin = "ARDUINO_MEGA2560_B_D36", name = "Master Caution Right",channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D31"} },  -- MC Right LED
    
    -- Fuel System Tests (no direct LEDs)
    { pin = "ARDUINO_MEGA2560_B_D53", name = "Fuel Sys Test FWD",  channel = "B", leds = {} },
    { pin = "ARDUINO_MEGA2560_B_D34", name = "Fuel Sys Test MID",  channel = "B", leds = {} },
    { pin = "ARDUINO_MEGA2560_B_D44", name = "Fuel Digit Test",    channel = "B", leds = {} },
    
    -- Nav GPS Buttons
    { pin = "ARDUINO_MEGA2560_B_D11", name = "Nav GPS Right White",channel = "B", leds = {} },
    { pin = "ARDUINO_MEGA2560_B_D25", name = "Nav GPS Left White", channel = "B", leds = {} },
    
    -- =========================================================================
    -- ARDUINO C - CAUTION PANEL (from caution_panel.lua)
    -- =========================================================================
    { pin = "ARDUINO_MEGA2560_C_D22", name = "CWP Test Switch PNL",channel = "C", leds = {} },
    { pin = "ARDUINO_MEGA2560_C_D23", name = "CWP Test Button",    channel = "C", leds = {} },  -- Lamp test lights ALL CWP LEDs
    { pin = "ARDUINO_MEGA2560_C_D24", name = "CWP Test Switch Pos2",channel = "C", leds = {} },
    { pin = "ARDUINO_MEGA2560_C_D4",  name = "Bright/Dim Bright",  channel = "C", leds = {} },
    { pin = "ARDUINO_MEGA2560_C_D5",  name = "Bright/Dim Dim",     channel = "C", leds = {} },
}

-- =============================================================================
-- STORAGE
-- =============================================================================
local led_handles = {}
local output_handles = {}

-- Extract pin number from pin string
local function get_pin_number(pin_str)
    return pin_str:match("_([DA]%d+)$") or pin_str
end

-- =============================================================================
-- COLLECT AND INITIALIZE ALL UNIQUE LEDs
-- =============================================================================
print("\nInitializing LEDs...")
local unique_leds = {}
local unique_outputs = {}

for _, btn in ipairs(ALL_BUTTONS) do
    for _, led_pin in ipairs(btn.leds or {}) do
        if btn.output then
            unique_outputs[led_pin] = true
        else
            unique_leds[led_pin] = true
        end
    end
end

-- Initialize regular LEDs
local led_count = 0
for led_pin, _ in pairs(unique_leds) do
    led_handles[led_pin] = hw_led_add(led_pin, 0.0)
    led_count = led_count + 1
end

-- Initialize output LEDs (analog pins)
local output_count = 0
for out_pin, _ in pairs(unique_outputs) do
    output_handles[out_pin] = hw_output_add(out_pin, false)
    output_count = output_count + 1
end

print(string.format("Initialized %d LEDs + %d Outputs", led_count, output_count))

-- =============================================================================
-- HELPER: Turn LEDs on/off
-- =============================================================================
local function set_button_leds(btn, state)
    for _, led_pin in ipairs(btn.leds or {}) do
        local pin_num = get_pin_number(led_pin)
        if btn.output and output_handles[led_pin] then
            hw_output_set(output_handles[led_pin], state)
            print(string.format("  -> Output %s: %s", pin_num, state and "ON" or "OFF"))
        elseif led_handles[led_pin] then
            hw_led_set(led_handles[led_pin], state and 1.0 or 0.0)
            print(string.format("  -> LED %s: %s", pin_num, state and "ON" or "OFF"))
        end
    end
end

-- =============================================================================
-- REGISTER ALL BUTTONS (must be done at load time!)
-- =============================================================================
print("\nRegistering buttons...")

for _, btn in ipairs(ALL_BUTTONS) do
    local btn_name = btn.name
    local btn_pin = btn.pin
    local btn_channel = btn.channel
    local btn_leds = btn.leds or {}
    local pin_num = get_pin_number(btn_pin)
    
    -- Build LED list string
    local led_list = {}
    for _, led_pin in ipairs(btn_leds) do
        table.insert(led_list, get_pin_number(led_pin))
    end
    local led_str = #led_list > 0 and table.concat(led_list, ", ") or "None"
    
    hw_button_add(btn_pin,
        function() -- PRESSED
            print("\n=============================================================================")
            print(">>> BUTTON PRESSED")
            print(string.format("  Name:      %s", btn_name))
            print(string.format("  Channel:   Arduino %s", btn_channel))
            print(string.format("  Pin:       %s", pin_num))
            print(string.format("  LED(s):    %s", led_str))
            print("=============================================================================")
            
            -- Light associated LEDs
            set_button_leds(btn, true)
        end,
        function() -- RELEASED
            print(string.format(">>> RELEASED: %s (%s)", btn_name, pin_num))
            
            -- Turn off associated LEDs
            set_button_leds(btn, false)
        end
    )
end

print(string.format("Registered %d buttons", #ALL_BUTTONS))

-- =============================================================================
-- COUNT BUTTONS WITH LEDs
-- =============================================================================
local buttons_with_leds = 0
for _, btn in ipairs(ALL_BUTTONS) do
    if btn.leds and #btn.leds > 0 then
        buttons_with_leds = buttons_with_leds + 1
    end
end

-- =============================================================================
-- READY MESSAGE
-- =============================================================================
print("\n=============================================================================")
print("         BUTTON TEST READY!")
print("         Press any button to see its info and light its LED(s)")
print(string.format("         Total Buttons: %d", #ALL_BUTTONS))
print(string.format("         Buttons with LEDs: %d", buttons_with_leds))
print("=============================================================================")

print("\nButton Test Script Loaded - Waiting for button presses...")
