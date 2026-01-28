# Bell 412 - Electrical System Specification

## Overview
- **File**: `electrical_logic.lua`
- **Hardware**: Arduino Channel A (Overhead Panel)
- **Logic Type**: Buttons Only (Active Low)

## Hardware Pin Assignments

### Inputs (D2-D10)
| Pin | Variable | Function | L-Var |
|-----|----------|----------|-------|
| D2 | PIN_BATT1_SW | Battery 1 | L:Swbatta |
| D3 | PIN_BATT2_SW | Battery 2 | L:Swbattb |
| D4 | PIN_GEN1_SW | Generator 1 | L:Genel + TOGGLE_ALTERNATOR1 |
| D5 | PIN_GEN2_SW | Generator 2 | L:Gener + TOGGLE_ALTERNATOR2 |
| D6 | PIN_INV1_SW | Inverter 1 | L:Swinva + L:ACBus |
| D7 | PIN_INV2_SW | Inverter 2 | L:Swinvb + L:ACBus |
| D8 | PIN_NONESNTL_SW | Non-Essential Bus | L:Swnonbus + L:SwNonEsntl |
| D9 | PIN_EMERGLOAD_SW | Emergency Load | L:Swemerload |
| D10 | PIN_STBYATT_SW | Standby Attitude | L:stbatt |

### Outputs - LEDs (D30-D34)
| Pin | Variable | Function | Condition |
|-----|----------|----------|-----------|
| D30 | PIN_GEN1_FAIL_LED | Gen 1 Fail | gen1_producing == 0 |
| D31 | PIN_GEN2_FAIL_LED | Gen 2 Fail | gen2_producing == 0 |
| D32 | PIN_INV1_FAIL_LED | Inv 1 Fail | sw_inv1 == 0 |
| D33 | PIN_INV2_FAIL_LED | Inv 2 Fail | sw_inv2 == 0 |
| D34 | PIN_BATT_CAUT_LED | Battery Caution | batts ON but no generators/GPU |

## Power Source Hierarchy

**Priority Order**: GPU > Generator > Battery

```lua
local function update_electrical_logic()
    if ext_power_on == 1 then
        bus_volts = 28.0  -- GPU Voltage
        dc_master = 1
        gen_master = 1
    elseif (gen1_producing == 1) or (gen2_producing == 1) then
        bus_volts = 28.0  -- Generator Voltage
        dc_master = 1
        gen_master = 1
    elseif (sw_batt1 == 1) or (sw_batt2 == 1) then
        dc_master = 1
        bus_volts = is_starting and 18.0 or 24.0  -- Battery (load drop during start)
    else
        -- Dead Ship
        bus_volts = 0.0
        dc_master = 0
        gen_master = 0
    end
end
```

## Voltage Constants
| Constant | Value | Description |
|----------|-------|-------------|
| V_GEN | 28.0V | Generator/GPU voltage |
| V_BATT | 24.0V | Normal battery voltage |
| V_LOAD | 18.0V | Battery under cranking load |

## L-Var Outputs
| L-Var | Type | Description |
|-------|------|-------------|
| L:MasterDcBus | Number | DC power available (0/1) |
| L:Genmast | Number | Generator power available (0/1) |
| L:VoltDC_Essential | Volts | Essential bus voltage |
| L:VoltDC_NonEssential | Volts | Non-essential bus voltage |
| L:ACBus | Number | AC power from inverters (0/1) |

## Sim Events Fired
| Switch | ON Event | OFF Event |
|--------|----------|-----------|
| Generator 1 | TOGGLE_ALTERNATOR1 | TOGGLE_ALTERNATOR1 |
| Generator 2 | TOGGLE_ALTERNATOR2 | TOGGLE_ALTERNATOR2 |

## Subscriptions (Sim → Logic)
| Variable | Purpose |
|----------|---------|
| L:CGenel | Generator 1 producing status |
| L:CGener | Generator 2 producing status |
| L:ExternalPower | GPU connected status |
| L:StartSwitch | Start cycle active (voltage drop) |
