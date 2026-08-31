$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$workspaceValidator = Join-Path $repoRoot "Tools/Validate-SymbolWorkspace.ps1"
$reviewGenerator = Join-Path $repoRoot "Tools/Generate-SymbolReview.ps1"
$syncScript = Join-Path $repoRoot "Tools/Sync-Corpus.ps1"

function Assert-True { param([bool]$Condition, [string]$Message); if (-not $Condition) { throw $Message } }

$symbolsPath = Join-Path $repoRoot "content/symbols"
$validationOutput = & $workspaceValidator -SymbolsPath "content/symbols" 2>&1
Assert-True ($LASTEXITCODE -eq 0) "Symbol workspace should validate. Output: $($validationOutput -join "`n")"

$symbolFiles = @(Get-ChildItem -LiteralPath $symbolsPath -Recurse -Filter "symbol.json" -File)
Assert-True ($symbolFiles.Count -eq 11) "The prepared pilot workspace should contain 11 Symbol records."

$fire = Get-Content -Raw -LiteralPath (Join-Path $symbolsPath "fire-u706B/symbol.json") | ConvertFrom-Json
Assert-True ($fire.editorialStatus -eq "needsReview") "Prepared Fire content must remain needsReview."
Assert-True ($fire.history.origin.asset.contentClass -eq "educationalReconstruction") "Fire Origin must be classified as educational reconstruction."
Assert-True ($fire.history.stages[0].assetRef -eq $null) "Fire must not invent an early historical asset reference."

$assetManifest = Get-Content -Raw -LiteralPath (Join-Path $repoRoot "Resources/Assets/Symbols/manifest.json") | ConvertFrom-Json
Assert-True ($assetManifest.runtimeNetworkRequired -eq $false) "Offline asset manifest must prohibit runtime network requirements."
foreach ($asset in @($assetManifest.assets)) {
  Assert-True (Test-Path (Join-Path $repoRoot ($asset.bundlePath -replace "/", "\"))) "Packaged asset must exist locally: $($asset.bundlePath)"
}

$reviewOutput = & $reviewGenerator -SymbolsPath "content/symbols" -OutputPath "content/generated-review/symbol-review.md" 2>&1
Assert-True ($LASTEXITCODE -eq 0) "Review report generation should succeed. Output: $($reviewOutput -join "`n")"
Assert-True (Test-Path (Join-Path $repoRoot "content/generated-review/symbol-review.md")) "Review report should be written."

$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("AsianLanguageSymbolSync-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $tempRoot | Out-Null
try {
  $syncOutput = & $syncScript -SourcePath $symbolsPath -DestinationPath $tempRoot 2>&1
  Assert-True ($LASTEXITCODE -eq 0) "Folder-based corpus sync should succeed. Output: $($syncOutput -join "`n")"
  Assert-True (@(Get-ChildItem -LiteralPath $tempRoot -Filter "*.json" -File).Count -eq 11) "Folder-based sync should produce 11 flat bundle records."
} finally {
  if (Test-Path $tempRoot) { Remove-Item -LiteralPath $tempRoot -Recurse -Force }
}

Write-Output "OK: Symbol workspace tests passed"
