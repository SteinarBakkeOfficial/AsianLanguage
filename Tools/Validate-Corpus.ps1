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
  }

  $traditional = $Record.focusCoverage.traditionalChinese
  if ($null -ne $traditional) {
    if ((Get-Count $traditional.taiwanExamples) -lt 2) {
      Add-Issue -Path $RecordPath -Message "Focus track 'traditionalChinese' must include at least two Taiwan examples."
    }
    if ((Get-Count $traditional.hongKongExamples) -lt 2) {
      Add-Issue -Path $RecordPath -Message "Focus track 'traditionalChinese' must include at least two Hong Kong examples."
    }
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
  Assert-FocusCoverage -RecordPath $recordPath -Record $record
  Assert-ExampleCoverage -RecordPath $recordPath -Record $record
  Assert-HistoryCoverage -RecordPath $recordPath -Record $record
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
