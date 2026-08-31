param(
  [string]$SourcePath = "content/shared-characters",
  [string]$SymbolsPath = "content/symbols",
  [string]$ComponentsPath = "content/components",
  [string]$ManifestPath = "content/manifests",
  [string]$AssetRoot = "Resources"
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$sourceRoot = Join-Path $repoRoot $SourcePath
$symbolsRoot = Join-Path $repoRoot $SymbolsPath
$componentsRoot = Join-Path $repoRoot $ComponentsPath
$manifestRoot = Join-Path $repoRoot $ManifestPath
$assetRootPath = Join-Path $repoRoot $AssetRoot

function Write-JsonFile {
  param(
    [Parameter(Mandatory = $true)] $Value,
    [Parameter(Mandatory = $true)] [string]$Path
  )

  $Value | ConvertTo-Json -Depth 50 | Set-Content -LiteralPath $Path -Encoding utf8
}

function Write-TextFile {
  param(
    [Parameter(Mandatory = $true)] [string]$Text,
    [Parameter(Mandatory = $true)] [string]$Path
  )

  $Text | Set-Content -LiteralPath $Path -Encoding utf8
}

function Get-CodePointLabel {
  param([Parameter(Mandatory = $true)] [string]$Character)

  $codePoint = [System.Char]::ConvertToUtf32($Character, 0)
  return "U+{0:X4}" -f $codePoint
}

function Get-SymbolFolderName {
  param([Parameter(Mandatory = $true)] $Record)

  return "{0}-{1}" -f $Record.id, (Get-CodePointLabel -Character $Record.coreCharacter).Replace("U+", "u")
}

function Get-FormationType {
  param([Parameter(Mandatory = $true)] [string]$ID)

  switch ($ID) {
    "big" { return "simpleIdeograph" }
    "small" { return "simpleIdeograph" }
    default { return "pictograph" }
  }
}

function Get-VisualTeachingNotes {
  param([Parameter(Mandatory = $true)] [string]$ID)

  $notes = @{
    fire = @(
      "Central flame should remain visually dominant.",
      "Show lateral flame activity where it helps comparison with the early graph.",
      "Avoid logs or a campfire setting overpowering the flame structure."
    )
    tree = @(
      "Show the whole tree with a clear trunk and visible branching.",
      "Avoid a canopy-only photograph.",
      "Keep the presentation neutral and uncluttered."
    )
    water = @(
      "Show flowing water lines or a clear water movement concept.",
      "Keep the visual structure legible at the scale used beside the graph.",
      "Avoid scenery that makes the relevant form difficult to notice."
    )
    mountain = @(
      "Show distinct mountain peaks or a readable mountain silhouette.",
      "Keep the central shape simple enough to compare with the graph."
    )
    person = @(
      "Use a clear side-view human posture where it supports the source-backed interpretation.",
      "Avoid modern contextual clutter."
    )
    eye = @(
      "Keep the eye orientation and main enclosing shape visible.",
      "Avoid decorative portrait context that obscures the concept."
    )
    mouth = @(
      "Show an opening or mouth shape clearly.",
      "Keep the visual simple and frontal where that supports the approved interpretation."
    )
    day = @(
      "Show a clear sun or solar disk concept.",
      "Avoid atmospheric scenery that hides the simple graphic relationship."
    )
    moon = @(
      "Show the moon as the central concept.",
      "Avoid a busy night landscape that competes with the shape comparison."
    )
  }

  if ($notes.ContainsKey($ID)) { return @($notes[$ID]) }
  return @("Educational composition is pending editorial direction for this Symbol.")
}

function Get-StageFolderName {
  param([Parameter(Mandatory = $true)] [string]$Stage)

  switch ($Stage) {
    "oracleBone" { return "oracle" }
    default { return $Stage }
  }
}

function Get-StageAvailability {
  param([Parameter(Mandatory = $true)] $Stage)

  if ($null -ne $Stage.availabilityState) { return $Stage.availabilityState }
  if ($null -ne $Stage.assetRef -or $null -ne $Stage.assetMetadata) { return "available" }
  return "unavailableAsset"
}

function Resolve-RepositoryAssetPath {
  param([Parameter(Mandatory = $true)] [string]$AssetReference)

  if ([string]::IsNullOrWhiteSpace($AssetReference)) { return $null }
  $relativeAssetPath = $AssetReference -replace "^Assets[/\\]", "Assets\"
  return Join-Path $assetRootPath $relativeAssetPath
}

if (-not (Test-Path $sourceRoot)) {
  throw "Source content path not found: $sourceRoot"
}

New-Item -ItemType Directory -Path $symbolsRoot -Force | Out-Null
New-Item -ItemType Directory -Path $componentsRoot -Force | Out-Null
New-Item -ItemType Directory -Path $manifestRoot -Force | Out-Null

$records = @(Get-ChildItem -LiteralPath $sourceRoot -Filter "*.json" -File | Sort-Object Name | ForEach-Object {
  Get-Content -Raw -LiteralPath $_.FullName | ConvertFrom-Json
})

if ($records.Count -eq 0) {
  throw "No Symbol records found in $sourceRoot"
}

$symbolManifest = [System.Collections.Generic.List[object]]::new()
$assetManifest = [System.Collections.Generic.List[object]]::new()

foreach ($record in $records) {
  $folderName = Get-SymbolFolderName -Record $record
  $symbolRoot = Join-Path $symbolsRoot $folderName
  $educationalOriginalRoot = Join-Path $symbolRoot "educational/original"
  $educationalAppRoot = Join-Path $symbolRoot "educational/app"
  $historicalRoot = Join-Path $symbolRoot "historical"
  $componentsReferenceRoot = Join-Path $symbolRoot "components"

  New-Item -ItemType Directory -Path $educationalOriginalRoot -Force | Out-Null
  New-Item -ItemType Directory -Path $educationalAppRoot -Force | Out-Null
  New-Item -ItemType Directory -Path $componentsReferenceRoot -Force | Out-Null

  # Force single-note fallback values to remain JSON arrays for the Swift [String]? model.
  $visualNotes = @(Get-VisualTeachingNotes -ID $record.id)
  foreach ($stage in @($record.history.stages)) {
    if ($null -eq $stage.availabilityState) {
      $stage | Add-Member -NotePropertyName availabilityState -NotePropertyValue (Get-StageAvailability -Stage $stage) -Force
    }
  }
  $record | Add-Member -NotePropertyName unicodeCodePoint -NotePropertyValue (Get-CodePointLabel -Character $record.coreCharacter) -Force
  $record | Add-Member -NotePropertyName simplifiedForm -NotePropertyValue $record.coreCharacter -Force
  $record | Add-Member -NotePropertyName traditionalForm -NotePropertyValue $record.coreCharacter -Force
  $record | Add-Member -NotePropertyName additionalMeanings -NotePropertyValue @($record.coreSharedMeaning -split ";\s*") -Force
  $record | Add-Member -NotePropertyName formationType -NotePropertyValue (Get-FormationType -ID $record.id) -Force
  $record | Add-Member -NotePropertyName visualTeachingNotes -NotePropertyValue $visualNotes -Force
  $record | Add-Member -NotePropertyName contentFolder -NotePropertyValue ((Join-Path $SymbolsPath $folderName).Replace("\", "/")) -Force
  $record | Add-Member -NotePropertyName learnerCopyPath -NotePropertyValue "lesson.md" -Force
  $record | Add-Member -NotePropertyName researchNotesPath -NotePropertyValue "research.md" -Force
  $record | Add-Member -NotePropertyName reviewPath -NotePropertyValue "review.md" -Force
  $record | Add-Member -NotePropertyName sourceConflicts -NotePropertyValue @() -Force
  $record | Add-Member -NotePropertyName editorialStatus -NotePropertyValue "needsReview" -Force

  Write-JsonFile -Value $record -Path (Join-Path $symbolRoot "symbol.json")
  Write-JsonFile -Value @($record.sources) -Path (Join-Path $symbolRoot "sources.json")

  $originState = if ($null -ne $record.history.origin) { "available" } else { "unavailableAsset" }
  $originSourcePath = $null
  $originAppPath = $null
  if ($null -ne $record.history.origin -and $null -ne $record.history.origin.asset) {
    $originSourcePath = Resolve-RepositoryAssetPath -AssetReference $record.history.origin.asset.assetRef
    if ($null -ne $originSourcePath -and (Test-Path $originSourcePath)) {
      $originExtension = [System.IO.Path]::GetExtension($originSourcePath)
      $originOriginalTarget = Join-Path $educationalOriginalRoot ("origin" + $originExtension)
      $originAppTarget = Join-Path $educationalAppRoot ("origin" + $originExtension)
      Copy-Item -LiteralPath $originSourcePath -Destination $originOriginalTarget -Force
      Copy-Item -LiteralPath $originSourcePath -Destination $originAppTarget -Force
      $originSourcePath = $originOriginalTarget.Substring($repoRoot.Path.Length + 1).Replace("\", "/")
      $originAppPath = $originAppTarget.Substring($repoRoot.Path.Length + 1).Replace("\", "/")
    } else {
      $originSourcePath = $null
    }
  }
  $lessonText = @(
    "# {0} / {1}" -f $record.coreSharedMeaning, $record.coreCharacter
    ""
    "Editorial status: needsReview"
    ""
    "## Learner-facing premise"
    ""
    $record.history.originAnchor
    ""
    "## Journey"
    ""
    "This Symbol proceeds through the historical stages supplied in symbol.json, then reaches Today and the selected modern language tracks."
    ""
    "The Origin visual state is currently {0}. Missing material must remain explicit until an approved local asset is added." -f $originState
    ""
    "## Today"
    ""
    "The learner-facing modern forms and readings remain in symbol.json under focusCoverage."
  ) -join [Environment]::NewLine
  Write-TextFile -Text $lessonText.Trim() -Path (Join-Path $symbolRoot "lesson.md")

  $stageResearchLines = @($record.history.stages | ForEach-Object {
    $legacyAvailability = Get-StageAvailability -Stage $_
    "- **{0}** ({1}): certainty {2}; local asset reference {3}; availability {4}" -f $_.label, $_.stage, $_.certainty, $_.assetRef, $legacyAvailability
  })
  $stageResearch = $stageResearchLines -join [Environment]::NewLine
  $researchText = @(
    "# Research notes: $($record.coreCharacter)"
    ""
    "This folder was prepared from the existing draft Shared Character record. It is editorial working material, not an approval record."
    ""
    "## Current evidence boundary"
    ""
    $record.visuals.note
    ""
    "## Formation mode"
    ""
    "{0} is a pedagogical working classification and requires human review before publication." -f $record.formationType
    ""
    "## Historical stages"
    ""
    $stageResearch
    ""
    "## Review rule"
    ""
    "Do not convert a missing stage into a guessed glyph. Record source disagreement in symbol.json under sourceConflicts and keep the Symbol in needsReview until resolved."
  ) -join [Environment]::NewLine
  Write-TextFile -Text $researchText.Trim() -Path (Join-Path $symbolRoot "research.md")

  $reviewText = @(
    "# Review: $($record.coreCharacter) / $($record.coreSharedMeaning)"
    ""
    "Status: needsReview"
    "Content folder: $SymbolsPath/$folderName"
    ""
    "## Human review checklist"
    ""
    "- [ ] Formation type checked against reputable sources."
    "- [ ] Learner-facing copy separated from research notes."
    "- [ ] Each historical stage has an evidence decision or is intentionally omitted."
    "- [ ] Historical asset provenance and redistribution license verified."
    "- [ ] Educational reconstruction is clearly separate from historical evidence."
    "- [ ] Modern readings and examples reviewed by an appropriate language editor."
    "- [ ] Source conflicts recorded explicitly."
    "- [ ] All required production assets resolve locally for offline packaging."
    "- [ ] Accessibility descriptions reviewed."
    ""
    "## Known gaps from the draft record"
    ""
    "- Publication status is $($record.publicationStatus)."
    "- Asset status is $($record.visuals.assetStatus)."
    "- $($record.visuals.note)"
  ) -join [Environment]::NewLine
  Write-TextFile -Text $reviewText.Trim() -Path (Join-Path $symbolRoot "review.md")

  $visualNotesText = @(
    "# Visual teaching notes"
    ""
    "These notes describe an educational reconstruction only. They must not be used to fabricate or label a historical artifact."
    ""
    @($visualNotes | ForEach-Object { "- $_" })
    ""
    "Historical stage used as visual reference: editorial review required."
  ) -join [Environment]::NewLine
  Write-TextFile -Text $visualNotesText.Trim() -Path (Join-Path $symbolRoot "educational/visual-notes.md")
  Write-TextFile -Text "Store the generation or commissioning specification here. Educational reconstruction only; never historical evidence." -Path (Join-Path $symbolRoot "educational/prompt.md")
  Write-JsonFile -Value ([ordered]@{
    contentClass = "educationalReconstruction"
    reviewStatus = "needsReview"
    visualTeachingNotes = $visualNotes
    originalAsset = $originSourcePath
    appAsset = $originAppPath
  }) -Path (Join-Path $symbolRoot "educational/metadata.json")

  if ($null -ne $originAppPath) {
    $assetManifest.Add([ordered]@{
      symbolID = $record.id
      stage = "origin"
      path = $originAppPath
      contentClass = "educationalReconstruction"
      editorialStatus = "needsReview"
    }) | Out-Null
  }

  $componentReference = @($record.structure.components | ForEach-Object {
    [ordered]@{
      id = if ($null -ne $_.id) { $_.id } else { $record.id }
      label = $_.label
      role = $_.role
      canonicalFolder = "content/components/$($record.id)"
      introducedAtStage = $_.introducedAtStage
      sourceIds = $_.sourceIds
      reviewStatus = "needsReview"
    }
  })
  Write-JsonFile -Value $componentReference -Path (Join-Path $componentsReferenceRoot "references.json")

  $componentRoot = Join-Path $componentsRoot $record.id
  New-Item -ItemType Directory -Path (Join-Path $componentRoot "educational") -Force | Out-Null
  New-Item -ItemType Directory -Path (Join-Path $componentRoot "historical") -Force | Out-Null
  Write-JsonFile -Value ([ordered]@{
    id = $record.id
    canonicalCharacter = $record.coreCharacter
    meaning = $record.coreSharedMeaning
    formationType = $record.formationType
    reviewStatus = "needsReview"
    sourceIds = @($record.structure.sourceIds)
  }) -Path (Join-Path $componentRoot "component.json")
  Write-TextFile -Text "# $($record.coreCharacter) component concept`n`nThis reusable component record is a draft reference. Confirm its meaning, form, and reuse contexts before publication." -Path (Join-Path $componentRoot "lesson.md")
  Write-JsonFile -Value @($record.sources) -Path (Join-Path $componentRoot "sources.json")

  $stageManifest = [System.Collections.Generic.List[object]]::new()
  foreach ($stage in @($record.history.stages)) {
    $stageFolder = Join-Path $historicalRoot (Get-StageFolderName -Stage $stage.stage)
    $originalFolder = Join-Path $stageFolder "original"
    $appFolder = Join-Path $stageFolder "app"
    New-Item -ItemType Directory -Path $originalFolder -Force | Out-Null
    New-Item -ItemType Directory -Path $appFolder -Force | Out-Null

    $sourceAssetPath = if ($null -ne $stage.assetRef) { Resolve-RepositoryAssetPath -AssetReference $stage.assetRef } else { $null }
    $localAssetExists = $null -ne $sourceAssetPath -and (Test-Path $sourceAssetPath)
    $contentClass = if (@($stage.sourceIds) -contains "source-prototype-redraw") { "educationalReconstruction" } elseif ($localAssetExists) { "historicalEvidence" } else { $null }
    $appAssetPath = $null
    $originalAssetPath = $null
    if ($localAssetExists) {
      $extension = [System.IO.Path]::GetExtension($sourceAssetPath)
      $originalTarget = Join-Path $originalFolder ("source-asset" + $extension)
      $appTarget = Join-Path $appFolder ("glyph" + $extension)
      Copy-Item -LiteralPath $sourceAssetPath -Destination $originalTarget -Force
      Copy-Item -LiteralPath $sourceAssetPath -Destination $appTarget -Force
      $originalAssetPath = $originalTarget.Substring($repoRoot.Path.Length + 1).Replace("\", "/")
      $appAssetPath = $appTarget.Substring($repoRoot.Path.Length + 1).Replace("\", "/")
    }

    $availability = Get-StageAvailability -Stage $stage
    $stageSource = [ordered]@{
      character = $record.coreCharacter
      stage = $stage.stage
      approximatePeriod = $null
      sourceInstitution = $null
      sourcePageURL = $null
      sourceAssetURL = $null
      catalogueReference = $null
      sourceDescription = $null
      license = if ($contentClass -eq "educationalReconstruction") { "internal-prototype-review-required" } else { "unresolved" }
      originalAssetPath = $originalAssetPath
      appAssetPath = $appAssetPath
      assetClass = $contentClass
      confidence = $stage.certainty
      availabilityState = $availability
      editorialStatus = "needsReview"
      sourceIds = @($stage.sourceIds)
      editorialNotes = @("Populate from an identifiable source before approval.")
    }
    Write-JsonFile -Value $stageSource -Path (Join-Path $stageFolder "source.json")
    $stageNotesText = @(
      "# $($stage.label)"
      ""
      "Availability: $availability"
      ""
      "This stage remains needsReview. Keep original source material separate from the app derivative and do not add a guessed glyph."
    ) -join [Environment]::NewLine
    Write-TextFile -Text $stageNotesText -Path (Join-Path $stageFolder "notes.md")

    $stageManifest.Add([ordered]@{
      stage = $stage.stage
      availabilityState = $availability
      contentClass = $contentClass
      sourceIds = @($stage.sourceIds)
      originalAssetPath = $originalAssetPath
      appAssetPath = $appAssetPath
      runtimeAssetRef = $stage.assetRef
      localAssetExists = $localAssetExists
    }) | Out-Null
    if ($null -ne $appAssetPath) {
      $assetManifest.Add([ordered]@{
        symbolID = $record.id
        stage = $stage.stage
        path = $appAssetPath
        contentClass = $contentClass
        editorialStatus = "needsReview"
      }) | Out-Null
    }
  }

  Write-JsonFile -Value $stageManifest -Path (Join-Path $symbolRoot "historical/manifest.json")
  $symbolManifest.Add([ordered]@{
    id = $record.id
    character = $record.coreCharacter
    unicodeCodePoint = Get-CodePointLabel -Character $record.coreCharacter
    folder = (Join-Path $SymbolsPath $folderName).Replace("\", "/")
    symbolJSON = (Join-Path $SymbolsPath "$folderName/symbol.json").Replace("\", "/")
    editorialStatus = "needsReview"
    publicationStatus = $record.publicationStatus
    offlineReady = $false
    stageCount = @($record.history.stages).Count
    localAssetCount = @($stageManifest | Where-Object { $_.localAssetExists }).Count
  }) | Out-Null
}

Write-JsonFile -Value ([ordered]@{
  generatedAt = (Get-Date).ToUniversalTime().ToString("o")
  source = (Join-Path $SymbolsPath "*/symbol.json").Replace("\", "/")
  reviewRequired = $true
  symbols = @($symbolManifest)
}) -Path (Join-Path $manifestRoot "symbols.json")

Write-JsonFile -Value ([ordered]@{
  generatedAt = (Get-Date).ToUniversalTime().ToString("o")
  offlineRuntimeNetworkRequired = $false
  assets = @($assetManifest)
}) -Path (Join-Path $manifestRoot "app-assets.json")

Write-Output "OK: prepared $($records.Count) Symbol workspace folder(s); all remain needsReview."
exit 0
