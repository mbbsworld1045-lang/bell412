$panelsDir = "d:\usman\bell412\Bell_412_Simulator\scripts\panels"
$outCsv = "d:\usman\bell412\Bell_412_Simulator\docs\Hardware_Pin_Mappings.csv"

$files = @(
    "caution_panel.lua", "collective.lua", "flight_director.lua",
    "front_panel.lua", "over_head.lua", "pedestal.lua"
)

$results = @()

foreach ($file in $files) {
    $filePath = Join-Path $panelsDir $file
    if (-not (Test-Path $filePath)) { continue }
    
    $content = Get-Content $filePath
    foreach ($line in $content) {
        # Match lines like: local PIN_NAME = "ARDUINO_MEGA2560_A_D12" -- Comment (L:Var)
        # or NAME = "ARDUINO_MEGA2560_A_D12", -- Comment
        if ($line -match "([A-Za-z0-9_]+)\s*=\s*`"ARDUINO_MEGA2560_([A-F])_([AD][0-9]+)`",?\s*-*-*\s*(.*)") {
            $rawName = $matches[1]
            $channel = $matches[2]
            $pinNum  = $matches[3]
            $comment = $matches[4]
            
            # Clean up the name (remove 'local PIN_')
            $name = $rawName -replace "^local PIN_", ""
            $name = $name -replace "^local ", ""
            
            $fullPin = "ARDUINO_MEGA2560_${channel}_${pinNum}"
            
            # Guess Type
            $type = "Input (Digital)"
            if ($name -match "LED" -or $name -match "LT_LT" -or $line -match "hw_led_add") {
                $type = "Output (LED)"
            } elseif ($pinNum -match "^A" -and $name -notmatch "SW") {
                if ($name -match "THROTTLE" -or $name -match "DIMMER" -or $name -match "POT") {
                    $type = "Input (Analog)"
                } else {
                    $type = "Input/Output (Verify)"
                }
            }
            if ($name -match "RELAY" -or $name -match "SERVO") {
                $type = "Output (Hardware)"
            }
            
            # Extract SimVars (L:Vars, K:Events, or H:Events)
            $logic = ""
            if ($comment -match "\((L:[a-zA-Z0-9_\s]+)\)") {
                $logic = $matches[1]
            } elseif ($comment -match "(L:[a-zA-Z0-9_\s]+)") {
                $logic = $matches[1]
            }
            
            if ($comment -match "\(([KHE]:[a-zA-Z0-9_\s]+)\)") {
                $logic += " " + $matches[1]
            }
            
            # Clean up Comment
            $cleanComment = $comment -replace "\([LKHE]:[^)]+\)", ""
            $cleanComment = $cleanComment.Trim()
            
            $results += [PSCustomObject]@{
                PanelFile       = $file
                ParameterName   = $name
                Channel         = $channel
                PinNumber       = $pinNum
                PinDesignation  = $fullPin
                Type            = $type
                SimVar_Logic    = $logic.Trim()
                Notes           = $cleanComment
            }
        }
    }
}

$results | Export-Csv -Path $outCsv -NoTypeInformation -Encoding UTF8
Write-Host "Successfully generated total of $($results.Count) records to $outCsv"
