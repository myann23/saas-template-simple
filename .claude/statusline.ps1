# Claude Code Status Line Script
# Shows: Model | [Progress Bar] Percent% | Used/Total tokens

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Read JSON from stdin
$jsonInput = $input | Out-String | ConvertFrom-Json

$model = $jsonInput.model.display_name
$sizeTokens = $jsonInput.context_window.context_window_size

# Use pre-calculated percentage (matches /context command)
$percent = [math]::Round($jsonInput.context_window.used_percentage)

# Derive current token usage from percentage
$usedTokens = [math]::Round(($percent / 100) * $sizeTokens)
$used = [math]::Round($usedTokens / 1000)
$size = [math]::Round($sizeTokens / 1000)

# ANSI color codes
$esc = [char]27
$bold = "$esc[1m"
$blue = "$esc[34m"
$reset = "$esc[0m"

# Build progress bar with Unicode blocks (10 segments)
$filled = [math]::Floor($percent / 10)
$empty = 10 - $filled
$filledChar = [char]0x2588  # █ Full block
$emptyChar = [char]0x2591   # ░ Light shade
$bar = ($filledChar.ToString() * $filled) + ($emptyChar.ToString() * $empty)

Write-Output "${bold}${blue}$model | [$bar] $percent% | ${used}k/${size}k tokens${reset}"
