param(
  [Parameter(Mandatory = $true)]
  [string]$SourcePath,
  [Parameter(Mandatory = $true)]
  [string]$DestinationPath,
  [string]$ManifestPath = ""
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $SourcePath)) {
  Write-Error "Source corpus path not found: $SourcePath"
  exit 2
}

$activeIDs = @()
if (-not [string]::IsNullOrWhiteSpace($ManifestPath)) {
  $manifestFile = if ([IO.Path]::IsPathRooted($ManifestPath)) { $ManifestPath } else { Join-Path (Resolve-Path (Join-Path $PSScriptRoot "..")) $ManifestPath }
  if (-not (Test-Path -LiteralPath $manifestFile)) {
    Write-Error "Active Symbol manifest not found: $manifestFile"
    exit 2
  }
  $activeIDs = @(Get-Content -LiteralPath $manifestFile -Raw | ConvertFrom-Json | ForEach-Object id)
}

$symbolFiles = @(Get-ChildItem -Path $SourcePath -Recurse -Filter "symbol.json" -File)
if ($activeIDs.Count -gt 0) {
  $symbolFiles = @($symbolFiles | Where-Object { $activeIDs -contains $_.Directory.Name })
}
$copyItems = New-Object System.Collections.Generic.List[object]
if ($symbolFiles.Count -gt 0) {
  foreach ($symbolFile in $symbolFiles) {
    $record = Get-Content -Raw -LiteralPath $symbolFile.FullName | ConvertFrom-Json
    if ([string]::IsNullOrWhiteSpace($record.id)) {
      Write-Error "Symbol record is missing id: $($symbolFile.FullName)"
      exit 2
    }
    $copyItems.Add([pscustomobject]@{ Source = $symbolFile.FullName; Name = "$($record.id).json" }) | Out-Null
  }
} else {
  $flatFiles = @(Get-ChildItem -Path $SourcePath -Filter "*.json" -File)
  foreach ($file in $flatFiles) {
    $copyItems.Add([pscustomobject]@{ Source = $file.FullName; Name = $file.Name }) | Out-Null
  }
}

if ($copyItems.Count -eq 0) {
  Write-Error "No source corpus JSON files or Symbol folders found: $SourcePath"
  exit 2
}

if (-not (Test-Path $DestinationPath)) {
  New-Item -ItemType Directory -Path $DestinationPath | Out-Null
}

Get-ChildItem -Path $DestinationPath -Filter "*.json" -File |
  Remove-Item -Force

foreach ($item in $copyItems) {
  Copy-Item -LiteralPath $item.Source -Destination (Join-Path $DestinationPath $item.Name)
}

Write-Output "OK: synced $($copyItems.Count) corpus record(s)."
exit 0
