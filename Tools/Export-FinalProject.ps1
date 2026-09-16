param(
  [Parameter(Mandatory = $true)]
  [string]$Destination
)

$ErrorActionPreference = "Stop"

$repoRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$destinationPath = [IO.Path]::GetFullPath($Destination)
$repoPrefix = $repoRoot.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar

# Prevent an export from being copied into the source tree and recursively
# including itself. Change the destination handling here if a signed archive
# workflow is added later.
if ($destinationPath.Equals($repoRoot, [StringComparison]::OrdinalIgnoreCase) -or
    $destinationPath.StartsWith($repoPrefix, [StringComparison]::OrdinalIgnoreCase)) {
  throw "Destination must be outside the repository: $destinationPath"
}

if (Test-Path -LiteralPath $destinationPath) {
  throw "Destination already exists; choose a new empty handoff path: $destinationPath"
}

$includedPaths = @(
  "AsianLanguage.xcodeproj",
  "Sources",
  "Tests",
  "Tools",
  "content/release",
  "Resources/Corpus",
  "Resources/Assets/Symbols",
  "Resources/Assets/Collections",
  "Resources/History",
  "Resources/Assets.xcassets",
  "Resources/Fonts",
  "README.md",
  "CONTEXT.md",
  "CURRENT_STEP.md",
  "DECISIONS.md",
  "ROADMAP.md",
  "PROJECT_KIND"
)

New-Item -ItemType Directory -Path $destinationPath -Force | Out-Null

foreach ($relativePath in $includedPaths) {
  $sourcePath = Join-Path $repoRoot $relativePath
  if (-not (Test-Path -LiteralPath $sourcePath)) {
    throw "Required handoff path is missing: $relativePath"
  }

  $targetPath = Join-Path $destinationPath $relativePath
  $targetParent = Split-Path -Parent $targetPath
  New-Item -ItemType Directory -Path $targetParent -Force | Out-Null
  Copy-Item -LiteralPath $sourcePath -Destination $targetPath -Recurse -Force
}

# The active runtime asset directory must contain exactly the symbol folders
# represented by the runtime corpus, plus private staging backgrounds. This
# preserves any suffix that belongs to a current authoritative record while
# excluding unreferenced legacy aliases.
$symbolRoot = Join-Path $destinationPath "Resources/Assets/Symbols"
$symbolFolders = @(Get-ChildItem -LiteralPath $symbolRoot -Directory | Where-Object { $_.Name -notmatch '^_' })
$corpusRoot = Join-Path $destinationPath "Resources/Corpus"
$corpusFolders = @(Get-ChildItem -LiteralPath $corpusRoot -Filter '*.json' -File | ForEach-Object { $_.BaseName })
if ($corpusFolders.Count -ne 126) {
  throw "Expected 126 runtime corpus records, found $($corpusFolders.Count)"
}

$missingAssetFolders = @(Compare-Object -ReferenceObject $corpusFolders -DifferenceObject $symbolFolders.Name -PassThru | Where-Object { $_ -in $corpusFolders })
$orphanAssetFolders = @(Compare-Object -ReferenceObject $corpusFolders -DifferenceObject $symbolFolders.Name -PassThru | Where-Object { $_ -in $symbolFolders.Name })
if ($missingAssetFolders.Count -gt 0 -or $orphanAssetFolders.Count -gt 0) {
  throw "Runtime and asset folder sets differ. Missing: $($missingAssetFolders -join ', '); orphaned: $($orphanAssetFolders -join ', ')"
}

$forbiddenNames = @("Reference Pictures", "artwork_production", "archive")
$forbiddenMatches = foreach ($name in $forbiddenNames) {
  Get-ChildItem -LiteralPath $destinationPath -Directory -Recurse -Force | Where-Object { $_.Name -eq $name }
}
if ($forbiddenMatches) {
  throw "Excluded folders were copied into the handoff: $($forbiddenMatches.FullName -join ', ')"
}

Write-Output "Final project exported to: $destinationPath"
Write-Output "Active symbol folders and runtime records: $($symbolFolders.Count)"
Write-Output "Excluded research/archive folders: verified absent"
