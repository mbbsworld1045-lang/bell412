# Bell 412 Startup Validation Test Procedures

## Overview
This document provides step-by-step test procedures to validate hardware functionality before and during flight operations.

---

## Pre-Test Hardware Checklist

### Arduino Connections
- [ ] Arduino Mega A (Overhead) powered and connected
- [ ] Arduino Mega B (Pedestal) powered and connected
- [ ] Arduino Mega C (Main/Collective) powered and connected
- [ ] Air Manager connected to simulator

### Visual Inspection
- [ ] All LEDs respond to power-on self-test
- [ ] No loose wires or connections
- [ ] USB connections stable

---

## 1. Electrical System Validation (Mega A)

### Battery Switches (D2, D3)
1. **Battery 1 ON**: Flip switch → LED response expected (if applicable)
   - Console: `ACTION: Battery 1 ON`
   - L:Swbatta = 1
2. **Battery 2 ON**: Similar to Battery 1
   - Console: `ACTION: Battery 2 ON`
   - L:Swbattb = 1

### Generator Switches (D4, D5)
1. **Gen 1 ON**: Flip switch
   - Console: `ACTION: Gen 1 ON`
   - Event: TOGGLE_ALTERNATOR1 fired
   - LED: Gen 1 Fail LED (D30) should turn OFF when producing

### Inverter Switches (D6, D7)
1. **Inv 1 ON**: Flip switch
   - Console: `ACTION: Inv 1 ON`
   - LED: Inv 1 Fail LED (D32) turns OFF
   - L:ACBus = 1

### Standby Attitude (D10)
1. **Stby Att ON**: Flip switch
   - Console: `ACTION: Stby Att ON`
   - L:stbatt = 1

---

## 2. Fire System Validation (Mega A)

### Fire Handle 1 (D24)
1. **Pull Handle**: 
   - Console: `ACTION: Fire Handle 1 PULLED`
   - L:firethandl = true
   - LED: Fire Eng 1 LED (D35) illuminates
2. **Release Handle**:
   - Console: `ACTION: Fire Handle 1 RESET`
   - LED extinguishes

### Fire Handle 2 (D25)
1. Similar to Handle 1 with L:firethandr and D36

### Fire Test (D26)
1. **Press and Hold**:
   - Console: `ACTION: Fire Test PRESSED`
   - L:Swfiretest = true
   - **All 3 Fire LEDs (D35, D36, D37) illuminate**
2. **Release**:
   - LEDs return to normal state

---

## 3. Fuel System Validation (Mega B)

### Transfer Switches (D2, D3)
1. **Trans 1 ON**:
   - Console: `ACTION: Fuel Trans 1 ON`
   - LED: Trans 1 Warn (D30) turns OFF
2. **Trans 1 OFF**:
   - LED: Trans 1 Warn (D30) turns ON (warning)

### Boost Pumps (D4, D5)
1. **Boost 1 ON**:
   - Console: `ACTION: Boost Pump 1 ON`
   - L:FuelPressure1 = 25.0 (when DC bus on)

### Fuel Valves (D8, D9)
1. **Valve 1 OPEN**:
   - Console: `ACTION: Fuel Valve 1 OPEN`
   - LED: Valve 1 Transit (D36) flashes during 2s transit
   - L:FuelValve1Pos transitions 0.0 → 1.0

---

## 4. Hydraulics System Validation (Mega B)

### Hydraulic Switches (D40, D41)
1. **Hyd 1 ON**:
   - Console: `ACTION: Hyd Sys 1 ON`
   - LED: Hyd 1 Fail (D46) turns OFF when pressure > 600

### Cyclic Centering Test (D42)
1. **Press Test**:
   - Console: `ACTION: Cyclic Center Test PRESSED`
   - L:Cyctest = 1

---

## 5. Startup System Validation (Mega C)

### Engine Start Switch (3-Position: D2, D3)
1. **Position 1 (D2) - Engine 1 PRESS** (with prerequisites met):
   - Console: `ACTION: Start Engine Switch -> Position 1 (State = 1, Engine 1)`
   - LED: Start Active (D30) illuminates
   - L:starteng = 1
2. **Position 2 (D3) - Engine 2 PRESS**:
   - Console: `ACTION: Start Engine Switch -> Position 2 (State = -1, Engine 2)`
   - LED: Start Active (D30) illuminates
   - L:starteng = -1
3. **Both Released**:
   - LED extinguishes
   - L:starteng = 0

### Idle Stop Switch (3-Position: D4, D7)
1. **Position 1 (D4) - Engine 1 PRESS**:
   - Console: `ACTION: Idle Stop Switch -> Position 1 (State = 1, Engine 1 Idle Stop Release)`
   - L:idle eng = 1
   - L:FuelcutE1 = 1, L:FuelcutE2 = 0
   - Throttle 1 can go to full cutoff (0.0), Throttle 2 clamped to idle
2. **Position 2 (D7) - Engine 2 PRESS**:
   - Console: `ACTION: Idle Stop Switch -> Position 2 (State = -1, Engine 2 Idle Stop Release)`
   - L:idle eng = -1
   - L:FuelcutE1 = 0, L:FuelcutE2 = 1
   - Throttle 2 can go to full cutoff (0.0), Throttle 1 clamped to idle
3. **Both Released**:
   - L:idle eng = 0
   - Both throttles clamped to idle (>= 0.12)
   - L:IdleStopRel = 1
   - Throttle can now move below 12%
2. **Release**:
   - Console: `ACTION: Idle Stop Release RELEASED - Clamp Engaged`
   - Throttle clamped to minimum 12%

### Throttles (A0, A1)
1. **Move Throttle 1**:
   - Value 0.0-1.0 based on position
   - With Idle Stop engaged: minimum 0.12
   - With Idle Stop released: full 0.0-1.0

### Rotor Brake (D24)
1. **Brake ON**:
   - Console: `ACTION: Rotor Brake ON`
   - If RPM > 40%: `WARNING: ROTOR BRAKE APPLIED ABOVE 40% RPM!`
   - LED: Rotor Brake LED (D31) illuminates

---

## 6. CWP Validation (Mega C)

### Test Panel (D10)
1. **Press and Hold**:
   - Console: `ACTION: MC Test PNL PRESSED`
   - LED: Master Caution (D40) illuminates
   - L:TestMC = 1

### CWP Warning LEDs (D41-D43)
1. **Governor A Warning**:
   - When L:SwGovA = true → LED (D41) illuminates
2. **Governor B Warning**:
   - When L:SwGovB = true → LED (D42) illuminates
3. **Chip Detector**:
   - When L:XMSN CHIP = true → LED (D43) illuminates

---

## 7. XMSN/Governor Validation (Mega C)

### Governor Mode (D20)
1. **Switch to Manual**:
   - Console: `ACTION: Gov Mode -> MANUAL`
   - LED: Gov Manual (D50) illuminates
   - L:GovMode = 1

### RPM Inc/Dec (D21, D22)
1. **Hold RPM Inc**:
   - Console: `ACTION: RPM Inc PRESSED`
   - Event: ROTOR_GOV_RPM_INC (repeats every 100ms)

---

## 8. Ancillary Systems Validation (Mega A + B)

### Force Trim (B-D20)
1. **Press and Hold**:
   - Console: `ACTION: Force Trim RELEASE PRESSED`
   - Event: ROTOR_TRIM_RESET fired
   - L:Sw forcetrim = 1
2. **Release**:
   - Console: `ACTION: Force Trim RELEASE - Re-engaged at new position`

### AFCS Toggle Buttons (B-D23 to D26)
1. **Press AFCS HP1**:
   - Console: `ACTION: AFCS HP1 -> 1` (toggles)
   - L:HP1 = 1

### Standby Attitude Test (B-D27)
1. **Press and Hold > 2s**:
   - L:StbyAttFlag = 0 during test
   - After 2s timer: L:StbyAttFlag = 1

---

## Validation Complete Checklist

### All Systems GO
- [ ] Electrical: Batteries, Generators, Inverters functional
- [ ] Fire: Handles, Test, and all 3 Fire LEDs (D35-D37) working
- [ ] Fuel: Transfers, Boost Pumps, Valve Transit LEDs working
- [ ] Hydraulics: Pressure calculation, Cyclic Centering LED working
- [ ] Startup: Engine Start, Idle Stop clamp, Rotor Brake warning working
- [ ] CWP: Master Caution LED, Gov A/B/Chip LEDs (D41-D43) working
- [ ] XMSN/Governor: Mode switch, RPM beeper, Warning LEDs working
- [ ] Ancillary: Force Trim, AFCS toggles, Standby Att test working
