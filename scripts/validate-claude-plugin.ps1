<#
.SYNOPSIS
    Validates the Claude Plugin manifest (claude/plugin/plugin.json) against
    the documented Claude Plugin requirements and the Skill it wraps
    (skills/career-targeting-intelligence/SKILL.md). When the `claude` CLI is available and a built
    plugin directory is passed, also runs `claude plugin validate`.

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

$RepoRoot = Split-Path -Parent $PSScriptRoot
$ManifestFile = Join-Path $RepoRoot "claude\plugin\plugin.json"
$SkillFile = Join-Path $RepoRoot "skills\career-targeting-intelligence\SKILL.md"

foreach ($required in @($ManifestFile, $SkillFile)) {
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
    if (Get-Command claude -ErrorAction SilentlyContinue) {
        & claude plugin validate $BuiltPluginDir
        if ($LASTEXITCODE -ne 0) { Fail "'claude plugin validate' failed for $BuiltPluginDir" }
    } else {
        Write-Warning "'claude' CLI not found; skipping 'claude plugin validate'."
    }
}

Write-Host "OK: Claude Plugin manifest and skill are valid."
