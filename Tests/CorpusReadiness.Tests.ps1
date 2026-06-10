$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$reportScript = Join-Path $repoRoot "Tools/Report-CorpusReadiness.ps1"

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

$output = & $reportScript -CorpusPath (Join-Path $repoRoot "content/shared-characters") -LaunchTarget 100 2>&1
$text = $output -join "`n"

Assert-Equal -Actual $LASTEXITCODE -Expected 0 -Message "Corpus readiness report should succeed."
Assert-Contains -Text $text -ExpectedSubstring "Total records: 11" -Message "Readiness report should include total corpus count."
Assert-Contains -Text $text -ExpectedSubstring "Draft records: 11" -Message "Readiness report should include draft count."
Assert-Contains -Text $text -ExpectedSubstring "Published records: 0" -Message "Readiness report should include published count."
Assert-Contains -Text $text -ExpectedSubstring "Launch target: 100" -Message "Readiness report should include launch target."

Write-Output "OK: corpus readiness tests passed"
