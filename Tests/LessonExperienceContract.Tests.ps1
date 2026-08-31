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
Assert-True $evolution.Contains("ScrollViewReader") "Evolution must support one continuous scrollable journey."
Assert-True (-not $evolution.Contains("TabView")) "Evolution must not split history and Today into paged lesson concepts."
Assert-True $evolution.Contains("stageNavigator") "Evolution must expose stage navigation."
Assert-True $evolution.Contains("HistoricalAssetView") "Evolution must use the asset renderer."
Assert-True $evolution.Contains("Historical visual unavailable") "Evolution must expose missing-asset state."
Assert-True (-not $lesson.Contains("summaryContent")) "Summary must not interrupt the primary Symbol Journey."
Assert-True (-not $lesson.Contains("structureContent")) "Structure must not interrupt the primary Symbol Journey."
Assert-True (-not $lesson.Contains("Continue to Structure")) "The primary journey must not require a Structure continuation step."
Assert-True (-not $lesson.Contains("Link(")) "The primary journey must not open online source links."
Assert-True $lesson.Contains("setStarred") "Character detail must expose independent Favorite state."
Assert-True $lesson.Contains("setReviewLater") "Character detail must expose independent Review Later state."

Write-Output "OK: Symbol Journey lesson contract tests passed"
