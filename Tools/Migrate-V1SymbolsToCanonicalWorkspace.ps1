param(
  [string]$ManifestPath = "Resources/V1CorpusManifest.json",
  [string]$RuntimeCorpusPath = "Resources/Corpus",
  [string]$ResearchRoot = "docs/archive/research-intake/v1-symbols",
  [string]$PilotWorkspacePath = "docs/archive/legacy-pilot/symbols",
  [string]$CanonicalWorkspacePath = "content/release/symbols"
)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

function Resolve-RepoPath([string]$Path) {
  if ([IO.Path]::IsPathRooted($Path)) { return $Path }
  return Join-Path $repoRoot $Path
}

function Read-Json([string]$Path) {
  return Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
}

function Get-RelativeFolderName([string]$Path) {
  return [IO.Path]::GetFileName($Path.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar))
}

$manifest = @(Read-Json (Resolve-RepoPath $ManifestPath))
$runtimeRoot = Resolve-RepoPath $RuntimeCorpusPath
$researchRootPath = Resolve-RepoPath $ResearchRoot
$pilotRoot = Resolve-RepoPath $PilotWorkspacePath
$canonicalRoot = Resolve-RepoPath $CanonicalWorkspacePath

if (-not (Test-Path -LiteralPath $runtimeRoot)) { throw "Runtime corpus not found: $runtimeRoot" }
if (-not (Test-Path -LiteralPath $researchRootPath)) { throw "Research root not found: $researchRootPath" }
if (-not (Test-Path -LiteralPath $canonicalRoot)) { New-Item -ItemType Directory -Path $canonicalRoot | Out-Null }

# The existing pilot folders use a suffixed ID. They are consulted only to
# recover missing editorial documents for the original pilot characters; the
# V1 research package remains the source for V1 historical assets.
$pilotByCharacter = @{}
if (Test-Path -LiteralPath $pilotRoot) {
  foreach ($file in @(Get-ChildItem -LiteralPath $pilotRoot -Recurse -Filter "symbol.json" -File)) {
    $pilotRecord = Read-Json $file.FullName
    if ($pilotRecord.coreCharacter) { $pilotByCharacter[[string]$pilotRecord.coreCharacter] = $file.Directory.FullName }
  }
}

$created = 0
foreach ($manifestRecord in ($manifest | Sort-Object teachingSequence)) {
  $id = [string]$manifestRecord.id
  $character = [string]$manifestRecord.coreCharacter
  $sourceFolder = Join-Path $researchRootPath (Get-RelativeFolderName ([string]$manifestRecord.contentFolder))
  $runtimeFile = Join-Path $runtimeRoot ($id + ".json")
  $targetFolder = Join-Path $canonicalRoot $id

  if (-not (Test-Path -LiteralPath $sourceFolder)) { throw "Research folder not found for $id`: $sourceFolder" }
  if (-not (Test-Path -LiteralPath $runtimeFile)) { throw "Runtime JSON not found for $id`: $runtimeFile" }
  if (Test-Path -LiteralPath $targetFolder) { throw "Canonical Symbol folder already exists; migration is not idempotent: $targetFolder" }

  New-Item -ItemType Directory -Path $targetFolder | Out-Null
  # Copy only the files and asset branches used by the active V1 importer.
  # Earlier research alternatives remain in the archive and must not make the
  # active per-Symbol folder ambiguous when this migration is rerun elsewhere.
  foreach ($file in @(Get-ChildItem -LiteralPath $sourceFolder -File -Force)) {
    Copy-Item -LiteralPath $file.FullName -Destination $targetFolder -Force
  }

  $sourceEducationalRoot = Join-Path $sourceFolder "educational"
  if (Test-Path -LiteralPath $sourceEducationalRoot) {
    foreach ($file in @(Get-ChildItem -LiteralPath $sourceEducationalRoot -File -Force)) {
      $targetEducationalRoot = Join-Path $targetFolder "educational"
      New-Item -ItemType Directory -Path $targetEducationalRoot -Force | Out-Null
      Copy-Item -LiteralPath $file.FullName -Destination $targetEducationalRoot -Force
    }

    $sourceOriginRoot = Join-Path $sourceEducationalRoot "original"
    if (Test-Path -LiteralPath $sourceOriginRoot) {
      $originV3 = Join-Path $sourceOriginRoot "origin-locked-style-v3.png"
      $originV2 = Join-Path $sourceOriginRoot "origin-locked-style-v2.png"
      $originSource = if (Test-Path -LiteralPath $originV3) { $originV3 } elseif (Test-Path -LiteralPath $originV2) { $originV2 } else { $null }
      if ($null -eq $originSource) { throw "No locked v2/v3 Origin illustration found for $id`: $sourceOriginRoot" }
      $targetOriginRoot = Join-Path $targetFolder "educational/original"
      New-Item -ItemType Directory -Path $targetOriginRoot -Force | Out-Null
      Copy-Item -LiteralPath $originSource -Destination $targetOriginRoot -Force
    }
  }

  $sourceSelectedRoot = Join-Path $sourceFolder "historical/zdic-selected"
  if (-not (Test-Path -LiteralPath $sourceSelectedRoot)) { throw "Selected historical assets not found for $id`: $sourceSelectedRoot" }
  Copy-Item -LiteralPath $sourceSelectedRoot -Destination (Join-Path $targetFolder "historical") -Recurse -Force

  # Keep the complete current structured record beside its character-specific
  # research and artwork. Runtime asset references remain bundle paths because
  # Resources/Corpus is still the generated iOS output.
  $record = Read-Json $runtimeFile
  $record.contentFolder = "content/release/symbols/$id"
  $record.researchNotesPath = if (Test-Path (Join-Path $targetFolder "research.md")) { "content/release/symbols/$id/research.md" } else { $null }
  $record.learnerCopyPath = if (Test-Path (Join-Path $targetFolder "lesson.md")) { "content/release/symbols/$id/lesson.md" } else { $null }
  $record.reviewPath = if (Test-Path (Join-Path $targetFolder "review.md")) { "content/release/symbols/$id/review.md" } else { $null }
  $record | ConvertTo-Json -Depth 80 | Set-Content -LiteralPath (Join-Path $targetFolder "symbol.json") -Encoding utf8

  # The first pilot batch predates the V1 research-folder metadata files. Keep
  # those editorial references discoverable in the canonical folder when they
  # are absent from the newer research package.
  if ($pilotByCharacter.ContainsKey($character)) {
    $pilotFolder = $pilotByCharacter[$character]
    foreach ($fileName in @("lesson.md", "research.md", "review.md", "sources.json")) {
      $sourceFile = Join-Path $pilotFolder $fileName
      $targetFile = Join-Path $targetFolder $fileName
      if ((Test-Path -LiteralPath $sourceFile) -and -not (Test-Path -LiteralPath $targetFile)) {
        Copy-Item -LiteralPath $sourceFile -Destination $targetFile -Force
      }
    }
  }

  $created++
}

Write-Output "OK: created $created canonical V1 Symbol folders under $CanonicalWorkspacePath."
