# Bell 412 - Transmission & Governor Specification

## Overview
- **File**: `xmsn_governor_logic.lua`
- **Hardware**: Arduino Channel C (Collective Panel)
- **Logic Type**: Buttons Only (Active Low)

## Hardware Pin Assignments

### Inputs (D20-D25, D60-D61)
| Pin | Variable | Function | Event/L-Var |
|-----|----------|----------|-------------|
| D20 | PIN_GOV_MODE | Governor Mode | L:GovMode (0=Auto, 1=Manual) |
| D21 | PIN_RPM_SWITCH_POS1 | RPM Switch Pos1 (Inc) | L:GOVERNOR RPM SWITCH (1) + ROTOR_GOV_RPM_INC event |
| D22 | PIN_RPM_SWITCH_POS2 | RPM Switch Pos2 (Dec) | L:GOVERNOR RPM SWITCH (-1) + ROTOR_GOV_RPM_DEC event |
| D23 | PIN_GOV_ENG1 | Governor Engine 1 | L:SwGovA (0/1) |
| D25 | PIN_GOV_ENG2 | Governor Engine 2 | L:SwGovB (0/1) |
| D60 | PIN_RPM_SWITCH_POS1_2 | RPM Switch Pos1 Button 2 (Inc) | L:GOVERNOR RPM SWITCH (1) + ROTOR_GOV_RPM_INC event |
| D61 | PIN_RPM_SWITCH_POS2_2 | RPM Switch Pos2 Button 2 (Dec) | L:GOVERNOR RPM SWITCH (-1) + ROTOR_GOV_RPM_DEC event |

### Outputs - Switch Status LEDs (D32-D33)
| Pin | Variable | Function | Condition |
|-----|----------|----------|-----------|
| D32 | PIN_GOV_ENG1_LED | Governor Engine 1 Status | sw_gov_eng1 == 1 |
| D33 | PIN_GOV_ENG2_LED | Governor Engine 2 Status | sw_gov_eng2 == 1 |

### Outputs - CWP Warning LEDs (D41-D43)
| Pin | Variable | Function | L-Var Subscribed |
|-----|----------|----------|------------------|
| D41 | PIN_GOV_A_WARN_LED | Governor A Warning | L:SwGovA |
| D42 | PIN_GOV_B_WARN_LED | Governor B Warning | L:SwGovB |
| D43 | PIN_CHIP_DET_LED | XMSN Chip Detector | L:XMSN CHIP |

### Outputs - XMSN/CBOX Panel LEDs (D50-D53)
| Pin | Variable | Function | Condition |
|-----|----------|----------|-----------|
| D50 | PIN_GOV_MAN_LED | Gov Manual | sw_gov_manual == 1 |
| D51 | PIN_XMSN_PRESS_LED | XMSN Press Warn | xmsn_oil_psi < 30 |
| D52 | PIN_XMSN_TEMP_LED | XMSN Temp Warn | xmsn_oil_temp > 120 |
| D53 | PIN_CBOX_PRESS_LED | CBOX Press Warn | cbox_oil_psi < 25 |

## System Logic

### Warning Thresholds
| Constant | Value | Description |
|----------|-------|-------------|
| XMSN_PRESS_LOW | 30.0 PSI | Low XMSN oil pressure |
| XMSN_TEMP_HIGH | 120.0°C | High XMSN oil temp |
| CBOX_PRESS_LOW | 25.0 PSI | Low CBOX oil pressure |

### CWP Warning LEDs
These LEDs are subscribed to L-Vars that may be set by the simulator or other systems:

```lua
-- Governor A Warning (from CWP)
fsx_variable_subscribe("L:SwGovA", "Bool", function(val)
    gov_a_warn = val and 1 or 0
    update_cwp_warning_leds()
end)

-- Governor B Warning (from CWP)
fsx_variable_subscribe("L:SwGovB", "Bool", function(val)
    gov_b_warn = val and 1 or 0
    update_cwp_warning_leds()
end)

-- XMSN Chip Detector Warning
fsx_variable_subscribe("L:XMSN CHIP", "Bool", function(val)
    chip_det_warn = val and 1 or 0
    update_cwp_warning_leds()
end)
```

### Governor Mode Switch
```lua
hw_button_add(PIN_GOV_MODE,
    function() -- PRESSED (Manual)
        sw_gov_manual = 1
        fsx_variable_write("L:GovMode", "Number", 1)
        update_gov_led()
    end,
    function() -- RELEASED (Auto)
        sw_gov_manual = 0
        fsx_variable_write("L:GovMode", "Number", 0)
        update_gov_led()
    end
)
```

### Governor RPM Switch (3-Position: 0=OFF, 1=Increase, -1=Decrease)
The RPM switch has **two sets of buttons** (4 buttons total) that work together:
- **First Set**: D21 (Increase), D22 (Decrease)
- **Second Set**: D60 (Increase), D61 (Decrease)

The state update function checks **all 4 buttons** - if any Increase button is pressed, state = 1; if any Decrease button is pressed, state = -1; otherwise state = 0.

```lua
local function update_rpm_switch_state()
    local new_state = 0
    
    -- Check if any Increase button is pressed (from either set)
    if rpm_switch_pos1_pressed or rpm_switch_pos1_2_pressed then
        new_state = 1  -- Position 1 - RPM Increase
    -- Check if any Decrease button is pressed (from either set)
    elseif rpm_switch_pos2_pressed or rpm_switch_pos2_2_pressed then
        new_state = -1  -- Position 2 - RPM Decrease
    else
        new_state = 0  -- OFF (all buttons released)
    end
    
    if rpm_switch_state ~= new_state then
        rpm_switch_state = new_state
        fsx_variable_write("L:GOVERNOR RPM SWITCH", "Number", rpm_switch_state)
        -- Start/stop timer based on switch state
        if rpm_switch_state == 1 or rpm_switch_state == -1 then
            start_rpm_timer()
        else
            stop_rpm_timer()
        end
    end
end
```

### RPM Beep Timer (Continuous while held)
```lua
local function start_rpm_timer()
    rpm_timer = timer_start(0, 100, function()
        if rpm_switch_state == 1 then
            fsx_event("ROTOR_GOV_RPM_INC")
        elseif rpm_switch_state == -1 then
            fsx_event("ROTOR_GOV_RPM_DEC")
        else
            stop_rpm_timer()
        end
    end)
end
```

### L-Var Outputs
| L-Var | Type | Description |
|-------|------|-------------|
| L:GovMode | Number | Governor mode (0=Auto, 1=Manual) |
| L:GOVERNOR RPM SWITCH | Number | RPM Switch state (0=OFF, 1=Increase, -1=Decrease) |
| L:SwGovA | Number | Governor Engine 1 switch (0=OFF, 1=ON) |
| L:SwGovB | Number | Governor Engine 2 switch (0=OFF, 1=ON) |
| L:XmsnPressWarn | Number | XMSN pressure warning flag |
| L:XmsnTempWarn | Number | XMSN temp warning flag |
| L:CboxPressWarn | Number | CBOX pressure warning flag |

### Subscriptions (Sim → Logic)
| Variable | Purpose |
|----------|---------|
| L:MasterDcBus | DC power check |
| L:XmsnOilPress | XMSN oil pressure |
| L:XmsnOilTemp | XMSN oil temperature |
| L:CboxOilPress | CBOX oil pressure |
| L:SwGovA | Governor A switch/warning (CWP LED + Status LED) |
| L:SwGovB | Governor B switch/warning (CWP LED + Status LED) |
| L:XMSN CHIP | Chip detector (CWP LED) |

### Sim Events Fired
| Event | Trigger |
|-------|---------|
| ROTOR_GOV_RPM_INC | RPM Switch in position 1 (continuous) |
| ROTOR_GOV_RPM_DEC | RPM Switch in position 2 (continuous) |
