$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

function Assert-True { param([bool]$Condition,[string]$Message); if (-not $Condition) { throw $Message } }
function Text([string]$Path) { Get-Content -Raw (Join-Path $repoRoot $Path) }
function Section([string]$Source,[string]$Start,[string]$End) {
  $startIndex = $Source.IndexOf($Start)
  Assert-True ($startIndex -ge 0) "Could not find design section '$Start'."
  $endIndex = $Source.IndexOf($End, $startIndex)
  Assert-True ($endIndex -gt $startIndex) "Could not find end of design section '$Start'."
  return $Source.Substring($startIndex, $endIndex - $startIndex)
}

$journey = Text "Sources/App/Lesson/CharacterEvolutionView.swift"
$rail = Section $journey "private var stageNavigator" "/// Keeps each stage marker"
$marker = Section $journey "private func stageMarker" "private func label"
Assert-True $rail.Contains("AppColors.journeyRailBackground") "The museum rail must retain its distinct surface color."
Assert-True $rail.Contains('id != "regular"') "The museum rail must not render a connector adjacent to Regular Script."
Assert-True $rail.Contains("if index < journeyIDs.count - 1") "The museum rail must not render a connector after the final stage."
Assert-True (-not $rail.Contains("nextStageCue")) "The museum rail must not add an unapproved next-stage text cue."
Assert-True (-not $rail.Contains("Text(label(for: id))")) "The museum rail must not replace compact markers with stage-name labels."
Assert-True $marker.Contains("Circle()") "The museum rail must retain the approved compact circle markers."
Assert-True $marker.Contains('id == "regular"') "Regular Script must remain free of a decorative circle."

$usage = Text "Sources/App/Lesson/UsageExamplesView.swift"
Assert-True $usage.Contains('Text("IN A WORD")') "Word context must retain the approved heading."
Assert-True $usage.Contains('.filter { $0.exampleLevel == .word }.prefix(4)') "Word context may show up to four existing word examples."
Assert-True $usage.Contains("fontRole.font") "Written context examples must use their locale-specific font."
Assert-True (-not $usage.Contains('Text("IN CONTEXT")')) "Word context must not be relabeled by an unapproved layout pass."
Assert-True (-not $usage.Contains("Basic sentence using")) "Word context must not include generated placeholder copy."

$browse = Text "Sources/App/Browse/BrowseView.swift"
Assert-True $browse.Contains("ForEach(CollectionsView.catalog(for: dependencies))") "Browse must show the complete collection catalog directly."
Assert-True (-not $browse.Contains("Explore all collections")) "Browse must not hide collections behind an extra Explore link."

$homeSource = Text "Sources/App/Home/HomeView.swift"
Assert-True $homeSource.Contains("EditorialCollectionArtwork") "Home collection continuation must show the approved collection artwork."
Assert-True $homeSource.Contains("EditorialCollectionDetailView") "Home collection continuation must open the collection, not a guessed next symbol."
$hero = Section $homeSource "private var previewItems" "var body: some View"
Assert-True $hero.Contains('stage != "regular"') "Home lineage preview must include the next available historical stage, not only Origin and Today."
$collectionModule = Section $homeSource "private var collectionModule" "/// Home always displays"
Assert-True (-not $collectionModule.Contains("openSymbol")) "Home collection continuation must not skip directly into a guessed symbol."

$history = Text "Sources/App/Navigation/RootTabView.swift"
$historyPage = Section $history "private struct HistoryRootView" "/// Stable structural model"
Assert-True $historyPage.Contains("History_V1.png") "History must use the approved overview artwork."
Assert-True (-not $historyPage.Contains("ScrollView")) "History must present the supplied artwork as the page, without wrapper content."
Assert-True (-not $historyPage.Contains("ArtifactField")) "History must not place the supplied full-page artwork inside an artifact card."

$about = Text "Sources/App/Settings/AboutMethodView.swift"
Assert-True $about.Contains("Visit 漢典 / ZDIC") "About must retain the historical image source link."
Assert-True (-not $about.Contains("Modern forms and typography")) "About must remain a concise reference page rather than an implementation manual."

$collectionsSource = Text "Sources/App/Collections/CollectionsView.swift"
Assert-True ([regex]::Matches($collectionsSource, "SharedCharacterCollection\(").Count -eq 10) "The V1 collection catalog must contain all ten editorial collections."
foreach ($artwork in @(
    "action-work-change",
    "family-society-institutions",
    "home-tools-materials",
    "mind-speech-learning",
    "nature-cosmos",
    "people-body-life",
    "place-direction-movement",
    "plants-animals-food",
    "qualities-relations-abstract-ideas",
    "time-number-measure"
)) {
  Assert-True (Test-Path (Join-Path $repoRoot "Resources/Assets/Collections/$artwork.png")) "Collection artwork '$artwork' must be bundled."
}

Write-Output "OK: design-freeze contract tests passed"
