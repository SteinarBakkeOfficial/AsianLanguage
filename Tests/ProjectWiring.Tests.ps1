$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$sourceCorpus = Join-Path $repoRoot "content/shared-characters/tree.json"
$bundledCorpus = Join-Path $repoRoot "Resources/Corpus/tree.json"
$projectFile = Join-Path $repoRoot "AsianLanguage.xcodeproj/project.pbxproj"

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

function Assert-Equal {
  param(
    [Parameter(Mandatory = $true)]
    $Actual,
    [Parameter(Mandatory = $true)]
    $Expected,
    [Parameter(Mandatory = $true)]
    [string]$Message
  )

  if ($Actual -ne $Expected) {
    throw "$Message Expected '$Expected', got '$Actual'."
  }
}

Assert-True -Condition (Test-Path $bundledCorpus) -Message "Bundled corpus record should exist at Resources/Corpus/tree.json."

$sourceJson = Get-Content -Raw $sourceCorpus | ConvertFrom-Json
$bundledJson = Get-Content -Raw $bundledCorpus | ConvertFrom-Json
Assert-Equal -Actual $bundledJson.id -Expected $sourceJson.id -Message "Bundled corpus id should match source corpus id."
Assert-Equal -Actual $bundledJson.coreCharacter -Expected $sourceJson.coreCharacter -Message "Bundled corpus character should match source corpus character."
Assert-Equal -Actual $bundledJson.recognitionTakeaway -Expected $sourceJson.recognitionTakeaway -Message "Bundled corpus takeaway should match source corpus takeaway."

$projectText = Get-Content -Raw $projectFile
Assert-True -Condition $projectText.Contains("tree.json") -Message "Xcode project should include the bundled tree corpus resource."
Assert-True -Condition $projectText.Contains("AsianLanguageTests") -Message "Xcode project should include the Swift unit test target."
Assert-True -Condition $projectText.Contains("tree.json in Resources") -Message "Swift unit tests should have access to the bundled tree corpus fixture."

$swiftFiles = Get-ChildItem -Path (Join-Path $repoRoot "Sources/App") -Filter "*.swift" -Recurse |
  ForEach-Object { $_.Name } |
  Sort-Object

foreach ($swiftFile in $swiftFiles) {
  Assert-True -Condition $projectText.Contains($swiftFile) -Message "Xcode project should reference Swift source '$swiftFile'."
}

$swiftTestFiles = Get-ChildItem -Path (Join-Path $repoRoot "Tests/AsianLanguageTests") -Filter "*.swift" -Recurse |
  ForEach-Object { $_.Name } |
  Sort-Object

foreach ($swiftTestFile in $swiftTestFiles) {
  Assert-True -Condition $projectText.Contains($swiftTestFile) -Message "Xcode project should reference Swift test source '$swiftTestFile'."
}

$schemeText = Get-Content -Raw (Join-Path $repoRoot "AsianLanguage.xcodeproj/xcshareddata/xcschemes/AsianLanguage.xcscheme")
Assert-True -Condition $schemeText.Contains("AsianLanguageTests.xctest") -Message "Shared Xcode scheme should include the Swift unit test bundle."

$homeViewText = Get-Content -Raw (Join-Path $repoRoot "Sources/App/Home/HomeView.swift")
Assert-True -Condition $homeViewText.Contains("NavigationLink(value: route)") -Message "Home should route through its selected lesson route."
Assert-True -Condition $homeViewText.Contains("homeLessonRoute") -Message "Home should choose between resume and featured lesson routes."
Assert-True -Condition $homeViewText.Contains("navigationDestination(for: LessonRoute.self)") -Message "Home should register a LessonRoute navigation destination."

$lessonViewText = Get-Content -Raw (Join-Path $repoRoot "Sources/App/Lesson/LessonView.swift")
Assert-True -Condition $lessonViewText.Contains("route.sharedCharacterID") -Message "Lesson view should resolve the route by Shared Character id."
Assert-True -Condition $lessonViewText.Contains("LessonStep.allCases") -Message "Lesson view should expose the six-step lesson flow."

Write-Output "OK: project wiring tests passed"
