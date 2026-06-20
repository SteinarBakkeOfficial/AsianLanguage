$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$newDraftScript = Join-Path $repoRoot "Tools/New-SharedCharacterDraft.ps1"
$validator = Join-Path $repoRoot "Tools/Validate-Corpus.ps1"

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

function Invoke-Validator {
  param(
    [Parameter(Mandatory = $true)]
    [string]$CorpusPath
  )

  $output = & $validator -CorpusPath $CorpusPath 2>&1
  return [pscustomobject]@{
    ExitCode = $LASTEXITCODE
    Output = ($output -join "`n")
  }
}

$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("AsianLanguageContentTooling-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $tempRoot | Out-Null

try {
  $draftPath = Join-Path $tempRoot "sun.json"
  $draftOutput = & $newDraftScript `
    -Id "sun" `
    -CoreCharacter "日" `
    -CoreSharedMeaning "sun; day" `
    -OutputPath $draftPath 2>&1

  Assert-Equal -Actual $LASTEXITCODE -Expected 0 -Message "Draft creation should succeed."
  Assert-Contains -Text ($draftOutput -join "`n") -ExpectedSubstring "OK: created draft Shared Character record" -Message "Draft creation should report success."
  Assert-Equal -Actual (Test-Path $draftPath) -Expected $true -Message "Draft JSON should be written."

  $draft = Get-Content -Raw $draftPath | ConvertFrom-Json
  Assert-Equal -Actual $draft.id -Expected "sun" -Message "Draft id should match input."
  Assert-Equal -Actual $draft.coreCharacter -Expected "日" -Message "Draft core character should match input."
  Assert-Equal -Actual $draft.coreSharedMeaning -Expected "sun; day" -Message "Draft core meaning should match input."
  Assert-Equal -Actual $draft.teachingSequence -Expected 999 -Message "Draft teaching sequence should default to the end of the seed path."
  Assert-Equal -Actual $draft.publicationStatus -Expected "draft" -Message "New records should start as draft."

  $invalidStatusCorpus = Join-Path $tempRoot "invalid-status"
  New-Item -ItemType Directory -Path $invalidStatusCorpus | Out-Null
  $record = Get-Content -Raw (Join-Path $repoRoot "content/shared-characters/tree.json") | ConvertFrom-Json
  $record.publicationStatus = "published-ish"
  $record | ConvertTo-Json -Depth 20 | Set-Content -Path (Join-Path $invalidStatusCorpus "tree.json") -Encoding utf8

  $invalidStatusResult = Invoke-Validator -CorpusPath $invalidStatusCorpus
  Assert-Equal -Actual $invalidStatusResult.ExitCode -Expected 1 -Message "Unknown publication status should fail validation."
  Assert-Contains -Text $invalidStatusResult.Output -ExpectedSubstring "Invalid publicationStatus 'published-ish'." -Message "Publication-status error should be readable."

  $missingCaveatCorpus = Join-Path $tempRoot "missing-caveat"
  New-Item -ItemType Directory -Path $missingCaveatCorpus | Out-Null
  $record = Get-Content -Raw (Join-Path $repoRoot "content/shared-characters/tree.json") | ConvertFrom-Json
  $record.structure.certainty = "limited"
  $record.structure.caveat = $null
  $record | ConvertTo-Json -Depth 20 | Set-Content -Path (Join-Path $missingCaveatCorpus "tree.json") -Encoding utf8

  $missingCaveatResult = Invoke-Validator -CorpusPath $missingCaveatCorpus
  Assert-Equal -Actual $missingCaveatResult.ExitCode -Expected 1 -Message "Limited-certainty structure without a caveat should fail validation."
  Assert-Contains -Text $missingCaveatResult.Output -ExpectedSubstring "Limited-certainty structure must include a caveat." -Message "Missing-caveat error should be readable."
}
finally {
  if (Test-Path $tempRoot) {
    Remove-Item -LiteralPath $tempRoot -Recurse -Force
  }
}

Write-Output "OK: content tooling tests passed"
