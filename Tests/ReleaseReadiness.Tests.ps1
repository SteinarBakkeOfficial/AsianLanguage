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
Assert-Contains -Text $text -ExpectedSubstring "Published records: 126" -Message "Release readiness should surface the approved V1 publication status."
Assert-Contains -Text $text -ExpectedSubstring "V1.0 release status: accepted for the approved 126-record package." -Message "Release readiness should report the accepted V1 release state."
Assert-Contains -Text $text -ExpectedSubstring "Post-release policy: user-discovered issues are tracked for Patch 0.1" -Message "Release readiness should record the post-release patch policy."

Write-Output "OK: release readiness tests passed"
