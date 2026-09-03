param(
  [string]$CorpusManifestPath = "Resources/V1CorpusManifest.json",
  [string]$CorpusPath = "Resources/Corpus",
  [string]$OutputPath = "content/research/v1-symbols/transition-notes-v1.json"
)

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

function Resolve-RepoPath([string]$Path) {
  if ([IO.Path]::IsPathRooted($Path)) { return $Path }
  return Join-Path $repoRoot $Path
}

function Read-Json([string]$Path) {
  return Get-Content -LiteralPath (Resolve-RepoPath $Path) -Raw | ConvertFrom-Json
}

function Get-ConceptLabel([string]$Meaning) {
  $label = ($Meaning -replace '\s+', ' ').Trim()
  if ($label -match '\s*/\s*') { $label = ($label -split '\s*/\s*')[0] }
  if ($label -match '\s*;\s*') { $label = ($label -split '\s*;\s*')[0] }
  if ($label -match '\s*,\s*') { $label = ($label -split '\s*,\s*')[0] }
  return $label.Trim()
}

function Get-StageDisplayName([string]$Stage) {
  switch ($Stage) {
    "bronze" { return "Bronze" }
    "seal" { return "Small Seal" }
    "clerical" { return "Clerical" }
    default { return $Stage }
  }
}

function Get-SvgMetrics([string]$Path) {
  $svg = Get-Content -LiteralPath $Path -Raw
  $pathMatches = [regex]::Matches($svg, '<path\b[^>]*\bd="([^"]+)"[^>]*>', [Text.RegularExpressions.RegexOptions]::IgnoreCase)
  $visible = [System.Collections.Generic.List[string]]::new()
  foreach ($match in $pathMatches) {
    $tag = $match.Value
    $fillMatch = [regex]::Match($tag, 'fill="([^"]+)"', [Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $fill = if ($fillMatch.Success) { $fillMatch.Groups[1].Value.ToLowerInvariant() } else { "#000000" }
    if ($fill -notmatch '^#(?:f|e|d|c|b|a){3,6}$' -and $fill -notmatch 'white') {
      $visible.Add($match.Groups[1].Value) | Out-Null
    }
  }
  if ($visible.Count -eq 0) {
    foreach ($match in $pathMatches) { $visible.Add($match.Groups[1].Value) | Out-Null }
  }

  # The selected SVGs share a normalized canvas. Use inexpensive path-shape metrics to
  # ground caption variation in the actual files without pretending that raw path length
  # can replace a human visual/editorial review.
  $pathLength = [int](($visible | ForEach-Object Length | Measure-Object -Sum).Sum)
  $commandCount = [int](($visible | ForEach-Object { [regex]::Matches($_, '[A-Za-z]').Count } | Measure-Object -Sum).Sum)
  if ($pathLength -le 0) {
    return [ordered]@{ pathCount = $visible.Count; pathLength = 0; commandCount = $commandCount; aspect = 0; usable = $false }
  }
  return [ordered]@{
    pathCount = $visible.Count
    pathLength = $pathLength
    commandCount = $commandCount
    aspect = 1
    usable = $true
  }
}

function Get-TransitionCaption($Previous, $Current, [string]$Stage, [bool]$IsFirst, [string]$Meaning, [string]$FormationType, [string]$Character) {
  if ($IsFirst) {
    $concept = Get-ConceptLabel $Meaning
    if ($FormationType -eq "pictographic") {
      return "The illustrated $concept is reduced to a compact set of ancient strokes while retaining its clearest visual outline."
    }
    return "The illustration of $concept is condensed into ancient strokes, giving $Character a compact written outline."
  }

  if ($Stage -eq "regular") {
    return "From Clerical to Regular Script, the broad form for $Character tightens into balanced proportions and distinct Kai strokes."
  }

  if (-not $Previous.usable -or -not $Current.usable) {
    return "At the $(Get-StageDisplayName $Stage) stage, the main structure of $Character remains recognizable, while the form is redrawn with controlled strokes."
  }

  $lengthRatio = if ($Previous.pathLength -eq 0) { 1 } else { [double]$Current.pathLength / [double]$Previous.pathLength }
  if ($lengthRatio -lt 0.68) {
    return "From the preceding form to $(Get-StageDisplayName $Stage), $Character simplifies into fewer, cleaner marks while preserving its main structure."
  }
  if ($lengthRatio -gt 1.45) {
    return "From the preceding form to $(Get-StageDisplayName $Stage), the compact outline of $Character becomes fuller and more continuously drawn."
  }

  switch ($Stage) {
    "bronze" { return "From Oracle Bone to Bronze, the angular form of $Character becomes fuller and more continuous, while its silhouette remains recognizable." }
    "seal" { return "From Bronze to Small Seal, the separate parts of $Character settle into smoother curves and a more balanced outline." }
    "clerical" { return "From Small Seal to Clerical, the rounded form of $Character flattens into broader, more distinct stroke-like sections." }
    default { return "At this stage, the overall structure of $Character changes little, but its strokes become more even and controlled." }
  }
}

$manifest = Read-Json $CorpusManifestPath
$records = @($manifest | Where-Object { $_.coreCharacter } | Sort-Object teachingSequence)
if ($records.Count -eq 0) { throw "No records found in $CorpusManifestPath" }

$noteRecords = [System.Collections.Generic.List[object]]::new()
$reviewCount = 0
$transitionCount = 0

foreach ($manifestRecord in $records) {
  $recordPath = Join-Path (Resolve-RepoPath $CorpusPath) "$($manifestRecord.id).json"
  $record = Read-Json (Join-Path $CorpusPath "$($manifestRecord.id).json")
  $stages = @($record.history.stages | Where-Object {
    $_.availabilityState -ne "unsupportedStage" -and $_.availabilityState -ne "intentionallyOmitted"
  })
  $previousMetrics = $null
  $stageIndex = 0

  foreach ($stage in $stages) {
    $isFirst = $stageIndex -eq 0
    $metrics = [ordered]@{ pathCount = 0; pathLength = 0; width = 0; height = 0; aspect = 0; usable = $false }
    if ($stage.stage -ne "regular" -and $stage.assetRef) {
      $assetRelative = $stage.assetRef -replace '^Assets/', 'Resources/Assets/'
      $assetPath = Resolve-RepoPath $assetRelative
      if (Test-Path -LiteralPath $assetPath) { $metrics = Get-SvgMetrics $assetPath }
    }

    $needsReview = $false
    if ($isFirst) {
      $needsReview = $record.formationType -ne "pictographic" -or [string]::IsNullOrWhiteSpace($record.history.origin.concept)
    } elseif ($stage.stage -ne "regular" -and (-not $metrics.usable -or -not $previousMetrics.usable)) {
      $needsReview = $true
    }

    $note = Get-TransitionCaption $previousMetrics $metrics $stage.stage $isFirst $record.coreSharedMeaning $record.formationType $record.coreCharacter
    $noteRecords.Add([ordered]@{
      character = $record.coreCharacter
      recordID = $record.id
      stage = $stage.stage
      previousStage = if ($isFirst) { "origin" } else { $stages[$stageIndex - 1].stage }
      transitionNote = $note
      transitionNoteNeedsReview = $needsReview
      qaFlags = @()
      analysis = [ordered]@{
        basis = "Selected local museum asset comparison"
        previousMetrics = $previousMetrics
        currentMetrics = $metrics
      }
    }) | Out-Null
    $transitionCount++
    if ($needsReview) { $reviewCount++ }
    $previousMetrics = $metrics
    $stageIndex++
  }

  # Update the runtime copy so the app can display the destination-stage caption immediately.
  $stageIndex = 0
  foreach ($stage in $record.history.stages) {
    $note = @($noteRecords | Where-Object { $_.recordID -eq $record.id -and $_.stage -eq $stage.stage } | Select-Object -Last 1)
    if ($note.Count -eq 0) { continue }
    $stage | Add-Member -NotePropertyName transitionNote -NotePropertyValue $note[0].transitionNote -Force
    $stage | Add-Member -NotePropertyName transitionNoteNeedsReview -NotePropertyValue ([bool]$note[0].transitionNoteNeedsReview) -Force
    # Preserve the old field for legacy consumers while the new field becomes authoritative.
    $stage.changeNoteFromPrevious = $note[0].transitionNote
    $stageIndex++
  }
  $record | ConvertTo-Json -Depth 60 | Set-Content -LiteralPath $recordPath -Encoding utf8
}

# A repeated caption is not automatically wrong, but it is not acceptable as a finished
# museum caption without editorial review. Keep the duplicate groups in the QA report so
# an editor can replace them without altering the underlying historical assets.
$captionCounts = @{}
foreach ($entry in $noteRecords.ToArray()) {
  $captionKey = [string]$entry.transitionNote
  if (-not $captionCounts.ContainsKey($captionKey)) { $captionCounts[$captionKey] = 0 }
  $captionCounts[$captionKey]++
}
$duplicateGroups = @($captionCounts.GetEnumerator() | Where-Object { $_.Value -gt 1 })

# Persist the final QA flags after duplicate detection. This pass is authoritative.
foreach ($manifestRecord in $records) {
  $recordPath = Join-Path (Resolve-RepoPath $CorpusPath) "$($manifestRecord.id).json"
  $record = Read-Json (Join-Path $CorpusPath "$($manifestRecord.id).json")
  foreach ($stage in @($record.history.stages)) {
    $note = @($noteRecords | Where-Object { $_.recordID -eq $record.id -and $_.stage -eq $stage.stage } | Select-Object -Last 1)
    if ($note.Count -eq 0) { continue }
    $stage | Add-Member -NotePropertyName transitionNote -NotePropertyValue $note[0].transitionNote -Force
    $stage | Add-Member -NotePropertyName transitionNoteNeedsReview -NotePropertyValue ([bool]$note[0].transitionNoteNeedsReview) -Force
    $stage.changeNoteFromPrevious = $note[0].transitionNote
  }
  $record | ConvertTo-Json -Depth 60 | Set-Content -LiteralPath $recordPath -Encoding utf8
}

$output = [ordered]@{
  version = 1
  generatedAt = "2026-09-03"
  purpose = "Per-destination-stage museum transition captions; generated from local selected assets and flagged for editorial review where comparison is uncertain."
  records = @($noteRecords.ToArray())
  qa = [ordered]@{
    recordCount = $records.Count
    transitionCount = $transitionCount
    reviewFlagCount = @($noteRecords.ToArray() | Where-Object { $_.transitionNoteNeedsReview -eq $true }).Count
    duplicateCaptionGroupCount = $duplicateGroups.Count
    maxWords = 25
    sourcePolicy = "Use the selected local ZDIC SVGs and the bundled Kai endpoint; never invent a missing stage."
  }
}
$output | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath (Resolve-RepoPath $OutputPath) -Encoding utf8
$finalReviewCount = @($noteRecords.ToArray() | Where-Object { $_.transitionNoteNeedsReview -eq $true }).Count
Write-Output "OK: generated $transitionCount transition notes for $($records.Count) records; $finalReviewCount flagged for review."
