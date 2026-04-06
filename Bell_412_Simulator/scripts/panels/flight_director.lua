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
local PIN_FD2_GA        = "ARDUINO_MEGA2560_F_D43"      -- GA
local PIN_FD2_SBY       = "ARDUINO_MEGA2560_F_D45"      -- SBY

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
-- 3. STATE TRACKING
-- =============================================================================
local fd1_state = {
    alt = false, ias = false, vs = false, hdg = false,
    nav = false, ils = false, bc = false, vor_apr = false,
    ga = false, sby = false
}

-- =============================================================================
-- 4. LED UPDATE FUNCTION
-- =============================================================================
local function update_fd1_leds()
    hw_led_set(led_fd1_alt, fd1_state.alt and 1.0 or 0.0)
    hw_led_set(led_fd1_ias, fd1_state.ias and 1.0 or 0.0)
    hw_led_set(led_fd1_vs, fd1_state.vs and 1.0 or 0.0)
    hw_led_set(led_fd1_hdg, fd1_state.hdg and 1.0 or 0.0)
    hw_led_set(led_fd1_nav_1, fd1_state.nav and 1.0 or 0.0)
    hw_led_set(led_fd1_nav_2, fd1_state.nav and 1.0 or 0.0)
    hw_led_set(led_fd1_ils_1, fd1_state.ils and 1.0 or 0.0)
    hw_led_set(led_fd1_ils_2, fd1_state.ils and 1.0 or 0.0)
    hw_led_set(led_fd1_bc_1, fd1_state.bc and 1.0 or 0.0)
    hw_led_set(led_fd1_bc_2, fd1_state.bc and 1.0 or 0.0)
    hw_led_set(led_fd1_vor_apr_1, fd1_state.vor_apr and 1.0 or 0.0)
    hw_led_set(led_fd1_vor_apr_2, fd1_state.vor_apr and 1.0 or 0.0)
    hw_led_set(led_fd1_ga, fd1_state.ga and 1.0 or 0.0)
    hw_led_set(led_fd1_sby, fd1_state.sby and 1.0 or 0.0)
end

-- =============================================================================
-- 5. BUTTON HANDLERS (Toggle + Write to Sim + Update LEDs)
-- =============================================================================
local function create_toggle_button(pin, name, lvar, state_key)
    hw_button_add(pin, function()
        fd1_state[state_key] = not fd1_state[state_key]
        local val = fd1_state[state_key] and 1 or 0
        print(name .. " -> " .. tostring(val))
        fsx_variable_write(lvar, "Number", val)
        update_fd1_leds()
    end)
end

-- FD1 Buttons (Toggle)
create_toggle_button(PIN_FD1_ALT,     "FD1 ALT",     "L:FD1_ALT_Switch",    "alt")
create_toggle_button(PIN_FD1_IAS,     "FD1 IAS",     "L:FD1_IAS_Switch",    "ias")
create_toggle_button(PIN_FD1_VS,      "FD1 VS",      "L:FD1_VS_Switch",     "vs")
create_toggle_button(PIN_FD1_HDG,     "FD1 HDG",     "L:FD1_HDG_Switch",    "hdg")
create_toggle_button(PIN_FD1_NAV,     "FD1 NAV",     "L:FD1_NAV_Switch",    "nav")
create_toggle_button(PIN_FD1_ILS,     "FD1 ILS",     "L:FD1_ILS_Switch",    "ils")
create_toggle_button(PIN_FD1_BC,      "FD1 BC",      "L:FD1_BC_Switch",     "bc")
create_toggle_button(PIN_FD1_VOR_APR, "FD1 VOR APR", "L:FD1_VORAPR_Switch", "vor_apr")
create_toggle_button(PIN_FD1_GA,      "FD1 GA",      "L:FD1_GA_Switch",     "ga")
create_toggle_button(PIN_FD1_SBY,     "FD1 SBY",     "L:FD1_SBY_Switch",    "sby")

-- FD2 Buttons (Simple press handlers - no LED bank for FD2)
hw_button_add(PIN_FD2_ALT,     function() print("FD2 ALT Pressed");     fsx_variable_write("L:FD2_ALT_Switch", "Number", 1) end)
hw_button_add(PIN_FD2_IAS,     function() print("FD2 IAS Pressed");     fsx_variable_write("L:FD2_IAS_Switch", "Number", 1) end)
hw_button_add(PIN_FD2_VS,      function() print("FD2 VS Pressed");      fsx_variable_write("L:FD2_VS_Switch", "Number", 1) end)
hw_button_add(PIN_FD2_HDG,     function() print("FD2 HDG Pressed");     fsx_variable_write("L:FD2_HDG_Switch", "Number", 1) end)
hw_button_add(PIN_FD2_NAV,     function() print("FD2 NAV Pressed");     fsx_variable_write("L:FD2_NAV_Switch", "Number", 1) end)
hw_button_add(PIN_FD2_ILS,     function() print("FD2 ILS Pressed");     fsx_variable_write("L:FD2_ILS_Switch", "Number", 1) end)
hw_button_add(PIN_FD2_BC,      function() print("FD2 BC Pressed");      fsx_variable_write("L:FD2_BC_Switch", "Number", 1) end)
hw_button_add(PIN_FD2_VOR_APR, function() print("FD2 VOR APR Pressed"); fsx_variable_write("L:FD2_VORAPR_Switch", "Number", 1) end)
hw_button_add(PIN_FD2_GA,      function() print("FD2 GA Pressed");      fsx_variable_write("L:FD2_GA_Switch", "Number", 1) end)
hw_button_add(PIN_FD2_SBY,     function() print("FD2 SBY Pressed");     fsx_variable_write("L:FD2_SBY_Switch", "Number", 1) end)

-- =============================================================================
-- 6. BI-DIRECTIONAL SYNC (Virtual Cockpit -> Physical LEDs)
-- =============================================================================
fsx_variable_subscribe("L:FD1_ALT_Switch", "Number", function(val) fd1_state.alt = (val ~= 0); update_fd1_leds() end)
fsx_variable_subscribe("L:FD1_IAS_Switch", "Number", function(val) fd1_state.ias = (val ~= 0); update_fd1_leds() end)
fsx_variable_subscribe("L:FD1_VS_Switch", "Number", function(val) fd1_state.vs = (val ~= 0); update_fd1_leds() end)
fsx_variable_subscribe("L:FD1_HDG_Switch", "Number", function(val) fd1_state.hdg = (val ~= 0); update_fd1_leds() end)
fsx_variable_subscribe("L:FD1_NAV_Switch", "Number", function(val) fd1_state.nav = (val ~= 0); update_fd1_leds() end)
fsx_variable_subscribe("L:FD1_ILS_Switch", "Number", function(val) fd1_state.ils = (val ~= 0); update_fd1_leds() end)
fsx_variable_subscribe("L:FD1_BC_Switch", "Number", function(val) fd1_state.bc = (val ~= 0); update_fd1_leds() end)
fsx_variable_subscribe("L:FD1_VORAPR_Switch", "Number", function(val) fd1_state.vor_apr = (val ~= 0); update_fd1_leds() end)
fsx_variable_subscribe("L:FD1_GA_Switch", "Number", function(val) fd1_state.ga = (val ~= 0); update_fd1_leds() end)
fsx_variable_subscribe("L:FD1_SBY_Switch", "Number", function(val) fd1_state.sby = (val ~= 0); update_fd1_leds() end)

-- =============================================================================
-- 7. INITIALIZATION
-- =============================================================================
fsx_variable_write("L:FD1_ALT_Switch", "Number", 0)
fsx_variable_write("L:FD1_IAS_Switch", "Number", 0)
fsx_variable_write("L:FD1_VS_Switch", "Number", 0)
fsx_variable_write("L:FD1_HDG_Switch", "Number", 0)
fsx_variable_write("L:FD1_NAV_Switch", "Number", 0)
fsx_variable_write("L:FD1_ILS_Switch", "Number", 0)
fsx_variable_write("L:FD1_BC_Switch", "Number", 0)
fsx_variable_write("L:FD1_VORAPR_Switch", "Number", 0)
fsx_variable_write("L:FD1_GA_Switch", "Number", 0)
fsx_variable_write("L:FD1_SBY_Switch", "Number", 0)

update_fd1_leds()
print("Flight Director Script Loaded - Sync Enabled")
