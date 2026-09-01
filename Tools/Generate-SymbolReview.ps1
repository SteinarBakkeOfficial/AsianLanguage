param(
  [string]$SymbolsPath = "content/symbols",
  [string]$OutputPath = "content/generated-review/symbol-review.md"
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
$symbolFiles = @(Get-ChildItem -LiteralPath $symbolsRoot -Recurse -Filter "symbol.json" -File | Sort-Object FullName)
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
  $lines.Add("- Learner copy: $folder/lesson.md")
  $lines.Add("- Research: $folder/research.md")
  $lines.Add("- Sources: $folder/sources.json")
  $lines.Add("- Review checklist: $folder/review.md")
  $lines.Add("")
}

$lines -join [Environment]::NewLine | Set-Content -LiteralPath $outputFile -Encoding utf8
Write-Output "OK: generated Symbol review report for $($symbolFiles.Count) Symbol folder(s): $OutputPath"
exit 0
