$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

function Assert-True {
  param(
    [Parameter(Mandatory = $true)]
    [bool]$Condition,
    [Parameter(Mandatory = $true)]
    [string]$Message
  )

  if (-not $Condition) {
    throw $Message
  }
}

function Assert-Contains {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Text,
    [Parameter(Mandatory = $true)]
    [string]$ExpectedSubstring,
    [Parameter(Mandatory = $true)]
    [string]$Message
  )

  Assert-True -Condition $Text.Contains($ExpectedSubstring) -Message "$Message Expected '$ExpectedSubstring'."
}

function Get-Text {
  param(
    [Parameter(Mandatory = $true)]
    [string]$RelativePath
  )

  return Get-Content -Raw (Join-Path $repoRoot $RelativePath)
}

$lessonStepText = Get-Text "Sources/App/Lesson/LessonStep.swift"
$expectedLessonCases = @(
  "case origin",
  "case character",
  "case modernForms",
  "case structure",
  "case usage",
  "case summary"
)

foreach ($case in $expectedLessonCases) {
  Assert-Contains -Text $lessonStepText -ExpectedSubstring $case -Message "LessonStep should preserve the V1 guided flow."
}

$focusTrackText = Get-Text "Sources/App/Core/FocusTrack.swift"
$expectedFocusCases = @(
  "case simplifiedChinese",
  "case traditionalChinese",
  "case japanese",
  "case korean"
)

foreach ($case in $expectedFocusCases) {
  Assert-Contains -Text $focusTrackText -ExpectedSubstring $case -Message "FocusTrack should preserve required V1 focus lanes."
}
Assert-Contains -Text $focusTrackText -ExpectedSubstring "struct FocusTrackSelection" -Message "Focus model should support multi-select focus tracks."
Assert-Contains -Text $focusTrackText -ExpectedSubstring "static let all = FocusTrackSelection" -Message "Focus selection should default all required tracks on."

$lessonRouteText = Get-Text "Sources/App/Lesson/LessonRoute.swift"
Assert-Contains -Text $lessonRouteText -ExpectedSubstring "let sharedCharacterID: String" -Message "LessonRoute should be keyed by Shared Character id."
Assert-Contains -Text $lessonRouteText -ExpectedSubstring "let startingStep: LessonStep?" -Message "LessonRoute should allow an optional starting step."

$recordText = Get-Text "Sources/App/Corpus/SharedCharacterRecord.swift"
$requiredRecordFields = @(
  "let id: String",
  "let teachingSequence: Int",
  "let coreCharacter: String",
  "let coreSharedMeaning: String",
  "let recognitionTakeaway: String",
  "let focusCoverage: FocusCoverage",
  "let visuals: SharedCharacterVisuals",
  "let history: CharacterHistory",
  "let structure: CharacterStructure",
  "let usage: UsageSummary",
  "let sources: [CorpusSource]"
  "let url: String?"
)

foreach ($field in $requiredRecordFields) {
  Assert-Contains -Text $recordText -ExpectedSubstring $field -Message "SharedCharacterRecord should expose the V1 corpus contract."
}

$repositoryText = Get-Text "Sources/App/Corpus/BundleCorpusRepository.swift"
Assert-Contains -Text $repositoryText -ExpectedSubstring "func sharedCharacter(id: String) throws -> SharedCharacterRecord" -Message "BundleCorpusRepository should load records by id."
Assert-Contains -Text $repositoryText -ExpectedSubstring "func sharedCharacters(ids: [String])" -Message "BundleCorpusRepository should load manifest records."
Assert-Contains -Text $repositoryText -ExpectedSubstring "subdirectory: `"Corpus`"" -Message "BundleCorpusRepository should load bundled Corpus folder JSON records."

Assert-Contains -Text $recordText -ExpectedSubstring "enum UsageExampleLevel" -Message "SharedCharacterRecord should expose progressive example levels."
Assert-Contains -Text $recordText -ExpectedSubstring "let parallelExampleGroupID: String?" -Message "Usage examples should support parallel grouping."
Assert-Contains -Text $recordText -ExpectedSubstring "let introducedSymbols: [String]" -Message "Usage examples should support symbol sequencing."

$homeText = Get-Text "Sources/App/Home/HomeView.swift"
Assert-Contains -Text $homeText -ExpectedSubstring "homeLessonRoute" -Message "Home should route through its selected lesson route."
Assert-Contains -Text $homeText -ExpectedSubstring "nextUnlearnedRecord?.id ?? dependencies.nextFeaturedSharedCharacter.id" -Message "Home should route to the next unlearned Shared Character before falling back to the dependency default."

$lessonViewText = Get-Text "Sources/App/Lesson/LessonView.swift"
Assert-Contains -Text $lessonViewText -ExpectedSubstring "dependencies.corpusRepository.sharedCharacter(id: route.sharedCharacterID)" -Message "Lesson view should resolve its routed corpus record."
Assert-Contains -Text $lessonViewText -ExpectedSubstring "ForEach(LessonStep.allCases)" -Message "Lesson view should expose the six-step flow."

$swiftTestText = Get-Text "Tests/AsianLanguageTests/SharedCharacterRecordTests.swift"
Assert-Contains -Text $swiftTestText -ExpectedSubstring "BundleCorpusRepository(bundle: Bundle(for: Self.self))" -Message "Future XCTest should decode records from the test bundle."
Assert-Contains -Text $swiftTestText -ExpectedSubstring "record.focusCoverage.traditionalChinese.form" -Message "Future XCTest should cover Traditional Chinese focus coverage."

Write-Output "OK: Swift model contract tests passed"
