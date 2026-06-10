$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$validator = Join-Path $repoRoot "Tools/Validate-Corpus.ps1"
$syncScript = Join-Path $repoRoot "Tools/Sync-Corpus.ps1"
$fixtureCorpus = Join-Path $repoRoot "content/shared-characters"

function Invoke-Validator {
  param(
    [Parameter(Mandatory = $true)]
    [string]$CorpusPath
  )

  $output = & $validator -CorpusPath $CorpusPath 2>&1
  return [pscustomobject]@{
    ExitCode = $LASTEXITCODE
    Output = ($output -join "`n")
  }
}

function Invoke-Sync {
  param(
    [Parameter(Mandatory = $true)]
    [string]$SourcePath,
    [Parameter(Mandatory = $true)]
    [string]$DestinationPath
  )

  $output = & $syncScript -SourcePath $SourcePath -DestinationPath $DestinationPath 2>&1
  return [pscustomobject]@{
    ExitCode = $LASTEXITCODE
    Output = ($output -join "`n")
  }
}

function Assert-Equal {
  param(
    [Parameter(Mandatory = $true)]
    $Actual,
    [Parameter(Mandatory = $true)]
    $Expected,
    [Parameter(Mandatory = $true)]
    [string]$Message
  )

  if ($Actual -ne $Expected) {
    throw "$Message Expected '$Expected', got '$Actual'."
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

  if (-not $Text.Contains($ExpectedSubstring)) {
    throw "$Message Expected output to contain '$ExpectedSubstring'. Actual output: $Text"
  }
}

$validResult = Invoke-Validator -CorpusPath $fixtureCorpus
Assert-Equal -Actual $validResult.ExitCode -Expected 0 -Message "Draft corpus should validate."

$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("AsianLanguageCorpusTests-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $tempRoot | Out-Null

try {
  $syncDestination = Join-Path $tempRoot "synced-corpus"
  New-Item -ItemType Directory -Path $syncDestination | Out-Null
  Set-Content -Path (Join-Path $syncDestination "stale.json") -Value "{}" -Encoding utf8

  $syncResult = Invoke-Sync -SourcePath $fixtureCorpus -DestinationPath $syncDestination
  Assert-Equal -Actual $syncResult.ExitCode -Expected 0 -Message "Corpus sync should succeed."
  Assert-Contains -Text $syncResult.Output -ExpectedSubstring "OK: synced 1 corpus record(s)." -Message "Corpus sync should report copied record count."
  Assert-Equal -Actual (Test-Path (Join-Path $syncDestination "stale.json")) -Expected $false -Message "Corpus sync should remove stale bundled records."

  $sourceRecord = Get-Content -Raw (Join-Path $fixtureCorpus "tree.json") | ConvertFrom-Json
  $syncedRecord = Get-Content -Raw (Join-Path $syncDestination "tree.json") | ConvertFrom-Json
  Assert-Equal -Actual $syncedRecord.id -Expected $sourceRecord.id -Message "Synced corpus id should match source."
  Assert-Equal -Actual $syncedRecord.coreCharacter -Expected $sourceRecord.coreCharacter -Message "Synced corpus character should match source."

  $missingFocusCorpus = Join-Path $tempRoot "missing-focus"
  New-Item -ItemType Directory -Path $missingFocusCorpus | Out-Null
  $record = Get-Content -Raw (Join-Path $fixtureCorpus "tree.json") | ConvertFrom-Json
  $record.focusCoverage.PSObject.Properties.Remove("japanese")
  $record | ConvertTo-Json -Depth 20 | Set-Content -Path (Join-Path $missingFocusCorpus "tree.json") -Encoding utf8

  $missingFocusResult = Invoke-Validator -CorpusPath $missingFocusCorpus
  Assert-Equal -Actual $missingFocusResult.ExitCode -Expected 1 -Message "Missing required focus track should fail validation."
  Assert-Contains -Text $missingFocusResult.Output -ExpectedSubstring "Missing required focus track 'japanese'." -Message "Missing focus-track error should be readable."

  $tooFewExamplesCorpus = Join-Path $tempRoot "too-few-examples"
  New-Item -ItemType Directory -Path $tooFewExamplesCorpus | Out-Null
  $record = Get-Content -Raw (Join-Path $fixtureCorpus "tree.json") | ConvertFrom-Json
  $record.focusCoverage.simplifiedChinese.examples = @($record.focusCoverage.simplifiedChinese.examples[0])
  $record | ConvertTo-Json -Depth 20 | Set-Content -Path (Join-Path $tooFewExamplesCorpus "tree.json") -Encoding utf8

  $tooFewExamplesResult = Invoke-Validator -CorpusPath $tooFewExamplesCorpus
  Assert-Equal -Actual $tooFewExamplesResult.ExitCode -Expected 1 -Message "A focus track with fewer than two examples should fail validation."
  Assert-Contains -Text $tooFewExamplesResult.Output -ExpectedSubstring "Focus track 'simplifiedChinese' must include at least two examples." -Message "Example-count error should be readable."

  $missingChangeNoteCorpus = Join-Path $tempRoot "missing-change-note"
  New-Item -ItemType Directory -Path $missingChangeNoteCorpus | Out-Null
  $record = Get-Content -Raw (Join-Path $fixtureCorpus "tree.json") | ConvertFrom-Json
  $record.history.stages[1].changeNoteFromPrevious = $null
  $record | ConvertTo-Json -Depth 20 | Set-Content -Path (Join-Path $missingChangeNoteCorpus "tree.json") -Encoding utf8

  $missingChangeNoteResult = Invoke-Validator -CorpusPath $missingChangeNoteCorpus
  Assert-Equal -Actual $missingChangeNoteResult.ExitCode -Expected 1 -Message "Historical stages after the first without change notes should fail validation."
  Assert-Contains -Text $missingChangeNoteResult.Output -ExpectedSubstring "Historical stage at index 1 must include changeNoteFromPrevious." -Message "Missing change-note error should be readable."

  $missingCoreExampleCorpus = Join-Path $tempRoot "missing-core-example"
  New-Item -ItemType Directory -Path $missingCoreExampleCorpus | Out-Null
  $record = Get-Content -Raw (Join-Path $fixtureCorpus "tree.json") | ConvertFrom-Json
  foreach ($example in $record.focusCoverage.korean.examples) {
    $example.showsCoreMeaning = $false
  }
  $record | ConvertTo-Json -Depth 20 | Set-Content -Path (Join-Path $missingCoreExampleCorpus "tree.json") -Encoding utf8

  $missingCoreExampleResult = Invoke-Validator -CorpusPath $missingCoreExampleCorpus
  Assert-Equal -Actual $missingCoreExampleResult.ExitCode -Expected 1 -Message "A focus track without a direct core-meaning example should fail validation."
  Assert-Contains -Text $missingCoreExampleResult.Output -ExpectedSubstring "Focus track 'korean' must include at least one direct core-meaning example." -Message "Missing core-meaning example error should be readable."

  $unknownSourceCorpus = Join-Path $tempRoot "unknown-source"
  New-Item -ItemType Directory -Path $unknownSourceCorpus | Out-Null
  $record = Get-Content -Raw (Join-Path $fixtureCorpus "tree.json") | ConvertFrom-Json
  $record.history.stages[0].sourceIds = @("source-does-not-exist")
  $record | ConvertTo-Json -Depth 20 | Set-Content -Path (Join-Path $unknownSourceCorpus "tree.json") -Encoding utf8

  $unknownSourceResult = Invoke-Validator -CorpusPath $unknownSourceCorpus
  Assert-Equal -Actual $unknownSourceResult.ExitCode -Expected 1 -Message "Unknown source references should fail validation."
  Assert-Contains -Text $unknownSourceResult.Output -ExpectedSubstring "Unknown source reference 'source-does-not-exist'." -Message "Unknown source-reference error should be readable."
}
finally {
  if (Test-Path $tempRoot) {
    Remove-Item -LiteralPath $tempRoot -Recurse -Force
  }
}

Write-Output "OK: corpus validation tests passed"
