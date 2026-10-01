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

$settingsText = Get-Text "Sources/App/Settings/SettingsView.swift"
Assert-Contains -Text $settingsText -ExpectedSubstring "@State private var isShowingResetConfirmation" -Message "Settings should track reset confirmation presentation."
Assert-Contains -Text $settingsText -ExpectedSubstring ".alert(" -Message "Settings should confirm reset before clearing progress."
Assert-True (-not $settingsText.Contains("About Script Roots")) "Settings should not duplicate the canonical About destination."
Assert-True (-not $settingsText.Contains("SourcesLicensesView")) "Settings should not duplicate the canonical Sources destination."

$aboutText = Get-Text "Sources/App/Settings/AboutMethodView.swift"
Assert-Contains -Text $aboutText -ExpectedSubstring "struct AboutMethodView: View" -Message "Polish should include an About app information view."
Assert-Contains -Text $aboutText -ExpectedSubstring "Shared Character" -Message "About should identify the bundled lesson unit."
Assert-Contains -Text $aboutText -ExpectedSubstring "offline" -Message "About should explain offline behavior."
Assert-Contains -Text $aboutText -ExpectedSubstring "corpusCount" -Message "About should include corpus size."

$browseText = Get-Text "Sources/App/Browse/BrowseView.swift"
Assert-Contains -Text $browseText -ExpectedSubstring "ContentUnavailableView" -Message "Browse should have a native empty state."

$collectionsText = Get-Text "Sources/App/Collections/CollectionsView.swift"
Assert-Contains -Text $collectionsText -ExpectedSubstring "EditorialCollectionArtwork" -Message "Collections should use editorial artwork previews."

$evolutionText = Get-Text "Sources/App/Lesson/CharacterEvolutionView.swift"
Assert-Contains -Text $evolutionText -ExpectedSubstring "SymbolStageBackgroundView" -Message "Symbol stages should use the approved stage environments."
Assert-Contains -Text $evolutionText -ExpectedSubstring "AppMotion.exhibit" -Message "Symbol stage changes should use the restrained exhibit transition."
Assert-True (-not $evolutionText.Contains("stageDateLabel")) "Symbol pages must not show period/date metadata."

$onboardingText = Get-Text "Sources/App/Navigation/RootTabView.swift"
Assert-Contains -Text $onboardingText -ExpectedSubstring 'private let onboardingSymbolID = "mountain"' -Message "Onboarding should use the curated Mountain exhibit."
Assert-Contains -Text $onboardingText -ExpectedSubstring 'openSymbol(onboardingSymbolID, intent: .start)' -Message "Onboarding should enter the curated exhibit from one primary page."
Assert-Contains -Text $onboardingText -ExpectedSubstring '.background(AppColors.artifactField)' -Message "Onboarding Today should use the same artifact tile surface as the historical stages."
Assert-Contains -Text $onboardingText -ExpectedSubstring "Choose your language paths" -Message "Onboarding should include the language setup page."
Assert-Contains -Text $onboardingText -ExpectedSubstring "History explains how each writing tradition works" -Message "Onboarding should explain the History pronunciation guidance."
Assert-Contains -Text $onboardingText -ExpectedSubstring "HistoryScriptDetailView" -Message "History script entries should open detail destinations."
Assert-Contains -Text $onboardingText -ExpectedSubstring "HistoryModernLanguageDetailView" -Message "History modern-language branches should open detail destinations."
Assert-Contains -Text $onboardingText -ExpectedSubstring "Historical and research references" -Message "Sources should show the concise historical and research reference list."
Assert-True (-not $onboardingText.Contains("Apple Speech Synthesis")) "Sources should not present technical speech attribution as a historical source."

$moreText = Get-Text "Sources/App/Navigation/RootTabView.swift"
Assert-Contains -Text $moreText -ExpectedSubstring 'utilityLink("About Script Roots"' -Message "More should own the canonical About destination."
Assert-Contains -Text $moreText -ExpectedSubstring 'utilityLink("Sources & Licenses"' -Message "More should own the canonical Sources destination."

$lessonText = Get-Text "Sources/App/Lesson/LessonView.swift"
Assert-Contains -Text $lessonText -ExpectedSubstring 'navigationMeaning(for: $0)' -Message "Symbol navigation titles should use a concise primary meaning."
Assert-Contains -Text $lessonText -ExpectedSubstring 'record.primarySharedMeaning' -Message "Symbol navigation titles should use the primary display meaning."
Assert-Contains -Text $lessonText -ExpectedSubstring '.split(separator: "(", maxSplits: 1' -Message "Symbol navigation titles should keep historical parentheticals out of the title."
Assert-Contains -Text $lessonText -ExpectedSubstring '.split(separator: "/", maxSplits: 1' -Message "Symbol navigation titles should use one concise primary meaning."

$recordText = Get-Text "Sources/App/Corpus/SharedCharacterRecord.swift"
Assert-Contains -Text $recordText -ExpectedSubstring "primarySharedMeaning" -Message "Learner-facing labels should have a primary meaning separate from editorial qualifiers."
Assert-Contains -Text $recordText -ExpectedSubstring "let speechText: String?" -Message "Readings should support explicit speech text."
Assert-Contains -Text $recordText -ExpectedSubstring "let speechLanguage: PronunciationLanguage?" -Message "Readings should carry platform-independent speech language intent."

$pronunciationText = Get-Text "Sources/App/Core/PronunciationService.swift"
Assert-Contains -Text $pronunciationText -ExpectedSubstring "AVSpeechSynthesizer" -Message "iOS pronunciation should use the native speech synthesizer."
Assert-Contains -Text $pronunciationText -ExpectedSubstring "zh-HK" -Message "Cantonese should have its own iOS locale."
Assert-Contains -Text $pronunciationText -ExpectedSubstring "stopSpeaking(at: .immediate)" -Message "New pronunciation should stop existing speech first."

$validatorText = Get-Text "Tools/Validate-Corpus.ps1"
Assert-Contains -Text $validatorText -ExpectedSubstring "Assert-PronunciationData" -Message "Corpus validation should protect explicit pronunciation metadata."
Assert-Contains -Text $validatorText -ExpectedSubstring "speechText and speechLanguage" -Message "Corpus validation should reject incomplete speech metadata."
$importText = Get-Text "Tools/Import-V1RuntimeCorpus.ps1"
Assert-Contains -Text $importText -ExpectedSubstring "Missing Cantonese data remains missing; it must never become Mandarin data." -Message "Cantonese import must not fall back to Mandarin."
Assert-Contains -Text $importText -ExpectedSubstring "Mandarin starter content must never appear under a Cantonese heading." -Message "Cantonese examples must not use Mandarin starter content."
$usageText = Get-Text "Sources/App/Lesson/UsageExamplesView.swift"
Assert-Contains -Text $usageText -ExpectedSubstring "hongKongReadings.isEmpty" -Message "Traditional Chinese should hide an unavailable Cantonese region."
Assert-Contains -Text $usageText -ExpectedSubstring "example.exampleLevel == .sentence" -Message "Japanese sentence examples must use the wrapping layout."
Assert-Contains -Text $usageText -ExpectedSubstring "translation: record.primarySharedMeaning.capitalized" -Message "Usage cards should place the English meaning beside the native form."
Assert-Contains -Text $usageText -ExpectedSubstring "native word and English meaning on one line" -Message "Usage examples should keep English beside the native word."
Assert-Contains -Text $usageText -ExpectedSubstring "Taiwan · Mandarin / Pinyin" -Message "Traditional Chinese should label the Taiwan reading section clearly."

$historyGuideText = Get-Text "Sources/App/Navigation/HistoryModernLanguageReadingGuide.swift"
Assert-Contains -Text $historyGuideText -ExpectedSubstring "Mandarin tone marks" -Message "History should explain Mandarin tone notation."
Assert-Contains -Text $historyGuideText -ExpectedSubstring "Jyutping tone numbers" -Message "History should explain Cantonese tone numbers."
Assert-Contains -Text $historyGuideText -ExpectedSubstring "Kana sound pattern" -Message "History should explain the shared kana sound pattern."
Assert-Contains -Text $historyGuideText -ExpectedSubstring "Basic sound chart" -Message "History should show the five-column basic kana chart."
Assert-Contains -Text $historyGuideText -ExpectedSubstring "How sounds are built" -Message "History should show how kana sounds combine."
Assert-Contains -Text $historyGuideText -ExpectedSubstring "combinationExamples" -Message "History should show a small set of kana construction examples."
Assert-True (-not $historyGuideText.Contains("combinationTable")) "History should not show a full second kana combination table."
Assert-Contains -Text $historyGuideText -ExpectedSubstring "Hangul letters become syllable blocks" -Message "History should explain Hangul block construction."

$lessonViewText = Get-Text "Sources/App/Lesson/LessonView.swift"
Assert-Contains -Text $lessonViewText -ExpectedSubstring "toggleFavorite" -Message "Favorite should be directly accessible from the Symbol toolbar."
Assert-Contains -Text $lessonViewText -ExpectedSubstring "onToggleReviewLater" -Message "Review Later should remain available in the character action sheet."
Assert-Contains -Text $lessonViewText -ExpectedSubstring "onShare" -Message "Share should remain available in the character action sheet."
Assert-True (-not $lessonViewText.Contains('accessibilityLabel(isReviewLater ? "Remove from Review Later" : "Save for Review Later")')) "Review Later should not be a Symbol toolbar action."
Assert-True (-not $lessonViewText.Contains('accessibilityLabel("Share Symbol")')) "Share should not be a Symbol toolbar action."
$toolbarMatch = [regex]::Match($lessonViewText, '(?s)ToolbarItemGroup\(placement: \.topBarTrailing\).*?\.sheet\(isPresented: \$showingAbout\)')
Assert-True $toolbarMatch.Success "Symbol toolbar block should remain statically inspectable."
Assert-True (-not $toolbarMatch.Value.Contains("toggleReviewLater")) "Review Later should not appear in the Symbol toolbar block."
Assert-True (-not $toolbarMatch.Value.Contains("square.and.arrow.up")) "Share should not appear in the Symbol toolbar block."
Assert-True (-not $lessonViewText.Contains('Section("Sources")')) "Symbol detail should not repeat the full source inventory."

Write-Output "OK: polish contract tests passed"
