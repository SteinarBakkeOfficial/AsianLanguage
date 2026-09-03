$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

function Assert-True { param([bool]$Condition,[string]$Message); if (-not $Condition) { throw $Message } }

$sourcePath = Join-Path $repoRoot "content/research/v1-symbols/transition-notes-v1.json"
$source = Get-Content -Raw $sourcePath | ConvertFrom-Json
$records = @($source.records)

Assert-True (@($records | Select-Object -ExpandProperty character -Unique).Count -eq 126) "Museum captions must cover all 126 V1 symbols."
Assert-True $records.Count -eq 630 "Museum captions must contain one note for each available stage."

$forbiddenStagePhrases = @("From Oracle Bone", "From Bronze", "From Small Seal", "From Clerical", "To Bronze", "To Small Seal", "To Clerical", "To Regular Script")
foreach ($entry in $records) {
  $note = [string]$entry.transitionNote
  Assert-True (-not [string]::IsNullOrWhiteSpace($note)) "$($entry.character)/$($entry.stage) must have a transition caption."
  Assert-True (@($note -split '\s+' | Where-Object { $_ }).Count -le 25) "$($entry.character)/$($entry.stage) caption exceeds 25 words."
  Assert-True (@($note -split '[.!?]+' | Where-Object { $_.Trim() }).Count -le 2) "$($entry.character)/$($entry.stage) caption exceeds two sentences."
  Assert-True (-not $note.Contains($entry.character)) "$($entry.character)/$($entry.stage) caption must not use the modern character as prose reference."
  foreach ($phrase in $forbiddenStagePhrases) {
    Assert-True (-not $note.Contains($phrase)) "$($entry.character)/$($entry.stage) caption must not name a stage transition."
  }
}

Write-Output "OK: museum caption contract tests passed"
