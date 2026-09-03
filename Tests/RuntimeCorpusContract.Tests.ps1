$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
function Assert-True { param([bool]$Condition,[string]$Message); if (-not $Condition) { throw $Message } }

$manifest = Get-Content -Raw (Join-Path $repoRoot "Resources/V1CorpusManifest.json") | ConvertFrom-Json
$records = @(Get-ChildItem (Join-Path $repoRoot "Resources/Corpus") -Filter "*.json" -File | ForEach-Object {
  Get-Content -Raw $_.FullName | ConvertFrom-Json
})
$runtimeIDs = @($manifest | Sort-Object teachingSequence | ForEach-Object id)
$allowedFormationTypes = @("pictograph", "simpleIdeograph", "compoundIdeograph", "phonoSemantic", "phoneticLoan", "laterFormation", "uncertain")

Assert-True ($runtimeIDs.Count -eq 126) "Runtime corpus must contain exactly 126 records."
foreach ($record in $records | Where-Object { $runtimeIDs -contains $_.id }) {
  Assert-True ($allowedFormationTypes -contains $record.formationType) "Runtime record '$($record.id)' has a Swift-incompatible formationType '$($record.formationType)'."
  Assert-True ($null -ne $record.history.origin.asset) "Runtime record '$($record.id)' must retain its origin asset metadata."
}

$fire = Get-Content -Raw (Join-Path $repoRoot "Resources/Corpus/fire.json") | ConvertFrom-Json
Assert-True ($fire.history.origin.asset.assetRef -eq "Assets/Symbols/fire-u706B/educational/app/origin.png") "Fire onboarding must retain its local origin illustration reference."
Assert-True (Test-Path (Join-Path $repoRoot "Resources/Assets/Symbols/fire-u706B/educational/app/origin.png")) "Fire onboarding origin illustration must exist locally."

Write-Output "OK: runtime corpus decode contract passed"
