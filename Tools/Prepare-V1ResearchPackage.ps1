param(
  [string]$AssessmentPath = "docs/content/shared-cjk-v1-visual-story-oracle-assessment.md",
  [string]$OutputPath = "content/research/v1-symbols",
  [string]$EvoMetadataPath = "",
  [string]$EtymologyDataPath = "",
  [string]$EtymologyRepoPath = "",
  [string]$OpenCCPath = ""
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$assessmentFile = Join-Path $repoRoot $AssessmentPath
$outputRoot = Join-Path $repoRoot $OutputPath

if ([string]::IsNullOrWhiteSpace($EvoMetadataPath)) {
  $EvoMetadataPath = Join-Path $env:TEMP "script-roots-evobc/List_of_EVOBC.json"
}
if ([string]::IsNullOrWhiteSpace($EtymologyDataPath)) {
  $EtymologyDataPath = Join-Path $env:TEMP "script-roots-ethymology/hanzi-data.json.gz"
}
if ([string]::IsNullOrWhiteSpace($EtymologyRepoPath)) {
  $EtymologyRepoPath = Join-Path $env:TEMP "script-roots-ethymology/repo/hanzi-etymology-dict-main"
}
if ([string]::IsNullOrWhiteSpace($OpenCCPath)) {
  $OpenCCPath = Join-Path $env:TEMP "script-roots-ethymology/STCharacters.txt"
}

foreach ($requiredPath in @($assessmentFile, $EvoMetadataPath, $EtymologyDataPath, $EtymologyRepoPath, $OpenCCPath)) {
  if (-not (Test-Path -LiteralPath $requiredPath)) {
    throw "Required research input was not found: $requiredPath"
  }
}

function Write-Utf8File {
  param(
    [Parameter(Mandatory = $true)] [string]$Path,
    [Parameter(Mandatory = $true)] [string]$Text
  )

  # Keep research text stable and easy to diff across repeated source refreshes.
  $Text | Set-Content -LiteralPath $Path -Encoding utf8
}

function Read-GzipJson {
  param([Parameter(Mandatory = $true)] [string]$Path)

  # Decode the public site export without adding a project dependency for the research pass.
  $fileStream = [System.IO.File]::OpenRead($Path)
  try {
    $gzipStream = [System.IO.Compression.GzipStream]::new($fileStream, [System.IO.Compression.CompressionMode]::Decompress)
    try {
      $reader = [System.IO.StreamReader]::new($gzipStream, [System.Text.Encoding]::UTF8)
      try { return ($reader.ReadToEnd() | ConvertFrom-Json) } finally { $reader.Dispose() }
    } finally { $gzipStream.Dispose() }
  } finally { $fileStream.Dispose() }
}

function Get-UnicodeCodePoint {
  param([Parameter(Mandatory = $true)] [string]$Character)

  return "U+{0:X4}" -f [System.Char]::ConvertToUtf32($Character, 0)
}

function Get-StageName {
  param([Parameter(Mandatory = $true)] [int]$Era)

  switch ($Era) {
    0 { return "oracle" }
    1 { return "bronze" }
    2 { return "seal" }
    3 { return "spring-autumn" }
    4 { return "warring-states" }
    5 { return "clerical" }
    default { return "unknown" }
  }
}

function Get-PrimaryCollectionMap {
  param([Parameter(Mandatory = $true)] [string]$Text)

  $map = @{}
  foreach ($line in ($Text -split "`r?`n")) {
    if ($line -match '^\d+\. \*\*([^*]+) \(\d+\):\*\* `([^`]+)`') {
      foreach ($character in ($Matches[2] -split '\s+')) { $map[$character] = $Matches[1] }
    }
  }
  return $map
}

function Get-OpenCCVariantMap {
  param([Parameter(Mandatory = $true)] [string]$Path)

  $map = @{}
  foreach ($line in (Get-Content -LiteralPath $Path)) {
    if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith("#")) { continue }
    $parts = $line -split "\s+"
    if ($parts.Count -ge 2) { $map[$parts[0]] = $parts[1] }
  }
  return $map
}

function Copy-DongGlyphs {
  param(
    [Parameter(Mandatory = $true)] [string]$Character,
    [Parameter(Mandatory = $true)] [string[]]$Forms,
    [Parameter(Mandatory = $true)] [string]$DongRoot,
    [Parameter(Mandatory = $true)] [string]$SymbolRoot
  )

  $localAssets = [System.Collections.Generic.List[string]]::new()
  foreach ($form in $Forms) {
    $formRoot = Join-Path $DongRoot $form
    if (-not (Test-Path -LiteralPath $formRoot)) { continue }
    foreach ($file in (Get-ChildItem -LiteralPath $formRoot -Filter "*.svg" -File)) {
      if ($file.Name -notmatch '_(oracle|bronze|seal)\.svg$') { continue }
      $stage = $Matches[1]
      $stageRoot = Join-Path $SymbolRoot "historical/$stage/original"
      New-Item -ItemType Directory -Path $stageRoot -Force | Out-Null
      $target = Join-Path $stageRoot ("dong-" + $file.Name)
      Copy-Item -LiteralPath $file.FullName -Destination $target -Force
      $localAssets.Add($target.Substring($repoRoot.Length + 1).Replace("\", "/")) | Out-Null
    }
  }
  return @($localAssets.ToArray())
}

$assessmentText = Get-Content -Raw -LiteralPath $assessmentFile
$rows = [System.Collections.Generic.List[object]]::new()
foreach ($block in [regex]::Matches($assessmentText, '```text\r?\n([\s\S]*?)```')) {
  foreach ($match in [regex]::Matches($block.Groups[1].Value, '(\d+)\s+(\S)')) {
    $rows.Add([ordered]@{ rank = [int]$match.Groups[1].Value; character = $match.Groups[2].Value }) | Out-Null
  }
}

$collectionMap = Get-PrimaryCollectionMap -Text $assessmentText
$pilotCharacters = @("火", "水", "山", "木", "日", "月", "人", "大", "小", "口", "目")
$newRows = @($rows | Where-Object { $pilotCharacters -notcontains $_.character })
$evoRecords = @(Get-Content -Raw -LiteralPath $EvoMetadataPath | ConvertFrom-Json)
$etymologyRecords = @(Read-GzipJson -Path $EtymologyDataPath)
$variantMap = Get-OpenCCVariantMap -Path $OpenCCPath
$dongRoot = Join-Path $EtymologyRepoPath "docs/glyphs/dong_chinese"
$wikimediaRoot = Join-Path $EtymologyRepoPath "docs/glyphs/wikimedia_seal"

New-Item -ItemType Directory -Path $outputRoot -Force | Out-Null
$indexRows = [System.Collections.Generic.List[object]]::new()

foreach ($row in $newRows) {
  $character = $row.character
  $record = $etymologyRecords | Where-Object { $_.c -eq $character } | Select-Object -First 1
  $evo = $evoRecords | Where-Object { $_.Character -eq $character } | Select-Object -First 1
  if ($null -eq $record) { throw "No etymology record for $character" }
  if ($null -eq $evo) { throw "No EVOBC metadata record for $character" }

  $codePoint = Get-UnicodeCodePoint -Character $character
  $folderName = "rank-{0:D3}-{1}-{2}" -f $row.rank, $character, ($codePoint.Replace("U+", "u"))
  $symbolRoot = Join-Path $outputRoot $folderName
  New-Item -ItemType Directory -Path (Join-Path $symbolRoot "educational") -Force | Out-Null
  New-Item -ItemType Directory -Path (Join-Path $symbolRoot "historical") -Force | Out-Null

  $traditionalVariant = if ($variantMap.ContainsKey($character)) { $variantMap[$character] } else { $null }
  $forms = [System.Collections.Generic.List[string]]::new()
  $forms.Add($character) | Out-Null
  if ($traditionalVariant -and $traditionalVariant -ne $character) { $forms.Add($traditionalVariant) | Out-Null }
  $localAssets = @(Copy-DongGlyphs -Character $character -Forms $forms.ToArray() -DongRoot $dongRoot -SymbolRoot $symbolRoot)

  $stageSummary = [ordered]@{}
  foreach ($image in @($evo.images)) {
    $stage = Get-StageName -Era ([int]$image.era)
    if (-not $stageSummary.Contains($stage)) { $stageSummary[$stage] = [System.Collections.Generic.List[string]]::new() }
    $stageSummary[$stage].Add($image.file) | Out-Null
  }

  $history = [ordered]@{
    character = $character
    unicode = $codePoint
    rank = $row.rank
    primaryCollection = $collectionMap[$character]
    traditionalVariant = $traditionalVariant
    formationType = $record.ft
    formationTypeConflicts = $record.ftc
    ideographicDescription = $record.ids
    confidence = $record.conf
    verificationStatus = $record.vs
    etymologyNotes = @($record.en)
    shuowen = $record.sw
    shuowenExplanation = $record.swe
    readings = [ordered]@{ mandarin = $record.py; japanese = $record.jk; korean = $record.ko; cantonese = $record.ca }
    frequencyRank = $record.fr
    hsk = $record.hsk
    evo = [ordered]@{
      dataset = "EVOBC"
      metadataSource = "https://huggingface.co/datasets/HaisuGuan/EVOBC"
      license = "CC BY-NC-SA 4.0"
      sourceRecordID = $evo.ID
      stageFiles = $stageSummary
      note = "This is complete stage/file metadata from the public index. Raw EVOBC archive images are not copied into the project because the public archive is multi-gigabyte; open per-character SVGs copied below are separately identified."
    }
    localHistoricalAssets = $localAssets
  }
  $historyJson = $history | ConvertTo-Json -Depth 50
  Write-Utf8File -Path (Join-Path $symbolRoot "historical-references.json") -Text $historyJson

  $sourceRows = @(
    [ordered]@{ id = "evobc"; label = "EVOBC historical stage metadata and image index"; url = "https://huggingface.co/datasets/HaisuGuan/EVOBC"; license = "CC BY-NC-SA 4.0"; role = "Oracle Bone/Bronze/Seal/Spring-Autumn/Warring-States/Clerical stage inventory" },
    [ordered]@{ id = "hanzi-etymology"; label = "Hanzi/Kanji Etymology Dictionary"; url = "https://github.com/lbm364dl/hanzi-etymology-dict"; license = "Mixed upstream licenses; review per field"; role = "Formation, IDS, etymology notes, readings, confidence, and historical-glyph metadata" },
    [ordered]@{ id = "dong-chinese"; label = "Dong Chinese historical glyphs"; url = ("https://www.dong-chinese.com/wiki/" + [uri]::EscapeDataString($character)); license = "CC BY-SA 4.0"; role = "Locally copied open Oracle/Bronze/Seal SVGs where available" },
    [ordered]@{ id = "academia-sinica"; label = "Academia Sinica Xiaoxuetang"; url = "https://xiaoxue.iis.sinica.edu.tw/guide/"; license = "Source consultation required"; role = "Independent historical evolution confirmation target" }
  )
  $sourceJson = $sourceRows | ConvertTo-Json -Depth 20
  Write-Utf8File -Path (Join-Path $symbolRoot "sources.json") -Text $sourceJson

  $noteTexts = @($record.en | ForEach-Object { if ($_.t) { $_.t } })
  $premise = if ($noteTexts.Count -gt 0) { $noteTexts -join " / " } else { "No compact etymology note was available in the downloaded aggregation; review the linked source pages." }
  $stageLines = @($stageSummary.GetEnumerator() | ForEach-Object { "- **$($_.Key)**: $($_.Value.Count) indexed reference(s); representative files are listed in historical-references.json." })
  $researchMarkdown = @(
    "# Research: $character ($codePoint)"
    ""
    "Status: research-only V1 preparation; not approved runtime content."
    ""
    "- Teaching rank: $($row.rank)"
    "- Primary collection: $($collectionMap[$character])"
    "- Formation screen: $($record.ft)"
    "- IDS / structure: $($record.ids)"
    "- Aggregated confidence: $($record.conf)"
    "- Verification status: $($record.vs)"
    "- Japanese reading field: $($record.jk)"
    "- Korean Hanja reading field: $($record.ko)"
    ""
    "## Current visual-story evidence"
    ""
    $premise
    ""
    "This wording is source aggregation, not final editorial copy. Preserve disagreement when specialist sources differ, and do not describe a component as meaningful if the source identifies it as phonetic only."
    ""
    "## EVOBC historical inventory"
    ""
    ($stageLines -join "`n")
    ""
    "EVOBC metadata is an indexed research inventory. It does not by itself establish exact glyph identity, interpretation, rights, or a final bundled image."
    ""
    "## Next review"
    ""
    "Confirm the earliest usable form against Xiaoxuetang and a specialist source, select the exact historical references for the journey, verify Chinese/Japanese/Korean identity and usage, then review the educational illustration brief in educational/prompt.md."
  ) -join "`n"
  Write-Utf8File -Path (Join-Path $symbolRoot "research.md") -Text $researchMarkdown.Trim()

  $promptMarkdown = @(
    "# Educational origin illustration brief: $character"
    ""
    "Use case: scientific-educational"
    "Asset type: educational origin reconstruction for the Script Roots Symbol Journey"
    ""
    "## Primary request"
    ""
    "Illustrate the concrete object, action, body form, or meaningful scene behind the earliest defensible story for $character. The composition must be understandable as a real-world referent first, then visually echo the silhouette, arrangement, or meaningful parts documented in the historical evidence. The learner should be able to compare this illustration with the separately displayed earliest glyph and understand the proposed transition without the illustration pretending to be the glyph."
    ""
    "## Source cues"
    ""
    ($noteTexts -join " / ")
    ""
    "## Composition constraints"
    ""
    "- Keep the meaningful object or relationship visually dominant and uncluttered."
    "- If the formation is multi-component, show each meaning-bearing component in a single coherent scene."
    "- Do not invent a component meaning when the source marks it as phonetic."
    "- Do not draw Oracle Bone, Bronze, Seal, Clerical, or Regular glyphs inside the illustration. Those remain separate historical evidence assets."
    "- Use the approved warm paper, ink, muted mineral, and restrained editorial museum direction used by the existing 11-symbol concept art."
    "- No modern text, labels, watermark, decorative border, or square icon treatment."
  ) -join "`n"
  Write-Utf8File -Path (Join-Path $symbolRoot "educational/prompt.md") -Text $promptMarkdown.Trim()

  $visualNotes = @(
    "The educational image must show the concrete meaning or meaning-bearing scene before the modern character is introduced.",
    "The first historical form should remain visible as a separate source-backed asset for manual comparison.",
    "Prefer a readable silhouette and one clear relationship over decorative realism.",
    "This is a concept reconstruction, never a historical glyph substitute."
  )
  $visualNotesJson = $visualNotes | ConvertTo-Json
  Write-Utf8File -Path (Join-Path $symbolRoot "educational/visual-notes.json") -Text $visualNotesJson

  $metadata = [ordered]@{
    assetKind = "illustrated-concept"
    status = "needsReview"
    character = $character
    unicode = $codePoint
    teachingRank = $row.rank
    primaryCollection = $collectionMap[$character]
    sourceDescription = "Internal educational reconstruction derived from source-backed research notes; not historical evidence."
    promptPath = "educational/prompt.md"
    visualNotesPath = "educational/visual-notes.json"
    historicalReferencesPath = "historical-references.json"
  }
  $metadataJson = $metadata | ConvertTo-Json -Depth 20
  Write-Utf8File -Path (Join-Path $symbolRoot "educational/metadata.json") -Text $metadataJson

  $indexRows.Add([ordered]@{
    rank = $row.rank
    character = $character
    unicode = $codePoint
    folder = (Join-Path $OutputPath $folderName).Replace("\", "/")
    collection = $collectionMap[$character]
    formation = $record.ft
    evoStages = @($stageSummary.Keys)
    copiedHistoricalSVGs = $localAssets.Count
  }) | Out-Null
}

$indexRows = @($indexRows | Sort-Object @{ Expression = { [int]$_.rank }; Ascending = $true })
$indexJson = $indexRows | ConvertTo-Json -Depth 30
Write-Utf8File -Path (Join-Path $outputRoot "index.json") -Text $indexJson

$indexMarkdown = @(
  "# V1 Research Package"
  ""
  "This folder contains research-only preparation for the 137 new symbols after the original 11-symbol pilot. It is not runtime corpus content. Each folder can be reviewed independently before specialist approval and illustration generation."
  ""
  '- Historical stage/file metadata: `historical-references.json`'
  '- Source and rights pointers: `sources.json`'
  '- Research synthesis: `research.md`'
  '- Educational origin brief: `educational/prompt.md`'
  '- Copied open historical SVGs, when available: `historical/`'
  ""
  "The EVOBC file inventory is complete for each character, but the public raw archive is multi-gigabyte. This package does not silently pretend that indexed file names are bundled assets; local SVG copies are listed explicitly per folder."
  ""
  "| Rank | Character | Collection | Formation | Copied historical SVGs |"
  "|---:|---|---|---|---:|"
  ($indexRows | ForEach-Object { "| $($_.rank) | $($_.character) | $($_.collection) | $($_.formation) | $($_.copiedHistoricalSVGs) |" })
) -join "`n"
Write-Utf8File -Path (Join-Path $outputRoot "README.md") -Text $indexMarkdown

Write-Output "OK: prepared research folders for $($indexRows.Count) new V1 symbols under $OutputPath"
