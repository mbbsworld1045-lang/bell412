-- =============================================================================
-- BELL 412 - DOCUMENTATION GENERATOR
-- Reads all panel scripts and generates a comprehensive CSV mapping table.
-- =============================================================================

local io = require("io")
local os = require("os")

local lfs = require("lfs") -- assuming LuaFileSystem is available in standard AirManager env
-- Or we use standard open if not

local panels_dir = "d:\\usman\\bell412\\Bell_412_Simulator\\scripts\\panels\\"
local out_file = "d:\\usman\\bell412\\Bell_412_Simulator\\docs\\Hardware_Pin_Mappings.csv"

local files = {
    "caution_panel.lua",
    "collective.lua",
    "flight_director.lua",
    "front_panel.lua",
    "over_head.lua",
    "pedestal.lua"
}

-- CSV Header
local out = io.open(out_file, "w")
if not out then
    print("Failed to open output file: " .. out_file)
    return
end

out:write("Panel File,Parameter Name,Arduino Channel,Pin Number,Pin Designation,Type (Input/LED/Output/Analog),Associated SimVar / Logic,Comments/Notes\n")

-- Helper to safely format CSV fields
local function esc(str)
    if not str then return "" end
    str = tostring(str):gsub("\r", ""):gsub("\n", " ")
    if str:find(",") or str:find('"') then
        return '"' .. str:gsub('"', '""') .. '"'
    end
    return str
end

-- Process each file
for _, file in ipairs(files) do
    local f = io.open(panels_dir .. file, "r")
    if f then
        
        local active_channel = "?"
        -- Try to guess channel from filename or early comments
        if file == "caution_panel.lua" then active_channel = "E"
        elseif file == "collective.lua" then active_channel = "C"
        elseif file == "flight_director.lua" then active_channel = "F"
        elseif file == "front_panel.lua" then active_channel = "B"
        elseif file == "over_head.lua" then active_channel = "D"
        elseif file == "pedestal.lua" then active_channel = "A"
        end

        for line in f:lines() do
            -- Look for ARDUINO_MEGA2560 pin definitions
            -- e.g. local PIN_NAME = "ARDUINO_MEGA2560_A_D12" -- Comment (L:Var)
            -- e.g. NAME = "ARDUINO_MEGA2560_A_D12", -- Comment
            
            local name, full_pin, comment = string.match(line, "([%w_]+)%s*=%s*\"(ARDUINO_MEGA2560_[%w_]+)\"%s*,?%s*-*-*(.*)")
            
            if name and full_pin then
                name = name:gsub("^local PIN_", ""):gsub("^local ", "")
                
                -- Parse Pin Details
                local chan, pin_num = string.match(full_pin, "MEGA2560_([A-F])_([AD]%d+)")
                if not chan then chan = active_channel end
                
                -- Determine Type Hint based on naming conventions
                local p_type = "Input (Digital)"
                if name:match("LED") or name:match("LT_LT") or line:match("hw_led_add") then
                    p_type = "Output (LED)"
                elseif pin_num and pin_num:match("^A") and not name:match("SW") then
                    -- Analog pins without SW are often inputs or LEDs depending on context, 
                    -- let's default to Analog Axis if it contains THROTTLE or POT
                    if name:match("THROTTLE") or name:match("DIMMER") or name:match("POT") then
                        p_type = "Input (Analog)"
                    else
                        p_type = "Input/Output (Verify)"
                    end
                end
                if name:match("RELAY") or name:match("SERVO") then
                    p_type = "Output (Hardware)"
                end

                -- Look for L:Vars in comments
                local logic = ""
                local lvar = string.match(comment, "(L:[%w%s_]+)")
                if lvar then logic = lvar end
                -- Try to find events too
                local ev = string.match(comment, "([KHE]:[%w%s_]+)")
                if ev then logic = logic .. " " .. ev end

                -- Clean comment
                local clean_comment = comment:gsub("%(L:[^%)]+%)", ""):gsub("%(K:[^%)]+%)", ""):match("^%s*(.-)%s*$")
                
                -- Write row
                out:write(string.format("%s,%s,%s,%s,%s,%s,%s,%s\n", 
                    esc(file), 
                    esc(name), 
                    esc(chan), 
                    esc(pin_num), 
                    esc(full_pin), 
                    esc(p_type), 
                    esc(logic), 
                    esc(clean_comment)
                ))
            end
        end
        f:close()
    end
end

out:close()
print("Documentation generated successfully at: " .. out_file)
