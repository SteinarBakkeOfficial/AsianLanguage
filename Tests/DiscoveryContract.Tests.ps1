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

$searchIndexText = Get-Text "Sources/App/Discovery/SharedCharacterSearchIndex.swift"
Assert-Contains -Text $searchIndexText -ExpectedSubstring "struct SharedCharacterSearchIndex" -Message "Discovery should expose a local search index."
Assert-Contains -Text $searchIndexText -ExpectedSubstring "func search(_ query: String)" -Message "Search index should provide a query interface."
Assert-Contains -Text $searchIndexText -ExpectedSubstring "normalizedQuery" -Message "Search should normalize user input."
Assert-Contains -Text $searchIndexText -ExpectedSubstring "coreCharacter" -Message "Search should include modern character forms."
Assert-Contains -Text $searchIndexText -ExpectedSubstring "coreSharedMeaning" -Message "Search should include English glosses."
Assert-Contains -Text $searchIndexText -ExpectedSubstring "readings" -Message "Search should include language readings."

$dependenciesText = Get-Text "Sources/App/Core/AppDependencies.swift"
Assert-Contains -Text $dependenciesText -ExpectedSubstring "let sharedCharacters: [SharedCharacterRecord]" -Message "App dependencies should expose bundled corpus records for discovery."
Assert-Contains -Text $dependenciesText -ExpectedSubstring "PrototypeCorpusManifest.recordIDs" -Message "App dependencies should load all prototype manifest records."

$rootText = Get-Text "Sources/App/Navigation/RootTabView.swift"
Assert-Contains -Text $rootText -ExpectedSubstring "SearchView(dependencies: dependencies)" -Message "Root tabs should inject dependencies into Search."
Assert-Contains -Text $rootText -ExpectedSubstring "BrowseView(dependencies: dependencies)" -Message "Root tabs should inject dependencies into Browse."
Assert-Contains -Text $rootText -ExpectedSubstring "CollectionsView(dependencies: dependencies)" -Message "Root tabs should inject dependencies into Collections."

$searchText = Get-Text "Sources/App/Search/SearchView.swift"
Assert-Contains -Text $searchText -ExpectedSubstring "SharedCharacterSearchIndex" -Message "Search view should use the local search index."
Assert-Contains -Text $searchText -ExpectedSubstring "NavigationLink(value: LessonRoute" -Message "Search results should route to lessons."
Assert-Contains -Text $searchText -ExpectedSubstring ".searchable" -Message "Search view should keep native search UI."

$browseText = Get-Text "Sources/App/Browse/BrowseView.swift"
Assert-Contains -Text $browseText -ExpectedSubstring "ForEach(dependencies.sharedCharacters)" -Message "Browse should list bundled Shared Characters."
Assert-Contains -Text $browseText -ExpectedSubstring "NavigationLink(value: LessonRoute" -Message "Browse rows should route to lessons."

$collectionsText = Get-Text "Sources/App/Collections/CollectionsView.swift"
Assert-Contains -Text $collectionsText -ExpectedSubstring "ForEach(dependencies.sharedCharacters)" -Message "Collections should expose an editorial bundled set."
Assert-Contains -Text $collectionsText -ExpectedSubstring "Review later" -Message "Collections should keep Review later."
Assert-Contains -Text $collectionsText -ExpectedSubstring "Favorites" -Message "Collections should keep Favorites."

Write-Output "OK: discovery contract tests passed"
