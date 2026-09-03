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
  foreach ($track in @("simplifiedChinese", "japanese", "korean")) {
    Assert-True ($record.focusCoverage.$track.readings -is [array]) "Runtime record '$($record.id)' track '$track' readings must be an array."
    foreach ($reading in @($record.focusCoverage.$track.readings)) {
      Assert-True (-not [string]::IsNullOrWhiteSpace([string]$reading.system)) "Runtime record '$($record.id)' track '$track' reading system must be present."
      Assert-True (-not [string]::IsNullOrWhiteSpace([string]$reading.value)) "Runtime record '$($record.id)' track '$track' reading value must be present."
    }
  }
  foreach ($field in @("readings", "taiwanReadings", "hongKongReadings")) {
    Assert-True ($record.focusCoverage.traditionalChinese.$field -is [array]) "Runtime record '$($record.id)' traditional '$field' must be an array."
  }
}

$fire = Get-Content -Raw (Join-Path $repoRoot "Resources/Corpus/fire.json") | ConvertFrom-Json
Assert-True ($fire.history.origin.asset.assetRef -eq "Assets/Symbols/fire-u706B/educational/app/origin.png") "Fire onboarding must retain its local origin illustration reference."
Assert-True (Test-Path (Join-Path $repoRoot "Resources/Assets/Symbols/fire-u706B/educational/app/origin.png")) "Fire onboarding origin illustration must exist locally."
Assert-True ($fire.focusCoverage.simplifiedChinese.readings -is [array]) "Fire onboarding readings must remain a decodable array."

Write-Output "OK: runtime corpus decode contract passed"
