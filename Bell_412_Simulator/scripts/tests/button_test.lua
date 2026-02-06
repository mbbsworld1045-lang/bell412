-- =============================================================================
-- BELL 412 - BUTTON TEST SCRIPT
-- Platform: Air Manager + Arduino Mega 2560
-- Purpose: Test all buttons - press to see info and light associated LED(s)
-- Channels: A (Pedestal), B (Front Panel), C (Collective), D (Caution Panel)
-- =============================================================================

print("=============================================================================")
print("         BELL 412 BUTTON TEST")
print("         Press any button to see its info and light its LED(s)")
print("=============================================================================")

-- =============================================================================
-- ALL BUTTONS WITH CORRECT LED MAPPINGS
-- =============================================================================

local ALL_BUTTONS = {
    -- =========================================================================
    -- ARDUINO A - PEDESTAL (pedestal.lua)
    -- =========================================================================
    -- AFCS Buttons -> LEDs
    { pin = "ARDUINO_MEGA2560_A_D13", name = "AP1 Switch",          channel = "A", 
      leds = {"ARDUINO_MEGA2560_A_D5"} },
    { pin = "ARDUINO_MEGA2560_A_D12", name = "AP2 Switch",          channel = "A", 
      leds = {"ARDUINO_MEGA2560_A_D4"} },
    { pin = "ARDUINO_MEGA2560_A_D10", name = "AFCS SAS Switch",     channel = "A", 
      leds = {"ARDUINO_MEGA2560_A_D2", "ARDUINO_MEGA2560_A_D3"} },
    { pin = "ARDUINO_MEGA2560_A_D9",  name = "AFCS TEST Switch",    channel = "A", 
      leds = {"ARDUINO_MEGA2560_A_A2"}, output = true },
    { pin = "ARDUINO_MEGA2560_A_D7",  name = "AFCS TRIM/FD Switch", channel = "A", 
      leds = {"ARDUINO_MEGA2560_A_A1", "ARDUINO_MEGA2560_A_A3"}, output = true },
    { pin = "ARDUINO_MEGA2560_A_D6",  name = "AFCS CPL Switch",     channel = "A", 
      leds = {"ARDUINO_MEGA2560_A_A4"}, output = true },
    { pin = "ARDUINO_MEGA2560_A_D43", name = "AFCS SYS2 Switch",    channel = "A", leds = {} },
    
    -- AHRS & Mag/DG
    { pin = "ARDUINO_MEGA2560_A_D53", name = "AHRS Test 1",         channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D49", name = "AHRS Test 2",         channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D51", name = "MAG/DG MAG1",         channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D47", name = "MAG/DG MAG2",         channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D52", name = "MAG/DG DG1",          channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D48", name = "MAG/DG DG2",          channel = "A", leds = {} },
    
    -- Fuel & Hydraulics
    { pin = "ARDUINO_MEGA2560_A_D30", name = "Fuel Valve 1",        channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D32", name = "Fuel Valve 2",        channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D28", name = "XFEED Bus Test",      channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D31", name = "XFEED Pos 2",         channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D33", name = "Fuel Crossfeed",      channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D34", name = "Fuel Trans 1",        channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D35", name = "Boost Pump 1",        channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D36", name = "Fuel Intercon",       channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D37", name = "Fuel Trans 2",        channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D38", name = "Boost Pump 2",        channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D39", name = "Hydraulic 1",         channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D42", name = "Hydraulic 2",         channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D23", name = "Governor Eng 1",      channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D29", name = "Governor Eng 2",      channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D25", name = "Part Sep 1",          channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D27", name = "Part Sep 2",          channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D40", name = "Force Trim",          channel = "A", leds = {} },
    { pin = "ARDUINO_MEGA2560_A_D41", name = "RPM Audio",           channel = "A", leds = {} },
    
    -- =========================================================================
    -- ARDUINO B - FRONT PANEL (front_panel.lua)
    -- =========================================================================
    -- BRG PTR
    { pin = "ARDUINO_MEGA2560_B_D38", name = "BRG PTR Left",        channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D3"} },
    { pin = "ARDUINO_MEGA2560_B_D10", name = "BRG PTR Right",       channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D13"} },
    
    -- Fire System
    { pin = "ARDUINO_MEGA2560_B_D50", name = "Fire Pull Left",      channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D5"} },
    { pin = "ARDUINO_MEGA2560_B_D35", name = "Fire Pull Right",     channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D24"} },
    { pin = "ARDUINO_MEGA2560_B_D51", name = "Fire Detection Test", channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D5", "ARDUINO_MEGA2560_B_D24"} },
    { pin = "ARDUINO_MEGA2560_B_D52", name = "Baggage Fire Test",   channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D2"} },
    { pin = "ARDUINO_MEGA2560_B_D7",  name = "Extinguisher Main",   channel = "B", leds = {} },
    { pin = "ARDUINO_MEGA2560_B_D8",  name = "Extinguisher Reserve",channel = "B", leds = {} },
    
    -- Marker Test
    { pin = "ARDUINO_MEGA2560_B_D45", name = "Marker Test Left",    channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D46", "ARDUINO_MEGA2560_B_D47", "ARDUINO_MEGA2560_B_D48", 
              "ARDUINO_MEGA2560_B_D26", "ARDUINO_MEGA2560_B_D27", "ARDUINO_MEGA2560_B_D28"} },
    { pin = "ARDUINO_MEGA2560_B_D37", name = "Marker Test Right",   channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D46", "ARDUINO_MEGA2560_B_D47", "ARDUINO_MEGA2560_B_D48", 
              "ARDUINO_MEGA2560_B_D26", "ARDUINO_MEGA2560_B_D27", "ARDUINO_MEGA2560_B_D28"} },
    
    -- Over Torque
    { pin = "ARDUINO_MEGA2560_B_D49", name = "Over Torque Left",    channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D39"} },
    { pin = "ARDUINO_MEGA2560_B_D33", name = "Over Torque Right",   channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D9"} },
    
    -- Cyclic Center
    { pin = "ARDUINO_MEGA2560_B_D40", name = "Cyclic Center Left",  channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D42"} },
    { pin = "ARDUINO_MEGA2560_B_D32", name = "Cyclic Center Right", channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D30"} },
    
    -- Master Caution
    { pin = "ARDUINO_MEGA2560_B_D41", name = "Master Caution Left", channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D43"} },
    { pin = "ARDUINO_MEGA2560_B_D36", name = "Master Caution Right",channel = "B", 
      leds = {"ARDUINO_MEGA2560_B_D31"} },
    
    -- Fuel Tests
    { pin = "ARDUINO_MEGA2560_B_D53", name = "Fuel Sys Test FWD",   channel = "B", leds = {} },
    { pin = "ARDUINO_MEGA2560_B_D34", name = "Fuel Sys Test MID",   channel = "B", leds = {} },
    { pin = "ARDUINO_MEGA2560_B_D44", name = "Fuel Digit Test",     channel = "B", leds = {} },
    
    -- Nav GPS
    { pin = "ARDUINO_MEGA2560_B_D11", name = "Nav GPS Right",       channel = "B", leds = {} },
    { pin = "ARDUINO_MEGA2560_B_D25", name = "Nav GPS Left",        channel = "B", leds = {} },
    
    -- =========================================================================
    -- ARDUINO C - COLLECTIVE (collective.lua)
    -- =========================================================================
    -- Landing Light
    { pin = "ARDUINO_MEGA2560_C_D22", name = "LDG LIGHT LT",        channel = "C", leds = {} },
    { pin = "ARDUINO_MEGA2560_C_D26", name = "LDG LT EXT",          channel = "C", leds = {} },
    { pin = "ARDUINO_MEGA2560_C_D25", name = "LDG LT RETR",         channel = "C", leds = {} },
    
    -- Search Light
    { pin = "ARDUINO_MEGA2560_C_D23", name = "SRCH LT ON",          channel = "C", leds = {} },
    { pin = "ARDUINO_MEGA2560_C_D24", name = "SRCH LT STOW",        channel = "C", leds = {} },
    { pin = "ARDUINO_MEGA2560_C_D39", name = "SRCH LT EXT",         channel = "C", leds = {} },
    { pin = "ARDUINO_MEGA2560_C_D37", name = "SRCH LT L",           channel = "C", leds = {} },
    { pin = "ARDUINO_MEGA2560_C_D38", name = "SRCH LT R",           channel = "C", leds = {} },
    { pin = "ARDUINO_MEGA2560_C_D40", name = "SRCH LT RETR",        channel = "C", leds = {} },
    
    -- Idle Stop
    { pin = "ARDUINO_MEGA2560_C_D28", name = "IDLE STOP ENG1",      channel = "C", leds = {} },
    { pin = "ARDUINO_MEGA2560_C_D29", name = "IDLE STOP ENG2",      channel = "C", leds = {} },
    
    -- Start
    { pin = "ARDUINO_MEGA2560_C_D31", name = "START ENG1",          channel = "C", leds = {} },
    { pin = "ARDUINO_MEGA2560_C_D30", name = "START ENG2",          channel = "C", leds = {} },
    
    -- RPM (Right Hand)
    { pin = "ARDUINO_MEGA2560_C_D34", name = "RPM INC RH",          channel = "C", leds = {} },
    { pin = "ARDUINO_MEGA2560_C_D35", name = "RPM DEC RH",          channel = "C", leds = {} },
    { pin = "ARDUINO_MEGA2560_C_D36", name = "RPM +2",              channel = "C", leds = {} },
    { pin = "ARDUINO_MEGA2560_C_D33", name = "RPM -2",              channel = "C", leds = {} },
    
    -- Yaw (Right Hand)
    { pin = "ARDUINO_MEGA2560_C_D48", name = "YAW UP RH",           channel = "C", leds = {} },
    { pin = "ARDUINO_MEGA2560_C_D32", name = "YAW DOWN RH",         channel = "C", leds = {} },
    
    -- Go Around (Right Hand)
    { pin = "ARDUINO_MEGA2560_C_D41", name = "GO AROUND RH",        channel = "C", leds = {} },
    
    -- RPM (Left Hand)
    { pin = "ARDUINO_MEGA2560_C_D45", name = "RPM INC LH",          channel = "C", leds = {} },
    { pin = "ARDUINO_MEGA2560_C_D46", name = "RPM DEC LH",          channel = "C", leds = {} },
    
    -- Yaw (Left Hand)
    { pin = "ARDUINO_MEGA2560_C_D44", name = "YAW UP LH",           channel = "C", leds = {} },
    { pin = "ARDUINO_MEGA2560_C_D43", name = "YAW DOWN LH",         channel = "C", leds = {} },
    
    -- Go Around (Left Hand)
    { pin = "ARDUINO_MEGA2560_C_D42", name = "GO AROUND LH",        channel = "C", leds = {} },
    
    -- =========================================================================
    -- ARDUINO D - CAUTION PANEL (caution_panel.lua)
    -- =========================================================================
    { pin = "ARDUINO_MEGA2560_D_D22", name = "CWP Test Switch PNL", channel = "D", leds = {} },
    { pin = "ARDUINO_MEGA2560_D_D23", name = "CWP Test Button",     channel = "D", leds = {} },
    { pin = "ARDUINO_MEGA2560_D_D24", name = "CWP Test Switch Pos2",channel = "D", leds = {} },
    { pin = "ARDUINO_MEGA2560_D_D4",  name = "Bright/Dim Bright",   channel = "D", leds = {} },
    { pin = "ARDUINO_MEGA2560_D_D5",  name = "Bright/Dim Dim",      channel = "D", leds = {} },
}

-- =============================================================================
-- STORAGE
-- =============================================================================
local led_handles = {}
local output_handles = {}

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
        if btn.output then unique_outputs[led_pin] = true
        else unique_leds[led_pin] = true end
    end
end

local led_count = 0
for led_pin, _ in pairs(unique_leds) do
    led_handles[led_pin] = hw_led_add(led_pin, 0.0)
    led_count = led_count + 1
end

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
-- REGISTER ALL BUTTONS
-- =============================================================================
print("\nRegistering buttons...")

for _, btn in ipairs(ALL_BUTTONS) do
    local btn_name = btn.name
    local btn_channel = btn.channel
    local btn_leds = btn.leds or {}
    local pin_num = get_pin_number(btn.pin)
    
    local led_list = {}
    for _, led_pin in ipairs(btn_leds) do
        table.insert(led_list, get_pin_number(led_pin))
    end
    local led_str = #led_list > 0 and table.concat(led_list, ", ") or "None"
    
    hw_button_add(btn.pin,
        function()
            print("\n=============================================================================")
            print(">>> BUTTON PRESSED")
            print(string.format("  Name:      %s", btn_name))
            print(string.format("  Channel:   Arduino %s", btn_channel))
            print(string.format("  Pin:       %s", pin_num))
            print(string.format("  LED(s):    %s", led_str))
            print("=============================================================================")
            set_button_leds(btn, true)
        end,
        function()
            print(string.format(">>> RELEASED: %s (%s)", btn_name, pin_num))
            set_button_leds(btn, false)
        end
    )
end

print(string.format("Registered %d buttons", #ALL_BUTTONS))

-- =============================================================================
-- COUNT
-- =============================================================================
local buttons_with_leds = 0
for _, btn in ipairs(ALL_BUTTONS) do
    if btn.leds and #btn.leds > 0 then buttons_with_leds = buttons_with_leds + 1 end
end

print("\n=============================================================================")
print("         BUTTON TEST READY!")
print("         Press any button to see its info and light its LED(s)")
print(string.format("         Total Buttons: %d", #ALL_BUTTONS))
print(string.format("         Buttons with LEDs: %d", buttons_with_leds))
print("         Channels: A (Pedestal), B (Front), C (Collective), D (Caution)")
print("=============================================================================")

print("\nButton Test Script Loaded - Waiting for button presses...")
