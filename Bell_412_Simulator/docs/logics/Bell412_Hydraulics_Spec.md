# Bell 412 - Hydraulics System Specification

## Overview
- **File**: `hydraulics_logic.lua`
- **Hardware**: Arduino Channel B (Pedestal Panel)
- **Logic Type**: Buttons Only (Active Low)

## Hardware Pin Assignments

### Inputs (D40-D43)
| Pin | Variable | Function | L-Var |
|-----|----------|----------|-------|
| D40 | PIN_HYD1_SW | Hydraulic Sys 1 | L:Sw hydsysA |
| D41 | PIN_HYD2_SW | Hydraulic Sys 2 | L:Sw hydsysB |
| D42 | PIN_CYC_CTR_TEST1 | Cyclic Center Test Button 1 | L:Cyctest (Number) |
| D43 | PIN_CYC_CTR_TEST2 | Cyclic Center Test Button 2 | L:Cyctest (Number) |

### Outputs - LEDs (D44-D48)
| Pin | Variable | Function | Condition |
|-----|----------|----------|-----------|
| D44 | PIN_CYC_CTR_TEST1_LED | Cyclic Center Test LED 1 | L:Cyctest == 1 |
| D45 | PIN_CYC_CTR_TEST2_LED | Cyclic Center Test LED 2 | L:Cyctest == 1 |
| D46 | PIN_HYD1_FAIL_LED | Hyd 1 Fail | sw_hyd1 == 0 OR pressure < 600 |
| D47 | PIN_HYD2_FAIL_LED | Hyd 2 Fail | sw_hyd2 == 0 OR pressure < 600 |
| D48 | PIN_CYC_CTR_LED | Cyclic Center | off-center AND rotor RPM < 95% |

## Pressure Calculation

Hydraulic pressure is derived from rotor RPM and switch state:

```lua
local function update_hydraulics_logic()
    if dc_bus == 0 then
        hyd1_pressure = 0.0
        hyd2_pressure = 0.0
    else
        -- Calculate RPM factor (0.0 to 1.0)
        local rpm_factor = 0.0
        if rotor_rpm >= 50.0 then
            rpm_factor = (rotor_rpm - 50.0) / 50.0
            if rpm_factor > 1.0 then rpm_factor = 1.0 end
        end
        
        -- Pressure = Switch ON * RPM Factor * 2800 PSI
        hyd1_pressure = (sw_hyd1 == 1) and (rpm_factor * 2800.0) or 0.0
        hyd2_pressure = (sw_hyd2 == 1) and (rpm_factor * 2800.0) or 0.0
    end
end
```

## Cyclic Center Test (2 Buttons + 2 LEDs)
Both buttons control the same L-Var (`L:Cyctest`), and both LEDs reflect its state:

```lua
-- Button 1 (D42)
hw_button_add(PIN_CYC_CTR_TEST1,
    function() -- PRESSED
        fsx_variable_write("L:Cyctest", "Number", 1)
    end,
    function() -- RELEASED
        fsx_variable_write("L:Cyctest", "Number", 0)
    end
)

-- Button 2 (D43)
hw_button_add(PIN_CYC_CTR_TEST2,
    function() -- PRESSED
        fsx_variable_write("L:Cyctest", "Number", 1)
    end,
    function() -- RELEASED
        fsx_variable_write("L:Cyctest", "Number", 0)
    end
)

-- Both LEDs subscribe to L:Cyctest
fsx_variable_subscribe("L:Cyctest", "Number", function(val)
    local led_value = (val == 1) and 1.0 or 0.0
    hw_led_set(led_cyc_ctr_test1_h, led_value)
    hw_led_set(led_cyc_ctr_test2_h, led_value)
end)
```

## Cyclic Centering Warning LED Logic

The warning LED (D48) illuminates when:
1. Cyclic stick is off-center (>5% deflection in X or Y)
2. AND Rotor RPM is below 95%

```lua
local function update_cyc_ctr_led()
    local abs_x = math.abs(yoke_x_pos)
    local abs_y = math.abs(yoke_y_pos)
    local off_center = (abs_x > 5.0) or (abs_y > 5.0)
    local low_rpm = (rotor_rpm_pct < 95.0)
    
    hw_led_set(led_cyc_ctr_h, (off_center and low_rpm) and 1.0 or 0.0)
end
```

## Constants
| Constant | Value | Description |
|----------|-------|-------------|
| HYD_PRESS_NOMINAL | 2800.0 PSI | Full system pressure |
| HYD_PRESS_MIN | 600.0 PSI | Minimum safe pressure |
| HYD_ROTOR_MIN_RPM | 50.0% | Min RPM for pressure buildup |
| CYC_CTR_THRESHOLD | 5.0% | Stick deflection threshold |

## L-Var Outputs
| L-Var | Type | Description |
|-------|------|-------------|
| L:HydPressure1 | Number | Hydraulic pressure PSI (0-2800) |
| L:HydPressure2 | Number | Hydraulic pressure PSI (0-2800) |
| L:Sw hydsysA | Number | Hyd system 1 switch state |
| L:Sw hydsysB | Number | Hyd system 2 switch state |
| L:Cyctest | Number | Cyclic centering test active (0/1) |

## Subscriptions (Sim → Logic)
| Variable | Purpose |
|----------|---------|
| L:MasterDcBus | DC power check |
| A:Eng Rotor Rpm | Rotor RPM for pressure calc |
| A:YOKE X POSITION | Cyclic X position |
| A:YOKE Y POSITION | Cyclic Y position |
| ROTOR RPM PCT:1 | Rotor RPM for centering LED |
