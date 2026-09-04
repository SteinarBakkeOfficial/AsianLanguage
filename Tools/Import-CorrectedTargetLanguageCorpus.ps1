param(
  [string]$SourcePath = "Reference Pictures/Chatgpt/Corpus_corrected_target_languages/Corpus",
  [string]$RuntimeCorpusPath = "Resources/Corpus"
)

$ErrorActionPreference = "Stop"

function Resolve-RepoPath([string]$Path) {
  if ([IO.Path]::IsPathRooted($Path)) { return $Path }
  return Join-Path (Resolve-Path (Join-Path $PSScriptRoot "..")) $Path
}

function Read-Json([string]$Path) {
  return Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json -Depth 100
}

function Write-Json([string]$Path, $Value) {
  $Value | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $Path -Encoding utf8
}

$sourceDirectory = Resolve-RepoPath $SourcePath
$runtimeDirectory = Resolve-RepoPath $RuntimeCorpusPath

if (-not (Test-Path -LiteralPath $sourceDirectory -PathType Container)) {
  throw "Corrected corpus source directory was not found: $sourceDirectory"
}
if (-not (Test-Path -LiteralPath $runtimeDirectory -PathType Container)) {
  throw "Runtime corpus directory was not found: $runtimeDirectory"
}

$sourceFiles = @(Get-ChildItem -LiteralPath $sourceDirectory -Filter "*.json" -File)
if ($sourceFiles.Count -ne 126) {
  throw "Expected exactly 126 corrected target-language records; found $($sourceFiles.Count)."
}

$existingRecords = @{}
foreach ($file in @(Get-ChildItem -LiteralPath $runtimeDirectory -Filter "*.json" -File)) {
  $record = Read-Json $file.FullName
  if ($record.coreCharacter -eq "火") { continue }
  $existingRecords[[string]$record.coreCharacter] = [pscustomobject]@{
    FileName = $file.Name
    Record = $record
  }
}

if ($existingRecords.Count -ne 126) {
  throw "Expected exactly 126 existing non-Fire runtime records; found $($existingRecords.Count)."
}

$incomingCharacters = New-Object System.Collections.Generic.HashSet[string]
$mergedCount = 0

foreach ($sourceFile in ($sourceFiles | Sort-Object Name)) {
  $incoming = Read-Json $sourceFile.FullName
  $character = [string]$incoming.coreCharacter

  if (-not $incomingCharacters.Add($character)) {
    throw "Duplicate corrected corpus character '$character' in $($sourceFile.Name)."
  }
  if (-not $existingRecords.ContainsKey($character)) {
    throw "Corrected corpus character '$character' has no matching stable runtime record."
  }

  $existing = $existingRecords[$character]
  $merged = $existing.Record

  # Preserve stable identity, readable runtime filenames, and current bundled
  # asset references. The handoff was generated before the ID/path rename.
  $merged.focusCoverage = $incoming.focusCoverage
  $merged.simplifiedForm = $incoming.simplifiedForm
  $merged.traditionalForm = $incoming.traditionalForm
  $merged.usage = $incoming.usage

  # Keep corrected target-language provenance without changing the existing
  # draft/needsReview publication gate.
  $merged | Add-Member -MemberType NoteProperty -Name targetLanguageEditorialStatus -Value $incoming.targetLanguageEditorialStatus -Force
  $merged | Add-Member -MemberType NoteProperty -Name targetLanguageEditorialPrinciples -Value $incoming.targetLanguageEditorialPrinciples -Force

  Write-Json (Join-Path $runtimeDirectory $existing.FileName) $merged
  $mergedCount++
}

if ($incomingCharacters.Count -ne 126) {
  throw "Corrected corpus character count was $($incomingCharacters.Count), not 126."
}

Write-Output "OK: merged corrected target-language content into $mergedCount stable runtime record(s)."
Write-Output "Fire was intentionally preserved outside this 126-record merge."
