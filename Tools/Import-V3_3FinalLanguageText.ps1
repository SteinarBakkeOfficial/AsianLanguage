param(
  [string]$SourcePath = "Reference Pictures/Chatgpt/NewFinal3.3_symbol/V3_3_FINAL_LANGUAGE_VERIFIED_126_FULL_PACKAGE/V3_3_FINAL_LANGUAGE_MASTER_126_STRUCTURED_PAYLOAD.json",
  [string]$RuntimeCorpusPath = "Resources/Corpus",
  [string]$CanonicalSymbolsPath = "content/release/symbols",
  [string]$RuntimeManifestPath = "Resources/V1CorpusManifest.json"
)

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

function Resolve-RepoPath([string]$Path) {
  if ([IO.Path]::IsPathRooted($Path)) { return $Path }
  return Join-Path $repoRoot $Path
}

function Read-Json([string]$Path) {
  Get-Content -LiteralPath (Resolve-RepoPath $Path) -Raw | ConvertFrom-Json -Depth 100
}

function Write-Json([string]$Path, $Value) {
  $Value | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath (Resolve-RepoPath $Path) -Encoding utf8
}

function Apply-FinalText($Record, $Incoming) {
  # The V3.3 package owns learner-facing copy and modern language content.
  # Existing asset, provenance, review, and navigation fields remain local to the app corpus.
  $Record.coreSharedMeaning = [string]$Incoming.meaning
  $Record.recognitionTakeaway = [string]$Incoming.history.regular
  $Record.simplifiedForm = [string]$Incoming.focusCoverage.simplifiedChinese.form
  $Record.traditionalForm = [string]$Incoming.focusCoverage.traditionalChinese.form
  $Record.focusCoverage = $Incoming.focusCoverage
  $Record.history.originAnchor = [string]$Incoming.originSummary

  if ($null -ne $Record.history.origin) {
    $Record.history.origin.explanation = [string]$Incoming.originSummary
  }

  $historyTextByStage = @{
    oracleBone = [string]$Incoming.history.oracleBone
    bronze = [string]$Incoming.history.bronze
    seal = [string]$Incoming.history.seal
    clerical = [string]$Incoming.history.clerical
    regular = [string]$Incoming.history.regular
  }

  foreach ($stage in @($Record.history.stages)) {
    if (-not $historyTextByStage.ContainsKey([string]$stage.stage)) { continue }
    $stageText = $historyTextByStage[[string]$stage.stage]
    $stage.changeNoteFromPrevious = $stageText
    $stage.stageExplanation = $stageText
    $stage.transitionNote = $stageText
  }

  if ($null -ne $Record.usage) {
    $Record.usage.coreMeaningFirst = "Start with '$($Incoming.meaning)', then compare the modern forms and readings across the four focus tracks."
  }

  return $Record
}

$payload = Read-Json $SourcePath
$incomingSymbols = @($payload.symbols)
if ($incomingSymbols.Count -ne 126) {
  throw "Expected exactly 126 V3.3 symbols; found $($incomingSymbols.Count)."
}

$incomingByID = @{}
foreach ($incoming in $incomingSymbols) {
  $incomingByID[[string]$incoming.id] = $incoming
}

$runtimeDirectory = Resolve-RepoPath $RuntimeCorpusPath
$runtimeFiles = @(Get-ChildItem -LiteralPath $runtimeDirectory -Filter "*.json" -File)
if ($runtimeFiles.Count -ne 126) {
  throw "Expected exactly 126 runtime records; found $($runtimeFiles.Count)."
}

$updatedIDs = New-Object System.Collections.Generic.HashSet[string]
foreach ($runtimeFile in $runtimeFiles) {
  $record = Read-Json (Join-Path $RuntimeCorpusPath $runtimeFile.Name)
  $id = [string]$record.id
  if (-not $incomingByID.ContainsKey($id)) {
    throw "Runtime record '$id' has no V3.3 source symbol."
  }
  Apply-FinalText $record $incomingByID[$id] | Out-Null
  Write-Json (Join-Path $RuntimeCorpusPath $runtimeFile.Name) $record
  $updatedIDs.Add($id) | Out-Null

  $canonicalFile = Join-Path (Join-Path $CanonicalSymbolsPath $id) "symbol.json"
  if (Test-Path -LiteralPath (Resolve-RepoPath $canonicalFile)) {
    $canonical = Read-Json $canonicalFile
    Apply-FinalText $canonical $incomingByID[$id] | Out-Null
    Write-Json $canonicalFile $canonical
  }
}

if ($updatedIDs.Count -ne 126) {
  throw "Updated $($updatedIDs.Count) records instead of 126."
}

$manifest = Read-Json $RuntimeManifestPath
if ($manifest -isnot [array] -or $manifest.Count -ne 126) {
  throw "Expected the runtime manifest to contain 126 records."
}
foreach ($record in $manifest) {
  $id = [string]$record.id
  if (-not $incomingByID.ContainsKey($id)) {
    throw "Manifest record '$id' has no V3.3 source symbol."
  }
  Apply-FinalText $record $incomingByID[$id] | Out-Null
}
Write-Json $RuntimeManifestPath $manifest

Write-Output "OK: applied V3.3 final language and Symbol copy to 126 runtime records and the aggregate manifest."
Write-Output "Canonical release Symbol JSON was updated where present; asset, provenance, and review fields were preserved."
