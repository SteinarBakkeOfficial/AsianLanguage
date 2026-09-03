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
Assert-True $root.Contains("LanguagesView(dependencies: dependencies)") "More must own Languages."
Assert-True $root.Contains("SettingsView(dependencies: dependencies)") "More must own Settings."
Assert-True $browse.Contains("AppSearchField") "Browse must show search at the top of its discovery surface."
Assert-True $browse.Contains("SharedCharacterSearchIndex") "Browse search must use the offline index."
Assert-True $browse.Contains("CollectionsView(dependencies: dependencies)") "Browse must own Collections."
Assert-True $search.Contains("SharedCharacterSearchIndex") "Search must use the offline index."
Assert-True $search.Contains("openSymbol") "Search must open the canonical Symbol destination."
Assert-True $browse.Contains("openSymbol(record.id, intent: .view)") "Every Browse symbol entry must open at Origin."
Assert-True $browse.Contains('NavigationStack(path: $navigationPath)') "Browse must own a resettable navigation path."
Assert-True $browse.Contains("selectedTab != .browse") "Browse must reset its navigation path after leaving the tab."
Assert-True $browse.Contains(".reviewFromBrowse") "Learned Browse entries must open Quick Review."
Assert-True (-not $browse.Contains("intent: position ? .resume : .view")) "Browse must not resume a saved position when opening a symbol."
Assert-True $browse.Contains("Your Library") "Browse must own the Your Library section."
Assert-True (-not $collections.Contains("Your Library")) "Collections must not duplicate Your Library."
Assert-True (-not $collections.Contains("Favorites")) "Collections must not duplicate Favorites."
Assert-True (-not $collections.Contains("Review Later")) "Collections must not duplicate Review Later."
Write-Output "OK: discovery contract tests passed"
