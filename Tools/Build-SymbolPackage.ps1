param(
  [string]$SymbolsPath = "docs/archive/legacy-pilot/symbols",
  [string]$CorpusDestination = "docs/archive/legacy-pilot/bundled-assets/Corpus",
  [string]$BundleAssetDestination = "docs/archive/legacy-pilot/bundled-assets/Symbols",
  [string]$V1ManifestPath = "docs/archive/legacy-pilot/no-active-v1-manifest.json"
)

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$symbolsRoot = Join-Path $repoRoot $SymbolsPath
$corpusDestinationPath = Join-Path $repoRoot $CorpusDestination
$bundleAssetRoot = Join-Path $repoRoot $BundleAssetDestination
$workspaceValidator = Join-Path $PSScriptRoot "Validate-SymbolWorkspace.ps1"
$syncScript = Join-Path $PSScriptRoot "Sync-Corpus.ps1"

& $workspaceValidator -SymbolsPath $SymbolsPath -V1ManifestPath $V1ManifestPath
if ($LASTEXITCODE -ne 0) {
  Write-Error "Symbol workspace validation failed; offline package was not built."
  exit 1
}

& $syncScript -SourcePath $symbolsRoot -DestinationPath $corpusDestinationPath
if ($LASTEXITCODE -ne 0) {
  Write-Error "Corpus synchronization failed; offline package was not built."
  exit 1
}

New-Item -ItemType Directory -Path $bundleAssetRoot -Force | Out-Null
$assetEntries = New-Object System.Collections.Generic.List[object]
$appFiles = @(Get-ChildItem -LiteralPath $symbolsRoot -Recurse -File | Where-Object { $_.FullName -match "[\\/]app[\\/]" })

foreach ($file in $appFiles) {
  $relativePath = $file.FullName.Substring($symbolsRoot.Length + 1).Replace("\", "/")
  $destination = Join-Path $bundleAssetRoot $relativePath
  New-Item -ItemType Directory -Path (Split-Path -Parent $destination) -Force | Out-Null
  Copy-Item -LiteralPath $file.FullName -Destination $destination -Force
  $assetEntries.Add([ordered]@{
    sourcePath = (Join-Path $SymbolsPath $relativePath).Replace("\", "/")
    bundlePath = (Join-Path $BundleAssetDestination $relativePath).Replace("\", "/")
    offline = $true
    reviewRequired = $true
  }) | Out-Null
}

$manifestPath = Join-Path $bundleAssetRoot "manifest.json"
$manifest = [ordered]@{
  generatedAt = (Get-Date).ToUniversalTime().ToString("o")
  source = (Join-Path $SymbolsPath "*/app/*").Replace("\", "/")
  runtimeNetworkRequired = $false
  assets = @($assetEntries.ToArray())
}
$manifest | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $manifestPath -Encoding utf8

Write-Output "OK: built offline Symbol package with $($assetEntries.Count) local app asset(s)."
exit 0
