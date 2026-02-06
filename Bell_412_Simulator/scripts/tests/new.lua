-- =============================================================================
-- BELL 412 - SPECIFIC LED + BUTTON TEST (new.lua)
-- Platform: Air Manager + Arduino Mega 2560
-- Purpose: Test specific LEDs with dedicated test buttons
-- LEDs: Engine 1, Engine 2, Right Beacon (3 separate), MC Left, RPM Left
-- =============================================================================

print("=============================================================================")
print("         BELL 412 - LED + BUTTON TEST")
print("         Press button to light corresponding LED")
print("=============================================================================")

-- =============================================================================
-- STORAGE
-- =============================================================================
local led_handles = {}

-- Get pin number from full pin string
local function get_pin_number(pin_str)
    return pin_str:match("_([DA]%d+)$") or pin_str
end

-- =============================================================================
-- INITIALIZE LEDs (Channel B)
-- =============================================================================
print("\nInitializing LEDs...")

led_handles["D4"]  = hw_led_add("ARDUINO_MEGA2560_B_D4", 0.0)   -- Engine 1
led_handles["D12"] = hw_led_add("ARDUINO_MEGA2560_B_D12", 0.0)  -- Engine 2
led_handles["D26"] = hw_led_add("ARDUINO_MEGA2560_B_D26", 0.0)  -- Right Beacon Red
led_handles["D27"] = hw_led_add("ARDUINO_MEGA2560_B_D27", 0.0)  -- Right Beacon White
led_handles["D28"] = hw_led_add("ARDUINO_MEGA2560_B_D28", 0.0)  -- Right Beacon Blue
led_handles["D43"] = hw_led_add("ARDUINO_MEGA2560_B_D43", 0.0)  -- MC Left
led_handles["D23"] = hw_led_add("ARDUINO_MEGA2560_B_D23", 0.0)  -- RPM Left

print("  LED D4  - Engine 1 Warning")
print("  LED D12 - Engine 2 Warning")
print("  LED D26 - Right Beacon Red")
print("  LED D27 - Right Beacon White")
print("  LED D28 - Right Beacon Blue")
print("  LED D43 - Master Caution Left")
print("  LED D23 - RPM Left")

-- =============================================================================
-- REGISTER TEST BUTTONS (at load time)
-- =============================================================================
print("\nRegistering test buttons...")

-- Button 1: D50 -> Engine 1 LED (D4)
hw_button_add("ARDUINO_MEGA2560_B_D50",
    function()
        print(">>> PRESSED: Button D50 -> Engine 1 LED (D4) ON")
        hw_led_set(led_handles["D4"], 1.0)
    end,
    function()
        print(">>> RELEASED: Button D50 -> Engine 1 LED OFF")
        hw_led_set(led_handles["D4"], 0.0)
    end
)

-- Button 2: D35 -> Engine 2 LED (D12)
hw_button_add("ARDUINO_MEGA2560_B_D35",
    function()
        print(">>> PRESSED: Button D35 -> Engine 2 LED (D12) ON")
        hw_led_set(led_handles["D12"], 1.0)
    end,
    function()
        print(">>> RELEASED: Button D35 -> Engine 2 LED OFF")
        hw_led_set(led_handles["D12"], 0.0)
    end
)

-- Button 3: D37 -> Right Beacon RED LED (D26)
hw_button_add("ARDUINO_MEGA2560_B_D37",
    function()
        print(">>> PRESSED: Button D37 -> Right Beacon RED (D26) ON")
        hw_led_set(led_handles["D26"], 1.0)
    end,
    function()
        print(">>> RELEASED: Button D37 -> Right Beacon RED OFF")
        hw_led_set(led_handles["D26"], 0.0)
    end
)

-- Button 4: D45 -> Right Beacon WHITE LED (D27)
hw_button_add("ARDUINO_MEGA2560_B_D45",
    function()
        print(">>> PRESSED: Button D45 -> Right Beacon WHITE (D27) ON")
        hw_led_set(led_handles["D27"], 1.0)
    end,
    function()
        print(">>> RELEASED: Button D45 -> Right Beacon WHITE OFF")
        hw_led_set(led_handles["D27"], 0.0)
    end
)

-- Button 5: D52 -> Right Beacon BLUE LED (D28)
hw_button_add("ARDUINO_MEGA2560_B_D52",
    function()
        print(">>> PRESSED: Button D52 -> Right Beacon BLUE (D28) ON")
        hw_led_set(led_handles["D28"], 1.0)
    end,
    function()
        print(">>> RELEASED: Button D52 -> Right Beacon BLUE OFF")
        hw_led_set(led_handles["D28"], 0.0)
    end
)

-- Button 6: D41 -> MC Left LED (D43)
hw_button_add("ARDUINO_MEGA2560_B_D41",
    function()
        print(">>> PRESSED: Button D41 -> MC Left LED (D43) ON")
        hw_led_set(led_handles["D43"], 1.0)
    end,
    function()
        print(">>> RELEASED: Button D41 -> MC Left LED OFF")
        hw_led_set(led_handles["D43"], 0.0)
    end
)

-- Button 7: D49 -> RPM Left LED (D23)
hw_button_add("ARDUINO_MEGA2560_B_D49",
    function()
        print(">>> PRESSED: Button D49 -> RPM Left LED (D23) ON")
        hw_led_set(led_handles["D23"], 1.0)
    end,
    function()
        print(">>> RELEASED: Button D49 -> RPM Left LED OFF")
        hw_led_set(led_handles["D23"], 0.0)
    end
)

print("\n=============================================================================")
print("         BUTTON -> LED MAPPING (ALL CHANNEL B)")
print("=============================================================================")
print("  Button D50 -> LED D4  (Engine 1 Warning)")
print("  Button D35 -> LED D12 (Engine 2 Warning)")
print("  Button D37 -> LED D26 (Right Beacon RED)")
print("  Button D45 -> LED D27 (Right Beacon WHITE)")
print("  Button D52 -> LED D28 (Right Beacon BLUE)")
print("  Button D41 -> LED D43 (Master Caution Left)")
print("  Button D49 -> LED D23 (RPM Left)")
print("=============================================================================")
print("\nPress any button to test its LED!")
