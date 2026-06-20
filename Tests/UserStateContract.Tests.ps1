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

$userStateText = Get-Text "Sources/App/UserState/AppUserState.swift"
Assert-Contains -Text $userStateText -ExpectedSubstring "enum LessonProgressStatus" -Message "User state should model lesson progress status."
Assert-Contains -Text $userStateText -ExpectedSubstring "case unseen" -Message "Lesson progress should support unseen."
Assert-Contains -Text $userStateText -ExpectedSubstring "case inProgress" -Message "Lesson progress should support in-progress."
Assert-Contains -Text $userStateText -ExpectedSubstring "case learned" -Message "Lesson progress should support learned."
Assert-Contains -Text $userStateText -ExpectedSubstring "var isReviewLater: Bool" -Message "Lesson state should track review-later separately."
Assert-Contains -Text $userStateText -ExpectedSubstring "var isStarred: Bool" -Message "Lesson state should track favorites separately."
Assert-Contains -Text $userStateText -ExpectedSubstring "var focusSelection: FocusTrackSelection" -Message "App user state should persist multi-select focus-track preferences."
Assert-Contains -Text $userStateText -ExpectedSubstring "mutating func markLearned" -Message "User state should expose a learned transition."
Assert-Contains -Text $userStateText -ExpectedSubstring "isReviewLater = false" -Message "Marking learned should clear review-later."

$storeText = Get-Text "Sources/App/UserState/LocalUserStateStore.swift"
Assert-Contains -Text $storeText -ExpectedSubstring "final class LocalUserStateStore: ObservableObject" -Message "Local user-state store should be observable by SwiftUI."
Assert-Contains -Text $storeText -ExpectedSubstring "@Published private(set) var state" -Message "Local user-state store should publish state snapshots."
Assert-Contains -Text $storeText -ExpectedSubstring "func setFocusTrack(_ focusTrack: FocusTrack, isSelected: Bool)" -Message "Local user-state store should persist focus-track toggles."
Assert-Contains -Text $storeText -ExpectedSubstring "func updateLessonState" -Message "Local user-state store should update per-lesson state."
Assert-Contains -Text $storeText -ExpectedSubstring "func reset()" -Message "Local user-state store should reset local progress."
Assert-Contains -Text $storeText -ExpectedSubstring "JSONEncoder" -Message "Local user-state store should write JSON."
Assert-Contains -Text $storeText -ExpectedSubstring "JSONDecoder" -Message "Local user-state store should read JSON."

$dependenciesText = Get-Text "Sources/App/Core/AppDependencies.swift"
Assert-Contains -Text $dependenciesText -ExpectedSubstring "let userStateStore: LocalUserStateStore" -Message "App dependencies should expose the local user-state store."
Assert-Contains -Text $dependenciesText -ExpectedSubstring "LocalUserStateStore.live()" -Message "Live dependencies should use the on-device local state store."
Assert-Contains -Text $dependenciesText -ExpectedSubstring "LocalUserStateStore.preview()" -Message "Preview dependencies should use an in-memory local state store."

$settingsText = Get-Text "Sources/App/Settings/SettingsView.swift"
Assert-Contains -Text $settingsText -ExpectedSubstring "@ObservedObject private var userStateStore: LocalUserStateStore" -Message "Settings should observe the local user-state store."
Assert-Contains -Text $settingsText -ExpectedSubstring "Toggle(track.title" -Message "Settings should expose multi-select focus toggles."
Assert-Contains -Text $settingsText -ExpectedSubstring "userStateStore.setFocusTrack" -Message "Settings should save focus language changes."
Assert-Contains -Text $settingsText -ExpectedSubstring "userStateStore.reset()" -Message "Settings reset should clear local state."

$homeText = Get-Text "Sources/App/Home/HomeView.swift"
Assert-Contains -Text $homeText -ExpectedSubstring "@ObservedObject private var userStateStore: LocalUserStateStore" -Message "Home should observe local user state."
Assert-Contains -Text $homeText -ExpectedSubstring "homeLessonRoute" -Message "Home should choose between resume and featured lesson routes."
Assert-Contains -Text $homeText -ExpectedSubstring "Resume current lesson" -Message "Home should support in-progress resume copy."

Write-Output "OK: user-state contract tests passed"
