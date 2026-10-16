<#
.SYNOPSIS
    Verifies that the version embedded in every published archive in dist/
    equals the given release version (the GitHub Release tag without "v").
    Logically equivalent to verify-archive-versions.sh.

.EXAMPLE
    .\scripts\validate\verify-archive-versions.ps1 -Version 1.2.0
#>
param(
    [Parameter(Mandatory = $true)][string]$Version,
    [string]$DistDir = "",
    [string[]]$Only = @()
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$RepoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if (-not $DistDir) { $DistDir = Join-Path $RepoRoot "dist" }
$Version = $Version.TrimStart("v")

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$Errors = @()

function Read-Entry {
    param($Archive, [string]$Name)
    $entry = $Archive.GetEntry($Name)
    if (-not $entry) { throw "entry not found: $Name" }
    $reader = New-Object System.IO.StreamReader($entry.Open(), [System.Text.Encoding]::UTF8)
    try { return $reader.ReadToEnd() } finally { $reader.Dispose() }
}

function Get-SkillVersion {
    param([string]$Text)
    $Text = $Text -replace "`r`n", "`n"
    if ($Text -match '(?s)^---\n(.*?)\n---\n') {
        $fm = $Matches[1] + "`n"
        if ($fm -match '(?m)^metadata:\n(?:[ \t]+.*\n)*?[ \t]+version:\s*(\S+)') { return $Matches[1] }
    }
    return $null
}

function Test-Version {
    param([string]$Label, $Found)
    if ($Found -ne $Version) {
        $script:Errors += "${Label}: found '$Found', expected '$Version'"
    } else {
        Write-Host "ok: $Label = $Found"
    }
}

function Open-Archive {
    param([string]$Name)
    if ($Only.Count -gt 0 -and $Only -notcontains $Name) { return $null }
    $path = Join-Path $DistDir $Name
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        $script:Errors += "${Name}: archive not found in $DistDir"
        return $null
    }
    return [System.IO.Compression.ZipFile]::OpenRead($path)
}

$a = Open-Archive "career-targeting-intelligence.skill.zip"
if ($a) {
    try { Test-Version "skill zip SKILL.md" (Get-SkillVersion (Read-Entry $a "career-targeting-intelligence/SKILL.md")) } finally { $a.Dispose() }
}

$a = Open-Archive "career-targeting-intelligence-claude-kit.zip"
if ($a) {
    try {
        $root = "career-targeting-intelligence-claude-kit/"
        Test-Version "claude kit VERSION" ((Read-Entry $a "${root}VERSION").Trim())
        $innerEntry = $a.GetEntry("${root}skill/career-targeting-intelligence.skill.zip")
        $ms = New-Object System.IO.MemoryStream
        $s = $innerEntry.Open(); $s.CopyTo($ms); $s.Dispose()
        $inner = New-Object System.IO.Compression.ZipArchive($ms)
        try { Test-Version "claude kit embedded skill SKILL.md" (Get-SkillVersion (Read-Entry $inner "career-targeting-intelligence/SKILL.md")) } finally { $inner.Dispose() }
    } finally { $a.Dispose() }
}

$a = Open-Archive "career-targeting-intelligence-claude-plugin.zip"
if ($a) {
    try {
        Test-Version "claude plugin manifest" ((Read-Entry $a ".claude-plugin/plugin.json") | ConvertFrom-Json).version
        Test-Version "claude plugin SKILL.md" (Get-SkillVersion (Read-Entry $a "skills/career-targeting-intelligence/SKILL.md"))
    } finally { $a.Dispose() }
}

$a = Open-Archive "career-targeting-intelligence-chatgpt-plugin.zip"
if ($a) {
    try { Test-Version "chatgpt plugin manifest" ((Read-Entry $a "plugin.json") | ConvertFrom-Json).version } finally { $a.Dispose() }
}

if ($Errors.Count -gt 0) {
    $Errors | ForEach-Object { Write-Error "error: $_" -ErrorAction Continue }
    exit 1
}
