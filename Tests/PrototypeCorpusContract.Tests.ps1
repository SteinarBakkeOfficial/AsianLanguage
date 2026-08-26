$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$corpusPath = Join-Path $repoRoot "content/shared-characters"
function Assert-True { param([bool]$Condition,[string]$Message); if (-not $Condition) { throw $Message } }

$records = Get-ChildItem $corpusPath -Filter "*.json" -File | ForEach-Object { Get-Content -Raw $_.FullName | ConvertFrom-Json }
Assert-True (@($records).Count -eq 11) "The current corpus should remain the 11 draft fixtures."
$bySequence = @($records | Sort-Object teachingSequence)
Assert-True ($bySequence[0].id -eq "fire") "Fire must lead the prototype sequence."
Assert-True ($bySequence[1].id -eq "water") "Water must follow Fire."
Assert-True ($bySequence[2].id -eq "mountain") "Mountain must follow Water."
Assert-True ($bySequence[3].id -eq "tree") "Tree must follow Mountain."

foreach ($record in $records) {
  Assert-True ($record.publicationStatus -eq "draft") "Seed record '$($record.id)' must remain draft."
  Assert-True ($null -eq $record.visuals.evolutionAssetRefs) "Stage asset maps must not be duplicated under visuals."
  foreach ($stage in @($record.history.stages)) {
    Assert-True (@("oracleBone","bronze","seal","clerical","regular") -contains $stage.stage) "Record '$($record.id)' has a non-canonical stage id."
    if ($null -ne $stage.assetRef) {
      Assert-True (Test-Path (Join-Path $repoRoot "Resources/$($stage.assetRef)")) "Stage asset must exist for '$($record.id)/$($stage.stage)'."
    }
  }
}

$modelText = Get-Content -Raw (Join-Path $repoRoot "Sources/App/Corpus/SharedCharacterRecord.swift")
Assert-True $modelText.Contains("struct HistoricalAssetMetadata") "Model must expose structured asset metadata."
Assert-True $modelText.Contains("struct ModernFormVariant") "Model must expose explicit modern variants."
Write-Output "OK: current prototype corpus contract tests passed"
