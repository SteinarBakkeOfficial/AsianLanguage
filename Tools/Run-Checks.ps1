param(
  [switch]$SkipReleaseReadiness
)

$ErrorActionPreference = "Stop"

# Keep this wrapper repo-local so Windows contributors can run every current check
# without remembering the shared tool path or individual test files.
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

# Update this path if the cross-project layout verifier moves.
$layoutVerifier = "C:\Users\Stein\dev\personal\Tools\verify-layout.ps1"

# Add new Windows-runnable test files here when the local check suite grows.
$testScripts = @(
  "Tests/ProjectWiring.Tests.ps1",
  "Tests/SwiftModelContract.Tests.ps1",
  "Tests/UserStateContract.Tests.ps1",
  "Tests/LessonExperienceContract.Tests.ps1",
  "Tests/DiscoveryContract.Tests.ps1",
  "Tests/VisualContentContract.Tests.ps1",
  "Tests/ContentTooling.Tests.ps1",
  "Tests/CorpusReadiness.Tests.ps1",
  "Tests/PolishContract.Tests.ps1",
  "Tests/PrototypeCorpusContract.Tests.ps1",
  "Tests/CorpusValidation.Tests.ps1"
)

if (-not $SkipReleaseReadiness) {
  $testScripts += "Tests/ReleaseReadiness.Tests.ps1"
}

Push-Location $repoRoot
try {
  Write-Output "Running layout verification..."
  & $layoutVerifier

  foreach ($testScript in $testScripts) {
    Write-Output "Running $testScript..."
    & (Join-Path $repoRoot $testScript)
  }
}
finally {
  Pop-Location
}

Write-Output "OK: all local checks passed"
