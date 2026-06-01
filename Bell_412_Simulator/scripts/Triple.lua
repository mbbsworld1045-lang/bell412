-- =============================================================================
-- Bell 412EP Triple Tachometer (Air Manager Lua)
-- Replicates XML gauge: Eng1 N2, Eng2 N2, Rotor RPM needles
-- Nonlinearity angles derived from XML gauge XY coordinates
-- =============================================================================

-- Images (same assets as bell412_tt.lua)
img_add_fullscreen("B412_Triple_Tach_Markings.png")
img_needle_1 = img_add("B412_Triple_Tach_Needle_1.png", 233, 91, 34, 318)
img_needle_2 = img_add("B412_Triple_Tach_Needle_2.png", 233, 91, 34, 318)
img_needle_R = img_add("B412_Triple_Tach_Needle_R.png", 233, 91, 34, 318)

-- =============================================================================
-- NONLINEARITY TABLE
-- Derived from XML gauge XY coords (center 125,125)
-- angle = atan2(X-125, 125-Y) → bearing CW from North in degrees
-- All three needles share the same nonlinearity in the XML
-- =============================================================================
local TACH_TABLE = {
    {value = 0,   angle = -3.5},
    {value = 10,  angle = 24.0},
    {value = 20,  angle = 51.6},
    {value = 30,  angle = 78.7},
    {value = 40,  angle = 105.5},
    {value = 50,  angle = 132.1},
    {value = 60,  angle = 160.3},
    {value = 70,  angle = 187.1},
    {value = 80,  angle = 215.9},
    {value = 90,  angle = 244.2},
    {value = 100, angle = 284.9},
}

-- =============================================================================
-- N2 NEEDLE SMOOTHING
-- XML specifies DegreesPerSecond="16" delay for both N2 needles
-- Rotor needle has NO delay (instant response)
-- Using smoothing factor to approximate the delayed needle movement
-- =============================================================================
local SMOOTHING = 0.15
local cur_n2_1 = -3.5
local cur_n2_2 = -3.5

-- =============================================================================
-- INTERPOLATION (linear interpolation through nonlinearity table)
-- =============================================================================
local function interpolate(value, tbl)
    if value <= tbl[1].value then return tbl[1].angle end
    if value >= tbl[#tbl].value then return tbl[#tbl].angle end

    for i = 1, #tbl - 1 do
        if value >= tbl[i].value and value < tbl[i + 1].value then
            local ratio = (value - tbl[i].value) / (tbl[i + 1].value - tbl[i].value)
            return tbl[i].angle + ratio * (tbl[i + 1].angle - tbl[i].angle)
        end
    end

    return tbl[1].angle
end

-- =============================================================================
-- DATA CALLBACK
-- =============================================================================
function new_data(eng1_n2, eng2_n2, rotor_pct)
    -- Eng1 N2 needle (smoothed - replicates XML Delay DegreesPerSecond="16")
    local tgt_1 = interpolate(eng1_n2, TACH_TABLE)
    cur_n2_1 = cur_n2_1 + (tgt_1 - cur_n2_1) * SMOOTHING
    img_rotate(img_needle_1, cur_n2_1)

    -- Eng2 N2 needle (smoothed - replicates XML Delay DegreesPerSecond="16")
    local tgt_2 = interpolate(eng2_n2, TACH_TABLE)
    cur_n2_2 = cur_n2_2 + (tgt_2 - cur_n2_2) * SMOOTHING
    img_rotate(img_needle_2, cur_n2_2)

    -- Rotor RPM needle (instant - no delay in XML)
    img_rotate(img_needle_R, interpolate(rotor_pct, TACH_TABLE))
end

-- =============================================================================
-- FSX VARIABLE SUBSCRIPTIONS (matching XML gauge variables)
-- XML: (L:Eng1N2,percent), (L:Eng2N2,percent), (A:Eng Rotor Rpm,percent)
-- =============================================================================
fsx_variable_subscribe(
    "L:Eng1N2", "percent",
    "L:Eng2N2", "percent",
    "ROTOR RPM PCT:1", "percent",
    new_data
)
