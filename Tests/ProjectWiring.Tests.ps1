$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
function Assert-True { param([bool]$Condition,[string]$Message); if (-not $Condition) { throw $Message } }
$projectText = Get-Content -Raw (Join-Path $repoRoot "AsianLanguage.xcodeproj/project.pbxproj")
$rootText = Get-Content -Raw (Join-Path $repoRoot "Sources/App/Navigation/RootTabView.swift")
$appTabText = Get-Content -Raw (Join-Path $repoRoot "Sources/App/Navigation/AppTab.swift")

foreach ($name in @("Home","Symbol","History","Browse","More")) {
  Assert-True $appTabText.Contains("case $($name.ToLower())") "Root shell must include $name."
}
foreach ($obsolete in @("case search","case savedArchive","case languages","case account","case settings")) {
  Assert-True (-not $appTabText.Contains($obsolete)) "Obsolete root destination remains: $obsolete."
}
Assert-True $rootText.Contains("HistoryRootView") "History must be a root destination."
Assert-True $rootText.Contains("MoreRootView") "More must be a root destination."
Assert-True $rootText.Contains("SymbolRootView") "Symbol must be the canonical journey owner."
Assert-True $projectText.Contains("LessonView.swift") "Xcode project must include LessonView.swift."

foreach ($file in (Get-ChildItem (Join-Path $repoRoot "Sources/App") -Filter "*.swift" -Recurse)) {
  Assert-True $projectText.Contains($file.Name) "Xcode project must reference $($file.Name)."
}
Write-Output "OK: project wiring tests passed"
