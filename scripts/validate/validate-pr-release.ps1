<#
.SYNOPSIS
    Validates a pull request's release classification (PowerShell twin of
    validate-pr-release.sh).

.DESCRIPTION
    Pure string checks: never calculates a version, edits CHANGELOG.md,
    tags, or releases. Rules: exactly one `release: major|minor|patch|none`
    label; the label is not lower than the PR title's Conventional Commit
    type implies (`!` or a BREAKING CHANGE footer -> major, feat -> minor,
    fix -> patch; a higher label is allowed); `release: major` requires a
    `!` or BREAKING CHANGE marker.

    Labels are comma- or newline-separated. Falls back to the PR_TITLE,
    PR_LABELS, and PR_BODY environment variables.
    Compatible with Windows PowerShell 5.1 and PowerShell 7+.
#>
param(
    [string]$Title = $env:PR_TITLE,
    [string]$Labels = $env:PR_LABELS,
    [string]$Body = $env:PR_BODY
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Fail {
    param([string]$Message)
    [Console]::Error.WriteLine("error: $Message")
    exit 1
}

$rank = @{ none = 0; patch = 1; minor = 2; major = 3 }

$found = @()
foreach ($l in ($Labels -split "[,\r\n]")) {
    $label = $l.Trim()
    if ($label.StartsWith("release: ")) {
        $level = $label.Substring(9)
        if (-not $rank.ContainsKey($level)) {
            Fail "unknown release label '$label'. Use release: major, minor, patch, or none."
        }
        $found += $level
    }
}
if ($found.Count -eq 0) { Fail "no release label. Add exactly one of: release: major, release: minor, release: patch, release: none." }
if ($found.Count -gt 1) { Fail "found $($found.Count) release labels. Keep exactly one." }
$level = $found[0]

$floor = "none"; $breaking = $false
if ($Title -cmatch '^([a-z]+)(\([^)]*\))?(!)?: .+$') {
    if ($Matches[3]) { $breaking = $true }
    if ($Matches[1] -ceq "feat") { $floor = "minor" }
    elseif ($Matches[1] -ceq "fix") { $floor = "patch" }
}
if ($Body -match '(?m)^BREAKING[ -]CHANGE:') { $breaking = $true }
if ($breaking) { $floor = "major" }

if ($rank[$level] -lt $rank[$floor]) {
    Fail "label 'release: $level' is lower than the title implies ('release: $floor'). Fix the label, or retitle the PR (for example docs: instead of feat:)."
}
if ($level -eq "major" -and -not $breaking) {
    Fail "'release: major' needs a breaking-change marker: '!' after the title type or a 'BREAKING CHANGE:' footer in the PR description."
}

Write-Output "ok: release: $level"
