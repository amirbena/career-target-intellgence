<#
.SYNOPSIS
    Packages the Career Targeting Intelligence Claude Plugin into
    dist/career-targeting-intelligence-claude-plugin.zip.

.DESCRIPTION
    Reuses the Claude Skill sources (SKILL.md, references/, templates/) with
    the same allowlist and file list as the Skill ZIP. The plugin root is the
    archive root: .claude-plugin/plugin.json sits at the top level.
    Set $env:RELEASE_VERSION (MAJOR.MINOR.PATCH) to write that version into
    the manifest and the packaged SKILL.md.
    Works when invoked from inside or outside the repository root.
    Logically equivalent to package-claude-plugin.sh.
#>

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Fail {
    param([string]$Message)
    Write-Error "error: $Message"
    exit 1
}

$ReleaseVersion = $env:RELEASE_VERSION
if ($ReleaseVersion -and $ReleaseVersion -notmatch '^\d+\.\d+\.\d+$') {
    Fail "RELEASE_VERSION must be MAJOR.MINOR.PATCH, got: $ReleaseVersion"
}

$RepoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$PluginSrcDir = Join-Path $RepoRoot "claude\plugin"
$SkillSourceDir = Join-Path $RepoRoot "skills\career-targeting-intelligence"
$DistDir = Join-Path $RepoRoot "dist"
$BuildDir = Join-Path $RepoRoot ".build\claude-plugin-package"
$PackageName = "career-targeting-intelligence-claude-plugin"
$SkillName = "career-targeting-intelligence"
$OutputZip = Join-Path $DistDir "$PackageName.zip"

foreach ($v in @("validate-skill-description.ps1", "validate-claude-plugin.ps1")) {
    if (-not (Test-Path -LiteralPath (Join-Path (Join-Path $PSScriptRoot "../validate") $v) -PathType Leaf)) {
        Fail "required validation script not found: $(Join-Path (Join-Path $PSScriptRoot "../validate") $v)"
    }
}
& (Join-Path $PSScriptRoot "../validate/validate-skill-description.ps1")
& (Join-Path $PSScriptRoot "../validate/validate-claude-plugin.ps1")

$PluginManifest = Join-Path $PluginSrcDir "plugin.json"
$SkillMdPath = Join-Path $SkillSourceDir "SKILL.md"
$ReferencesDir = Join-Path $SkillSourceDir "references"
$TemplatesDir = Join-Path $SkillSourceDir "templates"
if (-not (Test-Path -LiteralPath $PluginManifest -PathType Leaf)) { Fail "required file not found: $PluginManifest" }
if (-not (Test-Path -LiteralPath $SkillMdPath -PathType Leaf)) { Fail "required file not found: $SkillMdPath" }
if (-not (Test-Path -LiteralPath $ReferencesDir -PathType Container)) { Fail "required directory not found: $ReferencesDir" }
if (-not (Test-Path -LiteralPath $TemplatesDir -PathType Container)) { Fail "required directory not found: $TemplatesDir" }

# Only remove the dedicated build/staging directory — never an arbitrary path.
if (Test-Path -LiteralPath $BuildDir) {
    Remove-Item -LiteralPath $BuildDir -Recurse -Force
}

$PackageRoot = Join-Path $BuildDir $PackageName
$SkillDir = Join-Path $PackageRoot "skills\$SkillName"
New-Item -ItemType Directory -Path (Join-Path $PackageRoot ".claude-plugin") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $SkillDir "references") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $SkillDir "templates") -Force | Out-Null

# Explicit allowlist copy — never a recursive repository copy.
Copy-Item -LiteralPath $PluginManifest -Destination (Join-Path $PackageRoot ".claude-plugin\plugin.json") -Force
Copy-Item -LiteralPath $SkillMdPath -Destination (Join-Path $SkillDir "SKILL.md") -Force
Copy-Item -Path (Join-Path $ReferencesDir "*.md") -Destination (Join-Path $SkillDir "references") -Force
Copy-Item -Path (Join-Path $TemplatesDir "*.md") -Destination (Join-Path $SkillDir "templates") -Force

# With RELEASE_VERSION set, write it into the manifest and the packaged SKILL.md.
if ($ReleaseVersion) {
    $ManifestOut = Join-Path $PackageRoot ".claude-plugin\plugin.json"
    $Json = [System.IO.File]::ReadAllText($ManifestOut)
    $Json = [regex]::Replace($Json, '(?m)^(  "version": )"[^"]*"', "`${1}`"$ReleaseVersion`"")
    if ($Json -notmatch [regex]::Escape("`"version`": `"$ReleaseVersion`"")) { Fail "could not set version in the packaged plugin.json" }
    [System.IO.File]::WriteAllText($ManifestOut, $Json, (New-Object System.Text.UTF8Encoding($false)))

    $PackagedSkill = Join-Path $SkillDir "SKILL.md"
    $Lines = [System.Collections.Generic.List[string]](((Get-Content -LiteralPath $PackagedSkill -Raw -Encoding UTF8) -replace "`r`n", "`n") -split "`n")
    $End = $Lines.IndexOf("---", 1)
    $Lines.InsertRange($End, [string[]]@("metadata:", "  version: $ReleaseVersion"))
    [System.IO.File]::WriteAllText($PackagedSkill, ($Lines -join "`n"), (New-Object System.Text.UTF8Encoding($false)))
}

& (Join-Path $PSScriptRoot "../validate/validate-claude-plugin.ps1") $PackageRoot | Out-Null

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
# no directory entries are written.
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
$Expected = @(".claude-plugin/plugin.json", "skills/$SkillName/SKILL.md")
Get-ChildItem -LiteralPath $ReferencesDir -Filter "*.md" -File | ForEach-Object { $Expected += "skills/$SkillName/references/$($_.Name)" }
Get-ChildItem -LiteralPath $TemplatesDir -Filter "*.md" -File | ForEach-Object { $Expected += "skills/$SkillName/templates/$($_.Name)" }
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

Write-Host "Packaged Claude Plugin: $OutputZip"
Write-Host ""
Write-Host "Packaged files:"
$Actual | ForEach-Object { Write-Host $_ }
