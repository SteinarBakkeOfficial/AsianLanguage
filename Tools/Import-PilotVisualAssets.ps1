param(
  [string]$SharedCharactersPath = "content/shared-characters",
  [string]$SymbolsPath = "content/symbols"
)

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$sharedRoot = Join-Path $repoRoot $SharedCharactersPath
$symbolsRoot = Join-Path $repoRoot $SymbolsPath
$userAgent = "Script Roots pilot asset intake/1.0 (source-backed offline research)"

# This allowlist deliberately covers only the pilot's three visual symbols.
# A missing Wikimedia file remains unavailable; no modern or generated glyph is
# ever substituted for a historical stage.
$definitions = @(
  [ordered]@{
    id = "fire"; folder = "fire-u706B"; character = ([string][char]0x706B)
    files = @(
      [ordered]@{ stage = "oracleBone"; folder = "oracle"; file = "%E7%81%AB-oracle-2.svg"; catalogue = "Sinica 43.E519" }
      [ordered]@{ stage = "bronze"; folder = "bronze"; file = "%E7%81%AB-bronze.svg"; catalogue = "Ancient Chinese Characters project" }
      [ordered]@{ stage = "seal"; folder = "seal"; file = "%E7%81%AB-seal.svg"; catalogue = "Ancient Chinese Characters project" }
      [ordered]@{ stage = "clerical"; folder = "clerical"; file = "%E7%81%AB-clerical.svg"; catalogue = "Ancient Chinese Characters project" }
    )
  }
  [ordered]@{
    id = "water"; folder = "water-u6C34"; character = ([string][char]0x6C34)
    files = @(
      [ordered]@{ stage = "oracleBone"; folder = "oracle"; file = "%E6%B0%B4-oracle.svg"; catalogue = "Sinica 43.E7BE; 43.E7BE" }
      [ordered]@{ stage = "bronze"; folder = "bronze"; file = "%E6%B0%B4-bronze.svg"; catalogue = "Ancient Chinese Characters project" }
      [ordered]@{ stage = "seal"; folder = "seal"; file = "%E6%B0%B4-seal.svg"; catalogue = "Ancient Chinese Characters project" }
      [ordered]@{ stage = "clerical"; folder = "clerical"; file = "%E6%B0%B4-clerical.svg"; catalogue = "Ancient Chinese Characters project" }
    )
  }
  [ordered]@{
    id = "tree"; folder = "tree-u6728"; character = ([string][char]0x6728)
    files = @(
      [ordered]@{ stage = "oracleBone"; folder = "oracle"; file = "%E6%9C%A8-oracle.svg"; catalogue = "Ancient Chinese Characters project" }
      [ordered]@{ stage = "bronze"; folder = "bronze"; file = "%E6%9C%A8-bronze.svg"; catalogue = "Ancient Chinese Characters project" }
      [ordered]@{ stage = "seal"; folder = "seal"; file = "%E6%9C%A8-seal.svg"; catalogue = "Ancient Chinese Characters project" }
      [ordered]@{ stage = "clerical"; folder = "clerical"; file = "%E6%9C%A8-clerical.svg"; catalogue = "Ancient Chinese Characters project" }
    )
  }
)

function Set-JsonProperty {
  param([object]$Object, [string]$Name, [object]$Value)

  # Draft records predate some provenance fields; add them without disturbing
  # unrelated editorial data so the import can be rerun safely.
  if ($null -eq $Object.PSObject.Properties[$Name]) {
    $Object | Add-Member -MemberType NoteProperty -Name $Name -Value $Value
  } else {
    $Object.$Name = $Value
  }
}

function Add-UniqueSourceID {
  param([object]$Stage, [string]$SourceID)

  $existing = @($Stage.sourceIds)
  Set-JsonProperty $Stage "sourceIds" (@($existing + $SourceID | Select-Object -Unique))
}

function Read-Json {
  param([string]$Path)
  return Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
}

function Write-Json {
  param([object]$Value, [string]$Path)
  $Value | ConvertTo-Json -Depth 50 | Set-Content -LiteralPath $Path -Encoding utf8
}

function New-ConceptOrigin {
  param([string]$ID, [string]$Folder, [string]$Character, [string]$Concept, [string]$Explanation)

  return [pscustomobject][ordered]@{
    concept = $Concept
    explanation = $Explanation
    asset = [pscustomobject][ordered]@{
      characterID = $ID
      historicalStage = $null
      approximatePeriod = $null
      sourceInstitution = "Script Roots educational asset workflow"
      sourcePageURL = $null
      sourceAssetURL = $null
      catalogueReference = $null
      sourceDescription = "Original educational concept illustration; not historical evidence."
      retrievedAt = "2026-09-02"
      contentClass = "educationalReconstruction"
      assetRef = "Assets/Symbols/$Folder/educational/app/origin.png"
      artifactAssetRef = $null
      assetKind = "illustrated-concept"
      provenance = "OpenAI image generation; Script Roots editorial treatment"
      licenseStatus = "internal-authored"
      accessibilityDescription = "A clear educational illustration of $Concept."
      readiness = "needsReview"
    }
    sourceIds = @("source-generated-concept-$ID")
  }
}

function Update-Record {
  param([string]$Path, [object]$Definition)

  $record = Read-Json $Path
  $sourcesPath = Join-Path (Split-Path -Parent $Path) "sources.json"
  $sources = if (Test-Path -LiteralPath $sourcesPath) { @(Read-Json $sourcesPath) } else { @($record.sources) }

  $concept = switch ($Definition.id) {
    "fire" { "Fire" }
    "water" { "Flowing water" }
    "tree" { "A tree" }
  }
  $explanation = switch ($Definition.id) {
    "fire" { "A rising flame spreads into smaller tongues, an educational way to notice the idea behind the character." }
    "water" { "Flowing ribbons and a falling drop make the movement of water immediately visible beside the character." }
    "tree" { "A trunk, branching limbs, and a modest crown keep the tree idea visible beside the character." }
  }
  Set-JsonProperty $record.history "origin" (New-ConceptOrigin $Definition.id $Definition.folder $Definition.character $concept $explanation)
  Set-JsonProperty $record.visuals "assetStatus" "source-backed-draft"
  Set-JsonProperty $record.visuals "note" "Pilot historical glyphs use clear source-backed SVGs where available. Concept artwork is a separate educational reconstruction and remains under editorial review."

  $educationalMetadataPath = Join-Path (Split-Path -Parent $Path) "educational/metadata.json"
  if (Test-Path -LiteralPath $educationalMetadataPath) {
    $educationalMetadata = Read-Json $educationalMetadataPath
    Set-JsonProperty $educationalMetadata "originalAsset" "content/symbols/$($Definition.folder)/educational/original/origin.png"
    Set-JsonProperty $educationalMetadata "appAsset" "content/symbols/$($Definition.folder)/educational/app/origin.png"
    Set-JsonProperty $educationalMetadata "assetKind" "illustrated-concept"
    Set-JsonProperty $educationalMetadata "contentClass" "educationalReconstruction"
    Set-JsonProperty $educationalMetadata "provenance" "OpenAI image generation; Script Roots editorial treatment"
    Set-JsonProperty $educationalMetadata "licenseStatus" "internal-authored"
    Set-JsonProperty $educationalMetadata "readiness" "needsReview"
    Write-Json $educationalMetadata $educationalMetadataPath
  }

  $conceptSourceID = "source-generated-concept-$($Definition.id)"
  $sources = @($sources | Where-Object { $_.id -ne $conceptSourceID }) + [pscustomobject][ordered]@{
    id = $conceptSourceID
    label = "Script Roots educational concept illustration - $concept"
    type = "educational-asset"
    citation = "Original educational reconstruction generated for the Script Roots pilot; not historical evidence."
    url = "https://openai.com/index/image-generation-api/"
  }

  foreach ($fileDefinition in @($Definition.files)) {
    $stage = @($record.history.stages) | Where-Object { $_.stage -eq $fileDefinition.stage } | Select-Object -First 1
    if ($null -eq $stage) { continue }

    $sourceID = "source-commons-$($Definition.id)-$($fileDefinition.stage)"
    $assetRef = "Assets/Symbols/$($Definition.folder)/historical/$($fileDefinition.folder)/app/glyph.svg"
    $pageURL = "https://commons.wikimedia.org/wiki/File:" + $fileDefinition.file
    $assetURL = "https://commons.wikimedia.org/wiki/Special:FilePath/" + $fileDefinition.file
    $metadata = [pscustomobject][ordered]@{
      characterID = $Definition.id
      historicalStage = $fileDefinition.stage
      approximatePeriod = $null
      sourceInstitution = "Wikimedia Commons / Academia Sinica Xiaoxuetang"
      sourcePageURL = $pageURL
      sourceAssetURL = $assetURL
      catalogueReference = $fileDefinition.catalogue
      sourceDescription = "Source-backed historical glyph SVG from the Ancient Chinese Characters project; verify stage interpretation before publication."
      retrievedAt = "2026-09-02"
      contentClass = "historicalEvidence"
      assetRef = $assetRef
      artifactAssetRef = $null
      assetKind = "historical-glyph"
      provenance = "Wikimedia Commons Ancient Chinese Characters project; source references Academia Sinica Xiaoxuetang"
      licenseStatus = "CC0-1.0"
      accessibilityDescription = "$($Definition.character) in $($fileDefinition.stage) historical script"
      readiness = "needsReview"
    }
    Set-JsonProperty $stage "assetRef" $assetRef
    Set-JsonProperty $stage "availabilityState" "available"
    Set-JsonProperty $stage "assetMetadata" $metadata
    Add-UniqueSourceID $stage $sourceID

    $stageRoot = Join-Path (Join-Path (Split-Path -Parent $Path) "historical") $fileDefinition.folder
    New-Item -ItemType Directory -Force -Path (Join-Path $stageRoot "original"), (Join-Path $stageRoot "app") | Out-Null
    $originalPath = Join-Path $stageRoot "original/source-asset.svg"
    $appPath = Join-Path $stageRoot "app/glyph.svg"
    try {
      Invoke-WebRequest -Uri $assetURL -OutFile $originalPath -Headers @{ "User-Agent" = $userAgent } -TimeoutSec 120
      Copy-Item -LiteralPath $originalPath -Destination $appPath -Force
    } catch {
      # The source list is broader than the current Commons coverage. Preserve
      # the explicit missing state when a named stage file does not exist.
      Remove-Item -LiteralPath $originalPath -Force -ErrorAction SilentlyContinue
      Remove-Item -LiteralPath $appPath -Force -ErrorAction SilentlyContinue
      Set-JsonProperty $stage "assetRef" $null
      Set-JsonProperty $stage "availabilityState" "unavailableAsset"
      Set-JsonProperty $stage "assetMetadata" $null
      $sources = @($sources | Where-Object { $_.id -ne $sourceID }) + [pscustomobject][ordered]@{
        id = $sourceID
        label = "Wikimedia Commons candidate - $($fileDefinition.file)"
        type = "historical-asset"
        citation = "Allowlisted source candidate was checked during the pilot import, but no local asset was acquired; retain the stage as unavailable until an approved file is available."
        url = $pageURL
      }
      continue
    }

    $stageSourcePath = Join-Path $stageRoot "source.json"
    $stageSource = if (Test-Path -LiteralPath $stageSourcePath) { Read-Json $stageSourcePath } else { [pscustomobject]@{} }
    Set-JsonProperty $stageSource "character" $Definition.character
    Set-JsonProperty $stageSource "stage" $fileDefinition.stage
    Set-JsonProperty $stageSource "sourceInstitution" "Wikimedia Commons / Academia Sinica Xiaoxuetang"
    Set-JsonProperty $stageSource "sourcePageURL" $pageURL
    Set-JsonProperty $stageSource "sourceAssetURL" $assetURL
    Set-JsonProperty $stageSource "sourceDescription" "Public-domain/CC0 historical glyph SVG; retain this provenance with any derivative."
    Set-JsonProperty $stageSource "license" "CC0-1.0"
    Set-JsonProperty $stageSource "originalAssetPath" (Join-Path $SymbolsPath "$($Definition.folder)/historical/$($fileDefinition.folder)/original/source-asset.svg").Replace("\", "/")
    Set-JsonProperty $stageSource "appAssetPath" (Join-Path $SymbolsPath "$($Definition.folder)/historical/$($fileDefinition.folder)/app/glyph.svg").Replace("\", "/")
    Set-JsonProperty $stageSource "assetClass" "historicalEvidence"
    Set-JsonProperty $stageSource "availabilityState" "available"
    Set-JsonProperty $stageSource "editorialStatus" "needsReview"
    Set-JsonProperty $stageSource "sourceIds" @($stage.sourceIds)
    Write-Json $stageSource $stageSourcePath

    $sourceEntry = [pscustomobject][ordered]@{
      id = $sourceID
      label = "Wikimedia Commons - $($fileDefinition.file)"
      type = "historical-asset"
      citation = "CC0/public-domain SVG from the Ancient Chinese Characters project; source references Academia Sinica Xiaoxuetang."
      url = $pageURL
    }
    $sources = @($sources | Where-Object { $_.id -ne $sourceID }) + $sourceEntry
  }

  Write-Json $record $Path
  Write-Json $sources $sourcesPath
}

function Update-SharedRecord {
  param([string]$SharedPath, [string]$SymbolPath, [object]$Definition)

  # Shared-character records are intentionally flat. Copy only the resolved
  # presentation/provenance fields from the symbol package; never create asset
  # directories beside the shared record itself.
  $record = Read-Json $SharedPath
  $symbol = Read-Json $SymbolPath
  $symbolSourcesPath = Join-Path (Split-Path -Parent $SymbolPath) "sources.json"
  $symbolSources = if (Test-Path -LiteralPath $symbolSourcesPath) { @(Read-Json $symbolSourcesPath) } else { @() }

  Set-JsonProperty $record.history "origin" $symbol.history.origin
  Set-JsonProperty $record.visuals "assetStatus" $symbol.visuals.assetStatus
  Set-JsonProperty $record.visuals "note" $symbol.visuals.note

  $symbolStages = @($symbol.history.stages)
  foreach ($stage in @($record.history.stages)) {
    $matchingStage = $symbolStages | Where-Object { $_.stage -eq $stage.stage } | Select-Object -First 1
    if ($null -eq $matchingStage) { continue }
    Set-JsonProperty $stage "assetRef" $matchingStage.assetRef
    Set-JsonProperty $stage "availabilityState" $matchingStage.availabilityState
    Set-JsonProperty $stage "assetMetadata" $matchingStage.assetMetadata
    Set-JsonProperty $stage "sourceIds" @($matchingStage.sourceIds)
  }

  Set-JsonProperty $record "sources" $symbolSources
  Write-Json $record $SharedPath
}

foreach ($definition in $definitions) {
  $sharedPath = Join-Path $sharedRoot "$($definition.id).json"
  $symbolFolder = Join-Path $symbolsRoot $definition.folder
  $symbolPath = Join-Path $symbolFolder "symbol.json"
  if (Test-Path -LiteralPath $symbolPath) { Update-Record $symbolPath $definition }
  if ((Test-Path -LiteralPath $sharedPath) -and (Test-Path -LiteralPath $symbolPath)) {
    Update-SharedRecord $sharedPath $symbolPath $definition
  }
}

Write-Output "OK: imported pilot historical SVGs and concept provenance for Fire, Water, and Tree."
