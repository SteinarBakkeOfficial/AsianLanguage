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
Assert-True $rail.Contains("navigatorIDs") "The rail must switch between the museum and language navigation modes."
Assert-True $rail.Contains("if index < navigatorIDs.count - 1") "The rail must not render a connector after the final navigation item."
Assert-True (-not $rail.Contains("nextStageCue")) "The museum rail must not add an unapproved next-stage text cue."
Assert-True $marker.Contains("Circle()") "The museum rail must retain the approved compact circle markers."
Assert-True $marker.Contains("Text(shortLabel(for: id))") "The museum rail must keep each stage reachable and visibly named."

$usage = Text "Sources/App/Lesson/UsageExamplesView.swift"
Assert-True $usage.Contains('Text("IN A WORD")') "Word context must retain the approved heading."
Assert-True $usage.Contains('displayExamples(examples, variants: variants).prefix(4)') "Language context may show up to four real examples without placeholders."
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
Assert-True $historyPage.Contains("The History of Chinese Characters") "History must present the approved timeline title natively."
Assert-True $historyPage.Contains("ForEach(Array(stages.enumerated())") "History must render the five approved timeline stages."
Assert-True $historyPage.Contains("Why it changed") "History must include the visible timeline explanations from the approved reference."
Assert-True $historyPage.Contains("HistoryOverviewHeader") "History must preserve the reference-style editorial header."
Assert-True $historyPage.Contains("HistoryReferenceCropView") "History must reuse the supplied reference illustrations in native layout."
Assert-True (-not $historyPage.Contains('Image("History_V1")')) "History must not render the full reference screenshot as the page implementation."
Assert-True $history.Contains("static var livingTraditionArticle") "History must include the dedicated calligraphy article."
Assert-True $history.Contains("HistoryLivingTraditionView") "The calligraphy article must be reachable from History."
Assert-True $history.Contains('nextID: "livingTradition"') "Regular must transition to A Living Tradition."
Assert-True $history.Contains("Running and Cursive are not additional stages") "History must keep calligraphy styles separate from the evolution timeline."
Assert-True (Test-Path (Join-Path $repoRoot "Resources/History/History_Artwork_Set.png")) "The approved History artwork set must be bundled with the app."
Assert-True $history.Contains("HistoryCalligraphyDetailView") "Calligraphy examples must support an enlarged detail view."

$about = Text "Sources/App/Settings/AboutMethodView.swift"
# The approved content-architecture decision keeps source inventory and external links in Sources.
Assert-True (-not $about.Contains("ZDIC")) "About must not contain the global source inventory."
Assert-True $about.Contains("App information") "About must identify the app rather than explain implementation details."
Assert-True $about.Contains("Developer") "About must identify the developer."
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
