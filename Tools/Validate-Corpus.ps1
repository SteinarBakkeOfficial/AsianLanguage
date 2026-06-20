param(
  [Parameter(Mandatory = $true)]
  [string]$CorpusPath
)

$ErrorActionPreference = "Stop"

$issues = New-Object System.Collections.Generic.List[string]

function Add-Issue {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Path,
    [Parameter(Mandatory = $true)]
    [string]$Message
  )

  $issues.Add("${Path}: $Message") | Out-Null
}

function Test-HasText {
  param($Value)
  return ($null -ne $Value -and $Value -is [string] -and $Value.Trim().Length -gt 0)
}

function Assert-TextField {
  param(
    [Parameter(Mandatory = $true)]
    [string]$RecordPath,
    [Parameter(Mandatory = $true)]
    $Record,
    [Parameter(Mandatory = $true)]
    [string]$FieldName
  )

  if (-not (Test-HasText $Record.$FieldName)) {
    Add-Issue -Path $RecordPath -Message "Missing required text field '$FieldName'."
  }
}

function Assert-FocusCoverage {
  param(
    [Parameter(Mandatory = $true)]
    [string]$RecordPath,
    [Parameter(Mandatory = $true)]
    $Record
  )

  if ($null -eq $Record.focusCoverage) {
    Add-Issue -Path $RecordPath -Message "Missing required object 'focusCoverage'."
    return
  }

  $requiredTracks = @(
    "simplifiedChinese",
    "traditionalChinese",
    "japanese",
    "korean"
  )

  foreach ($track in $requiredTracks) {
    if ($null -eq $Record.focusCoverage.$track) {
      Add-Issue -Path $RecordPath -Message "Missing required focus track '$track'."
    }
  }
}

function Assert-PrototypeMetadata {
  param(
    [Parameter(Mandatory = $true)]
    [string]$RecordPath,
    [Parameter(Mandatory = $true)]
    $Record
  )

  if ($null -eq $Record.teachingSequence -or -not ($Record.teachingSequence -is [ValueType])) {
    Add-Issue -Path $RecordPath -Message "Missing required integer field 'teachingSequence'."
  }

  if ($null -eq $Record.visuals) {
    Add-Issue -Path $RecordPath -Message "Missing required object 'visuals'."
    return
  }

  if ($null -eq $Record.visuals.evolutionAssetRefs) {
    Add-Issue -Path $RecordPath -Message "Missing required object 'visuals.evolutionAssetRefs'."
  }

  if (-not (Test-HasText $Record.visuals.assetStatus)) {
    Add-Issue -Path $RecordPath -Message "Missing required text field 'visuals.assetStatus'."
  }
}

function Assert-PublicationStatus {
  param(
    [Parameter(Mandatory = $true)]
    [string]$RecordPath,
    [Parameter(Mandatory = $true)]
    $Record
  )

  $allowedStatuses = @("draft", "review", "published")
  if ((Test-HasText $Record.publicationStatus) -and $allowedStatuses -notcontains $Record.publicationStatus) {
    Add-Issue -Path $RecordPath -Message "Invalid publicationStatus '$($Record.publicationStatus)'."
  }
}

function Get-Count {
  param($Value)
  if ($null -eq $Value) {
    return 0
  }

  if ($Value -is [array]) {
    return $Value.Count
  }

  return 1
}

function Test-HasCoreMeaningExample {
  param($Examples)

  if ($null -eq $Examples) {
    return $false
  }

  foreach ($example in @($Examples)) {
    if ($example.showsCoreMeaning -eq $true) {
      return $true
    }
  }

  return $false
}

function Assert-UsageExampleMetadata {
  param(
    [Parameter(Mandatory = $true)]
    [string]$RecordPath,
    [Parameter(Mandatory = $true)]
    [string]$TrackName,
    [Parameter(Mandatory = $true)]
    $Examples
  )

  $allowedLevels = @("word", "phrase", "sentence")
  foreach ($example in @($Examples)) {
    if (-not (Test-HasText $example.exampleLevel) -or $allowedLevels -notcontains $example.exampleLevel) {
      Add-Issue -Path $RecordPath -Message "Focus track '$TrackName' example must include exampleLevel word, phrase, or sentence."
    }
    if ($null -eq $example.reusesKnownSymbols) {
      Add-Issue -Path $RecordPath -Message "Focus track '$TrackName' example must include reusesKnownSymbols."
    }
    if ($null -eq $example.introducedSymbols) {
      Add-Issue -Path $RecordPath -Message "Focus track '$TrackName' example must include introducedSymbols."
    }
  }
}

function Assert-ExampleCoverage {
  param(
    [Parameter(Mandatory = $true)]
    [string]$RecordPath,
    [Parameter(Mandatory = $true)]
    $Record
  )

  if ($null -eq $Record.focusCoverage) {
    return
  }

  $standardTracks = @("simplifiedChinese", "japanese", "korean")
  foreach ($track in $standardTracks) {
    $coverage = $Record.focusCoverage.$track
    if ($null -ne $coverage -and (Get-Count $coverage.examples) -lt 2) {
      Add-Issue -Path $RecordPath -Message "Focus track '$track' must include at least two examples."
    }
    if ($null -ne $coverage -and -not (Test-HasCoreMeaningExample $coverage.examples)) {
      Add-Issue -Path $RecordPath -Message "Focus track '$track' must include at least one direct core-meaning example."
    }
    if ($null -ne $coverage) {
      Assert-UsageExampleMetadata -RecordPath $RecordPath -TrackName $track -Examples $coverage.examples
    }
  }

  $traditional = $Record.focusCoverage.traditionalChinese
  if ($null -ne $traditional) {
    if ((Get-Count $traditional.taiwanExamples) -lt 2) {
      Add-Issue -Path $RecordPath -Message "Focus track 'traditionalChinese' must include at least two Taiwan examples."
    }
    if ((Get-Count $traditional.hongKongExamples) -lt 2) {
      Add-Issue -Path $RecordPath -Message "Focus track 'traditionalChinese' must include at least two Hong Kong examples."
    }
    if (-not (Test-HasCoreMeaningExample $traditional.taiwanExamples)) {
      Add-Issue -Path $RecordPath -Message "Focus track 'traditionalChinese' must include at least one direct core-meaning Taiwan example."
    }
    if (-not (Test-HasCoreMeaningExample $traditional.hongKongExamples)) {
      Add-Issue -Path $RecordPath -Message "Focus track 'traditionalChinese' must include at least one direct core-meaning Hong Kong example."
    }
    Assert-UsageExampleMetadata -RecordPath $RecordPath -TrackName "traditionalChinese.taiwan" -Examples $traditional.taiwanExamples
    Assert-UsageExampleMetadata -RecordPath $RecordPath -TrackName "traditionalChinese.hongKong" -Examples $traditional.hongKongExamples
  }
}

function Assert-HistoryCoverage {
  param(
    [Parameter(Mandatory = $true)]
    [string]$RecordPath,
    [Parameter(Mandatory = $true)]
    $Record
  )

  if (-not (Test-HasText $Record.history.originAnchor)) {
    Add-Issue -Path $RecordPath -Message "Missing required history originAnchor."
    return
  }

  if ((Get-Count $Record.history.stages) -lt 1) {
    Add-Issue -Path $RecordPath -Message "History must include at least one displayed stage."
    return
  }

  for ($index = 1; $index -lt $Record.history.stages.Count; $index++) {
    $stage = $Record.history.stages[$index]
    if (-not (Test-HasText $stage.changeNoteFromPrevious)) {
      Add-Issue -Path $RecordPath -Message "Historical stage at index $index must include changeNoteFromPrevious."
    }
  }
}

function Assert-SourceReferences {
  param(
    [Parameter(Mandatory = $true)]
    [string]$RecordPath,
    [Parameter(Mandatory = $true)]
    $Record
  )

  if ((Get-Count $Record.sources) -lt 1) {
    Add-Issue -Path $RecordPath -Message "Record must include at least one source."
    return
  }

  $knownSourceIds = New-Object System.Collections.Generic.HashSet[string]
  foreach ($source in @($Record.sources)) {
    if (Test-HasText $source.id) {
      $knownSourceIds.Add($source.id) | Out-Null
    }
    if (-not (Test-HasText $source.citation)) {
      Add-Issue -Path $RecordPath -Message "Source '$($source.id)' must include a citation."
    }
    if ($source.type -ne "prototype" -and -not (Test-HasText $source.url)) {
      Add-Issue -Path $RecordPath -Message "Source '$($source.id)' must include a URL."
    }
  }

  if ($knownSourceIds.Count -eq 0) {
    Add-Issue -Path $RecordPath -Message "Record sources must include stable ids."
    return
  }

  foreach ($stage in @($Record.history.stages)) {
    foreach ($sourceId in @($stage.sourceIds)) {
      if ((Test-HasText $sourceId) -and -not $knownSourceIds.Contains($sourceId)) {
        Add-Issue -Path $RecordPath -Message "Unknown source reference '$sourceId'."
      }
    }
  }

  foreach ($sourceId in @($Record.structure.sourceIds)) {
    if ((Test-HasText $sourceId) -and -not $knownSourceIds.Contains($sourceId)) {
      Add-Issue -Path $RecordPath -Message "Unknown source reference '$sourceId'."
    }
  }
}

function Assert-StructureCertainty {
  param(
    [Parameter(Mandatory = $true)]
    [string]$RecordPath,
    [Parameter(Mandatory = $true)]
    $Record
  )

  if ($null -eq $Record.structure) {
    return
  }

  if ((Test-HasText $Record.structure.certainty) -and
      $Record.structure.certainty -ne "high" -and
      -not (Test-HasText $Record.structure.caveat)) {
    Add-Issue -Path $RecordPath -Message "Limited-certainty structure must include a caveat."
  }
}

if (-not (Test-Path $CorpusPath)) {
  Write-Error "Corpus path not found: $CorpusPath"
  exit 2
}

$jsonFiles = Get-ChildItem -Path $CorpusPath -Filter "*.json" -File
if ($jsonFiles.Count -eq 0) {
  Write-Error "No corpus JSON files found: $CorpusPath"
  exit 2
}

foreach ($file in $jsonFiles) {
  $recordPath = Resolve-Path -Relative $file.FullName
  try {
    $record = Get-Content -Raw $file.FullName | ConvertFrom-Json
  }
  catch {
    Add-Issue -Path $recordPath -Message "Invalid JSON. $($_.Exception.Message)"
    continue
  }

  Assert-TextField -RecordPath $recordPath -Record $record -FieldName "id"
  Assert-TextField -RecordPath $recordPath -Record $record -FieldName "coreCharacter"
  Assert-TextField -RecordPath $recordPath -Record $record -FieldName "coreSharedMeaning"
  Assert-TextField -RecordPath $recordPath -Record $record -FieldName "recognitionTakeaway"
  Assert-TextField -RecordPath $recordPath -Record $record -FieldName "publicationStatus"
  Assert-PrototypeMetadata -RecordPath $recordPath -Record $record
  Assert-PublicationStatus -RecordPath $recordPath -Record $record
  Assert-FocusCoverage -RecordPath $recordPath -Record $record
  Assert-ExampleCoverage -RecordPath $recordPath -Record $record
  Assert-HistoryCoverage -RecordPath $recordPath -Record $record
  Assert-SourceReferences -RecordPath $recordPath -Record $record
  Assert-StructureCertainty -RecordPath $recordPath -Record $record
}

if ($issues.Count -gt 0) {
  Write-Output "Corpus validation failed:"
  foreach ($issue in $issues) {
    Write-Output " - $issue"
  }
  exit 1
}

Write-Output "OK: validated $($jsonFiles.Count) Shared Character record(s)."
exit 0
