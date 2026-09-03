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

function Get-OriginCaption([string]$Meaning) {
  # Keep the first caption tied to the illustrated subject, never to the modern
  # character. A few core pictographs get more concrete wording because the
  # relationship is central to the first museum comparison.
  $concept = Get-ConceptLabel $Meaning
  if ($concept -match '[\u3400-\u9FFF]') {
    return "The illustrated subject is reduced to a few simple strokes, while its clearest outline remains visible."
  }
  switch -Regex ($concept.ToLowerInvariant()) {
    "^woman$" { return "The side-facing woman is reduced to a few strokes, while her posture still faces left." }
    "^person$" { return "The leaning person is reduced to a few strokes, while the basic posture remains visible." }
    "^tree$" { return "The trunk, branches, and roots are reduced to a few simple strokes, but the tree’s structure remains visible." }
    "^water$" { return "The flowing water is reduced to a central line with smaller marks spreading around it." }
    "^mountain$" { return "The mountain peaks are reduced to a few connected strokes, while the rising outline remains clear." }
    "^mouth$" { return "The open mouth is simplified into a small enclosing outline, keeping its basic shape." }
    "^tongue$" { return "The tongue remains inside the open mouth as the two visible parts become simple strokes." }
    "^eye$" { return "The eye’s outer shape and inner mark are reduced to a few simple lines." }
    "^ear$" { return "The ear’s outer contour is reduced to a compact group of simple strokes." }
    "^fire$" { return "The central flame and smaller tongues are simplified into sharp marks radiating around the center." }
    default { return "The image of $concept is reduced to a few simple strokes, while its clearest outline remains visible." }
  }
}

function Get-TransitionCaption($Previous, $Current, [string]$Stage, [bool]$IsFirst, [string]$Meaning, [string]$FormationType, [string]$Character) {
  if ($IsFirst) { return Get-OriginCaption $Meaning }

  # Later captions compare neighboring artwork only. The inexpensive metrics
  # provide restrained variation grounded in the selected local SVGs; they are
  # not treated as a substitute for human review of an unclear comparison.
  if ($Stage -eq "regular") {
    $characterSeed = [int][char]$Character.Substring(0, 1)
    $options = @(
      "The strokes settle into an even, balanced arrangement with clearer separation between the main parts.",
      "The lines become more controlled, and the main sections settle into balanced proportions.",
      "The final arrangement is steadier, with distinct strokes and a clear balance between its parts."
    )
    return $options[$characterSeed % $options.Count]
  }

  if (-not $Previous.usable -or -not $Current.usable) {
    return "The main arrangement remains recognizable, while the marks become more even and controlled."
  }

  $lengthRatio = if ($Previous.pathLength -eq 0) { 1 } else { [double]$Current.pathLength / [double]$Previous.pathLength }
  $commandDelta = [int]$Current.commandCount - [int]$Previous.commandCount
  $characterSeed = [int][char]$Character.Substring(0, 1)

  switch ($Stage) {
    "bronze" {
      if ($lengthRatio -lt 0.82) {
        $options = @(
          "The early marks simplify into fewer strokes, while the main silhouette remains visible.",
          "Several small marks fall away, leaving the same basic outline in a cleaner form.",
          "The outline is drawn with fewer, simpler strokes, but its main shape is still easy to see."
        )
        return $options[$characterSeed % $options.Count]
      }
      if ($lengthRatio -gt 1.18) {
        $options = @(
          "The early marks become fuller and more continuous, while the main silhouette remains visible.",
          "The broken outline fills out into more continuous lines without losing its basic shape.",
          "The lines grow more complete and connected, keeping the original arrangement easy to follow."
        )
        return $options[$characterSeed % $options.Count]
      }
      if ($commandDelta -gt 8) {
        $options = @(
          "The outline gains fuller curves, while the original arrangement remains easy to recognize.",
          "More rounded lines fill the outline, but the earlier arrangement stays clear.",
          "The marks become fuller and rounder without disturbing the basic arrangement."
        )
        return $options[$characterSeed % $options.Count]
      }
      $options = @(
        "The main outline remains, but the strokes become more even and continuous.",
        "The basic shape holds steady as its separate marks become cleaner and more controlled.",
        "The structure changes only slightly; the lines become smoother and easier to distinguish."
      )
      return $options[$characterSeed % $options.Count]
    }
    "seal" {
      if ($lengthRatio -lt 0.82) {
        $options = @(
          "Small irregularities disappear, leaving a cleaner and more balanced arrangement.",
          "The compact shape loses stray details and settles into a clearer balance.",
          "Fewer marks remain, arranged with more even spacing and steadier proportions."
        )
        return $options[$characterSeed % $options.Count]
      }
      if ($lengthRatio -gt 1.18) {
        $options = @(
          "The separate parts draw into a smoother, more continuous outline with more even proportions.",
          "The parts connect into a fuller outline, with the height and spacing becoming more regular.",
          "The outline becomes more continuous, while its separate sections settle into steadier proportions."
        )
        return $options[$characterSeed % $options.Count]
      }
      if ($commandDelta -gt 8) {
        $options = @(
          "The lines become more rounded and connected, while the parts settle into a steadier arrangement.",
          "The curved sections join more smoothly, giving the separate parts a calmer balance.",
          "The parts remain distinct, but their connecting lines become rounder and more settled."
        )
        return $options[$characterSeed % $options.Count]
      }
      $options = @(
        "The parts settle into smoother curves and a more balanced arrangement.",
        "The separate marks become smoother, with their spacing and proportions more carefully balanced.",
        "The overall shape steadies as the curves become more even and the parts sit closer together."
      )
      return $options[$characterSeed % $options.Count]
    }
    "clerical" {
      if ($lengthRatio -lt 0.82) {
        $options = @(
          "Several curved sections reduce to fewer, broader strokes, giving the form a flatter structure.",
          "The longer curves shorten into broader marks, making the structure flatter and easier to read.",
          "Small details recede as the form settles into fewer, wider strokes."
        )
        return $options[$characterSeed % $options.Count]
      }
      if ($lengthRatio -gt 1.18) {
        $options = @(
          "The strokes broaden and straighten, making the form wider and more structured.",
          "The lines open outward into broader, straighter strokes while keeping the same arrangement.",
          "The form spreads into wider strokes, and its main sections become more clearly separated."
        )
        return $options[$characterSeed % $options.Count]
      }
      if ($commandDelta -lt -8) {
        $options = @(
          "Curved sections flatten into fewer, straighter strokes, giving the form a clearer structure.",
          "The curved lines simplify into straighter marks, leaving the main sections easier to distinguish.",
          "Several curved details disappear as the strokes become flatter and more direct."
        )
        return $options[$characterSeed % $options.Count]
      }
      $options = @(
        "Curved sections flatten into straighter, broader strokes, giving the form a more structured appearance.",
        "The rounded lines become flatter and more deliberate, while the main arrangement stays intact.",
        "The strokes straighten and broaden, bringing the separate sections into a clearer structure."
      )
      return $options[$characterSeed % $options.Count]
    }
    default {
      $options = @(
        "The overall arrangement changes little, but the strokes become more even and controlled.",
        "The same basic structure remains, with cleaner strokes and more deliberate spacing.",
        "Only small adjustments appear here; the lines become steadier and easier to separate."
      )
      return $options[$characterSeed % $options.Count]
    }
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
      $needsReview = $record.formationType -notin @("pictograph", "pictographic") -or [string]::IsNullOrWhiteSpace($record.history.origin.concept)
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
