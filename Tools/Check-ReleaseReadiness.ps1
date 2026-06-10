param(
  [int]$LaunchTarget = 100
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$projectFile = Join-Path $repoRoot "AsianLanguage.xcodeproj/project.pbxproj"
$schemeFile = Join-Path $repoRoot "AsianLanguage.xcodeproj/xcshareddata/xcschemes/AsianLanguage.xcscheme"
$corpusPath = Join-Path $repoRoot "content/shared-characters"
$runChecks = Join-Path $repoRoot "Tools/Run-Checks.ps1"
$readinessReport = Join-Path $repoRoot "Tools/Report-CorpusReadiness.ps1"

Write-Output "Running local release readiness checks..."
& $runChecks -SkipReleaseReadiness | Out-Null
Write-Output "OK: local checks passed"

$projectText = Get-Content -Raw $projectFile
if ($projectText -match "PRODUCT_BUNDLE_IDENTIFIER = ([^;]+);") {
  Write-Output "Bundle identifier: $($Matches[1])"
} else {
  Write-Error "Bundle identifier not found in Xcode project."
  exit 1
}

if (-not (Test-Path $schemeFile)) {
  Write-Error "Shared Xcode scheme not found: $schemeFile"
  exit 1
}
Write-Output "Shared scheme: AsianLanguage"

& $readinessReport -CorpusPath $corpusPath -LaunchTarget $LaunchTarget

Write-Output "BLOCKED: macOS/Xcode signing, simulator/device testing, and App Store/TestFlight upload are not available on Windows."
exit 0
