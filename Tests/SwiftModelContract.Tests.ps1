$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
function Assert-True { param([bool]$Condition,[string]$Message); if (-not $Condition) { throw $Message } }
function Text([string]$Path) { Get-Content -Raw (Join-Path $repoRoot $Path) }

$focus = Text "Sources/App/Core/FocusTrack.swift"
foreach ($case in @("case simplifiedChinese","case traditionalChinese","case japanese","case korean")) {
  Assert-True $focus.Contains($case) "FocusTrack is missing $case."
}
Assert-True (-not $focus.Contains("case all")) "FocusTrack must not have an All enum case."
Assert-True $focus.Contains("static let all = FocusTrackSelection") "All four tracks must be selected by default."

$position = Text "Sources/App/Lesson/LessonStep.swift"
Assert-True $position.Contains("enum SymbolJourneySection") "Journey sections must be modeled."
Assert-True $position.Contains("struct SymbolJourneyPosition") "Exact journey position must be modeled."

$route = Text "Sources/App/Lesson/LessonRoute.swift"
Assert-True $route.Contains("let startingPosition: SymbolJourneyPosition?") "Routes must carry exact journey position."

$record = Text "Sources/App/Corpus/SharedCharacterRecord.swift"
foreach ($field in @("let assetMetadata: HistoricalAssetMetadata?","let introducedComponentIds: [String]?","let stageExplanation: String?","let introducedAtStage: String?","let taiwanReadings: [CharacterReading]","let hongKongReadings: [CharacterReading]","let variants: [ModernFormVariant]")) {
  Assert-True $record.Contains($field) "Corpus model is missing $field."
}
Assert-True $record.Contains("enum HistoricalAvailabilityState") "Historical availability must be modeled separately from confidence."
Assert-True $record.Contains("let availabilityState: HistoricalAvailabilityState") "Historical stages must expose explicit availability."
Assert-True $record.Contains("var editorialConfidence: EditorialConfidence") "Historical confidence must be normalized for presentation."

$homeText = Text "Sources/App/Home/HomeView.swift"
Assert-True $homeText.Contains("homeRecord") "Home must resolve its display record from its route."
Assert-True (-not $homeText.Contains("nextUnlearnedRecord?.featuredSummary")) "Home must not render a different record from its route."

Write-Output "OK: current Swift model contract tests passed"
