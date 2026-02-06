-- =============================================================================
-- BELL 412 - FRONT PANEL LOGIC
-- Platform: Air Manager + Arduino Mega 2560
-- Hardware: Arduino Channel B (Front Panel)
-- Logic: Buttons Only (Active Low)
-- =============================================================================

-- =============================================================================
print("Bell 412 - Front Panel Script is now active")

-- =============================================================================
-- 1. HARDWARE CONFIGURATION HEADER
-- =============================================================================
-- INPUTS (Buttons)
-- BRG PTR Switches
local PIN_BRG_PTR           = "ARDUINO_MEGA2560_B_D38"      -- BRG PTR Switch Left (L:SwBrgPtr)
local PIN_BRG_PTR2          = "ARDUINO_MEGA2560_B_D10"      -- BRG PTR Switch Right (L:SwBrgPtr)

-- Fire System
local PIN_FIRE_PULL1        = "ARDUINO_MEGA2560_B_D50"      -- Fire Pull Handle Left (L:firethandl)
local PIN_FIRE_PULL2        = "ARDUINO_MEGA2560_B_D35"      -- Fire Pull Handle Right (L:firethandr)
local PIN_FIRE_TEST         = "ARDUINO_MEGA2560_B_D51"      -- Fire Detection Test (L:Swfiretest)
local PIN_BAG_FIRE_TEST     = "ARDUINO_MEGA2560_B_D52"      -- Baggage Fire Test (L:firetestbag)
local PIN_EXTINGUISHER_POS1 = "ARDUINO_MEGA2560_B_D7"       -- Fire Extinguisher Main (L:Extinguisher)
local PIN_EXTINGUISHER_POS2 = "ARDUINO_MEGA2560_B_D8"       -- Fire Extinguisher Reserve (L:Extinguisher)

-- Beacon Marker Tests
local PIN_MARKER_TEST       = "ARDUINO_MEGA2560_B_D45"      -- Marker Test Left (L:TestMarker)
local PIN_MARKER_TEST2      = "ARDUINO_MEGA2560_B_D37"      -- Marker Test Right (L:TestMarker)

-- Over Torque Tests
local PIN_OVERTQ_TEST       = "ARDUINO_MEGA2560_B_D49"      -- Over Torque Test Left (L:Overtq)
local PIN_OVERTQ_TEST2      = "ARDUINO_MEGA2560_B_D33"      -- Over Torque Test Right (L:Overtq)

-- Cyclic Center Tests
local PIN_CYC_CTR_TEST_L    = "ARDUINO_MEGA2560_B_D40"      -- Cyclic Center Test Left (L:Cyctest)
local PIN_CYC_CTR_TEST_R    = "ARDUINO_MEGA2560_B_D32"      -- Cyclic Center Test Right (L:Cyctest)

-- Master Caution Buttons
local PIN_MC_RESET_L        = "ARDUINO_MEGA2560_B_D41"      -- Master Caution Button Left
local PIN_MC_RESET_R        = "ARDUINO_MEGA2560_B_D36"      -- Master Caution Button Right

-- Fuel System
local PIN_FUEL_SYS_TEST_FWD = "ARDUINO_MEGA2560_B_D53"      -- Fuel Sys Test Fwd Tank (L:FuelQuantity = -1)
local PIN_FUEL_SYS_TEST_MID = "ARDUINO_MEGA2560_B_D34"      -- Fuel Sys Test Mid Tank (L:FuelQuantity = -1)
local PIN_FUEL_DIGIT_TEST   = "ARDUINO_MEGA2560_B_D44"      -- Fuel Digit Test

-- Nav GPS Buttons
local PIN_NAV_GPS_BTN_R     = "ARDUINO_MEGA2560_B_D11"      -- Nav GPS White Right Button
local PIN_NAV_GPS_BTN_L     = "ARDUINO_MEGA2560_B_D25"      -- Nav GPS White Left Button 

-- =============================================================================
-- OUTPUTS (LEDs)
-- =============================================================================
-- BRG PTR LEDs
local PIN_BRG_PTR_LED       = "ARDUINO_MEGA2560_B_D3"       -- BRG PTR Switch Left LED
local PIN_BRG_PTR2_LED      = "ARDUINO_MEGA2560_B_D13"      -- BRG PTR Switch Right LED

-- Fire Handle Status LEDs
local PIN_FIRE_HANDLE1_LED  = "ARDUINO_MEGA2560_B_D5"       -- Fire Handle 1 Status LED Left
local PIN_FIRE_HANDLE2_LED  = "ARDUINO_MEGA2560_B_D24"      -- Fire Handle 2 Status LED Right
local PIN_BAG_FIRE_TEST_LED = "ARDUINO_MEGA2560_B_D2"       -- Baggage Fire Test LED

-- Beacon Marker LEDs - Right Side
local PIN_MARKER_R_WHT      = "ARDUINO_MEGA2560_B_D26"      -- Marker Right White
local PIN_MARKER_R_RED      = "ARDUINO_MEGA2560_B_D27"      -- Marker Right Red
local PIN_MARKER_R_BLU      = "ARDUINO_MEGA2560_B_D28"      -- Marker Right Blue

-- Beacon Marker LEDs - Left Side
local PIN_MARKER_L_WHT      = "ARDUINO_MEGA2560_B_D46"      -- Marker Left White (right)
local PIN_MARKER_L_BLU      = "ARDUINO_MEGA2560_B_D47"      -- Marker Left Blue (left)
local PIN_MARKER_L_RED      = "ARDUINO_MEGA2560_B_D48"      -- Marker Left Red (middle)

-- Over Torque LEDs
local PIN_OVERTQ_LED_L      = "ARDUINO_MEGA2560_B_D39"      -- Over Torque LED Left
local PIN_OVERTQ_LED_R      = "ARDUINO_MEGA2560_B_D9"       -- Over Torque LED Right

-- Cyclic Center LEDs
local PIN_CYC_CTR_LED_L     = "ARDUINO_MEGA2560_B_D42"      -- Cyclic Center LED Left
local PIN_CYC_CTR_LED_R     = "ARDUINO_MEGA2560_B_D30"      -- Cyclic Center LED Right

-- Master Caution LEDs
local PIN_MC_LED_L          = "ARDUINO_MEGA2560_B_D43"      -- Master Caution LED Left
local PIN_MC_LED_R          = "ARDUINO_MEGA2560_B_D31"      -- Master Caution LED Right

-- Engine Warning LEDs
local PIN_ENG1_LED          = "ARDUINO_MEGA2560_B_D4"       -- Engine 1 Warning LED
local PIN_ENG2_LED          = "ARDUINO_MEGA2560_B_D12"      -- Engine 2 Warning LED

-- =============================================================================
-- 2. INITIALIZE HARDWARE LEDS
-- =============================================================================
-- BRG PTR LEDs
local led_brg_ptr_h         = hw_led_add(PIN_BRG_PTR_LED, 0.0)
local led_brg_ptr2_h        = hw_led_add(PIN_BRG_PTR2_LED, 0.0)

-- Fire Handle LEDs
local led_fire_h1_h         = hw_led_add(PIN_FIRE_HANDLE1_LED, 0.0)
local led_fire_h2_h         = hw_led_add(PIN_FIRE_HANDLE2_LED, 0.0)
local led_bag_fire_test_h   = hw_led_add(PIN_BAG_FIRE_TEST_LED, 0.0)

-- Beacon Marker LEDs
local led_mk_r_red          = hw_led_add(PIN_MARKER_R_RED, 0.0)
local led_mk_r_wht          = hw_led_add(PIN_MARKER_R_WHT, 0.0)
local led_mk_r_blu          = hw_led_add(PIN_MARKER_R_BLU, 0.0)
local led_mk_l_wht          = hw_led_add(PIN_MARKER_L_WHT, 0.0)
local led_mk_l_blu          = hw_led_add(PIN_MARKER_L_BLU, 0.0)
local led_mk_l_red          = hw_led_add(PIN_MARKER_L_RED, 0.0)

-- Over Torque LEDs
local led_ot_l_h            = hw_led_add(PIN_OVERTQ_LED_L, 0.0)
local led_ot_r_h            = hw_led_add(PIN_OVERTQ_LED_R, 0.0)

-- Cyclic Center LEDs
local led_cyc_ctr_l_h       = hw_led_add(PIN_CYC_CTR_LED_L, 0.0)
local led_cyc_ctr_r_h       = hw_led_add(PIN_CYC_CTR_LED_R, 0.0)

-- Master Caution LEDs
local led_mc_l_h            = hw_led_add(PIN_MC_LED_L, 0.0)
local led_mc_r_h            = hw_led_add(PIN_MC_LED_R, 0.0)

-- Engine Warning LEDs
local led_eng1_h            = hw_led_add(PIN_ENG1_LED, 0.0)
local led_eng2_h            = hw_led_add(PIN_ENG2_LED, 0.0)

-- =============================================================================
-- 3. INTERNAL VARIABLES & CONSTANTS
-- =============================================================================
-- Fire System States
local fire_handle1_pulled   = 0
local fire_handle2_pulled   = 0
local fire_test_active      = false
local bag_fire_test_state   = 0

-- Extinguisher State (3-position: 0=OFF, 1=Main, 2=Reserve)
local extinguisher_pos1_pressed = false
local extinguisher_pos2_pressed = false
local extinguisher_state    = 0

-- Marker Test States (separate left and right)
local marker_test_left_state  = 0
local marker_test_right_state = 0
local test_marker_state       = 0  -- Global marker test (L:TestMarker)

-- Over Torque State
local overtq_state          = 0

-- Cyclic Center Test State
local cyc_test_state        = 0

-- Master Caution Reset States
local mc_reset_l_held       = false
local mc_reset_r_held       = false

-- Fuel Quantity Test State
local fuel_quantity_state   = 0

-- DC Bus State
local dc_bus                = 0

-- Engine Warning States
local test_mc               = 0
local rpm_n1_e1             = 100.0
local rpm_n1_e2             = 100.0

-- =============================================================================
-- 4. SYSTEM LOGIC FUNCTIONS
-- =============================================================================

-- FIRE HANDLE LED UPDATE
local function update_fire_handle_leds()
    if dc_bus == 0 then
        hw_led_set(led_fire_h1_h, 0.0)
        hw_led_set(led_fire_h2_h, 0.0)
        return
    end
    hw_led_set(led_fire_h1_h, (fire_handle1_pulled == 1) and 1.0 or 0.0)
    hw_led_set(led_fire_h2_h, (fire_handle2_pulled == 1) and 1.0 or 0.0)
end

-- FIRE TEST LED UPDATE
local function update_fire_leds()
    if fire_test_active == 1 then
        hw_led_set(led_fire_h1_h, 1.0)
        hw_led_set(led_fire_h2_h, 1.0)
    else
        update_fire_handle_leds()
    end
end

-- BAGGAGE FIRE TEST LED UPDATE
local function update_bag_fire_test_led()
    hw_led_set(led_bag_fire_test_h, (bag_fire_test_state == 1) and 1.0 or 0.0)
end

-- MARKER LED UPDATE (separate left and right, or all if L:TestMarker=1)
local function update_marker_leds()
    -- If global test marker is active, light ALL beacon LEDs
    if test_marker_state == 1 then
        hw_led_set(led_mk_l_wht, 1.0)
        hw_led_set(led_mk_l_blu, 1.0)
        hw_led_set(led_mk_l_red, 1.0)
        hw_led_set(led_mk_r_wht, 1.0)
        hw_led_set(led_mk_r_red, 1.0)
        hw_led_set(led_mk_r_blu, 1.0)
        return
    end
    
    -- Left marker LEDs (controlled by left test button)
    local val_left = (marker_test_left_state == 1) and 1.0 or 0.0
    hw_led_set(led_mk_l_wht, val_left)
    hw_led_set(led_mk_l_blu, val_left)
    hw_led_set(led_mk_l_red, val_left)
    
    -- Right marker LEDs (controlled by right test button)
    local val_right = (marker_test_right_state == 1) and 1.0 or 0.0
    hw_led_set(led_mk_r_wht, val_right)
    hw_led_set(led_mk_r_red, val_right)
    hw_led_set(led_mk_r_blu, val_right)
end

-- OVER TORQUE LED UPDATE
local function update_overtq_led()
    local led_value = (overtq_state == 1) and 1.0 or 0.0
    hw_led_set(led_ot_l_h, led_value)
    hw_led_set(led_ot_r_h, led_value)
end

-- CYCLIC CENTER LED UPDATE
local function update_cyc_ctr_led()
    local led_val = (cyc_test_state == 1) and 1.0 or 0.0
    hw_led_set(led_cyc_ctr_l_h, led_val)
    hw_led_set(led_cyc_ctr_r_h, led_val)
end

-- EXTINGUISHER STATE UPDATE (3-position)
local function update_extinguisher_state()
    local new_state = 0
    if extinguisher_pos2_pressed then
        new_state = 2  -- Reserve
    elseif extinguisher_pos1_pressed then
        new_state = 1  -- Main
    end
    
    if extinguisher_state ~= new_state then
        extinguisher_state = new_state
        fsx_variable_write("L:Extinguisher", "Number", extinguisher_state)
        print("EXTINGUISHER: State changed to " .. tostring(extinguisher_state))
    end
end

-- MC RESET Logic (controls separate MC LEDs)
local function update_mc_reset()
    local reset_active = mc_reset_l_held or mc_reset_r_held
    fsx_variable_write("L:ResetMC", "Number", reset_active and 1 or 0)
    -- Left button (D41) controls Left LED (D43)
    hw_led_set(led_mc_l_h, mc_reset_l_held and 1.0 or 0.0)
    -- Right button (D36) controls Right LED (D31)
    hw_led_set(led_mc_r_h, mc_reset_r_held and 1.0 or 0.0)
    print("ACTION: MC Reset State = " .. tostring(reset_active))
end

-- BRG PTR LED UPDATE
local function update_brg_ptr_leds()
    -- Subscribe-based - will be updated from sim feedback
end

-- ENGINE WARNING LED UPDATE
-- Logic: LED ON when DC Bus ON AND (TestMC active OR RPM N1 <= 55%)
local function update_engine_leds()
    if dc_bus == 0 then
        hw_led_set(led_eng1_h, 0.0)
        hw_led_set(led_eng2_h, 0.0)
        return
    end
    
    -- Engine 1: ON if TestMC active OR RPM N1 E1 <= 55%
    local eng1_warn = (test_mc ~= 0) or (rpm_n1_e1 <= 55.0)
    hw_led_set(led_eng1_h, eng1_warn and 1.0 or 0.0)
    
    -- Engine 2: ON if TestMC active OR RPM N1 E2 <= 55%
    local eng2_warn = (test_mc ~= 0) or (rpm_n1_e2 <= 55.0)
    hw_led_set(led_eng2_h, eng2_warn and 1.0 or 0.0)
end

-- =============================================================================
-- 5. HARDWARE INPUTS (BUTTONS)
-- =============================================================================

-- BRG PTR SWITCH LEFT
hw_button_add(PIN_BRG_PTR,
    function() -- PRESSED
        print("ACTION: BRG PTR Left PRESSED")
        fsx_variable_write("L:SwBrgPtr", "Number", 1)
        hw_led_set(led_brg_ptr_h, 1.0)
    end,
    function() -- RELEASED
        print("ACTION: BRG PTR Left RELEASED")
        fsx_variable_write("L:SwBrgPtr", "Number", 0)
        hw_led_set(led_brg_ptr_h, 0.0)
    end
)

-- BRG PTR SWITCH RIGHT
hw_button_add(PIN_BRG_PTR2,
    function() -- PRESSED
        print("ACTION: BRG PTR Right PRESSED")
        fsx_variable_write("L:SwBrgPtr", "Number", 1)
        hw_led_set(led_brg_ptr2_h, 1.0)
    end,
    function() -- RELEASED
        print("ACTION: BRG PTR Right RELEASED")
        fsx_variable_write("L:SwBrgPtr", "Number", 0)
        hw_led_set(led_brg_ptr2_h, 0.0)
    end
)

-- FIRE PULL HANDLE LEFT
hw_button_add(PIN_FIRE_PULL1,
    function() -- PRESSED (Pulled)
        print("ACTION: Fire Handle Left PULLED")
        fire_handle1_pulled = 1
        fsx_variable_write("L:firethandl", "Number", 1)
        update_fire_handle_leds()
    end,
    function() -- RELEASED (Reset)
        print("ACTION: Fire Handle Left RESET")
        fire_handle1_pulled = 0
        fsx_variable_write("L:firethandl", "Number", 0)
        update_fire_handle_leds()
    end
)

-- FIRE PULL HANDLE LEFT
hw_button_add(PIN_FIRE_PULL1,
    function() -- PRESSED (Pulled)
        print("ACTION: Fire Handle Left PULLED")
        fire_handle1_pulled = 1
        fsx_variable_write("L:firethandl", "Number", 1)
        update_fire_handle_leds()
    end,
    function() -- RELEASED (Reset)
        print("ACTION: Fire Handle Left RESET")
        fire_handle1_pulled = 0
        fsx_variable_write("L:firethandl", "Number", 0)
        update_fire_handle_leds()
    end
)

-- FIRE PULL HANDLE RIGHT
hw_button_add(PIN_FIRE_PULL2,
    function() -- PRESSED (Pulled)
        print("ACTION: Fire Handle Right PULLED")
        fire_handle2_pulled = 1
        fsx_variable_write("L:firethandr", "Number", 1)
        update_fire_handle_leds()
    end,
    function() -- RELEASED (Reset)
        print("ACTION: Fire Handle Right RESET")
        fire_handle2_pulled = 0
        fsx_variable_write("L:firethandr", "Number", 0)
        update_fire_handle_leds()
    end
)

-- FIRE DETECTION TEST
hw_button_add(PIN_FIRE_TEST,
    function() -- PRESSED (LEDs ON)
        print("ACTION: Fire Test PRESSED")
        fire_test_active = 1
        fsx_variable_write("L:Swfiretest", "Number", 1)
        update_fire_leds()
    end,
    function() -- RELEASED (LEDs OFF)
        print("ACTION: Fire Test RELEASED")
        fire_test_active = 0
        fsx_variable_write("L:Swfiretest", "Number", 0)
        update_fire_leds()
    end
)

-- BAGGAGE FIRE TEST
hw_button_add(PIN_BAG_FIRE_TEST,
    function() -- PRESSED
        print("ACTION: Baggage Fire Test PRESSED")
        bag_fire_test_state = 1
        fsx_variable_write("L:firetestbag", "Number", 1)
        update_bag_fire_test_led()
    end,
    function() -- RELEASED
        print("ACTION: Baggage Fire Test RELEASED")
        bag_fire_test_state = 0
        fsx_variable_write("L:firetestbag", "Number", 0)
        update_bag_fire_test_led()
    end
)

-- FIRE EXTINGUISHER MAIN (Position 1)
hw_button_add(PIN_EXTINGUISHER_POS1,
    function() -- PRESSED
        print("ACTION: Extinguisher Main PRESSED")
        extinguisher_pos1_pressed = true
        update_extinguisher_state()
    end,
    function() -- RELEASED
        print("ACTION: Extinguisher Main RELEASED")
        extinguisher_pos1_pressed = false
        update_extinguisher_state()
    end
)

-- FIRE EXTINGUISHER RESERVE (Position 2)
hw_button_add(PIN_EXTINGUISHER_POS2,
    function() -- PRESSED
        print("ACTION: Extinguisher Reserve PRESSED")
        extinguisher_pos2_pressed = true
        update_extinguisher_state()
    end,
    function() -- RELEASED
        print("ACTION: Extinguisher Reserve RELEASED")
        extinguisher_pos2_pressed = false
        update_extinguisher_state()
    end
)

-- BEACON MARKER TEST LEFT (controls L:TestMarker -> all LEDs)
hw_button_add(PIN_MARKER_TEST,
    function() -- PRESSED
        print("ACTION: Marker Test Left PRESSED")
        fsx_variable_write("L:TestMarker", "Number", 1)
        test_marker_state = 1
        update_marker_leds()
    end,
    function() -- RELEASED
        print("ACTION: Marker Test Left RELEASED")
        fsx_variable_write("L:TestMarker", "Number", 0)
        test_marker_state = 0
        update_marker_leds()
    end
)

-- BEACON MARKER TEST RIGHT (controls L:TestMarker -> all LEDs)
hw_button_add(PIN_MARKER_TEST2,
    function() -- PRESSED
        print("ACTION: Marker Test Right PRESSED")
        fsx_variable_write("L:TestMarker", "Number", 1)
        test_marker_state = 1
        update_marker_leds()
    end,
    function() -- RELEASED
        print("ACTION: Marker Test Right RELEASED")
        fsx_variable_write("L:TestMarker", "Number", 0)
        test_marker_state = 0
        update_marker_leds()
    end
)

-- OVER TORQUE TEST LEFT
hw_button_add(PIN_OVERTQ_TEST,
    function() -- PRESSED
        print("ACTION: Over Torque Test Left PRESSED")
        overtq_state = 1
        fsx_variable_write("L:Overtq", "Number", 1)
        update_overtq_led()
    end,
    function() -- RELEASED
        print("ACTION: Over Torque Test Left RELEASED")
        overtq_state = 0
        fsx_variable_write("L:Overtq", "Number", 0)
        update_overtq_led()
    end
)

-- OVER TORQUE TEST RIGHT
hw_button_add(PIN_OVERTQ_TEST2,
    function() -- PRESSED
        print("ACTION: Over Torque Test Right PRESSED")
        overtq_state = 1
        fsx_variable_write("L:Overtq", "Number", 1)
        update_overtq_led()
    end,
    function() -- RELEASED
        print("ACTION: Over Torque Test Right RELEASED")
        overtq_state = 0
        fsx_variable_write("L:Overtq", "Number", 0)
        update_overtq_led()
    end
)

-- CYCLIC CENTER TEST LEFT
hw_button_add(PIN_CYC_CTR_TEST_L,
    function() -- PRESSED
        print("ACTION: Cyclic Center Test Left PRESSED")
        cyc_test_state = 1
        fsx_variable_write("L:Cyctest", "Number", 1)
        update_cyc_ctr_led()
    end,
    function() -- RELEASED
        print("ACTION: Cyclic Center Test Left RELEASED")
        cyc_test_state = 0
        fsx_variable_write("L:Cyctest", "Number", 0)
        update_cyc_ctr_led()
    end
)

-- CYCLIC CENTER TEST RIGHT
hw_button_add(PIN_CYC_CTR_TEST_R,
    function() -- PRESSED
        print("ACTION: Cyclic Center Test Right PRESSED")
        cyc_test_state = 1
        fsx_variable_write("L:Cyctest", "Number", 1)
        update_cyc_ctr_led()
    end,
    function() -- RELEASED
        print("ACTION: Cyclic Center Test Right RELEASED")
        cyc_test_state = 0
        fsx_variable_write("L:Cyctest", "Number", 0)
        update_cyc_ctr_led()
    end
)

-- MASTER CAUTION RESET LEFT
hw_button_add(PIN_MC_RESET_L,
    function() -- PRESSED
        print("ACTION: MC Reset Left PRESSED")
        mc_reset_l_held = true
        update_mc_reset()
    end,
    function() -- RELEASED
        print("ACTION: MC Reset Left RELEASED")
        mc_reset_l_held = false
        update_mc_reset()
    end
)

-- MASTER CAUTION RESET RIGHT
hw_button_add(PIN_MC_RESET_R,
    function() -- PRESSED
        print("ACTION: MC Reset Right PRESSED")
        mc_reset_r_held = true
        update_mc_reset()
    end,
    function() -- RELEASED
        print("ACTION: MC Reset Right RELEASED")
        mc_reset_r_held = false
        update_mc_reset()
    end
)

-- FUEL SYSTEM TEST FWD TANK
hw_button_add(PIN_FUEL_SYS_TEST_FWD,
    function() -- PRESSED
        print("ACTION: Fuel Sys Test FWD PRESSED")
        fuel_quantity_state = 1
        fsx_variable_write("L:FuelQuantity", "Number", 1)
    end,
    function() -- RELEASED
        print("ACTION: Fuel Sys Test FWD RELEASED")
        fuel_quantity_state = 0
        fsx_variable_write("L:FuelQuantity", "Number", 0)
    end
)

-- FUEL SYSTEM TEST MID TANK
hw_button_add(PIN_FUEL_SYS_TEST_MID,
    function() -- PRESSED
        print("ACTION: Fuel Sys Test MID PRESSED")
        fuel_quantity_state = -1
        fsx_variable_write("L:FuelQuantity", "Number", -1)
    end,
    function() -- RELEASED
        print("ACTION: Fuel Sys Test MID RELEASED")
        fuel_quantity_state = 0
        fsx_variable_write("L:FuelQuantity", "Number", 0)
    end
)

-- FUEL DIGIT TEST
hw_button_add(PIN_FUEL_DIGIT_TEST,
    function() -- PRESSED (LEDs ON)
        print("ACTION: Fuel Digit Test PRESSED")
        fsx_variable_write("L:Digitstest", "Number", 1)
    end,
    function() -- RELEASED (LEDs OFF)
        print("ACTION: Fuel Digit Test RELEASED")
        fsx_variable_write("L:Digitstest", "Number", 0)
    end
)

-- NAV GPS RIGHT BUTTON
hw_button_add(PIN_NAV_GPS_BTN_R,
    function() -- PRESSED
        print("ACTION: Nav GPS Right PRESSED")
        fsx_variable_write("L:NavGpsR", "Number", 1)
    end,
    function() -- RELEASED
        print("ACTION: Nav GPS Right RELEASED")
        fsx_variable_write("L:NavGpsR", "Number", 0)
    end
)

-- NAV GPS LEFT BUTTON
hw_button_add(PIN_NAV_GPS_BTN_L,
    function() -- PRESSED
        print("ACTION: Nav GPS Left PRESSED")
        fsx_variable_write("L:NavGpsL", "Number", 1)
    end,
    function() -- RELEASED
        print("ACTION: Nav GPS Left RELEASED")
        fsx_variable_write("L:NavGpsL", "Number", 0)
    end
)

-- =============================================================================
-- 6. SIMULATOR SUBSCRIPTIONS (Data In -> LED Update)
-- =============================================================================

-- DC Bus
fsx_variable_subscribe("L:MasterDcBus", "Number", function(val)
    dc_bus = (val ~= 0) and 1 or 0
    update_fire_leds()
    update_fire_handle_leds()
    update_engine_leds()
end)

-- Test MC State (for Engine Warning LEDs)
fsx_variable_subscribe("L:TestMC", "Number", function(val)
    test_mc = val or 0
    update_engine_leds()
end)

-- Engine 1 RPM N1 (for Engine 1 Warning LED)
fsx_variable_subscribe("TURB ENG N1:1", "Percent", function(val)
    rpm_n1_e1 = val or 0.0
    update_engine_leds()
end)

-- Engine 2 RPM N1 (for Engine 2 Warning LED)
fsx_variable_subscribe("TURB ENG N1:2", "Percent", function(val)
    rpm_n1_e2 = val or 0.0
    update_engine_leds()
end)

-- Fire Handle States (for sync from sim/other sources)
fsx_variable_subscribe("L:firethandl", "Number", function(val)
    fire_handle1_pulled = (val ~= 0) and 1 or 0
    update_fire_handle_leds()
end)

fsx_variable_subscribe("L:firethandr", "Number", function(val)
    fire_handle2_pulled = (val ~= 0) and 1 or 0
    update_fire_handle_leds()
end)

-- Cyclic Center Test State
fsx_variable_subscribe("L:Cyctest", "Number", function(val)
    cyc_test_state = (val ~= 0) and 1 or 0
    update_cyc_ctr_led()
end)

-- Baggage Fire Test State
fsx_variable_subscribe("L:firetestbag", "Number", function(val)
    bag_fire_test_state = (val ~= 0) and 1 or 0
    update_bag_fire_test_led()
end)

-- Global Marker Test (L:TestMarker = 1 lights ALL beacon LEDs)
fsx_variable_subscribe("L:TestMarker", "Number", function(val)
    test_marker_state = (val ~= 0) and 1 or 0
    update_marker_leds()
end)

-- Over Torque Test State
fsx_variable_subscribe("L:Overtq", "Number", function(val)
    overtq_state = (val ~= 0) and 1 or 0
    update_overtq_led()
end)

-- BRG PTR State
fsx_variable_subscribe("L:SwBrgPtr", "Number", function(val)
    local led_val = (val ~= 0) and 1.0 or 0.0
    hw_led_set(led_brg_ptr_h, led_val)
    hw_led_set(led_brg_ptr2_h, led_val)
end)

-- Master Caution LED State (from CWP logic)
fsx_variable_subscribe("L:MasterCaution", "Number", function(val)
    local led_val = (val ~= 0) and 1.0 or 0.0
    hw_led_set(led_mc_l_h, led_val)
    hw_led_set(led_mc_r_h, led_val)
end)

-- =============================================================================
-- 7. STARTUP INITIALIZATION
-- =============================================================================
fsx_variable_write("L:firethandl", "Number", 0)
fsx_variable_write("L:firethandr", "Number", 0)
fsx_variable_write("L:Swfiretest", "Number", 0)
fsx_variable_write("L:firetestbag", "Number", 0)
fsx_variable_write("L:Extinguisher", "Number", 0)
fsx_variable_write("L:TestMarker", "Number", 0)
fsx_variable_write("L:Overtq", "Number", 0)
fsx_variable_write("L:Cyctest", "Number", 0)
fsx_variable_write("L:ResetMC", "Number", 0)
fsx_variable_write("L:SwBrgPtr", "Number", 0)
fsx_variable_write("L:FuelQuantity", "Number", 0)

-- Initialize all LEDs
update_fire_handle_leds()
update_fire_leds()
update_bag_fire_test_led()
update_marker_leds()
update_overtq_led()
update_cyc_ctr_led()
update_extinguisher_state()
update_engine_leds()

print("DEBUG: Front Panel Script Loaded")
