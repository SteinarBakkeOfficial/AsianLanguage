param(
  [Parameter(Mandatory = $true)]
  [string]$SourcePath,
  [Parameter(Mandatory = $true)]
  [string]$DestinationPath
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $SourcePath)) {
  Write-Error "Source corpus path not found: $SourcePath"
  exit 2
}

$sourceFiles = Get-ChildItem -Path $SourcePath -Filter "*.json" -File
if ($sourceFiles.Count -eq 0) {
  Write-Error "No source corpus JSON files found: $SourcePath"
  exit 2
}

if (-not (Test-Path $DestinationPath)) {
  New-Item -ItemType Directory -Path $DestinationPath | Out-Null
}

Get-ChildItem -Path $DestinationPath -Filter "*.json" -File |
  Remove-Item -Force

foreach ($file in $sourceFiles) {
  Copy-Item -LiteralPath $file.FullName -Destination (Join-Path $DestinationPath $file.Name)
}

Write-Output "OK: synced $($sourceFiles.Count) corpus record(s)."
exit 0
