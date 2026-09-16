$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$workspaceValidator = Join-Path $repoRoot "Tools/Validate-SymbolWorkspace.ps1"
$reviewGenerator = Join-Path $repoRoot "Tools/Generate-SymbolReview.ps1"
$syncScript = Join-Path $repoRoot "Tools/Sync-Corpus.ps1"

function Assert-True { param([bool]$Condition, [string]$Message); if (-not $Condition) { throw $Message } }

$symbolsPath = Join-Path $repoRoot "content/release/symbols"
$validationOutput = & $workspaceValidator -SymbolsPath "content/release/symbols" 2>&1
Assert-True ($LASTEXITCODE -eq 0) "Symbol workspace should validate. Output: $($validationOutput -join "`n")"

$runtimeManifest = @(Get-Content -Raw (Join-Path $repoRoot "Resources/V1CorpusManifest.json") | ConvertFrom-Json)
$activeIDs = @($runtimeManifest | ForEach-Object id)
$symbolFiles = @(Get-ChildItem -LiteralPath $symbolsPath -Recurse -Filter "symbol.json" -File | Where-Object { $activeIDs -contains $_.Directory.Name })
Assert-True ($symbolFiles.Count -eq 126) "The canonical Symbol workspace should contain the 126 active V1 Symbol records."

$one = Get-Content -Raw -LiteralPath (Join-Path $symbolsPath "one/symbol.json") | ConvertFrom-Json
Assert-True ($one.contentFolder -eq "content/release/symbols/one") "Canonical V1 Symbol JSON must point to its own release source folder."
Assert-True (Test-Path (Join-Path $symbolsPath "one/research.md")) "Canonical V1 Symbol research must remain beside its JSON."
Assert-True (Test-Path (Join-Path $symbolsPath "one/sources.json")) "Canonical V1 Symbol sources must remain beside its JSON."
Assert-True (Test-Path (Join-Path $symbolsPath "one/historical/zdic-selected/oracleBone/museum-canvas.svg")) "Canonical V1 historical assets must remain beside their Symbol JSON."

$fire = Get-Content -Raw -LiteralPath (Join-Path $repoRoot "docs/archive/legacy-pilot/symbols/fire-u706B/symbol.json") | ConvertFrom-Json
Assert-True ($fire.editorialStatus -eq "needsReview") "Prepared Fire content must remain needsReview."
Assert-True ($fire.history.origin.asset.contentClass -eq "educationalReconstruction") "Fire Origin must be classified as educational reconstruction."
Assert-True ($fire.history.stages[0].assetMetadata.contentClass -eq "historicalEvidence") "Fire's early historical asset must be classified as historical evidence."
Assert-True ($fire.history.stages[0].assetRef -like "Assets/Symbols/fire-u706B/historical/oracle/app/*") "Fire's early historical asset must point to its bundled Oracle Bone asset."

$assetManifest = Get-Content -Raw -LiteralPath (Join-Path $repoRoot "docs/archive/legacy-pilot/Resources-Assets-Symbols-manifest.json") | ConvertFrom-Json
Assert-True ($assetManifest.runtimeNetworkRequired -eq $false) "Offline asset manifest must prohibit runtime network requirements."
foreach ($asset in @($assetManifest.assets)) {
  Assert-True (Test-Path (Join-Path $repoRoot ($asset.bundlePath -replace "/", "\"))) "Packaged asset must exist locally: $($asset.bundlePath)"
}

$reviewOutput = & $reviewGenerator -SymbolsPath "content/release/symbols" -OutputPath "content/generated-review/symbol-review.md" 2>&1
Assert-True ($LASTEXITCODE -eq 0) "Review report generation should succeed. Output: $($reviewOutput -join "`n")"
Assert-True (Test-Path (Join-Path $repoRoot "content/generated-review/symbol-review.md")) "Review report should be written."

$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("AsianLanguageSymbolSync-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $tempRoot | Out-Null
try {
  $syncOutput = & $syncScript -SourcePath $symbolsPath -DestinationPath $tempRoot -ManifestPath "Resources/V1CorpusManifest.json" 2>&1
  Assert-True ($LASTEXITCODE -eq 0) "Folder-based corpus sync should succeed. Output: $($syncOutput -join "`n")"
  Assert-True (@(Get-ChildItem -LiteralPath $tempRoot -Filter "*.json" -File).Count -eq 126) "Folder-based V1 sync should produce 126 active flat bundle records."
} finally {
  if (Test-Path $tempRoot) { Remove-Item -LiteralPath $tempRoot -Recurse -Force }
}

Write-Output "OK: Symbol workspace tests passed"
