$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$corpusPath = Join-Path $repoRoot "content/shared-characters"

function Assert-True {
  param(
    [Parameter(Mandatory = $true)]
    [bool]$Condition,
    [Parameter(Mandatory = $true)]
    [string]$Message
  )

  if (-not $Condition) {
    throw $Message
  }
}

function Assert-Contains {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Text,
    [Parameter(Mandatory = $true)]
    [string]$ExpectedSubstring,
    [Parameter(Mandatory = $true)]
    [string]$Message
  )

  Assert-True -Condition $Text.Contains($ExpectedSubstring) -Message "$Message Expected '$ExpectedSubstring'."
}

$records = Get-ChildItem -Path $corpusPath -Filter "*.json" -File |
  ForEach-Object { Get-Content -Raw $_.FullName | ConvertFrom-Json }

Assert-True -Condition (@($records).Count -ge 10) -Message "Source-backed seed corpus should include at least 10 draft Shared Character records."

$sequenceValues = @($records | ForEach-Object { $_.teachingSequence })
Assert-True -Condition ($sequenceValues -notcontains $null) -Message "Every seed record should include teachingSequence."
Assert-True -Condition (@($sequenceValues | Sort-Object -Unique).Count -eq @($records).Count) -Message "Teaching sequence values should be unique."

foreach ($record in $records) {
  Assert-True -Condition ($null -ne $record.visuals) -Message "Record '$($record.id)' should include visual asset metadata."
  Assert-True -Condition ($null -ne $record.visuals.evolutionAssetRefs) -Message "Record '$($record.id)' should include evolution asset refs."

  foreach ($assetRef in @($record.visuals.evolutionAssetRefs.PSObject.Properties.Value)) {
    $assetPath = Join-Path $repoRoot "Resources/$assetRef"
    Assert-True -Condition (Test-Path $assetPath) -Message "Visual asset should exist: Resources/$assetRef"
  }

  $allExamples = @()
  $allExamples += @($record.focusCoverage.simplifiedChinese.examples)
  $allExamples += @($record.focusCoverage.traditionalChinese.taiwanExamples)
  $allExamples += @($record.focusCoverage.traditionalChinese.hongKongExamples)
  $allExamples += @($record.focusCoverage.japanese.examples)
  $allExamples += @($record.focusCoverage.korean.examples)

  Assert-True -Condition (@($allExamples | Where-Object { $_.exampleLevel -eq "word" }).Count -ge 1) -Message "Record '$($record.id)' should include at least one word-level example."
  Assert-True -Condition (@($allExamples | Where-Object { $_.exampleLevel -eq "sentence" }).Count -ge 1) -Message "Record '$($record.id)' should include at least one sentence-level example."
  Assert-True -Condition (@($allExamples | Where-Object { $null -ne $_.introducedSymbols }).Count -ge 1) -Message "Record '$($record.id)' should identify introduced symbols in examples."
}

$historicalAssetRefs = @(
  $records |
    ForEach-Object { $_.visuals.evolutionAssetRefs.PSObject.Properties.Value } |
    Where-Object { $_ -like "Assets/HistoricalGlyphs/*" }
)
Assert-True -Condition (@($historicalAssetRefs).Count -ge 1) -Message "Seed corpus should include at least one bundled source-backed historical glyph asset."

$modelText = Get-Content -Raw (Join-Path $repoRoot "Sources/App/Corpus/SharedCharacterRecord.swift")
Assert-Contains -Text $modelText -ExpectedSubstring "let teachingSequence: Int" -Message "Swift corpus model should expose teaching sequencing."
Assert-Contains -Text $modelText -ExpectedSubstring "let visuals: SharedCharacterVisuals" -Message "Swift corpus model should expose visual metadata."
Assert-Contains -Text $modelText -ExpectedSubstring "let exampleLevel: UsageExampleLevel" -Message "Swift usage examples should expose example level."
Assert-Contains -Text $modelText -ExpectedSubstring "let parallelExampleGroupID: String?" -Message "Swift usage examples should expose parallel example grouping."
Assert-Contains -Text $modelText -ExpectedSubstring "let introducedSymbols: [String]" -Message "Swift usage examples should expose introduced symbols."

$dependenciesText = Get-Content -Raw (Join-Path $repoRoot "Sources/App/Core/AppDependencies.swift")
Assert-Contains -Text $dependenciesText -ExpectedSubstring "SeedCorpusManifest.recordIDs" -Message "App dependencies should load all seed manifest records."

$projectText = Get-Content -Raw (Join-Path $repoRoot "AsianLanguage.xcodeproj/project.pbxproj")
Assert-Contains -Text $projectText -ExpectedSubstring "HistoricalGlyphs in Resources" -Message "Xcode project should bundle historical glyph assets."

Write-Output "OK: prototype corpus contract tests passed"
