-- =============================================================================
-- vJoy Device Finder Utility (PRO - Input Monitor)
-- =============================================================================

print("--- STARTING PRO vJOY SCAN ---")

img_add_fullscreen("com_nav_radio.png")
txt_title = txt_add("VJOY PRO FINDER", "size:30px; color: white; halign: center;", 0, 10, 500, 50)
list_txt = txt_add("Move your stick now...", "size:20px; color: yellow; halign: center;", 10, 70, 480, 400)

-- A single callback that identifies which device sent it
local function universal_handler(device_name, type, index, value)
    if type == 0 then -- Axis only to keep console clean
        print(string.format("INPUT DETECTED! Device: [%s] | Axis: %d | Value: %.3f", device_name, index, value))
    end
end

-- METHOD 1: Scan and Subscribe to everything the API sees
local api_list = game_controller_list()
for i, name in ipairs(api_list) do
    print("Subscribing to API device: " .. name)
    game_controller_add(name, function(type, index, value) 
        universal_handler(name, type, index, value) 
    end)
end

-- METHOD 2: Force Probing common names just in case they are hidden
local probe_names = {
    "vJoy Device", 
    "vJoy Device 1", 
    "vJoy Device 2", 
    "BU0836X Interface", 
    "Arduino Leonardo",
    "Generic USB Joystick"
}

for _, t_name in ipairs(probe_names) do
    pcall(function() 
        game_controller_add(t_name, function(type, index, value) 
            universal_handler(t_name, type, index, value) 
        end)
        print("Probing/Subscribing to: " .. t_name)
    end)
end

print("--- MONITOR ACTIVE ---")
print("Move your stick and pedals. Look for 'INPUT DETECTED' in the console.")
