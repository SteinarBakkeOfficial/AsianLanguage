$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
function Assert-True { param([bool]$Condition,[string]$Message); if (-not $Condition) { throw $Message } }
function Text([string]$Path) { Get-Content -Raw (Join-Path $repoRoot $Path) }

$evolution = Text "Sources/App/Lesson/CharacterEvolutionView.swift"
Assert-True $evolution.Contains("struct BundledHistoricalAssetResolver") "A centralized asset resolver must exist."
Assert-True $evolution.Contains("Asset requires a compiled iOS image representation") "Unsupported source assets must remain explicit."
Assert-True $evolution.Contains("Historical visual unavailable") "Missing Historical Assets must be visible."
Assert-True (-not $evolution.Contains("fallbackForm")) "Historical rendering must not use a modern fallback form."

$lesson = Text "Sources/App/Lesson/LessonView.swift"
Assert-True $lesson.Contains("CharacterEvolutionView(") "Lesson must use the Symbol Journey renderer."
Assert-True (-not $lesson.Contains("EvolutionBoardView")) "The obsolete board must not be on the production path."

$pictogram = Text "Sources/App/Lesson/SymbolPictogramView.swift"
Assert-True $pictogram.Contains("Origin visual unavailable") "List surfaces must use an explicit origin gap."
Assert-True (-not $pictogram.Contains('case "tree"')) "Origin visuals must not be hardcoded by record id."

Write-Output "OK: visual content contract tests passed"
