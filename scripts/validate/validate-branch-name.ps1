<#
.SYNOPSIS
    Validates a branch name against the repository convention (PowerShell
    twin of validate-branch-name.sh).

.DESCRIPTION
    Convention: <type>/<issue-number>-<short-description>, with type one of
    feat, fix, docs, chore, ci, refactor, test and a lowercase kebab-case
    description, e.g. feat/42-codex-marketplace. Only `main` is exempt;
    auto-generated names such as claude/<slug>-<id> must be renamed first. Pure string check.

    Falls back to the BRANCH_NAME environment variable.
    Compatible with Windows PowerShell 5.1 and PowerShell 7+.
#>
param(
    [string]$Branch = $env:BRANCH_NAME
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

if ([string]::IsNullOrEmpty($Branch)) {
    [Console]::Error.WriteLine("error: no branch name given. Pass it as an argument or set BRANCH_NAME.")
    exit 1
}

if ($Branch -ceq "main") {
    Write-Output "ok: '$Branch' is exempt from the branch naming convention."
    exit 0
}

if ($Branch -cmatch '^(feat|fix|docs|chore|ci|refactor|test)/[0-9]+-[a-z0-9]+(-[a-z0-9]+)*$') {
    Write-Output "ok: '$Branch' follows the branch naming convention."
    exit 0
}

[Console]::Error.WriteLine(@"
error: branch name '$Branch' does not follow the convention.

  Expected: <type>/<issue-number>-<short-description>
  Types:    feat, fix, docs, chore, ci, refactor, test
  Example:  fix/38-skip-release-bot

Use lowercase kebab-case after the issue number. Rename the branch with
'git branch -m <new-name>', then push it again. See policies/git-workflow.md.
"@)
exit 1
