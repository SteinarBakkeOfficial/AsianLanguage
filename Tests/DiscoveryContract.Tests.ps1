$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
function Assert-True { param([bool]$Condition,[string]$Message); if (-not $Condition) { throw $Message } }
function Text([string]$Path) { Get-Content -Raw (Join-Path $repoRoot $Path) }

$root = Text "Sources/App/Navigation/RootTabView.swift"
$browse = Text "Sources/App/Browse/BrowseView.swift"
$search = Text "Sources/App/Search/SearchView.swift"
$collections = Text "Sources/App/Collections/CollectionsView.swift"
$more = Text "Sources/App/Navigation/RootTabView.swift"

Assert-True $root.Contains("BrowseView(dependencies: dependencies)") "Root must expose Browse."
Assert-True $root.Contains('NavigationLink("Languages")') "More must own Languages."
Assert-True $root.Contains('NavigationLink("Settings")') "More must own Settings."
Assert-True $browse.Contains("SearchView(dependencies: dependencies)") "Browse must own Search."
Assert-True $browse.Contains("CollectionsView(dependencies: dependencies)") "Browse must own Collections."
Assert-True $search.Contains("SharedCharacterSearchIndex") "Search must use the offline index."
Assert-True $search.Contains("openSymbol") "Search must open the canonical Symbol destination."
Assert-True $collections.Contains("Review later") "Collections must retain Review later."
Assert-True $collections.Contains("Favorites") "Collections must retain Favorites."
Write-Output "OK: discovery contract tests passed"
