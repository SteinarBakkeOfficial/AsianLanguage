param(
  [string]$OutputPath = "Resources/Assets/HistoricalGlyphs"
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$outputRoot = Join-Path $repoRoot $OutputPath

New-Item -ItemType Directory -Path $outputRoot -Force | Out-Null

$records = @(
  @{ id = "day"; char = "日" },
  @{ id = "moon"; char = "月" },
  @{ id = "person"; char = "人" },
  @{ id = "big"; char = "大" },
  @{ id = "small"; char = "小" },
  @{ id = "mountain"; char = "山" },
  @{ id = "water"; char = "水" },
  @{ id = "fire"; char = "火" },
  @{ id = "tree"; char = "木" },
  @{ id = "mouth"; char = "口" },
  @{ id = "eye"; char = "目" }
)

$stages = @(
  @{ id = "oracleBone"; commonsSuffix = "oracle"; fileSuffix = "oracle" },
  @{ id = "bronze"; commonsSuffix = "bronze"; fileSuffix = "bronze" },
  @{ id = "seal"; commonsSuffix = "seal"; fileSuffix = "seal" }
)

$downloaded = 0
$missing = New-Object System.Collections.Generic.List[string]

foreach ($record in $records) {
  foreach ($stage in $stages) {
    $commonsFileName = "$($record.char)-$($stage.commonsSuffix).svg"
    $encodedFileName = [System.Uri]::EscapeDataString($commonsFileName)
    $uri = "https://commons.wikimedia.org/wiki/Special:Redirect/file/$encodedFileName"
    $destination = Join-Path $outputRoot "$($record.id)-$($stage.fileSuffix).svg"

    try {
      Invoke-WebRequest -Uri $uri -OutFile $destination -MaximumRedirection 5 -ErrorAction Stop
      if ((Get-Item $destination).Length -gt 0) {
        $downloaded += 1
      }
      else {
        Remove-Item -LiteralPath $destination -Force
        $missing.Add("$($record.id):$($stage.id)") | Out-Null
      }
    }
    catch {
      if (Test-Path $destination) {
        Remove-Item -LiteralPath $destination -Force
      }
      $missing.Add("$($record.id):$($stage.id)") | Out-Null
    }
  }
}

Write-Output "OK: downloaded $downloaded historical glyph asset(s)."
if ($missing.Count -gt 0) {
  Write-Output "Missing: $($missing -join ', ')"
}
