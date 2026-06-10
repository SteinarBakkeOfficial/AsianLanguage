param(
  [Parameter(Mandatory = $true)]
  [string]$CorpusPath,

  [int]$LaunchTarget = 100
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $CorpusPath)) {
  Write-Error "Corpus path not found: $CorpusPath"
  exit 2
}

$jsonFiles = Get-ChildItem -Path $CorpusPath -Filter "*.json" -File
if ($jsonFiles.Count -eq 0) {
  Write-Error "No corpus JSON files found: $CorpusPath"
  exit 2
}

$records = foreach ($file in $jsonFiles) {
  Get-Content -Raw $file.FullName | ConvertFrom-Json
}

$draftCount = @($records | Where-Object { $_.publicationStatus -eq "draft" }).Count
$reviewCount = @($records | Where-Object { $_.publicationStatus -eq "review" }).Count
$publishedCount = @($records | Where-Object { $_.publicationStatus -eq "published" }).Count
$remainingToTarget = [Math]::Max(0, $LaunchTarget - $publishedCount)

Write-Output "Corpus readiness"
Write-Output "Total records: $($jsonFiles.Count)"
Write-Output "Draft records: $draftCount"
Write-Output "Review records: $reviewCount"
Write-Output "Published records: $publishedCount"
Write-Output "Launch target: $LaunchTarget"
Write-Output "Published remaining to target: $remainingToTarget"
exit 0
