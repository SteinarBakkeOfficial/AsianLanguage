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
Assert-Contains -Text $collectionsText -ExpectedSubstring "No saved Shared Characters" -Message "Collections should show empty copy for empty system collections."

Write-Output "OK: polish contract tests passed"
