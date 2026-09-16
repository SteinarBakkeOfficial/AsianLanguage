param(
  [string]$SymbolsPath = "content/release/symbols",
  [string]$OutputPath = "content/generated-review/symbol-review.md",
  [string]$V1ManifestPath = "Resources/V1CorpusManifest.json"
)

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$symbolsRoot = Join-Path $repoRoot $SymbolsPath
$outputFile = Join-Path $repoRoot $OutputPath

if (-not (Test-Path $symbolsRoot)) {
  Write-Error "Symbol workspace not found: $symbolsRoot"
  exit 2
}

New-Item -ItemType Directory -Path (Split-Path -Parent $outputFile) -Force | Out-Null
$manifestFile = Join-Path $repoRoot $V1ManifestPath
$activeIDs = if (Test-Path -LiteralPath $manifestFile) {
  @(Get-Content -LiteralPath $manifestFile -Raw | ConvertFrom-Json | ForEach-Object id)
} else {
  @()
}
$allSymbolFiles = @(Get-ChildItem -LiteralPath $symbolsRoot -Recurse -Filter "symbol.json" -File | Sort-Object FullName)
$symbolFiles = if ($activeIDs.Count -gt 0) {
  @($allSymbolFiles | Where-Object { $activeIDs -contains $_.Directory.Name })
} else {
  $allSymbolFiles
}
$lines = New-Object System.Collections.Generic.List[string]
$lines.Add("# Symbol review report")
$lines.Add("")
$lines.Add("Generated: $((Get-Date).ToUniversalTime().ToString('o'))")
$lines.Add("")
$lines.Add("This report is editorial preparation output. It does not approve generated or draft content.")
$lines.Add("")

foreach ($symbolFile in $symbolFiles) {
  $record = Get-Content -Raw -LiteralPath $symbolFile.FullName | ConvertFrom-Json
  $folder = $symbolFile.Directory.FullName.Substring($repoRoot.Path.Length + 1).Replace("\", "/")
  $lines.Add("## $($record.coreCharacter) — $($record.coreSharedMeaning)")
  $lines.Add("")
  $lines.Add("- ID: $($record.id)")
  $lines.Add("- Folder: $folder")
  $lines.Add("- Unicode: $($record.unicodeCodePoint)")
  $lines.Add("- Formation: $($record.formationType)")
  $lines.Add("- Editorial status: $($record.editorialStatus)")
  $lines.Add("- Publication status: $($record.publicationStatus)")
  $lines.Add("- Visual teaching notes: $(@($record.visualTeachingNotes).Count)")
  $lines.Add("")
  $lines.Add("### Historical stages")
  $lines.Add("")
  foreach ($stage in @($record.history.stages)) {
    $availability = $stage.availabilityState
    if ([string]::IsNullOrWhiteSpace($availability)) { $availability = if ($null -ne $stage.assetRef) { "available" } else { "unavailableAsset" } }
    $asset = if ([string]::IsNullOrWhiteSpace($stage.assetRef)) { "none (explicitly unavailable)" } else { $stage.assetRef }
    $lines.Add("- $($stage.label) ($($stage.stage)): availability $availability; certainty $($stage.certainty); asset $asset")
  }
  $lines.Add("")
  $lines.Add("### Review files")
  $lines.Add("")
  $lines.Add("- Structured record: $folder/symbol.json")
  $lines.Add("- Research: $folder/research.md")
  $lines.Add("- Sources: $folder/sources.json")
  $lines.Add("- Historical references: $folder/historical-references.json")
  $lines.Add("")
}

$lines -join [Environment]::NewLine | Set-Content -LiteralPath $outputFile -Encoding utf8
Write-Output "OK: generated Symbol review report for $($symbolFiles.Count) Symbol folder(s): $OutputPath"
exit 0
