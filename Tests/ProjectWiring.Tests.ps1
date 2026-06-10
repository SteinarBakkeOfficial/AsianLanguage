$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$sourceCorpus = Join-Path $repoRoot "content/shared-characters/tree.json"
$bundledCorpus = Join-Path $repoRoot "Resources/Corpus/tree.json"
$projectFile = Join-Path $repoRoot "AsianLanguage.xcodeproj/project.pbxproj"

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

Assert-True -Condition (Test-Path $bundledCorpus) -Message "Bundled corpus record should exist at Resources/Corpus/tree.json."

$sourceJson = Get-Content -Raw $sourceCorpus | ConvertFrom-Json
$bundledJson = Get-Content -Raw $bundledCorpus | ConvertFrom-Json
Assert-Equal -Actual $bundledJson.id -Expected $sourceJson.id -Message "Bundled corpus id should match source corpus id."
Assert-Equal -Actual $bundledJson.coreCharacter -Expected $sourceJson.coreCharacter -Message "Bundled corpus character should match source corpus character."
Assert-Equal -Actual $bundledJson.recognitionTakeaway -Expected $sourceJson.recognitionTakeaway -Message "Bundled corpus takeaway should match source corpus takeaway."

$projectText = Get-Content -Raw $projectFile
Assert-True -Condition $projectText.Contains("tree.json") -Message "Xcode project should include the bundled tree corpus resource."

$swiftFiles = Get-ChildItem -Path (Join-Path $repoRoot "Sources/App") -Filter "*.swift" -Recurse |
  ForEach-Object { $_.Name } |
  Sort-Object

foreach ($swiftFile in $swiftFiles) {
  Assert-True -Condition $projectText.Contains($swiftFile) -Message "Xcode project should reference Swift source '$swiftFile'."
}

Write-Output "OK: project wiring tests passed"
