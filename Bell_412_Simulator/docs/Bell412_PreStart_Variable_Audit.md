# Bell 412 Pre-Start Variable Audit

## Overview
This document lists all L-Var states expected before engine start and the hardware controls that set them.

---

## Electrical System (electrical_logic.lua)

| L-Var | Pre-Start State | Set By |
|-------|-----------------|--------|
| L:Swbatta | 1 (ON) | PIN_BATT1_SW (D2) |
| L:Swbattb | 1 (ON) | PIN_BATT2_SW (D3) |
| L:Genel | 0 (OFF initially) | PIN_GEN1_SW (D4) |
| L:Gener | 0 (OFF initially) | PIN_GEN2_SW (D5) |
| L:Swinva | 0 or 1 | PIN_INV1_SW (D6) |
| L:Swinvb | 0 or 1 | PIN_INV2_SW (D7) |
| L:MasterDcBus | 1 (computed) | Auto from batt/gen state |

---

## Fuel System (fuel_logic.lua)

| L-Var | Pre-Start State | Set By |
|-------|-----------------|--------|
| L:SwfueltransengA | 1 (ON) | PIN_FUEL_TRANS1 (D2) |
| L:SwfueltransengB | 1 (ON) | PIN_FUEL_TRANS2 (D3) |
| L:SwboostpuEng1 | 1 (ON) | PIN_BOOST1 (D4) |
| L:SwboostpuEng2 | 1 (ON) | PIN_BOOST2 (D5) |
| L:SwvalveEng1 | 1 (OPEN) | PIN_VALVE1 (D8) |
| L:SwvalveEng2 | 1 (OPEN) | PIN_VALVE2 (D9) |
| L:FuelPressure1 | > 4.0 PSI | Computed from boost pump |
| L:FuelPressure2 | > 4.0 PSI | Computed from boost pump |
| L:FuelValve1Pos | >= 0.99 | Valve transit complete |
| L:FuelValve2Pos | >= 0.99 | Valve transit complete |
| L:FuelQuantity | 0 (Norm) | Default / PIN_FUEL_SYS_TEST |
| L:Digitstest | 0 | Default / PIN_FUEL_DIGIT_TEST |

---

## Hydraulics System (hydraulics_logic.lua)

| L-Var | Pre-Start State | Set By |
|-------|-----------------|--------|
| L:Sw hydsysA | 0 (OFF before start) | PIN_HYD1_SW (D40) |
| L:Sw hydsysB | 0 (OFF before start) | PIN_HYD2_SW (D41) |
| L:Cyctest | 0 | Default / PIN_CYC_CTR_TEST |

---

## Startup System (startup.lua)

| L-Var | Pre-Start State | Set By |
|-------|-----------------|--------|
| L:SwpartsepA | 1 (ON recommended) | PIN_PARTSEP1 (D5) |
| L:SwpartsepB | 1 (ON recommended) | PIN_PARTSEP2 (D6) |
| L:IdleStopRel | 0 | Default |
| L:throgas1 | >= 0.12 (Idle clamp) | PIN_THROTTLE1 (A0) |
| L:throgas2 | >= 0.12 (Idle clamp) | PIN_THROTTLE2 (A1) |
| L:starteng | 0 (OFF) | Default (3-position: 0=OFF, 1=Eng1, -1=Eng2) |
| L:idle eng | 0 (OFF) | Default (3-position: 0=OFF, 1=Eng1, -1=Eng2) |
| L:StartSwitch | 0 | Default |
| L:Eng1StartFlag | 0 -> 1 when ready | Computed |
| L:Eng2StartFlag | 0 -> 1 when ready | Computed |
| Rotor Brake | OFF | PIN_ROTOR_BRAKE_SW (D24) |

---

## Ancillary System (systems_ancillary.lua)

| L-Var | Pre-Start State | Set By |
|-------|-----------------|--------|
| L:firethandl | 0 (Reset) | PIN_FIRE_PULL1 (D24) (Number 0/1) |
| L:firethandr | 0 (Reset) | PIN_FIRE_PULL2 (D25) (Number 0/1) |
| L:Swfiretest | false | Default / PIN_FIRE_TEST (D26) |
| L:CompassControl | 0 (Slave) | Default / PIN_COMPASS_SLAVE (D27) |
| L:StbyAttFlag | 1 or 0 | Depends on L:stbatt |
| L:Masterstbatt | 0 | Default |
| L:Sw forcetrim | 0 | Default |
| L:FireWarn1 | 0 | Sim fire detection |
| L:FireWarn2 | 0 | Sim fire detection |
| L:BagFire | 0 | Sim fire detection |
| L:SwBambiRelease | 0 | Default / PIN_BAMBI_REL (D39) or PIN_BAMBI_REL2 (D50) |
| L:platepilolight | 0 | Default / PIN_PLATE_MAPLIGHT (A0 analog) or PIN_PLATE_MAPLIGHT_BTN (D11) |
| L:SwBrgPtr | 0 (Pilot) | Default / PIN_BRG_PTR (D15) or PIN_BRG_PTR2 (D57) |
| L:SwCourseset | 0 (Nav1) | Default / PIN_COURSE_SET (D14) |
| L:Overtq | 0 | Default / PIN_OVERTQ_TEST (D16) or PIN_OVERTQ_TEST2 (D47) |
| L:AFTcall | 0 | Default / PIN_AFT_CALL (D17) or PIN_AFT_CALL2 (D48) |
| L:Testaft | 0 | Default / PIN_AFT_TEST (D18) or PIN_AFT_TEST2 (D49) |
| L:Swdme | 0 (OFF) | Default / PIN_DME_SEL_POS1 (D19) or PIN_DME_SEL_POS2 (D28) |
| L:TestMarker | 0 | Default / PIN_MARKER_TEST (D26) or PIN_MARKER_TEST2 (D58) |
| L:Dafcssel | 0 | Default / PIN_DAFCSEL (D27) |
| L:firetestbag | 0 | Default / PIN_BAG_FIRE_TEST (D29) |
| L:CRTest | 0 | Default / PIN_CARGO_TEST (D29) |
| L:SwMagDg | 0 (Norm) | Default / PIN_MAG_DG_MAG1/2 (D51/D52) or PIN_MAG_DG_DG1/2 (D53/D54) |

---

## XMSN/Governor (xmsn_governor_logic.lua)

| L-Var | Pre-Start State | Set By |
|-------|-----------------|--------|
| L:GovMode | 0 (Auto) | Default / PIN_GOV_MODE (D20) |
| L:GOVERNOR RPM SWITCH | 0 (OFF) | Default / PIN_RPM_SWITCH_POS1 (D21), PIN_RPM_SWITCH_POS2 (D22), PIN_RPM_SWITCH_POS1_2 (D60), PIN_RPM_SWITCH_POS2_2 (D61) |
| L:XmsnPressWarn | 0 | Computed |
| L:XmsnTempWarn | 0 | Computed |
| L:CboxPressWarn | 0 | Computed |
| L:SwGovA | 0 (OFF) | PIN_GOV_ENG1 (D23) (Number 0/1) |
| L:SwGovB | 0 (OFF) | PIN_GOV_ENG2 (D25) (Number 0/1) |
| L:XMSN CHIP | false | Sim/gauge |

---

## Engine Start Permission Checklist

### Engine 1 (L:Eng1StartFlag = 1)
- [ ] Battery 1 OR Battery 2 = ON
- [ ] Fuel Transfer 1 = ON
- [ ] Fuel Pressure 1 > 4.0 PSI
- [ ] Fuel Valve 1 >= 0.99 (fully open)
- [ ] Start Switch = 1 (Eng 1 selected)
- [ ] Rotor Brake = OFF

### Engine 2 (L:Eng2StartFlag = 1)
- [ ] Battery 1 OR Battery 2 = ON
- [ ] Fuel Transfer 2 = ON
- [ ] Fuel Pressure 2 > 4.0 PSI
- [ ] Fuel Valve 2 >= 0.99 (fully open)
- [ ] Start Switch = 2 (Eng 2 selected)
- [ ] Rotor Brake = OFF

---

## Pre-Start Procedure Summary

1. **Power Up**: Set BATT1 and BATT2 to ON
2. **Fuel**: Enable Fuel Transfer 1 & 2, Boost Pumps 1 & 2
3. **Fuel Valves**: Open Fuel Valves 1 & 2 (wait for transit)
4. **Throttles**: Advance to idle position (>12%)
5. **Particle Separators**: Enable (optional but recommended)
6. **Rotor Brake**: Ensure OFF
7. **Fire Handles**: Ensure RESET (not pulled)
8. **Start Engine 1**: Press and hold Engine 1 Start
9. **Monitor**: Check L:Eng1StartFlag = 1, LED illuminates
10. **After start**: Enable Generators, then Engine 2

---

## Physical LED Indicators

### Fire Warning LEDs (Mega A)
| Pin | LED | L-Var |
|-----|-----|-------|
| D35 | Fire Eng 1 | L:FireWarn1 |
| D36 | Fire Eng 2 | L:FireWarn2 |
| D37 | Baggage Fire | L:BagFire |

### CWP Warning LEDs (Mega C)
| Pin | LED | L-Var |
|-----|-----|-------|
| D41 | Governor A | L:SwGovA |
| D42 | Governor B | L:SwGovB |
| D43 | Chip Detector | L:XMSN CHIP |
