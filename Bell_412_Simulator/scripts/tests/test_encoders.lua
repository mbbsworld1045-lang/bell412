-- =============================================================================
-- BELL 412 - ROTARY ENCODER TEST
-- Testing CW and CCW directions for specified instrument encoders
-- =============================================================================

print("Starting Rotary Encoder Direction Test...")

-- IMPORTANT: Please change this variable to match the actual Arduino channel 
-- letter (A, B, C, D, E, or F) where these encoders are wired!
local ARDUINO_CHANNEL = "ARDUINO_MEGA2560_G_" 

-- Helper function to register an encoder easily
local function add_encoder(name, pin_a, pin_b)
    if not pin_a or not pin_b then
        print("WARNING: Skipping " .. name .. " - Missing pin definition (Unknown)")
        return
    end

    local full_pin_a = ARDUINO_CHANNEL .. pin_a
    local full_pin_b = ARDUINO_CHANNEL .. pin_b

    -- Note: Provide 1 detent per pulse as default, adjust if your encoder requires 2 or 4
    hw_dial_add(full_pin_a, full_pin_b, "TYPE_1_DETENT_PER_PULSE", function(direction)
        if direction == 1 then
            print(name .. " turned Clockwise (RIGHT / CW)")
        elseif direction == -1 then
            print(name .. " turned Counter-Clockwise (LEFT / CCW)")
        end
    end)
end

-- =============================================================================
-- RIGHT PANEL ENCODERS
-- =============================================================================
add_encoder("Alt Meter Right",        "D15", "D16")
add_encoder("Radar ALT Meter Right",  "D2",  "D51")

add_encoder("ADI Right (Right Enc)",  "D52", "D17")
add_encoder("ADI Right (Left Enc)",   "D14", "A15")

add_encoder("HSI Right (Right Enc)",  "A13", "A14")
add_encoder("HSI Right (Left Enc)",   "D19", "A11")

add_encoder("CDI Right",              "D18", "A12")


-- =============================================================================
-- LEFT PANEL ENCODERS
-- =============================================================================
add_encoder("Alt Meter Left",         "A7",  "D8")

add_encoder("ADI Left (Right Enc)",   "A6",  "A2")
add_encoder("ADI Left (Left Enc)",    "D12", nil)  -- Unknown pin provided by user

add_encoder("HSI Left (Right Enc)",   "A4",  "D9")
add_encoder("HSI Left (Left Enc)",    "D7",  nil)  -- Unknown pin provided by user

print("\nAll known encoders have been registered.")
print("If an encoder turns opposite to CW/CCW expectations, simply swap the physical wires or swap 'D15' and 'D16' in this script!")
print("Waiting for encoder input...\n")
