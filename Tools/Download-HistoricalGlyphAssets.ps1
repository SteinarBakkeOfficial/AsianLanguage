param(
  [string]$SymbolsPath = "content/symbols"
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$symbolsRoot = Join-Path $repoRoot $SymbolsPath
$manifestURL = "https://raw.githubusercontent.com/bluegreenstone/hanzi-project/main/assets/manifest.json"
$userAgent = "AsianLanguage prototype asset intake/1.0 (source-backed offline research)"

# The upstream manifest separates source identity and licensing for each visual.
# Keep only CC0 files here so the bundled app can ship the evidence without
# silently inheriting a broader repository license.
$manifest = Invoke-RestMethod -Uri $manifestURL -Headers @{ "User-Agent" = $userAgent } -TimeoutSec 120
$records = @(
  @{ id = "day"; folder = "day-u65E5"; char = "日"; code = "65E5" },
  @{ id = "moon"; folder = "moon-u6708"; char = "月"; code = "6708" },
  @{ id = "person"; folder = "person-u4EBA"; char = "人"; code = "4EBA" },
  @{ id = "big"; folder = "big-u5927"; char = "大"; code = "5927" },
  @{ id = "small"; folder = "small-u5C0F"; char = "小"; code = "5C0F" },
  @{ id = "mountain"; folder = "mountain-u5C71"; char = "山"; code = "5C71" },
  @{ id = "water"; folder = "water-u6C34"; char = "水"; code = "6C34" },
  @{ id = "fire"; folder = "fire-u706B"; char = "火"; code = "706B" },
  @{ id = "tree"; folder = "tree-u6728"; char = "木"; code = "6728" },
  @{ id = "mouth"; folder = "mouth-u53E3"; char = "口"; code = "53E3" },
  @{ id = "eye"; folder = "eye-u76EE"; char = "目"; code = "76EE" }
)

$stages = @(
  @{ id = "oracleBone"; folder = "oracle"; manifestFolder = "oracle" },
  @{ id = "bronze"; folder = "bronze"; manifestFolder = "bronze" },
  @{ id = "seal"; folder = "seal"; manifestFolder = "shuowen_seal" },
  @{ id = "clerical"; folder = "clerical"; manifestFolder = "liushutong" }
)

# Fire's bronze reference is a separately verified CC0 Commons asset; the
# upstream Sinica release does not contain a matching bronze representative.
$verifiedFallbacks = @{
  "fire:bronze" = [pscustomobject]@{
    original_url = "https://upload.wikimedia.org/wikipedia/commons/9/96/%E7%81%AB-bronze.svg"
    source_page = "https://commons.wikimedia.org/wiki/File:%E7%81%AB-bronze.svg"
    source_reference = "火-bronze"
    source_id = "source-commons-fire-bronze"
    source_label = "Wikimedia Commons — 火-bronze.svg"
    license_id = "CC0-1.0"
    mime_type = "image/svg+xml"
  }
}

$sourceRecords = @{}
$downloaded = 0
$missing = New-Object System.Collections.Generic.List[string]
$skippedLicense = New-Object System.Collections.Generic.List[string]

function Set-JsonProperty {
  param(
    [object]$Object,
    [string]$Name,
    [object]$Value
  )

  # Older draft records omit optional fields; add them without changing the
  # shape of unrelated content so this intake remains safe to rerun.
  if ($null -eq $Object.PSObject.Properties[$Name]) {
    $Object | Add-Member -MemberType NoteProperty -Name $Name -Value $Value
  } else {
    $Object.$Name = $Value
  }
}

foreach ($record in $records) {
  $symbolFolder = Join-Path $symbolsRoot $record.folder
  $symbolPath = Join-Path $symbolFolder "symbol.json"
  if (-not (Test-Path -LiteralPath $symbolPath)) {
    $missing.Add("$($record.id):symbol.json") | Out-Null
    continue
  }

  $symbol = Get-Content -LiteralPath $symbolPath -Raw | ConvertFrom-Json
  $sourcesPath = Join-Path $symbolFolder "sources.json"
  $sources = @(Get-Content -LiteralPath $sourcesPath -Raw | ConvertFrom-Json)

  foreach ($stage in $stages) {
    $manifestPath = "assets/$($stage.manifestFolder)/U+$($record.code)/"
    $matches = @($manifest.assets | Where-Object {
      $_.local_path -like "$manifestPath*" -and
      $_.license_id -eq "CC0-1.0" -and
      $_.mime_type -eq "image/png" -and
      (
        $_.local_path -like "*representative*" -or
        $stage.manifestFolder -eq "shuowen_seal"
      )
    })
    $asset = $matches | Select-Object -First 1
    $fallbackAsset = $verifiedFallbacks["$($record.id):$($stage.id)"]
    if ($null -eq $asset) {
      $asset = $fallbackAsset
    }
    if ($null -eq $asset) {
      $missing.Add("$($record.id):$($stage.id)") | Out-Null
      continue
    }
    if ($asset.license_id -ne "CC0-1.0") {
      $skippedLicense.Add("$($record.id):$($stage.id) ($($asset.license_id))") | Out-Null
      continue
    }

    $assetExtension = if ($asset.mime_type -eq "image/svg+xml") { "svg" } else { "png" }
    $stageRoot = Join-Path $symbolFolder "historical/$($stage.folder)"
    $originalPath = Join-Path $stageRoot "original/source-asset.$assetExtension"
    $appPath = Join-Path $stageRoot "app/glyph.$assetExtension"
    New-Item -ItemType Directory -Path (Split-Path -Parent $originalPath), (Split-Path -Parent $appPath) -Force | Out-Null
    Invoke-WebRequest -Uri $asset.original_url -OutFile $originalPath -Headers @{ "User-Agent" = $userAgent } -TimeoutSec 120
    Copy-Item -LiteralPath $originalPath -Destination $appPath -Force

    $assetRef = "Assets/Symbols/$($record.folder)/historical/$($stage.folder)/app/glyph.$assetExtension"
    $isFallback = $null -ne $fallbackAsset
    $sourceID = if ($isFallback) { $asset.source_id } else { "source-sinica-$($record.id)-$($stage.id)" }
    $sourceEntry = [ordered]@{
      id = $sourceID
      label = if ($isFallback) { $asset.source_label } else { "Academia Sinica Xiaoxuetang — $($stage.id) $($record.char)" }
      type = "historical-asset"
      citation = if ($isFallback) { "CC0 historical glyph from the verified Commons source." } else { "CC0 historical glyph image from the Academia Sinica Xiaoxuetang source manifest." }
      url = $asset.source_page
    }
    $sources = @($sources | Where-Object { $_.id -ne $sourceID }) + [pscustomobject]$sourceEntry

    $stageRecord = @($symbol.history.stages) | Where-Object { $_.stage -eq $stage.id } | Select-Object -First 1
    if ($null -eq $stageRecord) {
      $missing.Add("$($record.id):$($stage.id)-record") | Out-Null
      continue
    }

    Set-JsonProperty $stageRecord "assetRef" $assetRef
    Set-JsonProperty $stageRecord "availabilityState" "available"
    Set-JsonProperty $stageRecord "sourceIds" (@(@($stageRecord.sourceIds) + $sourceID | Select-Object -Unique))
    Set-JsonProperty $stageRecord "assetMetadata" ([pscustomobject]@{
      characterID = $record.id
      historicalStage = $stage.id
      approximatePeriod = $null
      sourceInstitution = if ($isFallback) { "Wikimedia Commons" } else { "Academia Sinica Xiaoxuetang" }
      sourcePageURL = $asset.source_page
      sourceAssetURL = $asset.original_url
      catalogueReference = $asset.source_reference
      sourceDescription = "Source-backed historical glyph image; review stage interpretation before publication."
      retrievedAt = (Get-Date).ToUniversalTime().ToString("o")
      contentClass = "historicalEvidence"
      assetRef = $assetRef
      artifactAssetRef = $null
      assetKind = "historical-glyph"
      provenance = if ($isFallback) { "Wikimedia Commons / Ancient Chinese characters project" } else { "Academia Sinica Xiaoxuetang" }
      licenseStatus = "CC0-1.0"
      accessibilityDescription = "$($record.char) in $($stage.id) historical script"
      readiness = "needsReview"
    })

    $stageSourcePath = Join-Path $stageRoot "source.json"
    $stageSource = if (Test-Path -LiteralPath $stageSourcePath) { Get-Content -LiteralPath $stageSourcePath -Raw | ConvertFrom-Json } else { [pscustomobject]@{} }
    Set-JsonProperty $stageSource "character" $record.char
    Set-JsonProperty $stageSource "stage" $stage.id
    Set-JsonProperty $stageSource "sourceInstitution" $sourceEntry.label
    Set-JsonProperty $stageSource "sourcePageURL" $asset.source_page
    Set-JsonProperty $stageSource "sourceAssetURL" $asset.original_url
    Set-JsonProperty $stageSource "sourceDescription" $sourceEntry.citation
    Set-JsonProperty $stageSource "license" "CC0-1.0"
    Set-JsonProperty $stageSource "originalAssetPath" ((Join-Path $SymbolsPath "$($record.folder)/historical/$($stage.folder)/original/source-asset.$assetExtension").Replace("\", "/"))
    Set-JsonProperty $stageSource "appAssetPath" ((Join-Path $SymbolsPath "$($record.folder)/historical/$($stage.folder)/app/glyph.$assetExtension").Replace("\", "/"))
    Set-JsonProperty $stageSource "assetClass" "historicalEvidence"
    Set-JsonProperty $stageSource "availabilityState" "available"
    Set-JsonProperty $stageSource "editorialStatus" "needsReview"
    Set-JsonProperty $stageSource "sourceIds" @($stageRecord.sourceIds)
    $stageSource | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $stageSourcePath -Encoding utf8

    $downloaded += 1
  }

  $symbol | ConvertTo-Json -Depth 30 | Set-Content -LiteralPath $symbolPath -Encoding utf8
  $sources | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $sourcesPath -Encoding utf8
}

Write-Output "OK: downloaded and wired $downloaded historical glyph asset(s)."
if ($missing.Count -gt 0) { Write-Output "Missing: $($missing -join ', ')" }
if ($skippedLicense.Count -gt 0) { Write-Output "Skipped unresolved license: $($skippedLicense -join ', ')" }
