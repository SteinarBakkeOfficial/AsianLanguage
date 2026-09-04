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
Assert-Contains -Text $settingsText -ExpectedSubstring "About / Method" -Message "Settings should expose About / Method."
Assert-Contains -Text $settingsText -ExpectedSubstring "AboutMethodView" -Message "Settings should route to AboutMethodView."

$aboutText = Get-Text "Sources/App/Settings/AboutMethodView.swift"
Assert-Contains -Text $aboutText -ExpectedSubstring "struct AboutMethodView: View" -Message "Polish should include an About / Method view."
Assert-Contains -Text $aboutText -ExpectedSubstring "Shared Character" -Message "About / Method should explain the lesson unit."
Assert-Contains -Text $aboutText -ExpectedSubstring "offline" -Message "About / Method should explain offline behavior."
Assert-Contains -Text $aboutText -ExpectedSubstring "corpusCount" -Message "About / Method should include corpus size."

$browseText = Get-Text "Sources/App/Browse/BrowseView.swift"
Assert-Contains -Text $browseText -ExpectedSubstring "ContentUnavailableView" -Message "Browse should have a native empty state."

$collectionsText = Get-Text "Sources/App/Collections/CollectionsView.swift"
Assert-Contains -Text $collectionsText -ExpectedSubstring "EditorialCollectionArtwork" -Message "Collections should use editorial artwork previews."

$evolutionText = Get-Text "Sources/App/Lesson/CharacterEvolutionView.swift"
Assert-Contains -Text $evolutionText -ExpectedSubstring "SymbolStageBackgroundView" -Message "Symbol stages should use the approved stage environments."
Assert-Contains -Text $evolutionText -ExpectedSubstring "AppMotion.exhibit" -Message "Symbol stage changes should use the restrained exhibit transition."
Assert-True (-not $evolutionText.Contains("stageDateLabel")) "Symbol pages must not show period/date metadata."

$onboardingText = Get-Text "Sources/App/Navigation/RootTabView.swift"
Assert-Contains -Text $onboardingText -ExpectedSubstring 'PrimaryActionButton("Explore \(firstSymbolRecord?.coreSharedMeaning.capitalized ?? "One")")' -Message "Onboarding should enter the first ranked symbol from one primary page."
Assert-True (-not $onboardingText.Contains("private enum Step")) "Onboarding should not retain the duplicate two-step flow."
Assert-Contains -Text $onboardingText -ExpectedSubstring "HistoryScriptDetailView" -Message "History script entries should open detail destinations."
Assert-Contains -Text $onboardingText -ExpectedSubstring "HistoryModernLanguageDetailView" -Message "History modern-language branches should open detail destinations."
Assert-Contains -Text $onboardingText -ExpectedSubstring "Apple Speech Synthesis" -Message "Sources should identify Apple speech synthesis."

$recordText = Get-Text "Sources/App/Corpus/SharedCharacterRecord.swift"
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

Write-Output "OK: polish contract tests passed"
