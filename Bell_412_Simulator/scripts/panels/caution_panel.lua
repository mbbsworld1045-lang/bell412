-- =============================================================================
-- BELL 412 - CAUTION WARNING PANEL (CWP) LOGIC
-- Platform: Air Manager + Arduino Mega 2560
-- Hardware: Arduino Channel E (Caution Panel)
-- Logic: 56 LEDs + 3 Switches (Active Low)
-- =============================================================================

print("Caution Panel Script Running")
-- ... (rest of file)
-- Remove end print

-- =============================================================================
-- 1. HARDWARE CONFIGURATION HEADER
-- =============================================================================

-- INPUTS (Switches/Buttons)
local PIN_TEST_SW_POS1      = "ARDUINO_MEGA2560_E_D22"      -- Test Switch Position 1 (PNL)
local PIN_TEST_BTN          = "ARDUINO_MEGA2560_E_D23"      -- Test Button (LT - Lamp Test)
local PIN_TEST_SW_POS2      = "ARDUINO_MEGA2560_E_D24"      -- Test Switch Position 2
local PIN_BRIGHT_DIM_POS1   = "ARDUINO_MEGA2560_E_D4"       -- Bright/Dim Switch Position 1
local PIN_BRIGHT_DIM_POS2   = "ARDUINO_MEGA2560_E_D5"       -- Bright/Dim Switch Position 2

-- =============================================================================
-- OUTPUTS (56 Caution LEDs) - Mapped by Panel Position
-- =============================================================================

-- RJ1 Connector LEDs (Pins 25-50, 3, 43-49)
local PIN_LED_ENG1_OUT      = "ARDUINO_MEGA2560_E_D25"      -- 1: ENG 1 OUT
local PIN_LED_ENG2_OUT      = "ARDUINO_MEGA2560_E_D26"      -- 2: ENG 2 OUT
local PIN_LED_ROTOR_BRAKE   = "ARDUINO_MEGA2560_E_D27"      -- 3: ROTOR BRAKE
local PIN_LED_XMSN_OIL_PRESS = "ARDUINO_MEGA2560_E_D28"     -- 4: XMSN OIL PRESS
local PIN_LED_XMSN_OIL_TEMP = "ARDUINO_MEGA2560_E_D29"      -- 5: XMSN OIL TEMP
local PIN_LED_CBOX_OIL_PRESS = "ARDUINO_MEGA2560_E_D30"     -- 6: C BOX OIL PRESS
local PIN_LED_CBOX_OIL_TEMP = "ARDUINO_MEGA2560_E_D31"      -- 7: C BOX OIL TEMP
local PIN_LED_BATT1_HOT     = "ARDUINO_MEGA2560_E_D32"      -- 8: BATT 1 HOT
local PIN_LED_BATT2_HOT     = "ARDUINO_MEGA2560_E_D33"      -- 9: BATT 2 HOT
local PIN_LED_ENG_OIL_PRESS1 = "ARDUINO_MEGA2560_E_D34"     -- 10: ENGINE OIL PRESS 1
local PIN_LED_ENG_OIL_PRESS2 = "ARDUINO_MEGA2560_E_D35"     -- 11: ENGINE OIL PRESS 2
local PIN_LED_ENG_CHIP1     = "ARDUINO_MEGA2560_E_D36"      -- 12: ENGINE CHIP 1
local PIN_LED_ENG_CHIP2     = "ARDUINO_MEGA2560_E_D37"      -- 13: ENGINE CHIP 2
local PIN_LED_FUEL_FILTER1  = "ARDUINO_MEGA2560_E_D38"      -- 14: FUEL FILTER 1
local PIN_LED_FUEL_FILTER2  = "ARDUINO_MEGA2560_E_D39"      -- 15: FUEL FILTER 2
local PIN_LED_FUEL_BOOST1   = "ARDUINO_MEGA2560_E_D40"      -- 16: FUEL BOOST 1
local PIN_LED_FUEL_BOOST2   = "ARDUINO_MEGA2560_E_D41"      -- 17: FUEL BOOST 2
local PIN_LED_FUEL_TRANS1   = "ARDUINO_MEGA2560_E_D42"      -- 18: FUEL TRANS 1
local PIN_LED_FUEL_TRANS2   = "ARDUINO_MEGA2560_E_D50"      -- 19: FUEL TRANS 2
local PIN_LED_FUEL_VALVE1   = "ARDUINO_MEGA2560_E_D49"      -- 20: FUEL VALVE 1
local PIN_LED_FUEL_VALVE2   = "ARDUINO_MEGA2560_E_D48"      -- 21: FUEL VALVE 2
local PIN_LED_FUEL_LOW      = "ARDUINO_MEGA2560_E_D3"       -- 22: FUEL LOW
local PIN_LED_FUEL_INTCON   = "ARDUINO_MEGA2560_E_D47"      -- 23: FUEL INTCON
local PIN_LED_FUEL_XFEED    = "ARDUINO_MEGA2560_E_D46"      -- 24: FUEL XFEED
local PIN_LED_GOV_MAN1      = "ARDUINO_MEGA2560_E_D45"      -- 25: GOV MANUAL 1
local PIN_LED_GOV_MAN2      = "ARDUINO_MEGA2560_E_D44"      -- 26: GOV MANUAL 2
local PIN_LED_PARTSEP1      = "ARDUINO_MEGA2560_E_D43"      -- 27: PART SEP OFF 1
local PIN_LED_PARTSEP2      = "ARDUINO_MEGA2560_E_D6"       -- 28: PART SEP OFF 2

-- RJ2 Connector LEDs (Pins 6-13, A0-A15, 51-53)
local PIN_LED_DC_GEN1       = "ARDUINO_MEGA2560_E_D7"       -- 29: DC GENERATOR 1
local PIN_LED_DC_GEN2       = "ARDUINO_MEGA2560_E_D8"       -- 30: DC GENERATOR 2
local PIN_LED_INVERTER1     = "ARDUINO_MEGA2560_E_A15"      -- 31: INVERTER 1
local PIN_LED_INVERTER2     = "ARDUINO_MEGA2560_E_A14"      -- 32: INVERTER 2
local PIN_LED_BATTERY       = "ARDUINO_MEGA2560_E_A13"      -- 33: BATTERY
local PIN_LED_GEN_OVHT1     = "ARDUINO_MEGA2560_E_A12"      -- 34: GEN OVHT 1
local PIN_LED_GEN_OVHT2     = "ARDUINO_MEGA2560_E_A11"      -- 35: GEN OVHT 2
local PIN_LED_HYDRAULIC1    = "ARDUINO_MEGA2560_E_A10"      -- 36: HYDRAULIC 1
local PIN_LED_HYDRAULIC2    = "ARDUINO_MEGA2560_E_A9"       -- 37: HYDRAULIC 2
local PIN_LED_EXT_POWER     = "ARDUINO_MEGA2560_E_A8"       -- 38: EXTERNAL POWER
local PIN_LED_XMSN_CHIP     = "ARDUINO_MEGA2560_E_A7"       -- 39: XMSN CHIP
local PIN_LED_CBOX_CHIP     = "ARDUINO_MEGA2560_E_A6"       -- 40: C BOX CHIP
local PIN_LED_4290_CHIP     = "ARDUINO_MEGA2560_E_A5"       -- 41: 42/90 CHIP
local PIN_LED_OVER_TORQ     = "ARDUINO_MEGA2560_E_D51"      -- 42: OVER TORQ
local PIN_LED_RPM           = "ARDUINO_MEGA2560_E_D52"      -- 43: RPM
local PIN_LED_AFCS          = "ARDUINO_MEGA2560_E_D53"      -- 44: AFCS
local PIN_LED_FT_OFF        = "ARDUINO_MEGA2560_E_A4"       -- 45: FT OFF
local PIN_LED_CYC_CTR       = "ARDUINO_MEGA2560_E_A3"       -- 46: CYC CTR
local PIN_LED_DOOR_LOCK     = "ARDUINO_MEGA2560_E_A2"       -- 47: DOOR LOCK
local PIN_LED_HEATER_AIR    = "ARDUINO_MEGA2560_E_A1"       -- 48: HEATER AIR LINE
local PIN_LED_CAUTION_PNL   = "ARDUINO_MEGA2560_E_A0"       -- 49: CAUTION PANEL
local PIN_LED_EMER_FLOATS   = "ARDUINO_MEGA2560_E_D9"       -- 50: EMER FLOATS
local PIN_LED_CARGO_REL     = "ARDUINO_MEGA2560_E_D10"      -- 51: CARGO RELEASE
local PIN_LED_BAG_FIRE      = "ARDUINO_MEGA2560_E_D11"      -- 52: BAGGAGE FIRE
local PIN_LED_WSHLD_HEAT    = "ARDUINO_MEGA2560_E_D12"      -- 53: WSHLD HEAT
local PIN_LED_20FT_CAUTION  = "ARDUINO_MEGA2560_E_D13"      -- 54: 20 FT CAUTION
local PIN_LED_NIGHTSUN      = "ARDUINO_MEGA2560_E_D2"       -- 55: NIGHTSUN (spare pin)
local PIN_LED_SPARE         = "ARDUINO_MEGA2560_E_D14"      -- 56: SPARE/BLANK

-- =============================================================================
-- 2. INITIALIZE HARDWARE LEDS
-- =============================================================================

-- Red Warning LEDs (1-9)
local led_eng1_out_h        = hw_led_add(PIN_LED_ENG1_OUT, 0.0)
local led_eng2_out_h        = hw_led_add(PIN_LED_ENG2_OUT, 0.0)
local led_rotor_brake_h     = hw_led_add(PIN_LED_ROTOR_BRAKE, 0.0)
local led_xmsn_oil_press_h  = hw_led_add(PIN_LED_XMSN_OIL_PRESS, 0.0)
local led_xmsn_oil_temp_h   = hw_led_add(PIN_LED_XMSN_OIL_TEMP, 0.0)
local led_cbox_oil_press_h  = hw_led_add(PIN_LED_CBOX_OIL_PRESS, 0.0)
local led_cbox_oil_temp_h   = hw_led_add(PIN_LED_CBOX_OIL_TEMP, 0.0)
local led_batt1_hot_h       = hw_led_add(PIN_LED_BATT1_HOT, 0.0)
local led_batt2_hot_h       = hw_led_add(PIN_LED_BATT2_HOT, 0.0)

-- Amber Caution LEDs - Engine & Fuel (10-28)
local led_eng_oil_press1_h  = hw_led_add(PIN_LED_ENG_OIL_PRESS1, 0.0)
local led_eng_oil_press2_h  = hw_led_add(PIN_LED_ENG_OIL_PRESS2, 0.0)
local led_eng_chip1_h       = hw_led_add(PIN_LED_ENG_CHIP1, 0.0)
local led_eng_chip2_h       = hw_led_add(PIN_LED_ENG_CHIP2, 0.0)
local led_fuel_filter1_h    = hw_led_add(PIN_LED_FUEL_FILTER1, 0.0)
local led_fuel_filter2_h    = hw_led_add(PIN_LED_FUEL_FILTER2, 0.0)
local led_fuel_boost1_h     = hw_led_add(PIN_LED_FUEL_BOOST1, 0.0)
local led_fuel_boost2_h     = hw_led_add(PIN_LED_FUEL_BOOST2, 0.0)
local led_fuel_trans1_h     = hw_led_add(PIN_LED_FUEL_TRANS1, 0.0)
local led_fuel_trans2_h     = hw_led_add(PIN_LED_FUEL_TRANS2, 0.0)
local led_fuel_valve1_h     = hw_led_add(PIN_LED_FUEL_VALVE1, 0.0)
local led_fuel_valve2_h     = hw_led_add(PIN_LED_FUEL_VALVE2, 0.0)
local led_fuel_low_h        = hw_led_add(PIN_LED_FUEL_LOW, 0.0)
local led_fuel_intcon_h     = hw_led_add(PIN_LED_FUEL_INTCON, 0.0)
local led_fuel_xfeed_h      = hw_led_add(PIN_LED_FUEL_XFEED, 0.0)
local led_gov_man1_h        = hw_led_add(PIN_LED_GOV_MAN1, 0.0)
local led_gov_man2_h        = hw_led_add(PIN_LED_GOV_MAN2, 0.0)
local led_partsep1_h        = hw_led_add(PIN_LED_PARTSEP1, 0.0)
local led_partsep2_h        = hw_led_add(PIN_LED_PARTSEP2, 0.0)

-- Amber Caution LEDs - Electrical & Hydraulic (29-38)
local led_dc_gen1_h         = hw_led_add(PIN_LED_DC_GEN1, 0.0)
local led_dc_gen2_h         = hw_led_add(PIN_LED_DC_GEN2, 0.0)
local led_inverter1_h       = hw_led_add(PIN_LED_INVERTER1, 0.0)
local led_inverter2_h       = hw_led_add(PIN_LED_INVERTER2, 0.0)
local led_battery_h         = hw_led_add(PIN_LED_BATTERY, 0.0)
local led_gen_ovht1_h       = hw_led_add(PIN_LED_GEN_OVHT1, 0.0)
local led_gen_ovht2_h       = hw_led_add(PIN_LED_GEN_OVHT2, 0.0)
local led_hydraulic1_h      = hw_led_add(PIN_LED_HYDRAULIC1, 0.0)
local led_hydraulic2_h      = hw_led_add(PIN_LED_HYDRAULIC2, 0.0)
local led_ext_power_h       = hw_led_add(PIN_LED_EXT_POWER, 0.0)

-- Amber Caution LEDs - Drive & Flight (39-46)
local led_xmsn_chip_h       = hw_led_add(PIN_LED_XMSN_CHIP, 0.0)
local led_cbox_chip_h       = hw_led_add(PIN_LED_CBOX_CHIP, 0.0)
local led_4290_chip_h       = hw_led_add(PIN_LED_4290_CHIP, 0.0)
local led_over_torq_h       = hw_led_add(PIN_LED_OVER_TORQ, 0.0)
local led_rpm_h             = hw_led_add(PIN_LED_RPM, 0.0)
local led_afcs_h            = hw_led_add(PIN_LED_AFCS, 0.0)
local led_ft_off_h          = hw_led_add(PIN_LED_FT_OFF, 0.0)
local led_cyc_ctr_h         = hw_led_add(PIN_LED_CYC_CTR, 0.0)

-- Amber Caution LEDs - Misc & Optional (47-56)
local led_door_lock_h       = hw_led_add(PIN_LED_DOOR_LOCK, 0.0)
local led_heater_air_h      = hw_led_add(PIN_LED_HEATER_AIR, 0.0)
local led_caution_pnl_h     = hw_led_add(PIN_LED_CAUTION_PNL, 0.0)
local led_emer_floats_h     = hw_led_add(PIN_LED_EMER_FLOATS, 0.0)
local led_cargo_rel_h       = hw_led_add(PIN_LED_CARGO_REL, 0.0)
local led_bag_fire_h        = hw_led_add(PIN_LED_BAG_FIRE, 0.0)
local led_wshld_heat_h      = hw_led_add(PIN_LED_WSHLD_HEAT, 0.0)
local led_20ft_caution_h    = hw_led_add(PIN_LED_20FT_CAUTION, 0.0)
local led_nightsun_h        = hw_led_add(PIN_LED_NIGHTSUN, 0.0)
local led_spare_h           = hw_led_add(PIN_LED_SPARE, 0.0)

-- =============================================================================
-- 3. INTERNAL VARIABLES & CONSTANTS
-- =============================================================================

-- Test Switch State (3-position: 0=Center, 1=PNL, 2=LT)
local test_sw_pos1_pressed  = false
local test_sw_pos2_pressed  = false
local test_btn_pressed      = false
local test_state            = 0  -- 0=Normal, 1=PNL Test, 2=LT (Lamp Test)

-- Bright/Dim Switch State (3-position: 0=Normal, 1=Bright, 2=Dim)
local bright_dim_pos1_pressed = false
local bright_dim_pos2_pressed = false
local bright_dim_state      = 0

-- LED Brightness (0.0 to 1.0)
local led_brightness        = 1.0
local DIM_BRIGHTNESS        = 0.3

-- DC Bus State
local dc_bus                = 0

-- Caution States (from subscriptions)
local caution_states = {
    eng1_out = 0, eng2_out = 0, rotor_brake = 0,
    xmsn_oil_press = 0, xmsn_oil_temp = 0, cbox_oil_press = 0, cbox_oil_temp = 0,
    batt1_hot = 0, batt2_hot = 0,
    eng_oil_press1 = 0, eng_oil_press2 = 0, eng_chip1 = 0, eng_chip2 = 0,
    fuel_filter1 = 0, fuel_filter2 = 0, fuel_boost1 = 0, fuel_boost2 = 0,
    fuel_trans1 = 0, fuel_trans2 = 0, fuel_valve1 = 0, fuel_valve2 = 0,
    fuel_low = 0, fuel_intcon = 0, fuel_xfeed = 0,
    gov_man1 = 0, gov_man2 = 0, partsep1 = 0, partsep2 = 0,
    dc_gen1 = 0, dc_gen2 = 0, inverter1 = 0, inverter2 = 0, battery = 0,
    gen_ovht1 = 0, gen_ovht2 = 0, hydraulic1 = 0, hydraulic2 = 0, ext_power = 0,
    xmsn_chip = 0, cbox_chip = 0, chip_4290 = 0,
    over_torq = 0, rpm = 0, afcs = 0, ft_off = 0, cyc_ctr = 0,
    door_lock = 0, heater_air = 0, caution_pnl = 0,
    emer_floats = 0, cargo_rel = 0, bag_fire = 0, wshld_heat = 0,
    caution_20ft = 0, nightsun = 0, spare = 0
}

-- =============================================================================
-- 4. SYSTEM LOGIC FUNCTIONS
-- =============================================================================

-- TEST SWITCH STATE UPDATE
local function update_test_state()
    local new_state = 0
    
    if test_btn_pressed then
        new_state = 2  -- LT (Lamp Test) - highest priority
    elseif test_sw_pos1_pressed then
        new_state = 1  -- PNL Test
    elseif test_sw_pos2_pressed then
        new_state = -1 -- Position 2
    else
        new_state = 0  -- Normal
    end
    
    if test_state ~= new_state then
        test_state = new_state
        fsx_variable_write("L:CWP_TestMode", "Number", test_state)
        print("CWP TEST: State changed to " .. tostring(test_state))
        if update_all_leds then update_all_leds() end
    end
end

-- BRIGHT/DIM SWITCH STATE UPDATE
local function update_bright_dim_state()
    local new_state = 0
    
    if bright_dim_pos1_pressed then
        new_state = 1  -- Bright
        led_brightness = 1.0
    elseif bright_dim_pos2_pressed then
        new_state = 2  -- Dim
        led_brightness = DIM_BRIGHTNESS
    else
        new_state = 0  -- Normal
        led_brightness = 1.0
    end
    
    if bright_dim_state ~= new_state then
        bright_dim_state = new_state
        fsx_variable_write("L:CWP_Brightness", "Number", bright_dim_state)
        print("CWP BRIGHTNESS: State changed to " .. tostring(bright_dim_state))
        if update_all_leds then update_all_leds() end
    end
end

-- HELPER: Set LED with brightness
local function set_led(led_handle, state)
    if dc_bus == 0 then
        hw_led_set(led_handle, 0.0)
        return
    end
    
    -- Lamp Test Mode: All LEDs ON
    if test_state == 2 then
        hw_led_set(led_handle, led_brightness)
        return
    end
    
    -- PNL Test Mode: All LEDs OFF except CAUTION PANEL
    if test_state == 1 then
        hw_led_set(led_handle, 0.0)
        return
    end
    
    -- Normal Mode
    hw_led_set(led_handle, (state == 1) and led_brightness or 0.0)
end

-- UPDATE ALL LEDs
local function update_all_leds()
    -- Red Warning LEDs
    set_led(led_eng1_out_h, caution_states.eng1_out)
    set_led(led_eng2_out_h, caution_states.eng2_out)
    set_led(led_rotor_brake_h, caution_states.rotor_brake)
    set_led(led_xmsn_oil_press_h, caution_states.xmsn_oil_press)
    set_led(led_xmsn_oil_temp_h, caution_states.xmsn_oil_temp)
    set_led(led_cbox_oil_press_h, caution_states.cbox_oil_press)
    set_led(led_cbox_oil_temp_h, caution_states.cbox_oil_temp)
    set_led(led_batt1_hot_h, caution_states.batt1_hot)
    set_led(led_batt2_hot_h, caution_states.batt2_hot)
    
    -- Amber LEDs - Engine & Fuel
    set_led(led_eng_oil_press1_h, caution_states.eng_oil_press1)
    set_led(led_eng_oil_press2_h, caution_states.eng_oil_press2)
    set_led(led_eng_chip1_h, caution_states.eng_chip1)
    set_led(led_eng_chip2_h, caution_states.eng_chip2)
    set_led(led_fuel_filter1_h, caution_states.fuel_filter1)
    set_led(led_fuel_filter2_h, caution_states.fuel_filter2)
    set_led(led_fuel_boost1_h, caution_states.fuel_boost1)
    set_led(led_fuel_boost2_h, caution_states.fuel_boost2)
    set_led(led_fuel_trans1_h, caution_states.fuel_trans1)
    set_led(led_fuel_trans2_h, caution_states.fuel_trans2)
    set_led(led_fuel_valve1_h, caution_states.fuel_valve1)
    set_led(led_fuel_valve2_h, caution_states.fuel_valve2)
    set_led(led_fuel_low_h, caution_states.fuel_low)
    set_led(led_fuel_intcon_h, caution_states.fuel_intcon)
    set_led(led_fuel_xfeed_h, caution_states.fuel_xfeed)
    set_led(led_gov_man1_h, caution_states.gov_man1)
    set_led(led_gov_man2_h, caution_states.gov_man2)
    set_led(led_partsep1_h, caution_states.partsep1)
    set_led(led_partsep2_h, caution_states.partsep2)
    
    -- Amber LEDs - Electrical & Hydraulic
    set_led(led_dc_gen1_h, caution_states.dc_gen1)
    set_led(led_dc_gen2_h, caution_states.dc_gen2)
    set_led(led_inverter1_h, caution_states.inverter1)
    set_led(led_inverter2_h, caution_states.inverter2)
    set_led(led_battery_h, caution_states.battery)
    set_led(led_gen_ovht1_h, caution_states.gen_ovht1)
    set_led(led_gen_ovht2_h, caution_states.gen_ovht2)
    set_led(led_hydraulic1_h, caution_states.hydraulic1)
    set_led(led_hydraulic2_h, caution_states.hydraulic2)
    set_led(led_ext_power_h, caution_states.ext_power)
    
    -- Amber LEDs - Drive & Flight
    set_led(led_xmsn_chip_h, caution_states.xmsn_chip)
    set_led(led_cbox_chip_h, caution_states.cbox_chip)
    set_led(led_4290_chip_h, caution_states.chip_4290)
    set_led(led_over_torq_h, caution_states.over_torq)
    set_led(led_rpm_h, caution_states.rpm)
    set_led(led_afcs_h, caution_states.afcs)
    set_led(led_ft_off_h, caution_states.ft_off)
    set_led(led_cyc_ctr_h, caution_states.cyc_ctr)
    
    -- Amber LEDs - Misc & Optional
    set_led(led_door_lock_h, caution_states.door_lock)
    set_led(led_heater_air_h, caution_states.heater_air)
    
    -- CAUTION PANEL LED: Special handling for PNL test (stays ON during PNL test)
    if test_state == 1 then
        hw_led_set(led_caution_pnl_h, led_brightness)
    else
        set_led(led_caution_pnl_h, caution_states.caution_pnl)
    end
    
    set_led(led_emer_floats_h, caution_states.emer_floats)
    set_led(led_cargo_rel_h, caution_states.cargo_rel)
    set_led(led_bag_fire_h, caution_states.bag_fire)
    set_led(led_wshld_heat_h, caution_states.wshld_heat)
    set_led(led_20ft_caution_h, caution_states.caution_20ft)
    set_led(led_nightsun_h, caution_states.nightsun)
    set_led(led_spare_h, caution_states.spare)
end

-- =============================================================================
-- 5. HARDWARE INPUTS (BUTTONS/SWITCHES)
-- =============================================================================

-- TEST SWITCH POSITION 1 (PNL)
hw_button_add(PIN_TEST_SW_POS1,
    function() -- PRESSED
        print("ACTION: CWP Test Switch -> PNL")
        test_sw_pos1_pressed = true
        update_test_state()
    end,
    function() -- RELEASED
        print("ACTION: CWP Test Switch PNL RELEASED")
        test_sw_pos1_pressed = false
        update_test_state()
    end
)

-- TEST BUTTON (LT - Lamp Test)
hw_button_add(PIN_TEST_BTN,
    function() -- PRESSED
        print("ACTION: CWP Test Button -> LT (Lamp Test)")
        test_btn_pressed = true
        update_test_state()
    end,
    function() -- RELEASED
        print("ACTION: CWP Test Button RELEASED")
        test_btn_pressed = false
        update_test_state()
    end
)

-- TEST SWITCH POSITION 2
hw_button_add(PIN_TEST_SW_POS2,
    function() -- PRESSED
        print("ACTION: CWP Test Switch -> Position 2")
        test_sw_pos2_pressed = true
        update_test_state()
    end,
    function() -- RELEASED
        print("ACTION: CWP Test Switch Position 2 RELEASED")
        test_sw_pos2_pressed = false
        update_test_state()
    end
)

-- BRIGHT/DIM SWITCH POSITION 1 (Bright)
hw_button_add(PIN_BRIGHT_DIM_POS1,
    function() -- PRESSED
        print("ACTION: CWP Bright/Dim -> BRIGHT")
        bright_dim_pos1_pressed = true
        update_bright_dim_state()
    end,
    function() -- RELEASED
        print("ACTION: CWP Bright/Dim BRIGHT RELEASED")
        bright_dim_pos1_pressed = false
        update_bright_dim_state()
    end
)

-- BRIGHT/DIM SWITCH POSITION 2 (Dim)
hw_button_add(PIN_BRIGHT_DIM_POS2,
    function() -- PRESSED
        print("ACTION: CWP Bright/Dim -> DIM")
        bright_dim_pos2_pressed = true
        update_bright_dim_state()
    end,
    function() -- RELEASED
        print("ACTION: CWP Bright/Dim DIM RELEASED")
        bright_dim_pos2_pressed = false
        update_bright_dim_state()
    end
)

-- =============================================================================
-- 6. SIMULATOR SUBSCRIPTIONS (Data In -> LED Update)
-- =============================================================================

-- DC Bus
fsx_variable_subscribe("L:MasterDcBus", "Number", function(val)
    dc_bus = (val ~= 0) and 1 or 0
    update_all_leds()
end)

-- Engine Out Warnings
fsx_variable_subscribe("TURB ENG N1:1", "Percent", function(val)
    caution_states.eng1_out = (val < 53) and 1 or 0
    update_all_leds()
end)

fsx_variable_subscribe("TURB ENG N1:2", "Percent", function(val)
    caution_states.eng2_out = (val < 53) and 1 or 0
    update_all_leds()
end)

-- Rotor Brake
fsx_variable_subscribe("A:Rotor Brake Active", "Bool", function(val)
    caution_states.rotor_brake = val and 1 or 0
    update_all_leds()
end)

-- XMSN Warnings
fsx_variable_subscribe("L:XmsnPressWarn", "Number", function(val)
    caution_states.xmsn_oil_press = (val ~= 0) and 1 or 0
    update_all_leds()
end)

fsx_variable_subscribe("L:XmsnTempWarn", "Number", function(val)
    caution_states.xmsn_oil_temp = (val ~= 0) and 1 or 0
    update_all_leds()
end)

fsx_variable_subscribe("L:CboxPressWarn", "Number", function(val)
    caution_states.cbox_oil_press = (val ~= 0) and 1 or 0
    update_all_leds()
end)

-- Fuel System
fsx_variable_subscribe("L:SwboostpuEng1", "Number", function(val)
    caution_states.fuel_boost1 = (val == 0) and 1 or 0
    update_all_leds()
end)

fsx_variable_subscribe("L:SwboostpuEng2", "Number", function(val)
    caution_states.fuel_boost2 = (val == 0) and 1 or 0
    update_all_leds()
end)

fsx_variable_subscribe("L:SwfueltransengA", "Number", function(val)
    caution_states.fuel_trans1 = (val == 0) and 1 or 0
    update_all_leds()
end)

fsx_variable_subscribe("L:SwfueltransengB", "Number", function(val)
    caution_states.fuel_trans2 = (val == 0) and 1 or 0
    update_all_leds()
end)

fsx_variable_subscribe("L:Swfuelintcon", "Number", function(val)
    caution_states.fuel_intcon = (val ~= 0) and 1 or 0
    update_all_leds()
end)

fsx_variable_subscribe("L:SwFuelxfeed", "Number", function(val)
    caution_states.fuel_xfeed = (val ~= 0) and 1 or 0
    update_all_leds()
end)

fsx_variable_subscribe("FUEL TANK CENTER LEVEL", "Percent", function(val)
    caution_states.fuel_low = (val < 9.2) and 1 or 0
    update_all_leds()
end)

-- Generators
fsx_variable_subscribe("L:CGenel", "Number", function(val)
    caution_states.dc_gen1 = (val == 0) and 1 or 0
    update_all_leds()
end)

fsx_variable_subscribe("L:CGener", "Number", function(val)
    caution_states.dc_gen2 = (val == 0) and 1 or 0
    update_all_leds()
end)

-- Inverters
fsx_variable_subscribe("L:Swinva", "Number", function(val)
    caution_states.inverter1 = (val == 0) and 1 or 0
    update_all_leds()
end)

fsx_variable_subscribe("L:Swinvb", "Number", function(val)
    caution_states.inverter2 = (val == 0) and 1 or 0
    update_all_leds()
end)

-- Hydraulics
fsx_variable_subscribe("L:Sw hydsysA", "Number", function(val)
    caution_states.hydraulic1 = (val == 0) and 1 or 0
    update_all_leds()
end)

fsx_variable_subscribe("L:Sw hydsysB", "Number", function(val)
    caution_states.hydraulic2 = (val == 0) and 1 or 0
    update_all_leds()
end)

-- Governor
fsx_variable_subscribe("L:SwGovA", "Number", function(val)
    caution_states.gov_man1 = (val ~= 0) and 1 or 0
    update_all_leds()
end)

fsx_variable_subscribe("L:SwGovB", "Number", function(val)
    caution_states.gov_man2 = (val ~= 0) and 1 or 0
    update_all_leds()
end)

-- Particle Separators
fsx_variable_subscribe("L:SwpartsepA", "Number", function(val)
    caution_states.partsep1 = (val ~= 0) and 1 or 0
    update_all_leds()
end)

fsx_variable_subscribe("L:SwpartsepB", "Number", function(val)
    caution_states.partsep2 = (val ~= 0) and 1 or 0
    update_all_leds()
end)

-- Chip Detectors
fsx_variable_subscribe("L:XMSN CHIP", "Bool", function(val)
    caution_states.xmsn_chip = val and 1 or 0
    update_all_leds()
end)

-- Over Torque
fsx_variable_subscribe("L:Overtq", "Number", function(val)
    caution_states.over_torq = (val ~= 0) and 1 or 0
    update_all_leds()
end)

-- Rotor RPM
fsx_variable_subscribe("ROTOR RPM PCT:1", "Percent", function(val)
    caution_states.rpm = ((val <= 95) or (val >= 105)) and 1 or 0
    update_all_leds()
end)

-- Force Trim
fsx_variable_subscribe("L:Sw forcetrim", "Number", function(val)
    caution_states.ft_off = (val == 0) and 1 or 0
    update_all_leds()
end)

-- Cyclic Center
fsx_variable_subscribe("L:Cyctest", "Number", function(val)
    caution_states.cyc_ctr = (val ~= 0) and 1 or 0
    update_all_leds()
end)

-- Baggage Fire
fsx_variable_subscribe("L:BagFire", "Number", function(val)
    caution_states.bag_fire = (val ~= 0) and 1 or 0
    update_all_leds()
end)

-- =============================================================================
-- 7. STARTUP INITIALIZATION
-- =============================================================================
fsx_variable_write("L:CWP_TestMode", "Number", 0)
fsx_variable_write("L:CWP_Brightness", "Number", 0)

-- Initialize switch states
update_test_state()
update_bright_dim_state()

-- Initialize all LEDs
update_all_leds()

update_all_leds()
