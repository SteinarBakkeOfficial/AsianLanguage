$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
function Assert-True { param([bool]$Condition,[string]$Message); if (-not $Condition) { throw $Message } }
function Text([string]$Path) { Get-Content -Raw (Join-Path $repoRoot $Path) }

$evolution = Text "Sources/App/Lesson/CharacterEvolutionView.swift"
Assert-True $evolution.Contains("struct BundledHistoricalAssetResolver") "A centralized asset resolver must exist."
Assert-True $evolution.Contains("case bundledSVG(URL)") "Bundled SVG assets must have an explicit local rendering path."
Assert-True $evolution.Contains("import WebKit") "Local SVG rendering must use an iOS-native view integration."
Assert-True $evolution.Contains("loadHTMLString") "Local SVG rendering must fit artwork to its assigned viewport."
Assert-True $evolution.Contains("isUserInteractionEnabled = false") "Historical artwork must not intercept journey controls."
Assert-True $evolution.Contains("Asset requires a compiled iOS image representation") "Unsupported source assets must remain explicit."
Assert-True $evolution.Contains("Historical visual unavailable") "Missing Historical Assets must be visible."
Assert-True (-not $evolution.Contains("fallbackForm")) "Historical rendering must not use a modern fallback form."
Assert-True $evolution.Contains("record.history.origin?.explanation ?? record.history.originAnchor") "Origin must display the full approved explanation before the legacy short anchor."
Assert-True $evolution.Contains("static let squareSize: CGFloat = 248") "Symbol exhibits should use one fixed artwork square across all stages."
Assert-True (-not $evolution.Contains("StageBackgroundNormalization")) "Stage backgrounds should be normalized as source assets, not at runtime."

Add-Type -AssemblyName System.Drawing
foreach ($stageID in @("origin", "oracleBone", "bronze", "seal", "clerical", "regular")) {
  $path = Join-Path $repoRoot "Resources/Assets/Symbols/_StageBackgrounds/$stageID.png"
  $bitmap = [System.Drawing.Bitmap]::new($path)
  try {
    $minX = $bitmap.Width
    $minY = $bitmap.Height
    $maxX = -1
    $maxY = -1
    for ($y = 0; $y -lt $bitmap.Height; $y++) {
      for ($x = 0; $x -lt $bitmap.Width; $x++) {
        if ($bitmap.GetPixel($x, $y).A -gt 8) {
          if ($x -lt $minX) { $minX = $x }
          if ($x -gt $maxX) { $maxX = $x }
          if ($y -lt $minY) { $minY = $y }
          if ($y -gt $maxY) { $maxY = $y }
        }
      }
    }
    Assert-True ($minX -le 1 -and $minY -le 1 -and $maxX -ge 510 -and $maxY -ge 510) "Stage background '$stageID' must fill the normalized canvas."
  }
  finally {
    $bitmap.Dispose()
  }
}

$lesson = Text "Sources/App/Lesson/LessonView.swift"
Assert-True $lesson.Contains("CharacterEvolutionView(") "Lesson must use the Symbol Journey renderer."
Assert-True (-not $lesson.Contains("EvolutionBoardView")) "The obsolete board must not be on the production path."

$modern = Text "Sources/App/Lesson/ModernFormsComparisonView.swift"
Assert-True $modern.Contains("Regular Script") "Modern must remain a single Regular Script museum endpoint."
Assert-True (-not $modern.Contains("ForEach(visibleTracks)")) "Modern must not render all language cards together."
Assert-True $modern.Contains("regularConclusion") "Regular Script must use a record-specific conclusion."
Assert-True $modern.Contains("transitionNote") "Regular Script must prefer the approved stage transition copy."
Assert-True (-not $modern.Contains("A modern standardized Kai reference rendering.")) "Regular Script must not repeat the generic rendering sentence."
Assert-True (-not $modern.Contains("Paper · brush")) "Regular Script must not show a historical method caption."
Assert-True $modern.Contains("AppTypography.body") "Regular Script conclusion must use the Museum body-text treatment."

$usage = Text "Sources/App/Lesson/UsageExamplesView.swift"
Assert-True $usage.Contains('Text("Korean")') "Korean Usage must use the plain Korean header."
Assert-True (-not $usage.Contains("Korean · Hanja / Hangul")) "Korean Usage must not repeat Hanja / Hangul in the page header."
Assert-True $usage.Contains("languageFormHeader") "Usage pages must show their locale-specific modern form before examples."
Assert-True $usage.Contains("showsJapaneseFurigana") "Japanese examples must opt into their native kana/furigana presentation."
Assert-True $usage.Contains("furiganaSegments") "Japanese examples must render structured furigana data."
Assert-True $usage.Contains("ensureBasicSentenceAtEnd: true") "Modern language pages must keep a basic sentence visible."
Assert-True $usage.Contains("koreanEquivalentRow") "Korean equivalents must have a distinct semantic-equivalent row."
Assert-True $usage.Contains('excludedExampleRoles: ["semanticEquivalent"]') "Korean semantic equivalents must not repeat as ordinary examples."

$tile = Text "Sources/App/SharedUI/DesignSystem.swift"
Assert-True (-not $tile.Contains('case .inProgress: return "In progress"')) "Browse character tiles should not label every non-learned record as in progress."

$pictogram = Text "Sources/App/Lesson/SymbolPictogramView.swift"
Assert-True $pictogram.Contains("Origin visual unavailable") "List surfaces must use an explicit origin gap."
Assert-True (-not $pictogram.Contains('case "tree"')) "Origin visuals must not be hardcoded by record id."

Write-Output "OK: visual content contract tests passed"
