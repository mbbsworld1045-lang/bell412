# Bell 412 Simulator L-Parameter Logic

This document translates the Reverse Polish Notation (RPN) logic found in the Bell 412 simulator gauges into standard mathematical equations. It includes every single `L:` assignment from the primary gauge logic file (`All_Gauges_Combined.md`).

---

## 📖 Glossary of Variable Types

In Microsoft Flight Simulator (MSFS/FSX/P3D) gauge programming, variables are prefixed with letters indicating their scope and origin. 

*   **(A:) - Aircraft Parameters**: Native variables built into the simulator core (e.g., `A:Indicated Altitude`, `A:Turb eng2 N1`). You read from these, but generally cannot write directly to them through assignment.
*   **(L:) - Local Variables (Custom)**: Aircraft-specific custom variables created by the developer (e.g., `L:RPM N1 E1`). These hold states, math calculations, and switch positions that the native `A:` variables don't cover. These are fully readable and writable.
*   **(K:) - Key Events**: These are commands to trigger an action in the simulator, rather than variables that hold a value (e.g., `K:TOGGLE_MASTER_BATTERY`).
*   **(G:) - Gauge Variables**: Variables strictly local to one specific XML gauge file.
*   **(E:) - Environment Variables**: Variables like Time of Day, Absolute Time.
*   **(M:) - Mouse Variables**: Mouse click coordinates and events (`M:Event`, `M:X`).

> [!NOTE]
> *In the fully expanded `A:` parameter equations below, items wrapped in `[Brackets]` are custom simplified shorthand designed to make complex `if/else` logic readable without rewriting paragraphs of XML.*

---

## 1. Engine 1 Core Performance (N1, Torque, ITT)

### 1.1 `L:RPM N1 E1` (Engine 1 Gas Generator RPM)
*Note: Engine 1 in the logic maps to physical MSFS Engine 2.*

*   **Direct L-Variable Equation:**
    `L:RPM N1 E1 = (L:GasN1E1, percent) / 1.17 + (L:Eng1torque, percent) / 6.21 + (L:OEIRPME1, percent)`
*   **Fully Expanded A-Parameter Equation:**
    ```text
    RPM_N1_E1 = ( (A:Turb eng2 N1, percent) + [Sync_Boost_E1] ) / 1.17 
              + (A:GENERAL ENG THROTTLE LEVER POSITION:1, percent) / 6.21 
              + [OEI_Boost_E1]
    ```

### 1.2 `L:Eng1torque` (Engine 1 Base Torque Input)
*   **Direct:** `L:Eng1torque = (A:GENERAL ENG THROTTLE LEVER POSITION:1, percent)` *(Updates if `L:Eng1N2 >= 80%`)*
*   **Expanded:** `Eng1Torque = (A:GENERAL ENG THROTTLE LEVER POSITION:1, percent)`

### 1.3 `L:SynRPM1` (Engine 1 RPM Sync Boost)
*   **Direct:** `L:SynRPM1 = 3.0` (Else `0`). 
    *(If `(A:Eng2 Combustion,bool)` is True, Altitude >= 4000ft, and `L:RPM N1 E1 <= 80%`)*
*   **Expanded:** `[Sync_Boost_E1] = 3.0` (If Eng2Combusting AND Alt >= 4000 AND RPM_N1_E1 <= 80), Else `0`

### 1.4 `L:OEIE1` & `L:OEIRPME1` (Engine 1 One Engine Inoperative Overdrive)
*   **Direct (`L:OEIE1`):** `1` (If `(A:Eng3 Combustion,bool) == 1` AND `L:RPM N1 E2 <= 83%`)
*   **Direct (`L:OEIRPME1`):** `10` (If `L:RPM N1 E1 >= 72%` AND `L:OEIE1 == 1`)
*   **Expanded:** `[OEI_Boost_E1] = 10` (If RPM_N1_E1 >= 72 AND Engine 2 is Combusting but failing [N1<=83]), Else `0`

### 1.5 `L:GasN1E1` (Engine 1 Base Gas Generator Math)
*   **Direct:** `L:GasN1E1 = (A:Turb eng2 N1, percent) + (L:SynRPM1, percent)`
*   **Expanded:** `GasN1E1 = (A:Turb eng2 N1, percent) + [Sync_Boost_E1]`

### 1.6 `L:ITTE1` (Engine 1 Interstage Turbine Temperature)
*   **Direct:** `L:ITTE1 = (A:Turb Eng2 ITT, celsius) + (L:Eng1torque, percent) / 0.54 + (L:ITTE1STR, celsius) + (L:OEIITTE1, celsius)`
*   **Expanded:**
    ```text
    ITT_E1 = (A:Turb Eng2 ITT, celsius) 
           + (A:GENERAL ENG THROTTLE LEVER POSITION:1, percent) / 0.54 
           + [Starter_Heat_E1: 200 if starting] 
           + [OEI_Heat_E1: 115 if OEI_Active]
    ```

---

## 2. Engine 2 Core Performance (N1, Torque, ITT)

### 2.1 `L:RPM N1 E2` (Engine 2 Gas Generator RPM)
*Note: Engine 2 in the logic maps to physical MSFS Engine 3.*

*   **Direct L-Variable Equation:**
    `L:RPM N1 E2 = (L:GasN1E2, percent) / 1.17 + (L:Eng2torque, percent) / 6.21 + (L:OEIRPME2, percent)`
*   **Fully Expanded A-Parameter Equation:**
    ```text
    RPM_N1_E2 = ( (A:Turb eng3 N1, percent) + [Sync_Boost_E2] ) / 1.17 
              + (A:GENERAL ENG THROTTLE LEVER POSITION:1, percent) / 6.21 
              + [OEI_Boost_E2]
    ```

### 2.2 `L:Eng2torque` (Engine 2 Base Torque Input)
*   **Direct:** `L:Eng2torque = (A:GENERAL ENG THROTTLE LEVER POSITION:1, percent)`
*   **Expanded:** `Eng2Torque = (A:GENERAL ENG THROTTLE LEVER POSITION:1, percent)`

### 2.3 `L:SynRPM2` (Engine 2 RPM Sync Boost)
*   **Direct:** `L:SynRPM2 = 3.0` (Else `0`)
*   **Expanded:** `[Sync_Boost_E2] = 3.0` (If Eng3Combusting AND Alt >= 4000 AND RPM_N1_E2 <= 80), Else `0`

### 2.4 `L:OEIE2` & `L:OEIRPME2` (Engine 2 One Engine Inoperative Overdrive)
*   **Direct (`L:OEIE2`):** `1` (If `(A:Eng2 Combustion,bool) == 1` AND `L:RPM N1 E1 <= 83%`)
*   **Direct (`L:OEIRPME2`):** `10` (If `L:RPM N1 E2 >= 72%` AND `L:OEIE2 == 1`)
*   **Expanded:** `[OEI_Boost_E2] = 10` (If RPM_N1_E2 >= 72 AND Engine 1 is Combusting but failing [N1<=83]), Else `0`

### 2.5 `L:GasN1E2` (Engine 2 Base Gas Generator Math)
*   **Direct:** `L:GasN1E2 = (A:Turb eng3 N1, percent) + (L:SynRPM2, percent)`
*   **Expanded:** `GasN1E2 = (A:Turb eng3 N1, percent) + [Sync_Boost_E2]`

### 2.6 `L:ITTE2` (Engine 2 Interstage Turbine Temperature)
*   **Direct:** `L:ITTE2 = (A:Turb Eng3 ITT, celsius) + (L:Eng2torque, percent) / 0.54 + (L:ITTE2STR, celsius) + (L:OEIITTE2, celsius)`
*   **Expanded:**
    ```text
    ITT_E2 = (A:Turb Eng3 ITT, celsius) 
           + (A:GENERAL ENG THROTTLE LEVER POSITION:1, percent) / 0.54 
           + [Starter_Heat_E2: 200 if starting] 
           + [OEI_Heat_E2: 115 if OEI_Active]
    ```

---

## 3. Oil & Transmission Systems

### 3.1 `L:OILE1` & `L:OILE1T` (Engine 1 Oil Pressure & Temp)
*   **Direct/Expanded Press:** `L:OILE1 = (A:Turb eng2 N1, percent) / 0.95`
*   **Direct/Expanded Temp:** `L:OILE1T = (A:General Eng2 Oil Temperature, celsius)`

### 3.2 `L:OILE2` & `L:OILE2T` (Engine 2 Oil Pressure & Temp)
*   **Direct/Expanded Press:** `L:OILE2 = (A:Turb eng3 N1, percent) / 0.95`
*   **Direct/Expanded Temp:** `L:OILE2T = (A:General Eng3 Oil Temperature, celsius)`

### 3.3 `L:MGbox` & `L:Gbox` & `L:GboxT` (Combining Gearbox)
*   **Direct (`L:MGbox`):** `(A:Turb eng1 N1, percent)`
*   **Direct/Expanded Press (`L:Gbox`):** `L:Gbox = (A:Turb eng1 N1, percent) / 0.95`
*   **Direct/Expanded Temp (`L:GboxT`):** `L:GboxT = (A:General Eng1 Oil Temperature, celsius)`

### 3.4 `L:Mxmsn` & `L:XMSN` & `L:XMSNT` (Main Transmission)
*   **Direct (`L:Mxmsn`):** `(A:Turb eng1 N1, percent)`
*   **Direct/Expanded Press (`L:XMSN`):** `L:XMSN = (A:Turb eng1 N1, percent) * (85 / 105)`
*   **Direct/Expanded Temp (`L:XMSNT`):** `L:XMSNT = (A:General Eng1 Oil Temperature, celsius)`

---

## 4. Hydraulic & Fuel Systems

### 4.1 Hydraulics (`L:HYDRS1`, `L:HYDRS2`, `L:HYDRT`)
*   **Direct System 1:** `L:HYDRS1 = 1005` (If `L:Sw hydsysA == 0` AND `(A:Turb eng1 N1) >= 10`), Else `0`
*   **Expanded System 1:** `HYD_SYS_1 = 1005` (If HydA_Switch_ON AND (A:Turb eng1 N1) >= 10), Else `0`
*   **Direct System 2:** `L:HYDRS2 = 1005` (If `L:Sw hydsysB == 0` AND `(A:Turb eng1 N1) >= 10`), Else `0`
*   **Direct/Expanded Temp:** `L:HYDRT = (A:General Eng1 Oil Temperature, celsius) - 34`

### 4.2 Fuel Quantity (`L:fuelq`, `L:fuelqt`, `L:fuelqtc`)
*   **Direct/Expanded (`L:fuelq`):**
    ```text
    FUEL_QTY = (A:FUEL TOTAL QUANTITY WEIGHT, pound) * [SelectorMultiplier]
    Where [SelectorMultiplier] = 0.666 (Fwd), 1.0 (Total), 0.5 (Mid) based on Switch Position.
    ```

### 4.3 Fuel Pressure (`L:fuelp1`, `L:fuelp2`)
*   **Direct/Expanded System 1:** `L:fuelp1 = 14` (If `L:SwboostpuEng1 == 1` AND `L:SwvalveEng1 == 1`), Else `0`
*   **Direct/Expanded System 2:** `L:fuelp2 = 14` (If `L:SwboostpuEng2 == 1` AND `L:SwvalveEng2 == 1`), Else `0`

---

## 5. Electrical Systems (Amps & Volts)

### 5.1 DC Voltage (`L:VoltDC1`, `L:VoltDC2`)
*   **Direct DC 1:** `L:VoltDC1 = (L:BVoltDC1) + (L:GVoltDC1) - (L:OVoltDC1)`
*   **Expanded DC 1:** `DC_VOLTS_1 = [24 if Battery_ON] + [4 if GenMaster_ON] - [6 if Engine2_Dead AND Starter_Active]`
*   **Direct DC 2:** `L:VoltDC2 = (L:BVoltDC2) + (L:GVoltDC2) - (L:OVoltDC2)`
*   **Expanded DC 2:** `DC_VOLTS_2 = [24 if Battery_ON] + [4 if GenMaster_ON] - [6 if Engine1_Dead AND Starter_Active]`

### 5.2 Amps (`L:Ampsg1`, `L:Ampsg2`)
*   **Direct Amps 1:** `L:Ampsg1 = (L:CAmps1) + (L:OAmps1)`
*   **Expanded Amps 1:** `AMPS_1 = [75 if Gen1_ON] + [280 if StartingEngine1 AND Eng2_Dead AND RPM_N1_E1 < 72]`
*   **Direct Amps 2:** `L:Ampsg2 = (L:CAmps2) + (L:OAmps2)`
*   **Expanded Amps 2:** `AMPS_2 = [75 if Gen2_ON] + [280 if StartingEngine2 AND Eng1_Dead AND RPM_N1_E2 < 72]`

### 5.3 AC Voltage (`L:VoltAC1`, `L:VoltAC2`)
*   **Direct/Expanded AC 1:** `L:VoltAC1 = 115` (If `L:MasterDcBus == 1` AND `L:Swinva == 1`), Else `0`
*   **Direct/Expanded AC 2:** `L:VoltAC2 = 115` (If `L:MasterDcBus == 1` AND `L:Swinvb == 1`), Else `0`

---

## 6. Miscellaneous Categorized Variables
*These variables are primarily set directly by pilot switch interactions or handle minor UI transitions. They map 1:1 with their L: namespace and do not have complex continuous A: variables driving them mathematically.*

**Switches & Controls:**
`L:Swbatta`, `L:Swbattb`, `L:ExternalPower`, `L:ResetMC`, `L:Testaft`, `L:CRTest`, `L:Cyctest`, `L:Radiotest`, `L:TestMarker`, `L:Testradaralt`, `L:Overtq`, `L:WARNINGOFF`

**Doors & Covers (0/1 or Percentages):**
`L:Door baggage`, `L:Door Cargo l`, `L:Door Cargo r`, `L:Door Eng l`, `L:Door Eng r`, `L:Door passenger l`, `L:Door passenger r`, `L:Copilotdoor`, `L:NoseDoor`
`L:EngineCovers`, `L:pitotcovers`, `L:doorcntl`, `L:doorcntr`

**Nav & Comms (Frequencies/States):**
`L:nav1`, `L:nav2`, `L:comm1`, `L:comm2`, `L:adf`, `L:ADF Active`, `L:ADF Standby`, `L:xpdr`, `L:tcas`, `L:OVERRADIOH`

**Rotor & Power Governing:**
`L:Trotor`, `L:TRQrotor`, `L:Powern2`, `L:Powern2E1`, `L:Powern2E2`, `L:GovRPM1`, `L:GovRPM2`

**Master/Helper States:**
`L:MasterDcBus`, `L:MasterACDC`, `L:Masterstbatt`, `L:stbatt`, `L:Genmast`, `L:Mgsnav`, `L:Mlocnav`
