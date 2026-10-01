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
# The exhibit uses a custom horizontal gesture so the whole page does not slide while the
# museum square crossfades in place. Keep testing the learner-facing behavior, not TabView.
Assert-True $evolution.Contains("DragGesture(minimumDistance: 24)") "Evolution must support horizontal stage paging."
Assert-True $evolution.Contains("selectedStageID = allJourneyIDs[nextIndex]") "Evolution swipe paging must select the adjacent stage."
Assert-True $evolution.Contains("PrimaryActionButton(completionTitle, action: onComplete)") "Today must offer a completion action that advances the Symbol Journey."
Assert-True $evolution.Contains("stageNavigator") "Evolution must expose stage navigation."
Assert-True $evolution.Contains("ScrollViewReader") "The stage rail must reveal the currently selected destination."
Assert-True $evolution.Contains("proxy.scrollTo(newID, anchor: .center)") "The stage rail must follow the selected language destination."
Assert-True $evolution.Contains("HistoricalAssetView") "Evolution must use the asset renderer."
Assert-True $evolution.Contains("Historical visual unavailable") "Evolution must expose missing-asset state."
Assert-True (-not $lesson.Contains("summaryContent")) "Summary must not interrupt the primary Symbol Journey."
Assert-True (-not $lesson.Contains("structureContent")) "Structure must not interrupt the primary Symbol Journey."
Assert-True (-not $lesson.Contains("Continue to Structure")) "The primary journey must not require a Structure continuation step."
Assert-True (-not $lesson.Contains("Link(")) "The primary journey must not open online source links."
Assert-True $lesson.Contains("setStarred") "Character detail must expose independent Favorite state."
Assert-True $lesson.Contains("setReviewLater") "Character detail must expose independent Review Later state."
Assert-True $lesson.Contains("QuickReviewCard") "Quick Review must use one card per learned symbol."
Assert-True $lesson.Contains("records.shuffled()") "Quick Review must randomize the learned-symbol session."
Assert-True $lesson.Contains(".meaningFromSymbol") "Quick Review must include symbol-to-meaning prompts."
Assert-True $lesson.Contains(".symbolFromMeaning") "Quick Review must include meaning-to-symbol prompts."
Assert-True $lesson.Contains(".targetLanguageForm") "Quick Review must include selected-language prompts."
Assert-True $lesson.Contains("Check this Symbol") "Quick Review must offer the full Symbol only after an incorrect choice."
Assert-True $lesson.Contains("Next Symbol") "Quick Review must advance one completed Symbol at a time."
Assert-True $lesson.Contains("Finish Review") "Quick Review must finish without forcing a journey replay."

Write-Output "OK: Symbol Journey lesson contract tests passed"
