<#
.SYNOPSIS
    Validates the Claude Plugin manifest (claude/plugin/plugin.json) against
    the documented Claude Plugin requirements, the marketplace manifest
    (.claude-plugin/marketplace.json: syntax, fields, paths, version
    consistency), and the Skill it wraps
    (skills/career-targeting-intelligence/SKILL.md). When a built plugin
    directory is passed, also checks its layout. It does not invoke the
    `claude` CLI; installing/updating in Claude is a manual check.

.DESCRIPTION
    Works when invoked from inside or outside the repository root.
    Logically equivalent to validate-claude-plugin.sh.
#>
param([string]$BuiltPluginDir = "")

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Fail {
    param([string]$Message)
    Write-Error "error: $Message"
    exit 1
}

$RepoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$ManifestFile = Join-Path $RepoRoot "claude\plugin\plugin.json"
$SkillFile = Join-Path $RepoRoot "skills\career-targeting-intelligence\SKILL.md"
$MarketplaceFile = Join-Path $RepoRoot ".claude-plugin\marketplace.json"

foreach ($required in @($ManifestFile, $SkillFile, $MarketplaceFile)) {
    if (-not (Test-Path -LiteralPath $required -PathType Leaf)) { Fail "required file not found: $required" }
}

try {
    $Manifest = Get-Content -LiteralPath $ManifestFile -Raw -Encoding UTF8 | ConvertFrom-Json
} catch {
    Fail "plugin.json is not valid JSON: $($_.Exception.Message)"
}

$Errors = @()
$Props = @($Manifest.PSObject.Properties.Name)
if ($Props -notcontains "name" -or $Manifest.name -notmatch '^[a-z0-9]+(-[a-z0-9]+)*$') { $Errors += "name must be kebab-case" }
if ($Props -notcontains "version" -or $Manifest.version -notmatch '^\d+\.\d+\.\d+$') { $Errors += "version must be MAJOR.MINOR.PATCH" }
if ($Props -notcontains "description" -or [string]::IsNullOrWhiteSpace($Manifest.description)) { $Errors += "description must be a non-empty string" }
foreach ($forbidden in @("hooks", "mcpServers", "commands", "agents")) {
    if ($Props -contains $forbidden) { $Errors += "manifest must not declare '$forbidden' (skills-only plugin)" }
}

try {
    $Market = Get-Content -LiteralPath $MarketplaceFile -Raw -Encoding UTF8 | ConvertFrom-Json
} catch {
    Fail "marketplace.json is not valid JSON: $($_.Exception.Message)"
}
if ($Market.name -notmatch '^[a-z0-9]+(-[a-z0-9]+)*$') { $Errors += "marketplace name must be kebab-case" }
if (-not $Market.owner -or -not $Market.owner.name) { $Errors += "marketplace owner.name is required" }
$Entries = @($Market.plugins)
if ($Entries.Count -eq 0) { $Errors += "marketplace plugins must be a non-empty list" }
$Entry = $null
foreach ($p in $Entries) {
    if ($p.name -eq $Manifest.name) { $Entry = $p }
    if (-not ($p.source -is [string])) { $Errors += "plugin entry '$($p.name)' needs a string source" }
    elseif (-not (Test-Path -LiteralPath (Join-Path $RepoRoot $p.source) -PathType Container)) { $Errors += "source path not found: $($p.source)" }
    foreach ($sk in @($p.skills)) {
        if ($sk -and -not (Test-Path -LiteralPath (Join-Path (Join-Path $RepoRoot $sk) "SKILL.md") -PathType Leaf)) { $Errors += "skills path has no SKILL.md: $sk" }
    }
}
if (-not $Entry) { $Errors += "marketplace.json has no entry matching the plugin name" }
elseif ($Entry.version -ne $Manifest.version) { $Errors += "marketplace.json plugin version must equal plugin.json version" }

$Skill = (Get-Content -LiteralPath $SkillFile -Raw -Encoding UTF8) -replace "`r`n", "`n"
if ($Skill -notmatch '(?s)^---\n(.*?)\n---\n') {
    $Errors += "SKILL.md must start with YAML frontmatter"
} else {
    $Frontmatter = $Matches[1]
    if ($Frontmatter -match '(?m)^name:\s*(\S.*?)\s*$') {
        if ($Matches[1] -ne $Manifest.name) { $Errors += "SKILL.md name must match the plugin manifest name" }
    } else {
        $Errors += "SKILL.md must declare name"
    }
}

if ($Errors.Count -gt 0) {
    $Errors | ForEach-Object { Write-Error "error: $_" -ErrorAction Continue }
    exit 1
}
Write-Host "plugin.json: valid"

if ($BuiltPluginDir) {
    foreach ($rel in @(".claude-plugin\plugin.json", "skills\career-targeting-intelligence\SKILL.md")) {
        if (-not (Test-Path -LiteralPath (Join-Path $BuiltPluginDir $rel) -PathType Leaf)) { Fail "built plugin is missing $rel`: $BuiltPluginDir" }
    }
    try { Get-Content -LiteralPath (Join-Path $BuiltPluginDir ".claude-plugin\plugin.json") -Raw | ConvertFrom-Json | Out-Null }
    catch { Fail "built plugin.json is not valid JSON" }
}

Write-Host "OK: Claude Plugin manifest and skill are valid."
