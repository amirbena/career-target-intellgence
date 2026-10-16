<#
.SYNOPSIS
    Validates the ChatGPT Plugin sources against the documented OpenAI plugin
    submission limits: chatgpt/plugin/plugin.json (manifest) and
    chatgpt/plugin/SKILL.md (skill frontmatter).

.DESCRIPTION
    Character counts use .NET string length on the UTF-8-decoded text
    (character count, not byte count).

    This is a skills-only plugin: the manifest must not declare apps, hooks,
    or MCP servers, which are out of scope for this package.

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
$ManifestFile = Join-Path $RepoRoot "chatgpt\plugin\plugin.json"
$SkillFile = Join-Path $RepoRoot "chatgpt\plugin\SKILL.md"

if (-not (Test-Path -LiteralPath $ManifestFile -PathType Leaf)) { Fail "plugin manifest not found: $ManifestFile" }
if (-not (Test-Path -LiteralPath $SkillFile -PathType Leaf)) { Fail "skill file not found: $SkillFile" }

$Errors = New-Object System.Collections.Generic.List[string]

function Has-Prop {
    param($Obj, [string]$Name)
    return ($null -ne $Obj) -and ($null -ne $Obj.PSObject.Properties[$Name])
}

function Check-Text {
    param($Obj, [string]$Key, [string]$Label, [int]$Limit)
    if (-not (Has-Prop $Obj $Key)) { $Errors.Add("$Label is required"); return $null }
    $value = $Obj.$Key
    if (-not ($value -is [string]) -or $value.Trim() -eq "") { $Errors.Add("$Label must be a non-empty string"); return $null }
    if ($value.Length -gt $Limit) { $Errors.Add("$Label is $($value.Length) characters, over the $Limit-character limit") }
    return $value
}

try {
    $Manifest = Get-Content -LiteralPath $ManifestFile -Raw -Encoding UTF8 | ConvertFrom-Json
} catch {
    Fail "plugin.json is not valid JSON: $($_.Exception.Message)"
}

$Name = Check-Text $Manifest "name" "name" 64
if ($Name -and ($Name -cnotmatch '^[a-z0-9]+(-[a-z0-9]+)*$')) {
    $Errors.Add("name must use lowercase letters, numbers, and single hyphens")
}
$Version = if (Has-Prop $Manifest "version") { $Manifest.version } else { $null }
if (-not ($Version -is [string]) -or ($Version -notmatch '^\d+\.\d+\.\d+$')) {
    $Errors.Add("version must be an explicit semantic version (MAJOR.MINOR.PATCH)")
}
$Description = Check-Text $Manifest "description" "description" 4000

if ((Has-Prop $Manifest "author")) { [void](Check-Text $Manifest.author "name" "author.name" 120) }
if (Has-Prop $Manifest "mcpServers") { $Errors.Add("mcpServers must not be declared (skills-only plugin)") }

$OpenAi = $null
if ((Has-Prop $Manifest "extensions") -and (Has-Prop $Manifest.extensions "com.openai")) {
    $OpenAi = $Manifest.extensions.PSObject.Properties["com.openai"].Value
}
if (Has-Prop $OpenAi "apps") { $Errors.Add("extensions.com.openai.apps must not be declared (out of scope)") }
if (Has-Prop $OpenAi "hooks") { $Errors.Add("extensions.com.openai.hooks must not be declared (out of scope)") }

if (-not (Has-Prop $OpenAi "interface")) {
    $Errors.Add("extensions.com.openai.interface is required")
} else {
    $Interface = $OpenAi.interface
    [void](Check-Text $Interface "displayName" "interface.displayName" 30)
    [void](Check-Text $Interface "shortDescription" "interface.shortDescription" 30)
    [void](Check-Text $Interface "longDescription" "interface.longDescription" 4000)
    [void](Check-Text $Interface "developerName" "interface.developerName" 80)
    $Prompts = @()
    if (Has-Prop $Interface "defaultPrompt") { $Prompts = @($Interface.defaultPrompt) }
    if ($Prompts.Count -gt 3) { $Errors.Add("interface.defaultPrompt allows at most 3 prompts") }
    if (@($Prompts | Select-Object -Unique).Count -ne $Prompts.Count) { $Errors.Add("interface.defaultPrompt entries must be unique") }
    for ($i = 0; $i -lt $Prompts.Count; $i++) {
        $p = $Prompts[$i]
        if (-not ($p -is [string]) -or $p.Length -gt 128) { $Errors.Add("interface.defaultPrompt[$i] must be a string of at most 128 characters") }
        elseif ($p.Contains("@")) { $Errors.Add("interface.defaultPrompt[$i] must not include app @mentions") }
    }
}

$Skill = Get-Content -LiteralPath $SkillFile -Raw -Encoding UTF8
$Skill = $Skill -replace "`r`n", "`n"
$Fm = [regex]::Match($Skill, '(?s)^---\n(.*?)\n---\n')
if (-not $Fm.Success) {
    $Errors.Add("SKILL.md must begin with YAML frontmatter")
} else {
    $SkillName = [regex]::Match($Fm.Groups[1].Value, '(?m)^name:\s*(\S.*)$')
    $SkillDesc = [regex]::Match($Fm.Groups[1].Value, '(?m)^description:\s*(\S.*)$')
    if (-not $SkillName.Success) { $Errors.Add("SKILL.md frontmatter requires name") }
    if (-not $SkillDesc.Success) { $Errors.Add("SKILL.md frontmatter requires description") }
    if ($SkillName.Success -and $Name -and ($SkillName.Groups[1].Value.Trim() -ne $Name)) {
        $Errors.Add("SKILL.md name must match the plugin manifest name")
    }
}

if ($Errors.Count -gt 0) {
    foreach ($e in $Errors) { [Console]::Error.WriteLine("error: $e") }
    exit 1
}

Write-Host "plugin.json: valid ($($Description.Length)-character description)"
Write-Host "SKILL.md: valid frontmatter ($($Skill.Length) characters)"
Write-Host "OK: ChatGPT Plugin manifest and skill are within the documented limits."
