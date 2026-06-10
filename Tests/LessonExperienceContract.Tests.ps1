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

$lessonViewText = Get-Text "Sources/App/Lesson/LessonView.swift"
Assert-Contains -Text $lessonViewText -ExpectedSubstring "struct LessonView: View" -Message "Lesson experience should expose a concrete LessonView."
Assert-Contains -Text $lessonViewText -ExpectedSubstring "ForEach(LessonStep.allCases)" -Message "LessonView should render every guided lesson step."
Assert-Contains -Text $lessonViewText -ExpectedSubstring "selectStep(_ step: LessonStep)" -Message "LessonView should centralize step selection."
Assert-Contains -Text $lessonViewText -ExpectedSubstring "visitedSteps.contains(step)" -Message "LessonView should distinguish visited and unvisited steps."
Assert-Contains -Text $lessonViewText -ExpectedSubstring "markInProgress(at: step)" -Message "LessonView should persist the current in-progress step."
Assert-Contains -Text $lessonViewText -ExpectedSubstring "markLearned()" -Message "LessonView should support Mark as Learned."
Assert-Contains -Text $lessonViewText -ExpectedSubstring "restartLesson()" -Message "LessonView should support restarting at Origin."
Assert-Contains -Text $lessonViewText -ExpectedSubstring "stepContent" -Message "LessonView should render step-specific content."
Assert-Contains -Text $lessonViewText -ExpectedSubstring "UsageExamplesView(record:" -Message "LessonView should show progressive cross-language usage examples."

$usageViewText = Get-Text "Sources/App/Lesson/UsageExamplesView.swift"
Assert-Contains -Text $usageViewText -ExpectedSubstring "struct UsageExamplesView: View" -Message "Lesson experience should include a progressive usage examples view."
Assert-Contains -Text $usageViewText -ExpectedSubstring "example.exampleLevel.rawValue" -Message "Usage examples should show word/sentence level."
Assert-Contains -Text $usageViewText -ExpectedSubstring "reusesKnownSymbols" -Message "Usage examples should show reused known symbols."

$homeText = Get-Text "Sources/App/Home/HomeView.swift"
Assert-Contains -Text $homeText -ExpectedSubstring "LessonView(route: route, dependencies: dependencies)" -Message "Home should open the concrete guided lesson view."

$projectText = Get-Content -Raw (Join-Path $repoRoot "AsianLanguage.xcodeproj/project.pbxproj")
Assert-Contains -Text $projectText -ExpectedSubstring "LessonView.swift" -Message "Xcode project should include LessonView.swift."

Write-Output "OK: lesson experience contract tests passed"
