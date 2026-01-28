# Bell 412 Lua Script Coverage Audit

## Summary
- **Total Hardware Pins**: 120+ (Inputs + Outputs + Analog)
- **Total L-Vars Written**: 70+
- **Total L-Vars Subscribed**: 50+
- **Total Sim Events**: 14
- **Compliance**: 100% hw_button_add for all inputs

---

## Arduino Mega A (Overhead Panel) - electrical_logic.lua + systems_ancillary.lua

### Inputs (24 pins: D2-D10, D11, D14-D27) + 1 Analog (A0)
| Pin | Function | Method | File |
|-----|----------|--------|------|
| D2 | Battery 1 | hw_button_add | electrical_logic.lua |
| D3 | Battery 2 | hw_button_add | electrical_logic.lua |
| D4 | Generator 1 | hw_button_add | electrical_logic.lua |
| D5 | Generator 2 | hw_button_add | electrical_logic.lua |
| D6 | Inverter 1 | hw_button_add | electrical_logic.lua |
| D7 | Inverter 2 | hw_button_add | electrical_logic.lua |
| D8 | Non-Essential Bus | hw_button_add | electrical_logic.lua |
| D9 | Emergency Load | hw_button_add | electrical_logic.lua |
| D10 | Standby Attitude | hw_button_add | electrical_logic.lua |
| D14 | Pitot Heat | hw_button_add | systems_ancillary.lua |
| D15 | Nav Lights | hw_button_add | systems_ancillary.lua |
| D16 | Anti-Collision | hw_button_add | systems_ancillary.lua |
| D17 | Pilot Wiper | hw_button_add | systems_ancillary.lua |
| D18 | Copilot Wiper | hw_button_add | systems_ancillary.lua |
| D19 | Heater | hw_button_add | systems_ancillary.lua |
| D20 | Vent Blower | hw_button_add | systems_ancillary.lua |
| D21 | Aft Outlet | hw_button_add | systems_ancillary.lua |
| D22 | Dome Light | hw_button_add | systems_ancillary.lua |
| D23 | Utility Light | hw_button_add | systems_ancillary.lua |
| D24 | Fire Handle 1 | hw_button_add | systems_ancillary.lua |
| D25 | Fire Handle 2 | hw_button_add | systems_ancillary.lua |
| D26 | Fire Test | hw_button_add | systems_ancillary.lua |
| D27 | Compass Mag/Slave | hw_button_add | systems_ancillary.lua |
| D11 | Plate/Maplight Dimmer Button | hw_button_add | systems_ancillary.lua |
| A0 | Plate/Maplight Dimmer (Analog) | hw_adc_input_add | systems_ancillary.lua |

### Outputs (8 LEDs: D30-D37)
| Pin | Function | Handle | File |
|-----|----------|--------|------|
| D30 | Gen 1 Fail | led_gen1_h | electrical_logic.lua |
| D31 | Gen 2 Fail | led_gen2_h | electrical_logic.lua |
| D32 | Inv 1 Fail | led_inv1_h | electrical_logic.lua |
| D33 | Inv 2 Fail | led_inv2_h | electrical_logic.lua |
| D34 | Battery Caution | led_batt_h | electrical_logic.lua |
| D35 | Fire Eng 1 | led_fire_eng1_h | systems_ancillary.lua |
| D36 | Fire Eng 2 | led_fire_eng2_h | systems_ancillary.lua |
| D37 | Baggage Fire | led_bag_fire_h | systems_ancillary.lua |

---

## Arduino Mega B (Pedestal Panel) - fuel_logic.lua + hydraulics_logic.lua + systems_ancillary.lua

### Inputs (30 pins: D2-D14, D20-D29, D39-D40, D42-D43, D49-D54)
| Pin | Function | Method | File |
|-----|----------|--------|------|
| D2 | Fuel Transfer 1 | hw_button_add | fuel_logic.lua |
| D3 | Fuel Transfer 2 | hw_button_add | fuel_logic.lua |
| D4 | Boost Pump 1 | hw_button_add | fuel_logic.lua |
| D5 | Boost Pump 2 | hw_button_add | fuel_logic.lua |
| D6 | Fuel Interconnect | hw_button_add | fuel_logic.lua |
| D7 | Fuel Crossfeed | hw_button_add | fuel_logic.lua |
| D8 | Fuel Valve 1 | hw_button_add | fuel_logic.lua |
| D9 | Fuel Valve 2 | hw_button_add | fuel_logic.lua |
| D10 | Fuel Quantity Pos2 | hw_button_add (3-pos) | fuel_logic.lua |
| D11 | Fuel Digit Test | hw_button_add | fuel_logic.lua |
| D12 | Fuel Quantity Pos1 | hw_button_add (3-pos) | fuel_logic.lua |
| D13 | XFEED/INTCON Pos1 | hw_button_add (3-pos) | fuel_logic.lua |
| D14 | XFEED/INTCON Pos2 | hw_button_add (3-pos) | fuel_logic.lua |
| D20 | Force Trim | hw_button_add | systems_ancillary.lua |
| D21 | Compass | hw_button_add | systems_ancillary.lua |
| D22 | Static Source | hw_button_add | systems_ancillary.lua |
| D23 | AFCS HP1 | hw_button_add (toggle) | systems_ancillary.lua |
| D24 | AFCS HP2 | hw_button_add (toggle) | systems_ancillary.lua |
| D25 | AFCS SAS | hw_button_add (toggle) | systems_ancillary.lua |
| D26 | AFCS ATT | hw_button_add (toggle) | systems_ancillary.lua |
| D27 | Standby Att Test | hw_button_add (timer) | systems_ancillary.lua |
| D28 | Cargo Release | hw_button_add | systems_ancillary.lua |
| D29 | Cargo Test | hw_button_add | systems_ancillary.lua |
| D39 | Bambi Release | hw_button_add | systems_ancillary.lua |
| D40 | Hydraulic Sys 1 | hw_button_add | hydraulics_logic.lua |
| D41 | Hydraulic Sys 2 | hw_button_add | hydraulics_logic.lua |
| D42 | Cyclic Center Test Button 1 | hw_button_add | hydraulics_logic.lua |
| D43 | Cyclic Center Test Button 2 | hw_button_add | hydraulics_logic.lua |
| D49 | Cargo Test LED | LED Output | systems_ancillary.lua |
| D50 | Bambi Release 2 | hw_button_add | systems_ancillary.lua |
| D51 | Mag/Dg Switch Mag Button 1 | hw_button_add (3-pos) | systems_ancillary.lua |
| D52 | Mag/Dg Switch Mag Button 2 | hw_button_add (3-pos) | systems_ancillary.lua |
| D53 | Mag/Dg Switch Dg Button 1 | hw_button_add (3-pos) | systems_ancillary.lua |
| D54 | Mag/Dg Switch Dg Button 2 | hw_button_add (3-pos) | systems_ancillary.lua |

### Outputs (15 LEDs: D30-D38, D44-D48, D49)
| Pin | Function | Handle | File |
|-----|----------|--------|------|
| D30 | Trans 1 Warn | led_trans1_h | fuel_logic.lua |
| D31 | Trans 2 Warn | led_trans2_h | fuel_logic.lua |
| D32 | Boost 1 Warn | led_boost1_h | fuel_logic.lua |
| D33 | Boost 2 Warn | led_boost2_h | fuel_logic.lua |
| D34 | Intcon Active | led_intcon_h | fuel_logic.lua |
| D35 | Xfeed Active | led_xfeed_h | fuel_logic.lua |
| D36 | Valve 1 Transit | led_v1_trans_h | fuel_logic.lua |
| D37 | Valve 2 Transit | led_v2_trans_h | fuel_logic.lua |
| D38 | Xfeed L-Var Status | led_xfeed_lvar_h | fuel_logic.lua |
| D44 | Cyclic Center Test LED 1 | led_cyc_ctr_test1_h | hydraulics_logic.lua |
| D45 | Cyclic Center Test LED 2 | led_cyc_ctr_test2_h | hydraulics_logic.lua |
| D46 | Hyd 1 Fail | led_hyd1_h | hydraulics_logic.lua |
| D47 | Hyd 2 Fail | led_hyd2_h | hydraulics_logic.lua |
| D48 | Cyclic Center | led_cyc_ctr_h | hydraulics_logic.lua |
| D49 | Cargo Test LED | led_cargo_test_h | systems_ancillary.lua |

---

## Arduino Mega C (Main Panel / Collective) - startup.lua + cwp_master_caution.lua + xmsn_governor_logic.lua

### Inputs (25+ pins: D2-D7, D10-D19, D20-D29, D47-D49, D57-D58, D60-D61) + 2 Analog (A0-A1)
| Pin | Function | Method | File |
|-----|----------|--------|------|
| D2 | Start Engine Pos1 (Eng1) | hw_button_add (3-pos) | startup.lua |
| D3 | Start Engine Pos2 (Eng2) | hw_button_add (3-pos) | startup.lua |
| D4 | Idle Stop Pos1 (Eng1) | hw_button_add (3-pos) | startup.lua |
| D5 | Particle Sep 1 | hw_button_add | startup.lua |
| D6 | Particle Sep 2 | hw_button_add | startup.lua |
| D7 | Idle Stop Pos2 (Eng2) | hw_button_add (3-pos) | startup.lua |
| D10 | Test Panel Pos1 | hw_button_add (3-pos) | cwp_master_caution.lua |
| D11 | Test Lights | hw_button_add | cwp_master_caution.lua |
| D12 | MC Reset | hw_button_add | cwp_master_caution.lua |
| D13 | Test Panel Pos2 | hw_button_add (3-pos) | cwp_master_caution.lua |
| D14 | Course Set Switch | hw_button_add | systems_ancillary.lua |
| D15 | BRG PTR Switch | hw_button_add | systems_ancillary.lua |
| D16 | Over Torque Test | hw_button_add | systems_ancillary.lua |
| D17 | AFT Call | hw_button_add | systems_ancillary.lua |
| D18 | AFT Test | hw_button_add | systems_ancillary.lua |
| D19 | DME Select N1 | hw_button_add (3-pos) | systems_ancillary.lua |
| D20 | Governor Mode | hw_button_add | xmsn_governor_logic.lua |
| D21 | RPM Switch Pos1 (Inc) | hw_button_add (3-pos) | xmsn_governor_logic.lua |
| D22 | RPM Switch Pos2 (Dec) | hw_button_add (3-pos) | xmsn_governor_logic.lua |
| D23 | Governor Engine 1 | hw_button_add | xmsn_governor_logic.lua |
| D24 | Rotor Brake | hw_button_add | startup.lua |
| D25 | Governor Engine 2 | hw_button_add | xmsn_governor_logic.lua |
| D26 | Marker Test | hw_button_add | systems_ancillary.lua |
| D27 | AFCS Selector | hw_button_add | systems_ancillary.lua |
| D28 | DME Select N2 | hw_button_add (3-pos) | systems_ancillary.lua |
| D29 | Baggage Fire Test | hw_button_add | systems_ancillary.lua |
| D47 | Over Torque Test 2 | hw_button_add | systems_ancillary.lua |
| D48 | AFT Call 2 | hw_button_add | systems_ancillary.lua |
| D49 | AFT Test 2 | hw_button_add | systems_ancillary.lua |
| D57 | BRG PTR Switch 2 | hw_button_add | systems_ancillary.lua |
| D58 | Marker Test 2 | hw_button_add | systems_ancillary.lua |
| D60 | RPM Switch Pos1 Button 2 | hw_button_add (3-pos) | xmsn_governor_logic.lua |
| D61 | RPM Switch Pos2 Button 2 | hw_button_add (3-pos) | xmsn_governor_logic.lua |
| A0 | Throttle 1 | hw_adc_input_add | startup.lua |
| A1 | Throttle 2 | hw_adc_input_add | startup.lua |

### Outputs (20+ LEDs: D30-D35, D36-D38, D39, D40-D43, D44-D46, D50-D56, D59)
| Pin | Function | Handle | File |
|-----|----------|--------|------|
| D30 | Start Active | led_start_h | startup.lua |
| D31 | Rotor Brake | led_rotor_brake_h | startup.lua |
| D32 | Governor Eng 1 Status | led_gov_eng1_h | xmsn_governor_logic.lua |
| D33 | Governor Eng 2 Status | led_gov_eng2_h | xmsn_governor_logic.lua |
| D34 | Particle Sep 1 Status | led_partsep1_h | startup.lua |
| D35 | Particle Sep 2 Status | led_partsep2_h | startup.lua |
| D36 | Marker Outer (Blue) | led_marker_outer_h | systems_ancillary.lua |
| D37 | Marker Middle (Amber) | led_marker_middle_h | systems_ancillary.lua |
| D38 | Marker Inner (White) | led_marker_inner_h | systems_ancillary.lua |
| D39 | Over Torque Test LED | led_overtq_h | systems_ancillary.lua |
| D40 | Master Caution | led_mc_h | cwp_master_caution.lua |
| D41 | Gov A Warn | led_gov_a_warn_h | xmsn_governor_logic.lua |
| D42 | Gov B Warn | led_gov_b_warn_h | xmsn_governor_logic.lua |
| D43 | Chip Detector | led_chip_det_h | xmsn_governor_logic.lua |
| D44 | AFT Call LED | led_aft_call_h | systems_ancillary.lua |
| D45 | AFT Test LED | led_aft_test_h | systems_ancillary.lua |
| D46 | Baggage Fire Test LED | led_bag_fire_test_h | systems_ancillary.lua |
| D50 | Gov Manual | led_gov_man_h | xmsn_governor_logic.lua |
| D51 | XMSN Press Warn | led_xmsn_press_h | xmsn_governor_logic.lua |
| D52 | XMSN Temp Warn | led_xmsn_temp_h | xmsn_governor_logic.lua |
| D53 | CBOX Press Warn | led_cbox_press_h | xmsn_governor_logic.lua |
| D54 | Over Torque Test LED 2 | led_overtq_h2 | systems_ancillary.lua |
| D55 | AFT Call LED 2 | led_aft_call_h2 | systems_ancillary.lua |
| D56 | AFT Test LED 2 | led_aft_test_h2 | systems_ancillary.lua |
| D59 | Marker Test LED 2 | led_marker_test_h2 | systems_ancillary.lua |

---

## Sim Events Summary
| Event | File | Trigger |
|-------|------|---------|
| TOGGLE_ALTERNATOR1 | electrical_logic.lua | Gen 1 switch |
| TOGGLE_ALTERNATOR2 | electrical_logic.lua | Gen 2 switch |
| PITOT_HEAT_ON/OFF | systems_ancillary.lua | Pitot Heat switch |
| NAV_LIGHTS_ON/OFF | systems_ancillary.lua | Nav Lights switch |
| BEACON_LIGHTS_ON/OFF | systems_ancillary.lua | Anti-Coll switch |
| ROTOR_TRIM_RESET | systems_ancillary.lua | Force Trim button |
| ROTOR_BRAKE | startup.lua | Rotor Brake switch |
| ROTOR_GOV_RPM_INC | xmsn_governor_logic.lua | RPM Inc button |
| ROTOR_GOV_RPM_DEC | xmsn_governor_logic.lua | RPM Dec button |

---

## Compliance Notes
- ✅ All switches use `hw_button_add` pattern
- ✅ All LEDs use `hw_led_add` + `hw_led_set`
- ✅ All callbacks include `print("ACTION: ...")` debug
- ✅ Pin variables defined as string literals at file top
- ✅ Standard 7-section code structure in all files
- ✅ CWP warning LEDs now have physical outputs (Gov A/B, Chip)
- ✅ Fire warning LEDs have physical outputs (Eng 1/2, Bag)
- ✅ Fire Test button illuminates all fire warning LEDs
