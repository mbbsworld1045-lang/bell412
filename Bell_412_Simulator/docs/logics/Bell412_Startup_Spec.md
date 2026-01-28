# Bell 412 - Engine Startup Specification

## Overview
- **File**: `startup.lua`
- **Hardware**: Arduino Channel C (Main Panel / Collective)
- **Logic Type**: Buttons Only (Active Low) + ADC Throttles

## Hardware Pin Assignments

### Inputs - Buttons (D2-D7, D24)
| Pin | Variable | Function | L-Var/Event |
|-----|----------|----------|-------------|
| D2 | PIN_START_ENG_POS1 | Start Engine Pos1 (Eng1) | L:starteng (1) |
| D3 | PIN_START_ENG_POS2 | Start Engine Pos2 (Eng2) | L:starteng (-1) |
| D4 | PIN_IDLE_STOP_POS1 | Idle Stop Pos1 (Eng1) | L:idle eng (1), L:IdleStopRel, L:FuelcutE1/E2 |
| D7 | PIN_IDLE_STOP_POS2 | Idle Stop Pos2 (Eng2) | L:idle eng (-1), L:IdleStopRel, L:FuelcutE1/E2 |
| D5 | PIN_PARTSEP1 | Particle Sep 1 | L:SwpartsepA |
| D6 | PIN_PARTSEP2 | Particle Sep 2 | L:SwpartsepB |
| D24 | PIN_ROTOR_BRAKE_SW | Rotor Brake | ROTOR_BRAKE event |

### Inputs - Analog (A0-A1)
| Pin | Variable | Function | L-Var |
|-----|----------|----------|-------|
| A0 | PIN_THROTTLE1 | Throttle 1 | L:throgas1 + GENERAL ENG THROTTLE LEVER POSITION:1 |
| A1 | PIN_THROTTLE2 | Throttle 2 | L:throgas2 + GENERAL ENG THROTTLE LEVER POSITION:2 |

### Outputs - LEDs (D30-D31, D34-D35)
| Pin | Variable | Function | Condition |
|-----|----------|----------|-----------|
| D30 | PIN_START_LED | Start Active | start_eng_state != 0 |
| D31 | PIN_ROTOR_BRAKE_LED | Rotor Brake | A:Rotor Brake Active == true |
| D34 | PIN_PARTSEP1_LED | Particle Sep 1 Status | sw_partsep1 == 1 |
| D35 | PIN_PARTSEP2_LED | Particle Sep 2 Status | sw_partsep2 == 1 |

## Idle Stop Logic

**Per Flight Manual**: *"Rotate throttle full open, then back against idle stop. Actuate IDLE STOP release, roll throttle to full closed."*

### Constants
```lua
local IDLE_DETENT_MIN = 0.12    -- 12% throttle position (idle stop detent)
local ROTOR_BRAKE_MAX_RPM = 40.0  -- Maximum safe RPM for rotor brake application
```

### Clamp Function
```lua
local function clamp_throttle(raw_value)
    if idle_stop_released then
        return raw_value  -- Full range (0.0 to 1.0) for engine cutoff
    else
        return math.max(raw_value, IDLE_DETENT_MIN)  -- Clamp minimum to idle
    end
end
```

### Idle Stop Switch (3-Position: 0=OFF, 1=Eng1, -1=Eng2)
The idle stop switch is now a 3-position switch that controls per-engine idle stops:

```lua
-- Position 1 Button (D4 -> State = 1, Engine 1)
hw_button_add(PIN_IDLE_STOP_POS1,
    function() -- PRESSED (Eng1)
        idle_stop_pos1_pressed = true
        update_idle_stop_state()
    end,
    function() -- RELEASED
        idle_stop_pos1_pressed = false
        update_idle_stop_state()
    end
)

-- Position 2 Button (D7 -> State = -1, Engine 2)
hw_button_add(PIN_IDLE_STOP_POS2,
    function() -- PRESSED (Eng2)
        idle_stop_pos2_pressed = true
        update_idle_stop_state()
    end,
    function() -- RELEASED
        idle_stop_pos2_pressed = false
        update_idle_stop_state()
    end
)

local function update_idle_stop_state()
    local new_state = 0
    if idle_stop_pos1_pressed then
        new_state = 1  -- Engine 1
    elseif idle_stop_pos2_pressed then
        new_state = -1  -- Engine 2
    else
        new_state = 0  -- OFF
    end
    
    if idle_stop_state ~= new_state then
        idle_stop_state = new_state
        fsx_variable_write("L:idle eng", "Number", idle_stop_state)
        -- Update per-engine fuel cut and idle stop release
        if idle_stop_state == 1 then
            fsx_variable_write("L:IdleStopRel", "Number", 1)
            fsx_variable_write("L:FuelcutE1", "Number", 1)
            fsx_variable_write("L:FuelcutE2", "Number", 0)
        elseif idle_stop_state == -1 then
            fsx_variable_write("L:IdleStopRel", "Number", 1)
            fsx_variable_write("L:FuelcutE1", "Number", 0)
            fsx_variable_write("L:FuelcutE2", "Number", 1)
        else
            fsx_variable_write("L:IdleStopRel", "Number", 0)
            fsx_variable_write("L:FuelcutE1", "Number", 0)
            fsx_variable_write("L:FuelcutE2", "Number", 0)
        end
    end
end
```

The throttle clamp function is now per-engine:
```lua
local function clamp_throttle(raw_value, engine_num)
    if idle_stop_state == 1 and engine_num == 1 then
        -- Eng1 idle stop active: clamp to idle
        return math.max(raw_value, IDLE_DETENT_MIN)
    elseif idle_stop_state == -1 and engine_num == 2 then
        -- Eng2 idle stop active: clamp to idle
        return math.max(raw_value, IDLE_DETENT_MIN)
    else
        -- Idle stop released or not active for this engine: full range
        return raw_value
    end
end
```

## Rotor Brake Safety Logic

**Per Flight Manual**: *"Apply at or below 40% ROTOR RPM."*

```lua
hw_button_add(PIN_ROTOR_BRAKE_SW,
    function() -- PRESSED (Brake ON)
        print("ACTION: Rotor Brake ON")
        
        -- Safety Check: Warn if applied above 40% RPM
        if rotor_rpm_pct > ROTOR_BRAKE_MAX_RPM then
            print("WARNING: ROTOR BRAKE APPLIED ABOVE 40% RPM! (Current: " .. 
                  string.format("%.1f", rotor_rpm_pct) .. "%)")
        end
        
        -- Execute brake regardless (log pilot error, don't block)
        fsx_event("ROTOR_BRAKE", 100)
    end,
    function() -- RELEASED (Brake OFF)
        fsx_event("ROTOR_BRAKE", 0)
    end
)
```

## Engine Start Permission Flags

### L:Eng1StartFlag = 1 when ALL true:
- Battery 1 OR Battery 2 = ON
- Fuel Transfer 1 = ON
- Fuel Pressure 1 > 4.0 PSI
- Fuel Valve 1 >= 0.99 (fully open)
- start_eng_state == 1 (Engine 1 selected)
- Rotor Brake = OFF

### L:Eng2StartFlag = 1 when ALL true:
- Battery 1 OR Battery 2 = ON
- Fuel Transfer 2 = ON
- Fuel Pressure 2 > 4.0 PSI
- Fuel Valve 2 >= 0.99 (fully open)
- start_eng_state == -1 (Engine 2 selected)
- Rotor Brake = OFF

## L-Var Outputs
| L-Var | Type | Values | Description |
|-------|------|--------|-------------|
| L:starteng | Number | 0, 1, -1 | Start Engine Switch (0=OFF, 1=Eng1, -1=Eng2) |
| L:idle eng | Number | 0, 1, -1 | Idle Stop Switch (0=OFF, 1=Eng1, -1=Eng2) |
| L:IdleStopRel | Number | 0, 1 | Legacy compatibility (1 if either engine selected) |
| L:FuelcutE1 | Number | 0, 1 | Engine 1 fuel cut (1 when idle stop released for Eng1) |
| L:FuelcutE2 | Number | 0, 1 | Engine 2 fuel cut (1 when idle stop released for Eng2) |

## Subscriptions (Sim → Logic)
| Variable | Purpose |
|----------|---------|
| L:FuelPressure1/2 | Fuel pressure check |
| L:FuelValve1Pos/2Pos | Valve position check |
| L:SwfueltransengA/B | Fuel transfer switch state |
| L:Swbatta/Swbattb | Battery switch state |
| ROTOR RPM PCT:1 | Rotor RPM for brake warning |
| A:ROTOR BRAKE HANDLE POS | Brake position for start interlock |
| A:Rotor Brake Active | LED control |
