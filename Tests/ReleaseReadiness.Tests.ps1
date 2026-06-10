$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$releaseScript = Join-Path $repoRoot "Tools/Check-ReleaseReadiness.ps1"

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

function Assert-Contains {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Text,
    [Parameter(Mandatory = $true)]
    [string]$ExpectedSubstring,
    [Parameter(Mandatory = $true)]
    [string]$Message
  )

  if (-not $Text.Contains($ExpectedSubstring)) {
    throw "$Message Expected output to contain '$ExpectedSubstring'. Actual output: $Text"
  }
}

$output = & $releaseScript -LaunchTarget 100 2>&1
$text = $output -join "`n"

Assert-Equal -Actual $LASTEXITCODE -Expected 0 -Message "Release readiness check should complete."
Assert-Contains -Text $text -ExpectedSubstring "OK: local checks passed" -Message "Release readiness should run local checks."
Assert-Contains -Text $text -ExpectedSubstring "Bundle identifier: com.steinarbakke.asianlanguage" -Message "Release readiness should report bundle identifier."
Assert-Contains -Text $text -ExpectedSubstring "Published records: 0" -Message "Release readiness should surface corpus publication status."
Assert-Contains -Text $text -ExpectedSubstring "BLOCKED: macOS/Xcode signing, simulator/device testing, and App Store/TestFlight upload are not available on Windows." -Message "Release readiness should state the Apple-tooling blocker."

Write-Output "OK: release readiness tests passed"
