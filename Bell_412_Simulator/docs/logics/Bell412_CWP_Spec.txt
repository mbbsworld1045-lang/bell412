# Bell 412 - Central Warning Panel (CWP) Specification

## Overview
- **File**: `cwp_master_caution.lua`
- **Hardware**: Arduino Channel C (Main Panel)
- **Logic Type**: Buttons Only (Active Low)

## Hardware Pin Assignments

### Inputs (D10-D13)
| Pin | Variable | Function | L-Var |
|-----|----------|----------|-------|
| D10 | PIN_TEST_PNL_POS1 | Test Panel Pos1 | L:TestMC (1) |
| D11 | PIN_TEST_LT | Test Lights | L:TestMC (2) |
| D12 | PIN_RESET | MC Reset | L:ResetMC |
| D13 | PIN_TEST_PNL_POS2 | Test Panel Pos2 | L:TestMC (-1) |

### Outputs - LEDs (D40-D43)
| Pin | Variable | Function | File | Condition |
|-----|----------|----------|------|-----------|
| D40 | PIN_MC_LED | Master Caution | cwp_master_caution.lua | any_caution == true |
| D41 | PIN_GOV_A_WARN_LED | Governor A | xmsn_governor_logic.lua | L:SwGovA == true |
| D42 | PIN_GOV_B_WARN_LED | Governor B | xmsn_governor_logic.lua | L:SwGovB == true |
| D43 | PIN_CHIP_DET_LED | Chip Detector | xmsn_governor_logic.lua | L:XMSN CHIP == true |

**Note**: CWP warning LEDs (D41-D43) are physically connected in `xmsn_governor_logic.lua` for code organization, but logically part of the CWP system.

## Master Caution Conditions

**LED ON when ANY of the following are TRUE:**

### Battery/Generator Warnings
- Batteries ON but no generators or GPU (`genmast == 0`)
- Generator 1 not producing (`gen1_producing == 0`)
- Generator 2 not producing (`gen2_producing == 0`)

### Hydraulic Warnings
- Hydraulic 1 switch OFF OR pressure < 600 PSI
- Hydraulic 2 switch OFF OR pressure < 600 PSI

### Engine Oil Warnings
- Engine 1 oil pressure < 50 PSI
- Engine 2 oil pressure < 50 PSI

### Rotor Warnings
- Rotor RPM <= 95% OR >= 105%
- Rotor brake active

### Fuel Warnings
- Center tank level < 9.2%
- Fuel valve 1 in transit OR position mismatch
- Fuel valve 2 in transit OR position mismatch

### Fire Warnings
- Fire handle 1 pulled (`L:firethandl == 1`) (Number type)
- Fire handle 2 pulled (`L:firethandr == 1`) (Number type)
- Fire test active (`L:Swfiretest == true`)

### XMSN/CBOX Warnings
- XMSN pressure warning (`L:XmsnPressWarn == 1`)
- XMSN temperature warning (`L:XmsnTempWarn == 1`)
- CBOX pressure warning (`L:CboxPressWarn == 1`)

### Governor Warnings
- Governor A warning (`L:SwGovA == 1`) (Number type)
- Governor B warning (`L:SwGovB == 1`) (Number type)
- XMSN chip detected (`L:XMSN CHIP == true`)

### Inverter Warnings
- Inverter 1 OFF (`L:Swinva == 0`)
- Inverter 2 OFF (`L:Swinvb == 0`)

## Test Switch Logic

### Test Panel Switch (3-Position: 0=OFF, 1=Position 1, -1=Position 2)
The test panel switch has **priority** over the TEST_LT button (D11).

```lua
-- Position 1 Button (D10 -> State = 1)
hw_button_add(PIN_TEST_PNL_POS1,
    function() -- PRESSED (Position 1)
        test_pnl_pos1_pressed = true
        update_test_panel_state()
    end,
    function() -- RELEASED
        test_pnl_pos1_pressed = false
        update_test_panel_state()
    end
)

-- Position 2 Button (D13 -> State = -1)
hw_button_add(PIN_TEST_PNL_POS2,
    function() -- PRESSED (Position 2)
        test_pnl_pos2_pressed = true
        update_test_panel_state()
    end,
    function() -- RELEASED
        test_pnl_pos2_pressed = false
        update_test_panel_state()
    end
)
```

### Test Lights Button (D11)
The TEST_LT button only operates when the test panel switch is OFF (priority logic).

| Mode | TestMC Value | LED State | Priority |
|------|--------------|-----------|----------|
| Test Panel Pos1 | 1 | ON | Highest |
| Test Panel Pos2 | -1 | ON | Highest |
| Lights Test Held | 2 | ON | Lower (only if panel OFF) |
| Neither | 0 | Normal Logic | - |

## Fuel Valve Warning Function
```lua
local function fuel_valve_warning()
    local v1_transit = (pos > 0.01) and (pos < 0.99)
    local v1_mismatch = (cmd == 1 and pos < 0.99) or
                        (cmd == 0 and pos > 0.01)
    return (transit OR mismatch) and 1 or 0
end
```

## Subscriptions (Sim → Logic)
| Variable | Purpose |
|----------|---------|
| L:MasterDcBus | DC power check |
| L:Swbatta, L:Swbattb | Battery states |
| L:CGenel, L:CGener | Generator status |
| L:Genmast | Generator master |
| L:HydPressure1/2 | Hydraulic pressure |
| L:Sw hydsysA/B | Hydraulic switches |
| L:OILE1/2 | Engine oil pressure |
| ROTOR RPM PCT:1 | Rotor RPM |
| FUEL TANK CENTER LEVEL | Fuel level |
| A:Rotor Brake Active | Brake status |
| L:firethandl/r | Fire handles |
| L:Swfiretest | Fire test |
| L:XmsnPressWarn/TempWarn | XMSN warnings |
| L:CboxPressWarn | CBOX warning |
| L:SwGovA/B | Governor warnings (Number 0/1) |
| L:XMSN CHIP | Chip detector |
| L:Swinva/b | Inverter switches |
| L:FuelValve1/2Pos | Valve positions |
| L:SwvalveEng1/2 | Valve commands |
