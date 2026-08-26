$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
function Assert-True { param([bool]$Condition,[string]$Message); if (-not $Condition) { throw $Message } }
function Text([string]$Path) { Get-Content -Raw (Join-Path $repoRoot $Path) }

$lesson = Text "Sources/App/Lesson/LessonView.swift"
Assert-True $lesson.Contains("SymbolJourneyPosition") "Lesson must use exact Symbol Journey positions."
Assert-True $lesson.Contains("markLearnedAndOpenNext") "Lesson must support automatic next-symbol progression."
Assert-True $lesson.Contains("state.markInProgress(at: position)") "Lesson must persist exact journey position."
Assert-True (-not $lesson.Contains("LessonStep.allCases")) "Lesson must not render the obsolete six-step rail."
Assert-True (-not $lesson.Contains("EvolutionBoardView")) "Lesson must not depend on the obsolete poster board."
Assert-True $lesson.Contains("UsageExamplesView(record: record, focusSelection:") "Usage must remain focus-track aware."

$evolution = Text "Sources/App/Lesson/CharacterEvolutionView.swift"
Assert-True $evolution.Contains("TabView") "Evolution must support horizontal stage paging."
Assert-True $evolution.Contains("stageNavigator") "Evolution must expose stage navigation."
Assert-True $evolution.Contains("HistoricalAssetView") "Evolution must use the asset renderer."
Assert-True $evolution.Contains("Historical visual unavailable") "Evolution must expose missing-asset state."

Write-Output "OK: Symbol Journey lesson contract tests passed"
