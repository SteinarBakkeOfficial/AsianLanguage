param(
  [string]$CaptionSource = "artwork_production/source/AsianLanguagesApp_FINAL_IMAGE_GENERATION_TEXT_HANDOFF_v3_SEMANTIC_REBUILD/ILLUSTRATION_TEXT/ILLUSTRATION_TEXT_126.md",
  [string]$ReleaseSymbolsPath = "content/release/symbols",
  [string]$ArtworkApprovalPath = "artwork_production/approved/originals",
  [string]$RuntimeImportScript = "Tools/Import-V1RuntimeCorpus.ps1"
)

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

function Resolve-RepoPath([string]$Path) {
  if ([IO.Path]::IsPathRooted($Path)) { return $Path }
  return Join-Path $repoRoot $Path
}

function Read-Text([string]$Path) {
  return Get-Content -LiteralPath (Resolve-RepoPath $Path) -Raw
}

function Write-Text([string]$Path, [string]$Text) {
  Set-Content -LiteralPath (Resolve-RepoPath $Path) -Value $Text -Encoding utf8
}

function Get-CaptionLedger([string]$Path) {
  $lines = Get-Content -LiteralPath (Resolve-RepoPath $Path)
  $ledger = @{}
  for ($index = 0; $index -lt $lines.Count; $index++) {
    if ($lines[$index] -match '^## (\d{3})\s+.+$') {
      $sequence = [int]$Matches[1]
      for ($lookahead = $index + 1; $lookahead -lt [Math]::Min($index + 16, $lines.Count); $lookahead++) {
        if ($lines[$lookahead] -match '^- \*\*Learner-facing text:\*\*\s*(.+)$') {
          $ledger[$sequence] = $Matches[1]
          break
        }
      }
    }
  }
  return $ledger
}

function Set-CaptionLedger([string]$Path, [hashtable]$Captions) {
  $lines = [System.Collections.Generic.List[string]](Get-Content -LiteralPath (Resolve-RepoPath $Path))
  for ($index = 0; $index -lt $lines.Count; $index++) {
    if ($lines[$index] -match '^## (\d{3})\s+.+$') {
      $sequence = [int]$Matches[1]
      if (-not $Captions.ContainsKey($sequence)) { continue }
      for ($lookahead = $index + 1; $lookahead -lt [Math]::Min($index + 16, $lines.Count); $lookahead++) {
        if ($lines[$lookahead] -match '^- \*\*Learner-facing text:\*\*\s*(.+)$') {
          $lines[$lookahead] = "- **Learner-facing text:** $($Captions[$sequence])"
          break
        }
      }
    }
  }
  Set-Content -LiteralPath (Resolve-RepoPath $Path) -Value ($lines -join [Environment]::NewLine) -Encoding utf8
}

function Set-OriginAnchor([string]$Path, [string]$Caption) {
  $resolvedPath = Resolve-RepoPath $Path
  $raw = Get-Content -LiteralPath $resolvedPath -Raw
  $jsonCaption = $Caption | ConvertTo-Json -Compress
  $pattern = '(?m)^(\s*"originAnchor"\s*:\s*)("(?:\\.|[^"\\])*")(\s*,?\s*)$'
  $updated = [regex]::Replace($raw, $pattern, {
      param($match)
      return $match.Groups[1].Value + $jsonCaption + $match.Groups[3].Value
    }, 1)
  if ($updated -eq $raw) { return }
  Set-Content -LiteralPath $resolvedPath -Value $updated -Encoding utf8
}

function Backup-File([string]$SourcePath, [string]$BackupRoot, [string]$RelativePath) {
  $source = Resolve-RepoPath $SourcePath
  if (-not (Test-Path -LiteralPath $source)) { return $false }
  $destination = Join-Path $BackupRoot $RelativePath
  New-Item -ItemType Directory -Path (Split-Path -Parent $destination) -Force | Out-Null
  Copy-Item -LiteralPath $source -Destination $destination -Force
  return $true
}

$captionLedger = Get-CaptionLedger $CaptionSource
if ($captionLedger.Count -ne 126) {
  throw "Expected 126 caption entries, found $($captionLedger.Count)."
}

# These are the captions explicitly approved in the preceding review. All
# other entries remain exactly as they appear in the authoritative ledger.
$approvedCaptionOverrides = @{
  3 = "A crescent moon, representing both the moon and the month."
  15 = "A framed well opening, showing a protected source of water."
  16 = "A rock opening and water combine to show a spring or source."
  17 = "A sprout and the ground combine to express life, birth, and growth."
  20 = "A kneeling woman with crossed arms is the pictographic origin of 'woman' and 'female.'"
  22 = "A kneeling mother figure with added marks for motherhood and breastfeeding."
  27 = "A human nose became a way to refer to oneself, leading to 'self'; a later form took over 'nose.'"
  29 = "The rounded abdomen may show pregnancy or the body itself; its meaning later broadened to 'body' and 'self.'"
  31 = "An elderly person, long hair, and a staff combine to express old age."
  33 = "The ancient picture is disputed: scholars see a great person, enlarged head, or sign above a person; all suggest what is highest—'sky' or 'heaven.'"
  42 = "A high-footed lidded vessel was borrowed by sound to write 'bean'; the vessel meaning survives mainly in historical contexts."
  43 = "A bladed tool likely represents working the ground, though some see a carpenter's square; it later came to mean 'work' or 'craft.'"
  54 = "A settlement flag may mark the center; other theories see a wind flag or abstract midpoint sign. The meaning became 'middle' or 'center.'"
  55 = "A cluster of tiny marks suggests 'small'; early forms varied, and the related meaning 'few' later separated."
  56 = "Four tiny marks suggest 'few' or 'little'; early forms overlapped with 'small' before the meanings separated."
  57 = "Two portions of meat repeat to suggest abundance, leading to the meanings 'many' or 'much.'"
  62 = "A person and a wooden neck restraint form a disputed combination that later came to mean 'center.'"
  64 = "Two standing people face away from each other; together, they came to mean 'north.'"
  66 = "Two separate trees stand side by side; together, they represent a forest."
  67 = "A person and a tree combine to show resting against a tree; this led to 'rest.'"
  68 = "Two separate people, one behind the other, combine to express following."
  69 = "A woman and a child together express an affectionate bond; this led to 'good.'"
  70 = "A field and a farming tool combine to represent a man."
  71 = "A window and a crescent moon combine to show moonlight; this led to 'bright.'"
  73 = "A person and a mouth element combine to express an older brother with authority."
  74 = "Three separate vessel-like forms combine to suggest goods, things, and a range of items."
  75 = "A tongue and an upper speech element combine to express telling."
  76 = "A lid and a vessel fit together; their joining led to 'join.'"
  77 = "A hand and an ear combine to express seizing or taking."
  78 = "A hand and a tree combine to show picking; this led to 'gather.'"
  80 = "Two separate footprints, one ahead of the other, combine to express a step."
  83 = "A footprint and a destination marker combine to express moving straight or upright."
  84 = "A foot ahead of a person marks what comes before; this led to 'before.'"
  85 = "A person and a reaching hand combine to show catching up; this led to 'reach.'"
  87 = "A hand and a cliff face combine to suggest climbing; this later came to mean 'turn back.'"
  88 = "Two separate hands facing the same way show cooperation; together, they came to mean 'friend.'"
  89 = "A roofed house and a sound opening suggest an echo; sound borrowing later gave the meaning 'direction.'"
  90 = "A knife and two separate pieces combine to show dividing something apart."
  91 = "A grain plant and a knife combine to show harvest; gain from harvesting led to 'benefit.'"
  92 = "A weapon and an advancing foot combine to express military force in motion; this led to 'martial.'"
  93 = "A hand and a cowry shell combine to show taking something valuable; this led to 'obtain.'"
  94 = "A bound foot and an advancing foot combine to show one following behind; this led to 'after.'"
  95 = "A bird and a tree combine to show birds gathering in a tree; this led to 'gather.'"
  96 = "A tongue and speech lines combine to represent spoken language; this led to 'speech.'"
  98 = "An eye and a pointed tool combine in a disputed image; later usage broadened to 'people.'"
  99 = "Bound writing slips and a low stand combine to show a written record; this led to 'classic.'"
  100 = "An axe and two hands combine to show a weapon in use; this led to 'soldier.'"
  101 = "A speech element and a kneeling person combine to show authority issuing a command."
  102 = "A foot and a cave opening combine to show arrival; sound borrowing later gave the meaning 'each.'"
  104 = "A woman and a hand combine in disputed interpretations: seizing or arranging her hair; together, they came to mean 'wife.'"
  105 = "A firmness-related upper element and a lower enclosure combine; the original idea was 'solid,' later borrowed for 'old.'"
  106 = "An upper ritual object and a separate lower enclosure suggest sacred protection and blessing; this led to 'auspicious.'"
  107 = "A banner and a group of people combine to show troops under a standard; this later led to 'journey.'"
  108 = "A banner and an arrow or weapon combine to represent a military group; this later broadened to 'group.'"
  109 = "A roof and a hand combine to show guarding what lies beneath; this led to 'protect.'"
  110 = "A roofed building and a group of people combine to show a government office; this later led to 'official.'"
  111 = "A lightning flash suggested stretching through its spreading form; sound borrowing later led to 'state' and 'apply.'"
  113 = "Leading theory: a raised thumb linked with 'first' and 'chief,' later borrowed by sound for 'white.' Other theories see a vessel, head, or light."
  114 = "Leading theory: a person receiving facial tattooing and dark pigment as punishment; the sign later meant 'black,' inspiring a fire-and-chimney explanation."
  117 = "Leading interpretation: a person looking toward the sun expresses summer heat; others see a cicada or a personal name."
  118 = "A cord tied at both ends suggests an ending; it was later borrowed by sound for 'winter,' while later forms added ice."
  119 = "A person and a separate eye show looking into the distance; this led to waiting and hope, while later forms added the moon."
}

foreach ($entry in $approvedCaptionOverrides.GetEnumerator()) {
  $captionLedger[[int]$entry.Key] = [string]$entry.Value
}

$backupRoot = Join-Path $repoRoot "content/archive/symbols/approved-caption-artwork-import-2026-09-16"
New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null

# Preserve every canonical record before changing the visible Origin caption.
foreach ($symbolFolder in Get-ChildItem -LiteralPath (Resolve-RepoPath $ReleaseSymbolsPath) -Directory) {
  $relative = "$($symbolFolder.Name)/symbol.json"
  Backup-File "$ReleaseSymbolsPath/$relative" $backupRoot $relative | Out-Null
}

Set-CaptionLedger -Path $CaptionSource -Captions $captionLedger

foreach ($symbolFolder in Get-ChildItem -LiteralPath (Resolve-RepoPath $ReleaseSymbolsPath) -Directory) {
  $symbolPath = Join-Path $symbolFolder.FullName "symbol.json"
  $record = Get-Content -LiteralPath $symbolPath -Raw | ConvertFrom-Json
  $sequence = [int]$record.teachingSequence
  if (-not $captionLedger.ContainsKey($sequence)) {
    throw "No final learner-facing caption found for sequence $sequence ($($record.id))."
  }
  Set-OriginAnchor -Path $symbolPath -Caption $captionLedger[$sequence]
}

# Promote the exact user-approved production exports into the canonical release
# source. Missing production exports remain untouched because they may belong to
# an earlier approval package with separate provenance.
$releaseRoot = Resolve-RepoPath $ReleaseSymbolsPath
foreach ($artwork in Get-ChildItem -LiteralPath (Resolve-RepoPath $ArtworkApprovalPath) -File -Filter "*.png") {
  if ($artwork.Name -notmatch '^(\d{3})_(.+)\.png$') { continue }
  $sequence = [int]$Matches[1]
  $id = $Matches[2]
  $destination = Join-Path $releaseRoot "$id/educational/original/origin-locked-style-v2.png"
  if (-not (Test-Path -LiteralPath (Split-Path -Parent $destination))) { continue }
  Backup-File "$ReleaseSymbolsPath/$id/educational/original/origin-locked-style-v2.png" $backupRoot "$id/educational/original/origin-locked-style-v2.png" | Out-Null
  Copy-Item -LiteralPath $artwork.FullName -Destination $destination -Force
}

# These candidates were approved in the conversation but had not yet been
# copied into the production approval export directory.
$latestApprovedCandidates = @{
  116 = "artwork_production/native/round_02/originals/116_year.png"
  117 = "artwork_production/native/round_01/originals/117_summer.png"
  118 = "artwork_production/native/round_01/originals/118_winter.png"
  119 = "artwork_production/native/round_01/originals/119_look-toward.png"
  120 = "artwork_production/native/round_02/originals/120_sweet.png"
  121 = "artwork_production/native/round_01/originals/121_fragrance.png"
  122 = "artwork_production/native/round_01/originals/122_increase.png"
  123 = "artwork_production/native/round_01/originals/123_sacrifice.png"
  124 = "artwork_production/native/round_01/originals/124_ancestor.png"
  125 = "artwork_production/native/round_01/originals/125_lodging.png"
  126 = "artwork_production/native/round_01/originals/126_blessing.png"
}
$idBySequence = @{}
foreach ($symbolFolder in Get-ChildItem -LiteralPath $releaseRoot -Directory) {
  $record = Get-Content -LiteralPath (Join-Path $symbolFolder.FullName "symbol.json") -Raw | ConvertFrom-Json
  $idBySequence[[int]$record.teachingSequence] = $record.id
}
foreach ($entry in $latestApprovedCandidates.GetEnumerator()) {
  $source = Resolve-RepoPath $entry.Value
  if (-not (Test-Path -LiteralPath $source)) { throw "Approved artwork candidate not found: $($entry.Value)" }
  $id = $idBySequence[[int]$entry.Key]
  $destination = Join-Path $releaseRoot "$id/educational/original/origin-locked-style-v2.png"
  Backup-File "$ReleaseSymbolsPath/$id/educational/original/origin-locked-style-v2.png" $backupRoot "$id/educational/original/origin-locked-style-v2.png" | Out-Null
  Copy-Item -LiteralPath $source -Destination $destination -Force
}

# Two older records retain runtime origin artwork but lacked a matching source
# export. Rehydrate only those exact existing local assets so the canonical
# importer can run without inventing a historical or educational visual.
$speechSource = Resolve-RepoPath "Resources/Assets/Symbols/speech/educational/origin.png"
$speechDestination = Join-Path $releaseRoot "speech/educational/original/origin-locked-style-v2.png"
if (-not (Test-Path -LiteralPath $speechDestination) -and (Test-Path -LiteralPath $speechSource)) {
  New-Item -ItemType Directory -Path (Split-Path -Parent $speechDestination) -Force | Out-Null
  Copy-Item -LiteralPath $speechSource -Destination $speechDestination -Force
}

$importScript = Resolve-RepoPath $RuntimeImportScript
& $importScript `
  -ManifestPath "content/research/zdic-v1-complete-manifest.json" `
  -SymbolsPath $ReleaseSymbolsPath `
  -CorpusDestination "Resources/Corpus" `
  -AssetDestination "Resources/Assets/Symbols"

Write-Output "OK: imported approved captions and artwork into the canonical release source and runtime corpus."
Write-Output "Approved caption overrides: $($approvedCaptionOverrides.Count)"
Write-Output "Latest artwork candidates promoted: $($latestApprovedCandidates.Count)"
Write-Output "Canonical backup: content/archive/symbols/approved-caption-artwork-import-2026-09-16"
