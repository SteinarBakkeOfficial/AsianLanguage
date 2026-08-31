param(
  [string]$SymbolsPath = "content/symbols",
  [switch]$RequireApprovedOfflineAssets
)

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$symbolsRoot = Join-Path $repoRoot $SymbolsPath
$issues = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

function Add-Issue { param([string]$Message) $issues.Add($Message) | Out-Null }
function Add-Warning { param([string]$Message) $warnings.Add($Message) | Out-Null }
function Has-Text { param($Value) return ($null -ne $Value -and $Value -is [string] -and $Value.Trim().Length -gt 0) }

if (-not (Test-Path $symbolsRoot)) {
  Write-Error "Symbol workspace not found: $symbolsRoot"
  exit 2
}

$symbolFiles = @(Get-ChildItem -LiteralPath $symbolsRoot -Recurse -Filter "symbol.json" -File)
if ($symbolFiles.Count -eq 0) {
  Write-Error "No symbol.json files found below $symbolsRoot"
  exit 2
}

$allowedStatuses = @("draft", "needsReview", "approved", "rejected", "needsSources", "needsArtwork", "needsCopyEdit")
$allowedAvailability = @("available", "unavailableAsset", "unsupportedStage", "intentionallyOmitted")
$allowedAssetClasses = @("historicalEvidence", "educationalReconstruction")

foreach ($symbolFile in $symbolFiles) {
  $symbolFolder = $symbolFile.Directory.FullName
  $relativeFolder = $symbolFolder.Substring($repoRoot.Path.Length + 1).Replace("\", "/")
  try {
    $record = Get-Content -Raw -LiteralPath $symbolFile.FullName | ConvertFrom-Json
  } catch {
    Add-Issue "$relativeFolder/symbol.json: invalid JSON ($($_.Exception.Message))"
    continue
  }

  if (-not (Has-Text $record.id)) { Add-Issue "$relativeFolder/symbol.json: missing id." }
  if (-not (Has-Text $record.coreCharacter)) { Add-Issue "$relativeFolder/symbol.json: missing coreCharacter." }
  if (-not (Has-Text $record.unicodeCodePoint)) { Add-Issue "$relativeFolder/symbol.json: missing unicodeCodePoint." }
  if ($allowedStatuses -notcontains $record.editorialStatus) { Add-Issue "$relativeFolder/symbol.json: invalid editorialStatus '$($record.editorialStatus)'." }

  foreach ($requiredFile in @("lesson.md", "research.md", "review.md", "sources.json", "educational/visual-notes.md", "educational/prompt.md", "educational/metadata.json", "historical/manifest.json", "components/references.json")) {
    if (-not (Test-Path (Join-Path $symbolFolder $requiredFile))) {
      Add-Issue "${relativeFolder}/${requiredFile}: required editorial file is missing."
    }
  }

  if ($record.editorialStatus -eq "approved" -and $RequireApprovedOfflineAssets) {
    Add-Issue "$relativeFolder/symbol.json: approved records require a reviewed offline asset package."
  } elseif ($record.editorialStatus -ne "approved") {
    Add-Warning "$relativeFolder remains $($record.editorialStatus)."
  }

  foreach ($stage in @($record.history.stages)) {
    $availability = $stage.availabilityState
    if (-not (Has-Text $availability)) {
      $availability = if ($null -ne $stage.assetRef -or $null -ne $stage.assetMetadata) { "available" } else { "unavailableAsset" }
    }
    if ($allowedAvailability -notcontains $availability) {
      Add-Issue "$relativeFolder/symbol.json: stage '$($stage.stage)' has invalid availabilityState '$availability'."
    }
    if ($availability -eq "unsupportedStage" -or $availability -eq "intentionallyOmitted") {
      Add-Issue "$relativeFolder/symbol.json: stage '$($stage.stage)' marked $availability must not be in the primary stage list."
    }
    if ($availability -eq "available" -and $null -eq $stage.assetRef -and $null -eq $stage.assetMetadata) {
      Add-Issue "$relativeFolder/symbol.json: available stage '$($stage.stage)' has no local asset reference or metadata."
    }
    if ((Has-Text $stage.assetRef) -and $stage.assetRef -match "^https?://") {
      Add-Issue "$relativeFolder/symbol.json: stage '$($stage.stage)' uses a remote runtime asset reference."
    }

    $stageFolder = Join-Path $symbolFolder ("historical/" + $(if ($stage.stage -eq "oracleBone") { "oracle" } else { $stage.stage }))
    if (-not (Test-Path (Join-Path $stageFolder "source.json"))) {
      Add-Issue "$relativeFolder/historical/$($stage.stage)/source.json: stage provenance file is missing."
    }
  }

  if ($null -ne $record.history.origin -and $null -ne $record.history.origin.asset -and $record.history.origin.asset.assetRef -match "^https?://") {
    Add-Issue "$relativeFolder/symbol.json: Origin uses a remote runtime asset reference."
  }
}

if ($issues.Count -gt 0) {
  Write-Output "Symbol workspace validation failed:"
  $issues | ForEach-Object { Write-Output " - $_" }
  if ($warnings.Count -gt 0) {
    Write-Output "Warnings:"
    $warnings | ForEach-Object { Write-Output " - $_" }
  }
  exit 1
}

Write-Output "Symbol workspace validation passed for $($symbolFiles.Count) Symbol folder(s)."
if ($warnings.Count -gt 0) {
  Write-Output "Review warnings:"
  $warnings | ForEach-Object { Write-Output " - $_" }
}
exit 0
