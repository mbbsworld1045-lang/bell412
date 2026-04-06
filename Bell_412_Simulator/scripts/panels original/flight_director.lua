-- =============================================================================
-- BELL 412 - FLIGHT DIRECTOR LOGIC
-- Platform: Air Manager + Arduino Mega 2560
-- Hardware: Arduino Channel F (Flight Directors)
-- =============================================================================

print("Flight Director Script Running")

-- =============================================================================
-- 1. HARDWARE CONFIGURATION HEADER
-- =============================================================================

-- Flight Director 1 (FD1)
local PIN_FD1_ALT       = "ARDUINO_MEGA2560_F_D46"      -- ALT
local PIN_FD1_IAS       = "ARDUINO_MEGA2560_F_D47"      -- IAS
local PIN_FD1_VS        = "ARDUINO_MEGA2560_F_D48"      -- VS
local PIN_FD1_HDG       = "ARDUINO_MEGA2560_F_D49"      -- HDG
local PIN_FD1_NAV       = "ARDUINO_MEGA2560_F_D50"      -- NAV
local PIN_FD1_ILS       = "ARDUINO_MEGA2560_F_D51"      -- ILS
local PIN_FD1_BC        = "ARDUINO_MEGA2560_F_D52"      -- BC
local PIN_FD1_VOR_APR   = "ARDUINO_MEGA2560_F_D53"      -- VOR APR
-- CSV Correction: GA Button is D13
local PIN_FD1_GA        = "ARDUINO_MEGA2560_F_D13"      -- GA
local PIN_FD1_SBY       = "ARDUINO_MEGA2560_F_A1"       -- SBY

-- Flight Director 1 (FD1) LEDs
local PIN_FD1_LED_VS        = "ARDUINO_MEGA2560_F_A4"
local PIN_FD1_LED_IAS       = "ARDUINO_MEGA2560_F_A2"
local PIN_FD1_LED_ALT       = "ARDUINO_MEGA2560_F_A3"
local PIN_FD1_LED_ILS_1     = "ARDUINO_MEGA2560_F_A5"
local PIN_FD1_LED_ILS_2     = "ARDUINO_MEGA2560_F_A6"
local PIN_FD1_LED_NAV_1     = "ARDUINO_MEGA2560_F_A7"
local PIN_FD1_LED_NAV_2     = "ARDUINO_MEGA2560_F_A8"
local PIN_FD1_LED_HDG       = "ARDUINO_MEGA2560_F_A9"
local PIN_FD1_LED_GA        = "ARDUINO_MEGA2560_F_A10"
local PIN_FD1_LED_VOR_APR_1 = "ARDUINO_MEGA2560_F_A11"
local PIN_FD1_LED_VOR_APR_2 = "ARDUINO_MEGA2560_F_A12"
local PIN_FD1_LED_BC_1      = "ARDUINO_MEGA2560_F_A13"
local PIN_FD1_LED_BC_2      = "ARDUINO_MEGA2560_F_A14"
local PIN_FD1_LED_SBY       = "ARDUINO_MEGA2560_F_A15"

-- Flight Director 2 (FD2)
local PIN_FD2_ALT       = "ARDUINO_MEGA2560_F_D25"      -- ALT
local PIN_FD2_IAS       = "ARDUINO_MEGA2560_F_D26"      -- IAS
local PIN_FD2_VS        = "ARDUINO_MEGA2560_F_D27"      -- VS
local PIN_FD2_HDG       = "ARDUINO_MEGA2560_F_D33"      -- HDG
local PIN_FD2_NAV       = "ARDUINO_MEGA2560_F_D34"      -- NAV
local PIN_FD2_ILS       = "ARDUINO_MEGA2560_F_D35"      -- ILS
local PIN_FD2_BC        = "ARDUINO_MEGA2560_F_D42"      -- BC
local PIN_FD2_VOR_APR   = "ARDUINO_MEGA2560_F_D41"      -- VOR APR
-- Note: User specified A043/A45 which likely means D43/D45 or A-series pins. 
-- Assuming Digital Pins 43 and 45 based on context.
local PIN_FD2_GA        = "ARDUINO_MEGA2560_F_D43"      -- GA (Digital 43)
local PIN_FD2_SBY       = "ARDUINO_MEGA2560_F_D45"      -- SBY (Digital 45)

-- =============================================================================
-- 2. LED HANDLES
-- =============================================================================
-- FD1 LEDs
local led_fd1_vs        = hw_led_add(PIN_FD1_LED_VS, 0.0)
local led_fd1_ias       = hw_led_add(PIN_FD1_LED_IAS, 0.0)
local led_fd1_alt       = hw_led_add(PIN_FD1_LED_ALT, 0.0)
local led_fd1_ils_1     = hw_led_add(PIN_FD1_LED_ILS_1, 0.0)
local led_fd1_ils_2     = hw_led_add(PIN_FD1_LED_ILS_2, 0.0)
local led_fd1_nav_1     = hw_led_add(PIN_FD1_LED_NAV_1, 0.0)
local led_fd1_nav_2     = hw_led_add(PIN_FD1_LED_NAV_2, 0.0)
local led_fd1_hdg       = hw_led_add(PIN_FD1_LED_HDG, 0.0)
local led_fd1_ga        = hw_led_add(PIN_FD1_LED_GA, 0.0)
local led_fd1_vor_apr_1 = hw_led_add(PIN_FD1_LED_VOR_APR_1, 0.0)
local led_fd1_vor_apr_2 = hw_led_add(PIN_FD1_LED_VOR_APR_2, 0.0)
local led_fd1_bc_1      = hw_led_add(PIN_FD1_LED_BC_1, 0.0)
local led_fd1_bc_2      = hw_led_add(PIN_FD1_LED_BC_2, 0.0)
local led_fd1_sby       = hw_led_add(PIN_FD1_LED_SBY, 0.0)

-- =============================================================================
-- 3. BUTTON HANDLERS
-- =============================================================================

local function create_button(pin, name, lvar, value)
    hw_button_add(pin, function()
        print(name .. " Pressed")
        -- Placeholders for L-Var writes. 
        -- Replace 'Number' with correct unit if different.
        if lvar then
            -- Initial simple toggle or set logic could be added here
            -- For now, just print the L-Var for verification
            print("  -> Writing " .. lvar .. " = " .. tostring(value or 1))
            -- fsx_variable_write(lvar, "Number", value or 1)
        end
    end)
end

-- Example L-Vars - Please verify actual L-Vars for your aircraft
-- FD1
create_button(PIN_FD1_ALT,      "FD1 ALT",      "L:FD1_ALT_Switch")
create_button(PIN_FD1_IAS,      "FD1 IAS",      "L:FD1_IAS_Switch")
create_button(PIN_FD1_VS,       "FD1 VS",       "L:FD1_VS_Switch")
create_button(PIN_FD1_HDG,      "FD1 HDG",      "L:FD1_HDG_Switch")
create_button(PIN_FD1_NAV,      "FD1 NAV",      "L:FD1_NAV_Switch")
create_button(PIN_FD1_ILS,      "FD1 ILS",      "L:FD1_ILS_Switch")
create_button(PIN_FD1_BC,       "FD1 BC",       "L:FD1_BC_Switch")
create_button(PIN_FD1_VOR_APR,  "FD1 VOR APR",  "L:FD1_VORAPR_Switch")
create_button(PIN_FD1_GA,       "FD1 GA",       "L:FD1_GA_Switch")
create_button(PIN_FD1_SBY,      "FD1 SBY",      "L:FD1_SBY_Switch")

-- FD2
create_button(PIN_FD2_ALT,      "FD2 ALT",      "L:FD2_ALT_Switch")
create_button(PIN_FD2_IAS,      "FD2 IAS",      "L:FD2_IAS_Switch")
create_button(PIN_FD2_VS,       "FD2 VS",       "L:FD2_VS_Switch")
create_button(PIN_FD2_HDG,      "FD2 HDG",      "L:FD2_HDG_Switch")
create_button(PIN_FD2_NAV,      "FD2 NAV",      "L:FD2_NAV_Switch")
create_button(PIN_FD2_ILS,      "FD2 ILS",      "L:FD2_ILS_Switch")
create_button(PIN_FD2_BC,       "FD2 BC",       "L:FD2_BC_Switch")
create_button(PIN_FD2_VOR_APR,  "FD2 VOR APR",  "L:FD2_VORAPR_Switch")
create_button(PIN_FD2_GA,       "FD2 GA",       "L:FD2_GA_Switch")
create_button(PIN_FD2_SBY,      "FD2 SBY",      "L:FD2_SBY_Switch")
