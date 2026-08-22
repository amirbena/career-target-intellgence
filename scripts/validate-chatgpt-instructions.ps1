<#
.SYNOPSIS
    Validates that chatgpt/instructions.md — the exact content pasted
    unedited into the Custom GPT's Instructions field — stays within the
    platform's character limit.

.DESCRIPTION
    Character count uses .NET string length on the UTF-8-decoded text
    (character count, not byte count, not word count), matching what
    ChatGPT itself counts against the Instructions field limit.

    Works when invoked from inside or outside the repository root, since all
    paths are resolved relative to this script's own location ($PSScriptRoot).
    Compatible with Windows PowerShell 5.1 and PowerShell 7+.
#>

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Fail {
    param([string]$Message)
    Write-Error "error: $Message"
    exit 1
}

$RepoRoot = Split-Path -Parent $PSScriptRoot
$InstructionsFile = Join-Path $RepoRoot "chatgpt\instructions.md"

$HardLimit = 8000
$WarnThreshold = 7600

if (-not (Test-Path -LiteralPath $InstructionsFile -PathType Leaf)) {
    Fail "instructions file not found: $InstructionsFile"
}

$Text = Get-Content -LiteralPath $InstructionsFile -Raw -Encoding UTF8
$CharCount = $Text.Length

Write-Host "chatgpt/instructions.md: $CharCount characters (hard limit $HardLimit, warn threshold $WarnThreshold)"

if ($CharCount -ge $HardLimit) {
    Fail "chatgpt/instructions.md is $CharCount characters, at or over the $HardLimit-character Custom GPT Instructions field hard limit. Shorten it before packaging."
}

if ($CharCount -gt $WarnThreshold) {
    Write-Warning "chatgpt/instructions.md is $CharCount characters, over the $WarnThreshold-character safety margin (hard limit $HardLimit)."
}

Write-Host "OK: chatgpt/instructions.md is within the Custom GPT Instructions field limit."
