<#
.SYNOPSIS
    Validates that the `description:` field in claude/skill/SKILL.md's YAML
    frontmatter — the canonical source of the packaged Claude Skill's
    activation-triggering description — stays within the platform's
    character limit.

.DESCRIPTION
    Character count is taken on the YAML-parsed (folded) string value of
    the `description` field, not a raw line/grep count, since YAML block
    scalars fold line breaks and indentation into the final string Claude
    actually reads. Frontmatter is parsed with the same Python-based logic
    as the shell script (via python3), so both platforms agree on the
    count.

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
$SkillFile = Join-Path $RepoRoot "claude\skill\SKILL.md"

$HardLimit = 2400
$WarnThreshold = 2200

if (-not (Get-Command python3 -ErrorAction SilentlyContinue)) {
    Fail "python3 is required but was not found on PATH."
}

if (-not (Test-Path -LiteralPath $SkillFile -PathType Leaf)) {
    Fail "Skill source file not found: $SkillFile"
}

$PythonScript = @'
import re
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    text = f.read()

match = re.match(r"^---\n(.*?\n)---\n", text, re.DOTALL)
if not match:
    print("error: could not locate YAML frontmatter block", file=sys.stderr)
    sys.exit(1)

try:
    import yaml
    data = yaml.safe_load(match.group(1))
except ImportError:
    print("error: PyYAML is required to parse SKILL.md frontmatter (pip install pyyaml)", file=sys.stderr)
    sys.exit(1)

if not isinstance(data, dict) or "description" not in data:
    print("error: no description field found in SKILL.md frontmatter", file=sys.stderr)
    sys.exit(1)

description = data["description"]
print(len(description))
'@

$CharCountRaw = & python3 -c $PythonScript $SkillFile
if ($LASTEXITCODE -ne 0) {
    Fail "failed to parse claude/skill/SKILL.md frontmatter"
}
$CharCount = [int]$CharCountRaw

Write-Host "claude/skill/SKILL.md description: $CharCount characters (hard limit $HardLimit, warn threshold $WarnThreshold)"

if ($CharCount -ge $HardLimit) {
    Fail "claude/skill/SKILL.md description is $CharCount characters, at or over the $HardLimit-character Claude Skill description hard limit. Shorten it before packaging."
}

if ($CharCount -gt $WarnThreshold) {
    Write-Warning "claude/skill/SKILL.md description is $CharCount characters, over the $WarnThreshold-character safety margin (hard limit $HardLimit)."
}

Write-Host "OK: claude/skill/SKILL.md description is within the Claude Skill description limit."
