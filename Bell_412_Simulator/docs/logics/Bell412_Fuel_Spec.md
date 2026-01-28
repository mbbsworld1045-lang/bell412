# Bell 412 - Fuel System Specification

## Overview
- **File**: `fuel_logic.lua`
- **Hardware**: Arduino Channel B (Pedestal Panel)
- **Logic Type**: Buttons Only (Active Low)

## Hardware Pin Assignments

### Inputs (D2-D14)
| Pin | Variable | Function | L-Var |
|-----|----------|----------|-------|
| D2 | PIN_FUEL_TRANS1 | Fuel Transfer 1 | L:SwfueltransengA |
| D3 | PIN_FUEL_TRANS2 | Fuel Transfer 2 | L:SwfueltransengB |
| D4 | PIN_BOOST1 | Boost Pump 1 | L:SwboostpuEng1 |
| D5 | PIN_BOOST2 | Boost Pump 2 | L:SwboostpuEng2 |
| D6 | PIN_INTCON | Fuel Interconnect | L:Swfuelintcon |
| D7 | PIN_XFEED | Fuel Crossfeed | L:SwFuelxfeed |
| D8 | PIN_VALVE1 | Fuel Valve 1 | L:SwvalveEng1 + L:MvalveEng1 |
| D9 | PIN_VALVE2 | Fuel Valve 2 | L:SwvalveEng2 + L:MvalveEng2 |
| D10 | PIN_FUEL_QUANTITY_POS2 | Fuel Quantity Pos2 | L:FuelQuantity (-1) |
| D11 | PIN_FUEL_DIGIT_TEST | Fuel Digit Test | L:Digitstest (Number) |
| D12 | PIN_FUEL_QUANTITY_POS1 | Fuel Quantity Pos1 | L:FuelQuantity (1) |
| D13 | PIN_XFEED_INTCON_POS1 | XFEED/INTCON Pos1 | L:Swxfeedbus (1) |
| D14 | PIN_XFEED_INTCON_POS2 | XFEED/INTCON Pos2 | L:Swxfeedbus (2, priority) |

### Outputs - LEDs (D30-D37)
| Pin | Variable | Function | Condition |
|-----|----------|----------|-----------|
| D30 | PIN_TRANS1_LED | Trans 1 Warn | sw_trans1 == 0 |
| D31 | PIN_TRANS2_LED | Trans 2 Warn | sw_trans2 == 0 |
| D32 | PIN_BOOST1_LED | Boost 1 Warn | sw_boost1 == 0 |
| D33 | PIN_BOOST2_LED | Boost 2 Warn | sw_boost2 == 0 |
| D34 | PIN_INTCON_LED | Intcon Active | sw_intcon == 1 |
| D35 | PIN_XFEED_LED | Xfeed Active | sw_xfeed == 1 |
| D36 | PIN_VALVE1_TRANS_LED | Valve 1 Transit | Flashes during valve motion |
| D37 | PIN_VALVE2_TRANS_LED | Valve 2 Transit | Flashes during valve motion |
| D38 | PIN_XFEED_LVAR_LED | Xfeed L-Var Status | L:SwFuelxfeed state |

## Valve Transit Physics

**Transit Time**: 2.0 seconds from open to close (or vice versa)

```lua
local FUEL_VALVE_TIME_S = 2.0

local function update_valves_tick()
    local t = os.clock()
    
    if valve1_moving then
        local u = clamp((t - valve1_t0) / FUEL_VALVE_TIME_S, 0.0, 1.0)
        valve1_pos = valve1_start + (valve1_target - valve1_start) * u
        fsx_variable_write("L:FuelValve1Pos", "Number", valve1_pos)
        if u >= 1.0 then valve1_moving = false end
    end
end
```

## Fuel Pressure Calculation

```lua
local function update_fuel_pressure()
    if dc_bus == 1 then
        local p1_raw = (sw_boost1 == 1) and 25.0 or 0.0
        local p2_raw = (sw_boost2 == 1) and 25.0 or 0.0
        
        if sw_xfeed == 1 then
            -- Crossfeed equalizes pressure
            local p_max = math.max(p1_raw, p2_raw)
            p1 = p_max
            p2 = p_max
        else
            p1 = p1_raw
            p2 = p2_raw
        end
    end
    
    fsx_variable_write("L:FuelPressure1", "Number", p1)
    fsx_variable_write("L:FuelPressure2", "Number", p2)
end
```

## Constants
| Constant | Value | Description |
|----------|-------|-------------|
| FUEL_PRESS_NOMINAL | 25.0 PSI | Normal boost pump pressure |
| FUEL_VALVE_TIME_S | 2.0 sec | Valve transit time |
| UPDATE_DT_MS | 50 ms | Valve position update rate |
| FLASH_RATE_MS | 250 ms | Transit LED flash rate |

## Fuel XFEED/INTCON Switch (3-Position: 0=Norm, 1=Test Bus 1, 2=Test Bus 2)
```lua
-- Position 1 Button (D13 -> State = 1, Test Bus 1)
hw_button_add(PIN_XFEED_INTCON_POS1,
    function() -- PRESSED (Test Bus 1)
        xfeed_intcon_pos1_pressed = true
        update_xfeed_intcon_state()
    end,
    function() -- RELEASED
        xfeed_intcon_pos1_pressed = false
        update_xfeed_intcon_state()
    end
)

-- Position 2 Button (D14 -> State = 2, Test Bus 2, has priority)
hw_button_add(PIN_XFEED_INTCON_POS2,
    function() -- PRESSED (Test Bus 2)
        xfeed_intcon_pos2_pressed = true
        update_xfeed_intcon_state()
    end,
    function() -- RELEASED
        xfeed_intcon_pos2_pressed = false
        update_xfeed_intcon_state()
    end
)
```

## L-Var Outputs
| L-Var | Type | Description |
|-------|------|-------------|
| L:FuelPressure1 | Number | Fuel pressure PSI (0-25) |
| L:FuelPressure2 | Number | Fuel pressure PSI (0-25) |
| L:FuelValve1Pos | Number | Valve position (0.0-1.0) |
| L:FuelValve2Pos | Number | Valve position (0.0-1.0) |
| L:FuelQuantity | Number | 3-position switch (0=OFF, 1=Position 1, -1=Position 2) |
| L:Digitstest | Number | Digit display test (0/1) |
| L:Swxfeedbus | Number | XFEED/INTCON switch (0=Norm, 1=Test Bus 1, 2=Test Bus 2) |

## Fuel Quantity Switch (3-Position: 0=OFF, 1=Position 1, -1=Position 2)
```lua
-- Position 1 Button (D12 -> State = 1)
hw_button_add(PIN_FUEL_QUANTITY_POS1,
    function() -- PRESSED (Position 1)
        fuel_quantity_pos1_pressed = true
        update_fuel_quantity_state()
    end,
    function() -- RELEASED
        fuel_quantity_pos1_pressed = false
        update_fuel_quantity_state()
    end
)

-- Position 2 Button (D10 -> State = -1)
hw_button_add(PIN_FUEL_QUANTITY_POS2,
    function() -- PRESSED (Position 2)
        fuel_quantity_pos2_pressed = true
        update_fuel_quantity_state()
    end,
    function() -- RELEASED
        fuel_quantity_pos2_pressed = false
        update_fuel_quantity_state()
    end
)
```

## Subscriptions (Sim → Logic)
| Variable | Purpose |
|----------|---------|
| L:MasterDcBus | DC power for valve/pump operation |
| L:SwFuelxfeed | Crossfeed switch state (for LED feedback) |
