<#
.SYNOPSIS
    Packages the Career Targeting Intelligence External Self-Install Kit
    into dist/career-targeting-intelligence-claude-kit.zip.

.DESCRIPTION
    The kit bundles the built Skill ZIP, the canonical compact Project
    Instructions (copied byte-for-byte as project-instructions.md), a fixed
    allowlist of shared-methodology Knowledge files, and the external
    installation documentation. It never contains personal data, Golden
    Journey content, or repository-development files.

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
$ExternalInstallDir = Join-Path $RepoRoot "claude\external-install"
$ProjectInstructionsCompact = Join-Path $RepoRoot "claude\project-instructions.compact.md"
$CoreDir = Join-Path $RepoRoot "core"
$RankingDir = Join-Path $RepoRoot "ranking"

$DistDir = Join-Path $RepoRoot "dist"
$BuildDir = Join-Path $RepoRoot ".build\claude-external-kit-package"
$PackageName = "career-targeting-intelligence-claude-kit"
$OutputZip = Join-Path $DistDir "$PackageName.zip"

$SkillZipName = "career-targeting-intelligence.skill.zip"
$SkillZipPath = Join-Path $DistDir $SkillZipName

# Required external-install documentation.
$RequiredDocs = @(
    "README.md", "installation-checklist.md", "knowledge-files.md",
    "conversation-starters.md", "verification-guide.md", "privacy-guide.md"
)
foreach ($doc in $RequiredDocs) {
    $docPath = Join-Path $ExternalInstallDir $doc
    if (-not (Test-Path -LiteralPath $docPath -PathType Leaf)) {
        Fail "required file not found: $docPath"
    }
}

if (-not (Test-Path -LiteralPath $ProjectInstructionsCompact -PathType Leaf)) {
    Fail "required file not found: $ProjectInstructionsCompact"
}

# Required canonical Knowledge sources — explicit allowlist, source path -> deployed name.
$KnowledgeFiles = @(
    @{ Source = Join-Path $CoreDir "product-definition.md"; Dest = "product-definition.md" },
    @{ Source = Join-Path $CoreDir "data-model.md"; Dest = "data-model.md" },
    @{ Source = Join-Path $CoreDir "workflow.md"; Dest = "workflow.md" },
    @{ Source = Join-Path $CoreDir "source-policy.md"; Dest = "source-policy.md" },
    @{ Source = Join-Path $CoreDir "confidence-model.md"; Dest = "confidence-model.md" },
    @{ Source = Join-Path $CoreDir "freshness-policy.md"; Dest = "freshness-policy.md" },
    @{ Source = Join-Path $CoreDir "quality-gates.md"; Dest = "quality-gates.md" },
    @{ Source = Join-Path $CoreDir "output-contracts.md"; Dest = "output-contracts.md" },
    @{ Source = Join-Path $RankingDir "company-ranking-model.md"; Dest = "company-ranking-model.md" },
    @{ Source = Join-Path $RankingDir "person-ranking-model.md"; Dest = "person-ranking-model.md" },
    @{ Source = Join-Path $RankingDir "exclusion-policy.md"; Dest = "exclusion-policy.md" },
    @{ Source = Join-Path $RankingDir "outreach-priority-model.md"; Dest = "outreach-priority-model.md" }
)

foreach ($file in $KnowledgeFiles) {
    if (-not (Test-Path -LiteralPath $file.Source -PathType Leaf)) {
        Fail "required Knowledge source not found: $($file.Source)"
    }
}

# Build the Skill ZIP first — the external kit embeds it unchanged.
$SkillPackager = Join-Path $PSScriptRoot "package-claude-skill.ps1"
if (-not (Test-Path -LiteralPath $SkillPackager -PathType Leaf)) {
    Fail "required packaging script not found: $SkillPackager"
}
& $SkillPackager | Out-Null
if (-not (Test-Path -LiteralPath $SkillZipPath -PathType Leaf)) {
    Fail "Skill packaging did not produce: $SkillZipPath"
}

# Only remove the dedicated build/staging directory — never an arbitrary path.
if (Test-Path -LiteralPath $BuildDir) {
    Remove-Item -LiteralPath $BuildDir -Recurse -Force
}

$PackageRoot = Join-Path $BuildDir $PackageName
New-Item -ItemType Directory -Path (Join-Path $PackageRoot "skill") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $PackageRoot "knowledge") -Force | Out-Null

# Explicit allowlist copy — never a recursive repository copy.
foreach ($doc in $RequiredDocs) {
    Copy-Item -LiteralPath (Join-Path $ExternalInstallDir $doc) -Destination (Join-Path $PackageRoot $doc) -Force
}

# Canonical compact instructions, copied byte-for-byte — never a separately maintained fork.
Copy-Item -LiteralPath $ProjectInstructionsCompact -Destination (Join-Path $PackageRoot "project-instructions.md") -Force

# The built Skill ZIP, embedded unchanged.
Copy-Item -LiteralPath $SkillZipPath -Destination (Join-Path $PackageRoot "skill\$SkillZipName") -Force

# The fixed Knowledge allowlist, each copied byte-for-byte with a stable deployment name.
foreach ($file in $KnowledgeFiles) {
    Copy-Item -LiteralPath $file.Source -Destination (Join-Path $PackageRoot "knowledge\$($file.Dest)") -Force
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

Write-Host "Packaged Claude external kit: $OutputZip"
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
