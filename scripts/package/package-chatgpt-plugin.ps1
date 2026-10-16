<#
.SYNOPSIS
    Packages the Career Targeting Intelligence ChatGPT Plugin into
    dist/career-targeting-intelligence-chatgpt-plugin.zip.

.DESCRIPTION
    Validates the manifest and skill, runs the Knowledge builder, then
    assembles a skills-only plugin using an explicit allowlist. The plugin
    root is the archive root: plugin.json sits at the top level of the zip.

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

$RepoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$ChatGptDir = Join-Path $RepoRoot "chatgpt"
$PluginSrcDir = Join-Path $ChatGptDir "plugin"
$KnowledgeDir = Join-Path $ChatGptDir "knowledge"

$DistDir = Join-Path $RepoRoot "dist"
$BuildDir = Join-Path $RepoRoot ".build\chatgpt-plugin-package"
$PackageName = "career-targeting-intelligence-chatgpt-plugin"
$SkillName = "career-targeting-intelligence"
$OutputZip = Join-Path $DistDir "$PackageName.zip"

# Validate the manifest and skill against the plugin limits before packaging.
$Validator = Join-Path $PSScriptRoot "../validate/validate-chatgpt-plugin.ps1"
if (-not (Test-Path -LiteralPath $Validator -PathType Leaf)) {
    Fail "required validation script not found: $Validator"
}
& $Validator

$PluginManifest = Join-Path $PluginSrcDir "plugin.json"
$SkillFile = Join-Path $PluginSrcDir "SKILL.md"
$CapabilityPolicy = Join-Path $ChatGptDir "capability-policy.md"
foreach ($required in @($PluginManifest, $SkillFile, $CapabilityPolicy)) {
    if (-not (Test-Path -LiteralPath $required -PathType Leaf)) {
        Fail "required file not found: $required"
    }
}

# Build the reference bundles first — the archive embeds their output unchanged.
$KnowledgeBuilder = Join-Path $PSScriptRoot "build-chatgpt-knowledge.ps1"
if (-not (Test-Path -LiteralPath $KnowledgeBuilder -PathType Leaf)) {
    Fail "required build script not found: $KnowledgeBuilder"
}
& $KnowledgeBuilder | Out-Null

$KnowledgeFiles = @(
    "01-product-and-terminology.md", "02-candidate-and-search.md", "03-company-intelligence.md",
    "04-people-and-activity.md", "05-ranking-and-exclusions.md", "06-workflow-and-state.md",
    "07-evidence-confidence-freshness.md", "08-output-contracts.md", "09-job-and-company-state.md"
)
foreach ($kf in $KnowledgeFiles) {
    $kfPath = Join-Path $KnowledgeDir $kf
    if (-not (Test-Path -LiteralPath $kfPath -PathType Leaf)) {
        Fail "Knowledge build did not produce: $kfPath"
    }
}

# Only remove the dedicated build/staging directory — never an arbitrary path.
if (Test-Path -LiteralPath $BuildDir) {
    Remove-Item -LiteralPath $BuildDir -Recurse -Force
}

$PackageRoot = Join-Path $BuildDir $PackageName
$SkillDir = Join-Path $PackageRoot "skills\$SkillName"
New-Item -ItemType Directory -Path (Join-Path $SkillDir "references") -Force | Out-Null

# Explicit allowlist copy — never a recursive repository copy.
Copy-Item -LiteralPath $PluginManifest -Destination (Join-Path $PackageRoot "plugin.json") -Force
# With RELEASE_VERSION set, write it into the packaged manifest's version field.
if ($env:RELEASE_VERSION) {
    if ($env:RELEASE_VERSION -notmatch '^\d+\.\d+\.\d+$') {
        Fail "RELEASE_VERSION must be MAJOR.MINOR.PATCH, got: $($env:RELEASE_VERSION)"
    }
    $ManifestOut = Join-Path $PackageRoot "plugin.json"
    $Json = [System.IO.File]::ReadAllText($ManifestOut)
    $Json = [regex]::Replace($Json, '(?m)^(  "version": )"[^"]*"', "`${1}`"$($env:RELEASE_VERSION)`"")
    if ($Json -notmatch [regex]::Escape("`"version`": `"$($env:RELEASE_VERSION)`"")) { Fail "could not set version in the packaged plugin.json" }
    [System.IO.File]::WriteAllText($ManifestOut, $Json, (New-Object System.Text.UTF8Encoding($false)))
}
Copy-Item -LiteralPath $SkillFile -Destination (Join-Path $SkillDir "SKILL.md") -Force
Copy-Item -LiteralPath $CapabilityPolicy -Destination (Join-Path $SkillDir "references\capability-policy.md") -Force
foreach ($kf in $KnowledgeFiles) {
    Copy-Item -LiteralPath (Join-Path $KnowledgeDir $kf) -Destination (Join-Path $SkillDir "references\$kf") -Force
}

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

# Build the archive entry by entry so paths are forward-slash normalized and
# no directory entries are written (Windows PowerShell 5.1's
# CreateFromDirectory emits backslash paths).
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$PackageRootFull = (Resolve-Path -LiteralPath $PackageRoot).Path.TrimEnd('\', '/')
$Zip = [System.IO.Compression.ZipFile]::Open($OutputZip, [System.IO.Compression.ZipArchiveMode]::Create)
try {
    Get-ChildItem -LiteralPath $PackageRoot -Recurse -Force -File | Sort-Object FullName | ForEach-Object {
        $entryName = $_.FullName.Substring($PackageRootFull.Length + 1).Replace('\', '/')
        [void][System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
            $Zip, $_.FullName, $entryName, [System.IO.Compression.CompressionLevel]::Optimal)
    }
} finally {
    $Zip.Dispose()
}

Remove-Item -LiteralPath $BuildDir -Recurse -Force

if (-not (Test-Path -LiteralPath $OutputZip -PathType Leaf)) {
    Fail "packaging failed: $OutputZip was not created"
}

# Verify the archive holds exactly the allowlisted, normalized paths.
$Expected = @("plugin.json", "skills/$SkillName/SKILL.md", "skills/$SkillName/references/capability-policy.md")
foreach ($kf in $KnowledgeFiles) { $Expected += "skills/$SkillName/references/$kf" }
$Expected = $Expected | Sort-Object { $_ } -CaseSensitive

$Archive = [System.IO.Compression.ZipFile]::OpenRead($OutputZip)
try {
    $Actual = @($Archive.Entries | ForEach-Object { $_.FullName } | Sort-Object { $_ } -CaseSensitive)
} finally {
    $Archive.Dispose()
}
if (($Expected -join "`n") -ne ($Actual -join "`n")) {
    Fail "archive contents do not match the allowlist. Expected:`n$($Expected -join "`n")`nActual:`n$($Actual -join "`n")"
}

Write-Host "Packaged ChatGPT Plugin: $OutputZip"
Write-Host ""
Write-Host "Packaged files:"
$Actual | ForEach-Object { Write-Host $_ }
