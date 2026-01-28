# Bell 412 - Ancillary Systems Specification

## Overview
- **File**: `systems_ancillary.lua`
- **Hardware**: Arduino Channel A (Overhead) + Channel B (Pedestal)
- **Logic Type**: Buttons Only (Active Low)

## Hardware Pin Assignments

### Channel A - Overhead Panel Inputs (D11, D13-D29)
| Pin | Variable | Function | L-Var |
|-----|----------|----------|-------|
| D11 | PIN_PLATE_MAPLIGHT_BTN | Plate/Maplight Dimmer Button 2 | L:platepilolight (0/25) |
| D13 | PIN_DOME_LIGHT_POS1 | Aft Dome Light Pos1 | L:Swredwhite (1) |
| D14 | PIN_PITOT_HEAT | Pitot Heat | L:pitotcovers |
| D15 | PIN_NAV_LIGHTS | Nav Lights | L:Swposition |
| D16 | PIN_ANTICOLL | Anti-Collision | L:Swanticoll |
| D17 | PIN_WIPER_PI | Pilot Wiper | L:SwPiWiper, L:Swpiwiper |
| D18 | PIN_WIPER_CO | Copilot Wiper | L:SwCoWiper, L:Swcowiper |
| D19 | PIN_HEATER | Heater | L:SwHeater |
| D20 | PIN_VENT_BLOWER | Vent Blower | L:SwVentBlower |
| D21 | PIN_AFT_OUTLET | Aft Outlet | L:SwAftOutlet |
| D22 | PIN_DOME_LIGHT_POS2 | Aft Dome Light Pos2 | L:Swredwhite (2) |
| D23 | PIN_UTILITY_LT | Utility Light | L:SwUtilityLight |
| D24 | PIN_FIRE_PULL1 | Fire Handle 1 | L:firethandl (Number 0/1) |
| D25 | PIN_FIRE_PULL2 | Fire Handle 2 | L:firethandr (Number 0/1) |
| D26 | PIN_FIRE_TEST | Fire Test | L:Swfiretest (Bool) |
| D27 | PIN_COMPASS_SLAVE | Compass Mag/Slave | L:CompassControl |
| D28 | PIN_EXTINGUISHER_POS1 | Fire Extinguisher Pos1 | L:Extinguisher (1) |
| D29 | PIN_EXTINGUISHER_POS2 | Fire Extinguisher Pos2 | L:Extinguisher (2) |

### Channel A - Analog Inputs (A0)
| Pin | Variable | Function | L-Var | Range |
|-----|----------|----------|-------|-------|
| A0 | PIN_PLATE_MAPLIGHT | Plate/Maplight Dimmer (Analog) | L:platepilolight | 0-50 |

### Channel A - Fire Handle Status LEDs (D30-D31)
| Pin | Variable | Function | Condition |
|-----|----------|----------|-----------|
| D30 | PIN_FIRE_HANDLE1_LED | Fire Handle 1 Status | fire_handle1_pulled == 1 |
| D31 | PIN_FIRE_HANDLE2_LED | Fire Handle 2 Status | fire_handle2_pulled == 1 |

### Channel A - Fire Warning LEDs (D35-D37)
| Pin | Variable | Function | L-Var Subscribed |
|-----|----------|----------|------------------|
| D35 | PIN_FIRE_ENG1_LED | Fire Warn Eng 1 | L:FireWarn1 |
| D36 | PIN_FIRE_ENG2_LED | Fire Warn Eng 2 | L:FireWarn2 |
| D37 | PIN_BAG_FIRE_LED | Baggage Fire | L:BagFire |

### Channel B - Pedestal Panel (D20-D29, D39, D49-D54)
| Pin | Variable | Function | L-Var | Behavior |
|-----|----------|----------|-------|----------|
| D20 | PIN_FORCE_TRIM | Force Trim Release | L:Sw forcetrim | Momentary + Event |
| D21 | PIN_COMPASS | Compass | L:SwCompass | ON/OFF |
| D22 | PIN_STATIC_SRC | Static Source | L:SwStaticSource | ON/OFF |
| D23 | PIN_AFCS_HP1 | AFCS HP1 | L:HP1 | Toggle-on-press |
| D24 | PIN_AFCS_HP2 | AFCS HP2 | L:HP2 | Toggle-on-press |
| D25 | PIN_AFCS_SAS | AFCS SAS | L:SASATT | Toggle-on-press |
| D26 | PIN_AFCS_ATT | AFCS ATT | L:AP_ATT | Toggle-on-press |
| D27 | PIN_STBY_ATT_TEST | Standby Att Test | L:Masterstbatt | 2s timer |
| D28 | PIN_CARGO_REL | Cargo Release | L:Swcargorel | ON/OFF |
| D29 | PIN_CARGO_TEST | Cargo Test | L:CRTest | Momentary |
| D39 | PIN_BAMBI_REL | Bambi Release | L:SwBambiRelease | ON/OFF |
| D39 | PIN_BAMBI_REL2 | Bambi Release 2 | L:SwBambiRelease | ON/OFF |
| D49 | PIN_CARGO_TEST_LED | Cargo Test LED | L:CRTest | Status LED |
| D50 | PIN_BAMBI_REL2 | Bambi Release Switch 2 | L:SwBambiRelease | ON/OFF |
| D51 | PIN_MAG_DG_MAG1 | Mag/Dg Switch Mag Button 1 | L:SwMagDg (1) | 3-Position |
| D52 | PIN_MAG_DG_MAG2 | Mag/Dg Switch Mag Button 2 | L:SwMagDg (1) | 3-Position |
| D53 | PIN_MAG_DG_DG1 | Mag/Dg Switch Dg Button 1 | L:SwMagDg (2) | 3-Position |
| D54 | PIN_MAG_DG_DG2 | Mag/Dg Switch Dg Button 2 | L:SwMagDg (2) | 3-Position |

### Channel C - Nav Selectors & Test Buttons (D14-D19, D26-D29, D47-D49, D57-D58)
| Pin | Variable | Function | L-Var | Behavior |
|-----|----------|----------|-------|----------|
| D14 | PIN_COURSE_SET | Course Set Switch | L:SwCourseset | 0=Nav1, 1=Nav2 |
| D15 | PIN_BRG_PTR | BRG PTR Switch | L:SwBrgPtr | 0=Pilot, 1=Co-Pilot |
| D16 | PIN_OVERTQ_TEST | Over Torque Test | L:Overtq | Momentary |
| D17 | PIN_AFT_CALL | AFT Call | L:AFTcall | Momentary |
| D18 | PIN_AFT_TEST | AFT Test | L:Testaft | Momentary |
| D19 | PIN_DME_SEL_POS1 | DME Select N1 | L:Swdme (1) | 3-Position |
| D26 | PIN_MARKER_TEST | Marker Test | L:TestMarker | Momentary |
| D27 | PIN_DAFCSEL | AFCS Selector | L:Dafcssel | Momentary |
| D28 | PIN_DME_SEL_POS2 | DME Select N2 | L:Swdme (2) | 3-Position |
| D29 | PIN_BAG_FIRE_TEST | Baggage Fire Test | L:firetestbag | Momentary |
| D47 | PIN_OVERTQ_TEST2 | Over Torque Test 2 | L:Overtq | Momentary |
| D48 | PIN_AFT_CALL2 | AFT Call 2 | L:AFTcall | Momentary |
| D49 | PIN_AFT_TEST2 | AFT Test 2 | L:Testaft | Momentary |
| D57 | PIN_BRG_PTR2 | BRG PTR Switch 2 | L:SwBrgPtr | 0=Pilot, 1=Co-Pilot |
| D58 | PIN_MARKER_TEST2 | Marker Test 2 | L:TestMarker | Momentary |

### Channel C - Test & Status LEDs (D36-D39, D44-D46, D54-D56, D59)
| Pin | Variable | Function | L-Var | Condition |
|-----|----------|----------|-------|-----------|
| D36 | PIN_MARKER_OUTER_LED | Marker Outer (Blue) | L:TestMarker | marker_test_state == 1 |
| D37 | PIN_MARKER_MIDDLE_LED | Marker Middle (Amber) | L:TestMarker | marker_test_state == 1 |
| D38 | PIN_MARKER_INNER_LED | Marker Inner (White) | L:TestMarker | marker_test_state == 1 |
| D39 | PIN_OVERTQ_LED | Over Torque Test LED | L:Overtq | overtq_state == 1 |
| D44 | PIN_AFT_CALL_LED | AFT Call LED | L:AFTcall | aft_call_state == 1 |
| D45 | PIN_AFT_TEST_LED | AFT Test LED | L:Testaft | aft_test_state == 1 |
| D46 | PIN_BAG_FIRE_TEST_LED | Baggage Fire Test LED | L:firetestbag | bag_fire_test_state == 1 |
| D54 | PIN_OVERTQ_LED2 | Over Torque Test LED 2 | L:Overtq | overtq_state == 1 |
| D55 | PIN_AFT_CALL_LED2 | AFT Call LED 2 | L:AFTcall | aft_call_state == 1 |
| D56 | PIN_AFT_TEST_LED2 | AFT Test LED 2 | L:Testaft | aft_test_state == 1 |
| D59 | PIN_MARKER_TEST_LED2 | Marker Test LED 2 | L:TestMarker | marker_test_state == 1 |

## Fire Warning LED System

### Fire LEDs (D35-D37)
The fire warning LEDs illuminate based on:
1. **Fire Detection**: Subscribes to L:FireWarn1, L:FireWarn2, L:BagFire
2. **Fire Test Mode**: All three LEDs illuminate when Fire Test button is pressed

```lua
local function update_fire_leds()
    if dc_bus == 0 then
        -- No power, all off
        hw_led_set(led_fire_eng1_h, 0.0)
        hw_led_set(led_fire_eng2_h, 0.0)
        hw_led_set(led_bag_fire_h, 0.0)
        return
    end
    
    if fire_test_active then
        -- Fire Test illuminates all fire LEDs
        hw_led_set(led_fire_eng1_h, 1.0)
        hw_led_set(led_fire_eng2_h, 1.0)
        hw_led_set(led_bag_fire_h, 1.0)
    else
        -- Normal operation
        hw_led_set(led_fire_eng1_h, (fire_warn_eng1 == 1) and 1.0 or 0.0)
        hw_led_set(led_fire_eng2_h, (fire_warn_eng2 == 1) and 1.0 or 0.0)
        hw_led_set(led_bag_fire_h, (fire_warn_bag == 1) and 1.0 or 0.0)
    end
end
```

### Fire Test Button Integration
```lua
hw_button_add(PIN_FIRE_TEST,
    function() -- PRESSED
        print("ACTION: Fire Test PRESSED")
        fire_test_active = true
        fsx_variable_write("L:Swfiretest", "Bool", true)
        update_fire_leds()  -- Force all fire LEDs ON
    end,
    function() -- RELEASED
        print("ACTION: Fire Test RELEASED")
        fire_test_active = false
        fsx_variable_write("L:Swfiretest", "Bool", false)
        update_fire_leds()  -- Return to normal state
    end
)
```

## Force Trim Logic (Flight Manual Procedure)

**Per Flight Manual**: *"Press cyclic FORCE TRIM release button... Release button when desired attitude is reached."*

```lua
hw_button_add(PIN_FORCE_TRIM,
    function() -- PRESSED: Release force trim
        print("ACTION: Force Trim RELEASE PRESSED")
        force_trim_held = true
        fsx_variable_write("L:Sw forcetrim", "Number", 1)
        fsx_event("ROTOR_TRIM_RESET")
    end,
    function() -- RELEASED: Re-engages at new position
        print("ACTION: Force Trim RELEASE - Re-engaged at new position")
        force_trim_held = false
        fsx_variable_write("L:Sw forcetrim", "Number", 0)
    end
)
```

## Sim Events Fired
| Switch | ON Event | OFF Event |
|--------|----------|-----------|
| Pitot Heat | PITOT_HEAT_ON | PITOT_HEAT_OFF |
| Nav Lights | NAV_LIGHTS_ON | NAV_LIGHTS_OFF |
| Anti-Coll | BEACON_LIGHTS_ON | BEACON_LIGHTS_OFF |
| Force Trim | ROTOR_TRIM_RESET | (none) |

## Subscriptions (Sim → Logic)
| Variable | Purpose |
|----------|---------|
| L:MasterDcBus | DC power for fire LEDs |
| L:stbatt | Standby attitude power |
| L:FireWarn1 | Engine 1 fire detection |
| L:FireWarn2 | Engine 2 fire detection |
| L:BagFire | Baggage fire detection |
| L:firethandl | Fire Handle 1 state (for LED sync) |
| L:firethandr | Fire Handle 2 state (for LED sync) |
| L:TestMarker | Marker Test state (for LED sync) |
| L:Overtq | Over Torque Test state (for LED sync) |
| L:AFTcall | AFT Call state (for LED sync) |
| L:Testaft | AFT Test state (for LED sync) |
| L:firetestbag | Baggage Fire Test state (for LED sync) |
| L:Swdme | DME Select state (for sync) |
| L:SwMagDg | Mag/Dg Switch state (for sync) |

## Aft Dome Light Switch (3-Position: 0=OFF, 1=Position 1, 2=Position 2)
```lua
-- Position 1 Button (D13 -> State = 1)
hw_button_add(PIN_DOME_LIGHT_POS1,
    function() -- PRESSED (Position 1)
        dome_light_pos1_pressed = true
        update_dome_light_state()
    end,
    function() -- RELEASED
        dome_light_pos1_pressed = false
        update_dome_light_state()
    end
)

-- Position 2 Button (D22 -> State = 2, has priority)
hw_button_add(PIN_DOME_LIGHT_POS2,
    function() -- PRESSED (Position 2)
        dome_light_pos2_pressed = true
        update_dome_light_state()
    end,
    function() -- RELEASED
        dome_light_pos2_pressed = false
        update_dome_light_state()
    end
)
```

## Fire Extinguisher Switch (3-Position: 0=OFF, 1=Position 1, 2=Position 2)
```lua
-- Position 1 Button (D28 -> State = 1)
hw_button_add(PIN_EXTINGUISHER_POS1,
    function() -- PRESSED (Position 1)
        extinguisher_pos1_pressed = true
        update_extinguisher_state()
    end,
    function() -- RELEASED
        extinguisher_pos1_pressed = false
        update_extinguisher_state()
    end
)

-- Position 2 Button (D29 -> State = 2, has priority)
hw_button_add(PIN_EXTINGUISHER_POS2,
    function() -- PRESSED (Position 2)
        extinguisher_pos2_pressed = true
        update_extinguisher_state()
    end,
    function() -- RELEASED
        extinguisher_pos2_pressed = false
        update_extinguisher_state()
    end
)
```

## Fire Handle Status LEDs
The fire handle status LEDs (D30-D31) illuminate when the respective fire handle is pulled:
- **D30**: ON when `fire_handle1_pulled == 1` (L:firethandl == 1)
- **D31**: ON when `fire_handle2_pulled == 1` (L:firethandr == 1)

LEDs require DC bus power and are synchronized with L:firethandl and L:firethandr subscriptions.

## New Switches & Controls

### Approach Plate and Maplight Dimmer
- **Analog Input (A0)**: Potentiometer control, maps 0.0-1.0 to L:platepilolight (0-50)
- **Button Control (A_D11)**: Toggle between 0 (OFF) and 25 (half brightness)

### Course Set Switch (2-Position)
- **D14**: 0=Nav 1, 1=Nav 2
- Controls: `L:SwCourseset`

### BRG PTR Switch (2-Position, 2 buttons)
- **D15**: Primary switch (0=Pilot, 1=Co-Pilot)
- **D57**: Secondary switch (0=Pilot, 1=Co-Pilot)
- Controls: `L:SwBrgPtr`

### Over Torque Test (2 buttons + 2 LEDs)
- **D16**: Primary button
- **D47**: Secondary button
- **D39**: Primary LED
- **D54**: Secondary LED
- Controls: `L:Overtq` (Number 0/1)

### AFT Call (2 buttons + 2 LEDs)
- **D17**: Primary button
- **D48**: Secondary button
- **D44**: Primary LED
- **D55**: Secondary LED
- Controls: `L:AFTcall` (Number 0/1)

### AFT Test (2 buttons + 2 LEDs)
- **D18**: Primary button
- **D49**: Secondary button
- **D45**: Primary LED
- **D56**: Secondary LED
- Controls: `L:Testaft` (Number 0/1)

### DME Select Switch (3-Position)
- **D19**: Position 1 (N1, State = 1)
- **D28**: Position 2 (N2, State = 2, has priority)
- Controls: `L:Swdme` (Number 0=OFF, 1=N1, 2=N2)

### Marker Test (2 buttons + 4 LEDs)
- **D26**: Primary button
- **D58**: Secondary button
- **D36**: Marker Outer LED (Blue)
- **D37**: Marker Middle LED (Amber)
- **D38**: Marker Inner LED (White)
- **D59**: Marker Test Status LED 2
- Controls: `L:TestMarker` (Number 0/1)
- When active: All 4 LEDs illuminate

### AFCS Selector
- **D27**: Momentary button
- Controls: `L:Dafcssel` (Number 0/1)

### Baggage Fire Test
- **D29**: Momentary button
- **D46**: Status LED
- Controls: `L:firetestbag` (Number 0/1)

### Cargo Test
- **D29**: Momentary button
- **D49**: Status LED (Channel B)
- Controls: `L:CRTest` (Number 0/1)

### Bambi Release (2 buttons)
- **D39**: Primary switch
- **D50**: Secondary switch
- Controls: `L:SwBambiRelease` (Number 0/1)

### Mag/Dg Switch (3-Position: 4 buttons)
- **D51**: Mag Button 1 (State = 1)
- **D52**: Mag Button 2 (State = 1)
- **D53**: Dg Button 1 (State = 2, has priority)
- **D54**: Dg Button 2 (State = 2, has priority)
- Controls: `L:SwMagDg` (Number 0=Norm, 1=Mag, 2=Dg)

## L-Var Outputs
| L-Var | Type | Description |
|-------|------|-------------|
| L:Swredwhite | Number | Aft Dome Light (0=OFF, 1=Pos1, 2=Pos2) |
| L:Extinguisher | Number | Fire Extinguisher (0=OFF, 1=Pos1, 2=Pos2) |
| L:firethandl | Number | Fire Handle 1 (0=Reset, 1=Pulled) |
| L:firethandr | Number | Fire Handle 2 (0=Reset, 1=Pulled) |
| L:platepilolight | Number | Plate/Maplight Dimmer (0-50) |
| L:SwCourseset | Number | Course Set (0=Nav1, 1=Nav2) |
| L:SwBrgPtr | Number | BRG PTR (0=Pilot, 1=Co-Pilot) |
| L:Overtq | Number | Over Torque Test (0=OFF, 1=ON) |
| L:AFTcall | Number | AFT Call (0=OFF, 1=ON) |
| L:Testaft | Number | AFT Test (0=OFF, 1=ON) |
| L:Swdme | Number | DME Select (0=OFF, 1=N1, 2=N2) |
| L:TestMarker | Number | Marker Test (0=OFF, 1=ON) |
| L:Dafcssel | Number | AFCS Selector (0=OFF, 1=ON) |
| L:firetestbag | Number | Baggage Fire Test (0=OFF, 1=ON) |
| L:CRTest | Number | Cargo Test (0=OFF, 1=ON) |
| L:SwBambiRelease | Number | Bambi Release (0=OFF, 1=ON) |
| L:SwMagDg | Number | Mag/Dg Switch (0=Norm, 1=Mag, 2=Dg) |

## Startup Initialization
```lua
fsx_variable_write("L:StbyAttFlag", "Number", 1)
fsx_variable_write("L:Masterstbatt", "Number", 0)
fsx_variable_write("L:firethandl", "Number", 0)
fsx_variable_write("L:firethandr", "Number", 0)
fsx_variable_write("L:Swfiretest", "Bool", false)
fsx_variable_write("L:CompassControl", "Number", 0)
fsx_variable_write("L:Sw forcetrim", "Number", 0)
fsx_variable_write("L:Extinguisher", "Number", 0)
fsx_variable_write("L:Swredwhite", "Number", 0)
fsx_variable_write("L:SwBambiRelease", "Number", 0)
fsx_variable_write("L:platepilolight", "Number", 0)
fsx_variable_write("L:SwBrgPtr", "Number", 0)
fsx_variable_write("L:SwCourseset", "Number", 0)
fsx_variable_write("L:Overtq", "Number", 0)
fsx_variable_write("L:AFTcall", "Number", 0)
fsx_variable_write("L:Testaft", "Number", 0)
fsx_variable_write("L:Swdme", "Number", 0)
fsx_variable_write("L:SwMagDg", "Number", 0)
fsx_variable_write("L:Dafcssel", "Number", 0)
fsx_variable_write("L:firetestbag", "Number", 0)
fsx_variable_write("L:TestMarker", "Number", 0)

-- Initialize switch states
update_extinguisher_state()
update_dome_light_state()
update_dme_select_state()
update_mag_dg_state()

-- Initialize LEDs
update_fire_leds()
update_fire_handle_leds()
update_overtq_led()
update_aft_leds()
update_bag_fire_test_led()
update_marker_leds()
```
