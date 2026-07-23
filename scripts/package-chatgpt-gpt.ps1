<#
.SYNOPSIS
    Packages the Career Targeting Intelligence ChatGPT Custom GPT deployment
    archive into dist/career-targeting-intelligence-chatgpt.zip.

.DESCRIPTION
    Runs the Knowledge builder first, then assembles the archive around its
    output plus the deployment documentation, using an explicit allowlist.

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
$ChatGptDir = Join-Path $RepoRoot "chatgpt"
$KnowledgeDir = Join-Path $ChatGptDir "knowledge"

$DistDir = Join-Path $RepoRoot "dist"
$BuildDir = Join-Path $RepoRoot ".build\chatgpt-gpt-package"
$PackageName = "career-targeting-intelligence-chatgpt"
$OutputZip = Join-Path $DistDir "$PackageName.zip"

# Required deployment documentation.
$Docs = @(
    "README.md", "instructions.md", "builder-config.md", "conversation-starters.md",
    "builder-setup.md", "capability-policy.md", "testing-guide.md",
    "sharing-and-publishing.md", "knowledge-manifest.md"
)
foreach ($doc in $Docs) {
    $docPath = Join-Path $ChatGptDir $doc
    if (-not (Test-Path -LiteralPath $docPath -PathType Leaf)) {
        Fail "required file not found: $docPath"
    }
}

# Build the Knowledge bundles first — the archive embeds their output unchanged.
$KnowledgeBuilder = Join-Path $PSScriptRoot "build-chatgpt-knowledge.ps1"
if (-not (Test-Path -LiteralPath $KnowledgeBuilder -PathType Leaf)) {
    Fail "required build script not found: $KnowledgeBuilder"
}
& $KnowledgeBuilder | Out-Null

$KnowledgeFiles = @(
    "01-product-and-terminology.md", "02-candidate-and-search.md", "03-company-intelligence.md",
    "04-people-and-activity.md", "05-ranking-and-exclusions.md", "06-workflow-and-state.md",
    "07-evidence-confidence-freshness.md", "08-output-contracts.md"
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
New-Item -ItemType Directory -Path (Join-Path $PackageRoot "knowledge") -Force | Out-Null

# Explicit allowlist copy — never a recursive repository copy.
foreach ($doc in $Docs) {
    Copy-Item -LiteralPath (Join-Path $ChatGptDir $doc) -Destination (Join-Path $PackageRoot $doc) -Force
}
foreach ($kf in $KnowledgeFiles) {
    Copy-Item -LiteralPath (Join-Path $KnowledgeDir $kf) -Destination (Join-Path $PackageRoot "knowledge\$kf") -Force
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

Write-Host "Packaged ChatGPT Custom GPT: $OutputZip"
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
