<#
.SYNOPSIS
    Packages the Career Targeting Intelligence Claude Skill into
    dist/career-targeting-intelligence.skill.zip using an explicit file
    allowlist (SKILL.md, references/, templates/).

.DESCRIPTION
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
$SkillSourceDir = Join-Path $RepoRoot "claude\skill"
$DistDir = Join-Path $RepoRoot "dist"
$BuildDir = Join-Path $RepoRoot ".build\claude-skill-package"
$PackageName = "career-targeting-intelligence"
$OutputZip = Join-Path $DistDir "$PackageName.skill.zip"

$SkillMdPath = Join-Path $SkillSourceDir "SKILL.md"
$ReferencesDir = Join-Path $SkillSourceDir "references"
$TemplatesDir = Join-Path $SkillSourceDir "templates"

if (-not (Test-Path -LiteralPath $SkillMdPath -PathType Leaf)) {
    Fail "required file not found: $SkillMdPath"
}
if (-not (Test-Path -LiteralPath $ReferencesDir -PathType Container)) {
    Fail "required directory not found: $ReferencesDir"
}
if (-not (Test-Path -LiteralPath $TemplatesDir -PathType Container)) {
    Fail "required directory not found: $TemplatesDir"
}

# Only remove the dedicated build/staging directory — never an arbitrary path.
if (Test-Path -LiteralPath $BuildDir) {
    Remove-Item -LiteralPath $BuildDir -Recurse -Force
}

$PackageRoot = Join-Path $BuildDir $PackageName
New-Item -ItemType Directory -Path (Join-Path $PackageRoot "references") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $PackageRoot "templates") -Force | Out-Null

# Explicit allowlist copy — never a recursive repository copy.
Copy-Item -LiteralPath $SkillMdPath -Destination (Join-Path $PackageRoot "SKILL.md") -Force
Copy-Item -Path (Join-Path $ReferencesDir "*.md") -Destination (Join-Path $PackageRoot "references") -Force
Copy-Item -Path (Join-Path $TemplatesDir "*.md") -Destination (Join-Path $PackageRoot "templates") -Force

# Strip platform artifacts if any slipped in via the source tree.
Get-ChildItem -LiteralPath $BuildDir -Recurse -Force -File |
    Where-Object { $_.Name -eq ".DS_Store" -or $_.Name -eq "Thumbs.db" } |
    Remove-Item -Force -ErrorAction SilentlyContinue

Get-ChildItem -LiteralPath $BuildDir -Recurse -Force -Directory |
    Where-Object { $_.Name -eq "__MACOSX" } |
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

if (-not (Test-Path -LiteralPath $DistDir)) {
    New-Item -ItemType Directory -Path $DistDir -Force | Out-Null
}
if (Test-Path -LiteralPath $OutputZip) {
    Remove-Item -LiteralPath $OutputZip -Force
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory(
    $BuildDir,
    $OutputZip,
    [System.IO.Compression.CompressionLevel]::Optimal,
    $false
)

Remove-Item -LiteralPath $BuildDir -Recurse -Force

if (-not (Test-Path -LiteralPath $OutputZip -PathType Leaf)) {
    Fail "packaging failed: $OutputZip was not created"
}

Write-Host "Packaged Claude Skill: $OutputZip"
Write-Host ""
Write-Host "Packaged files:"

Add-Type -AssemblyName System.IO.Compression.FileSystem
$Archive = [System.IO.Compression.ZipFile]::OpenRead($OutputZip)
try {
    $Archive.Entries |
        Where-Object { -not $_.FullName.EndsWith("/") } |
        ForEach-Object { $_.FullName } |
        Sort-Object
} finally {
    $Archive.Dispose()
}
