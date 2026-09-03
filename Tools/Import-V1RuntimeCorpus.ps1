param(
  [string]$ManifestPath = "content/research/zdic-v1-complete-manifest.json",
  [string]$GenerationInputPath = "C:\Users\Stein\AppData\Local\Temp\asianlanguage-origin-generation\origin-generation-inputs.json",
  [string]$LegacyCorpusPath = "content/shared-characters",
  [string]$CorpusDestination = "Resources/Corpus",
  [string]$AssetDestination = "Resources/Assets/Symbols",
  [string]$TransitionNotesPath = "content/research/v1-symbols/transition-notes-v1.json"
)

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

function Resolve-RepoPath([string]$Path) {
  if ([IO.Path]::IsPathRooted($Path)) { return $Path }
  return Join-Path $repoRoot $Path
}

function Read-Json([string]$Path) {
  return Get-Content -LiteralPath (Resolve-RepoPath $Path) -Raw | ConvertFrom-Json
}

function New-Reading([string]$System, [string]$Value) {
  return [ordered]@{ system = $System; value = $Value; audioAssetRef = $null }
}

function New-Example([string]$Text, [string]$Reading, [string]$Translation, [bool]$ShowsCoreMeaning, [string]$Level, [string]$Character) {
  return [ordered]@{
    text = $Text
    reading = $Reading
    translation = $Translation
    showsCoreMeaning = $ShowsCoreMeaning
    exampleLevel = $Level
    parallelExampleGroupID = $null
    reusesKnownSymbols = @()
    introducedSymbols = @($Character)
  }
}

function Get-Meaning([string]$Character, $Research) {
  $known = @{
    "人"="person"; "女"="woman"; "子"="child"; "大"="big"; "小"="small"; "口"="mouth"; "目"="eye"; "耳"="ear"; "身"="body"; "首"="head"; "舌"="tongue"; "心"="heart"; "言"="speech"; "自"="self"; "水"="water"; "山"="mountain"; "木"="tree"; "土"="earth"; "石"="stone"; "川"="river"; "日"="sun / day"; "月"="moon"; "天"="sky"; "雨"="rain"; "田"="field"; "井"="well"; "泉"="spring"; "牛"="ox"; "犬"="dog"; "羊"="sheep"; "虎"="tiger"; "角"="horn"; "竹"="bamboo"; "豆"="bean"; "衣"="clothing"; "玉"="jade"; "王"="king"; "刀"="knife"; "弓"="bow"; "册"="book"; "示"="altar"; "工"="work"; "力"="strength"; "夕"="evening"; "申"="stretch"; "云"="cloud"; "西"="west"; "南"="south"; "北"="north"; "年"="year"; "老"="old"; "白"="white"; "黑"="black"; "赤"="red"; "长"="long"; "高"="high"; "多"="many"; "少"="few"; "正"="upright"; "上"="above"; "下"="below"; "中"="middle"; "一"="one"; "十"="ten"; "二"="two"; "三"="three"; "出"="exit"; "入"="enter"; "行"="go"; "走"="walk"; "立"="stand"; "止"="stop"; "生"="life"; "央"="center"; "林"="forest"; "光"="light"; "明"="bright"; "休"="rest"; "好"="good"; "男"="man"; "母"="mother"; "兄"="older brother"; "友"="friend"; "公"="public"; "民"="people"; "兵"="soldier"; "典"="classic"; "令"="command"; "先"="before"; "及"="reach"; "从"="follow"; "取"="take"; "采"="gather"; "反"="turn back"; "交"="交 / meet"; "同"="same"; "合"="join"; "各"="each"; "告"="tell"; "向"="direction"; "望"="look toward"; "步"="step"; "分"="divide"; "利"="benefit"; "後"="after"; "集"="gather"; "得"="obtain"; "益"="increase"; "甘"="sweet"; "祭"="sacrifice"; "武"="martial"; "族"="group"; "旅"="journey"; "夏"="summer"; "冬"="winter"; "美"="beautiful"; "宗"="ancestor"; "守"="guard"; "官"="official"; "宿"="lodging"; "妻"="wife"; "祝"="blessing"; "香"="fragrance"; "古"="old"; "吉"="auspicious"; "品"="things / goods"
  }
  if ($known.ContainsKey($Character)) { return $known[$Character] }

  $note = @($Research.etymologyNotes) | ForEach-Object { $_.t } | Where-Object { $_ } | Select-Object -First 1
  if (-not $note) { return "shared character" }
  $match = [regex]::Match($note, '(?i)(?:pictogram|pictograph) of ([^\.]+)')
  if ($match.Success) { return $match.Groups[1].Value.Trim() }
  $match = [regex]::Match($note, '^A[n]? ([^\.]+)')
  if ($match.Success) { return $match.Groups[1].Value.Trim() }
  return (($note -replace '\s+', ' ').Trim().TrimEnd('.') | Select-Object -First 1)
}

function Get-ReadingValue($Value) {
  if ($null -eq $Value) { return $null }
  $text = [string]$Value
  if ([string]::IsNullOrWhiteSpace($text)) { return $null }
  return $text.Trim()
}

function Normalize-FormationType([string]$Value) {
  # Research sources use several classification vocabularies; runtime JSON must
  # emit only the raw values accepted by SymbolFormationType in Swift.
  switch (($Value ?? "").Trim().ToLowerInvariant()) {
    "pictograph" { return "pictograph" }
    "pictographic" { return "pictograph" }
    "indicative" { return "simpleIdeograph" }
    "ideographic" { return "simpleIdeograph" }
    "simpleideograph" { return "simpleIdeograph" }
    "simple-ideograph" { return "simpleIdeograph" }
    "compoundideograph" { return "compoundIdeograph" }
    "compound-ideograph" { return "compoundIdeograph" }
    "compound" { return "compoundIdeograph" }
    "phono-semantic" { return "phonoSemantic" }
    "phonosemantic" { return "phonoSemantic" }
    "phonetic-loan" { return "phoneticLoan" }
    "phoneticloan" { return "phoneticLoan" }
    "phonetic" { return "phoneticLoan" }
    "later-formation" { return "laterFormation" }
    "laterformation" { return "laterFormation" }
    "uncertain" { return "uncertain" }
    default { return "uncertain" }
  }
}

function Get-SourceRows($ResearchSources, [string]$Character) {
  $rows = [System.Collections.Generic.List[object]]::new()
  foreach ($source in @($ResearchSources)) {
    if (-not $source.id -or -not $source.url) { continue }
    $rows.Add([ordered]@{
      id = [string]$source.id
      label = [string]$source.label
      type = "research"
      citation = "$($source.role). License/rights note: $($source.license)."
      url = [string]$source.url
    }) | Out-Null
  }
  $rows.Add([ordered]@{ id = "source-zdic-$Character"; label = "漢典 / ZDIC selected historical glyphs"; type = "historical-asset"; citation = "Selected first-clear glyph variant for Oracle Bone, Bronze, Small Seal, and Clerical stages; reuse permission remains to be confirmed before commercial distribution."; url = "https://zdic.net/hans/$([uri]::EscapeDataString($Character))" }) | Out-Null
  $rows.Add([ordered]@{ id = "source-kai-font"; label = "CNS11643 Full Character Set — 正楷體"; type = "font"; citation = "Modern standardized Kai reference rendering for the Regular Script endpoint; not an archaeological facsimile."; url = "https://www.cns11643.gov.tw" }) | Out-Null
  $rows.Add([ordered]@{ id = "source-source-han-serif"; label = "Adobe Source Han Serif"; type = "font"; citation = "Localized modern CJK font family used for the four Used Today focus tracks; SIL Open Font License 1.1."; url = "https://github.com/adobe-fonts/source-han-serif" }) | Out-Null
  $rows.Add([ordered]@{ id = "source-generated-origin-$Character"; label = "Script Roots origin illustration"; type = "educational-asset"; citation = "Internal educational reconstruction generated in the approved Soft Ink & Wash museum style; not historical evidence."; url = "https://openai.com/index/image-generation-api/" }) | Out-Null
  return @($rows.ToArray())
}

function New-HistoricalMetadata($Stage, [string]$AssetRef, [string]$OriginalRef, [string]$Character, [string]$RuntimeStage) {
  return [ordered]@{
    characterID = $Character
    historicalStage = $RuntimeStage
    approximatePeriod = $null
    sourceInstitution = "漢典 / ZDIC"
    sourcePageURL = [string]$Stage.sourcePageURL
    sourceAssetURL = [string]$Stage.sourceAssetURL
    catalogueReference = "ZDIC selected variant $($Stage.selectedVariant)"
    sourceDescription = "Selected and normalized ZDIC historical glyph; the historical glyph itself is preserved."
    retrievedAt = "2026-09-03"
    contentClass = "historicalEvidence"
    assetRef = $AssetRef
    artifactAssetRef = $OriginalRef
    assetKind = "historical-glyph"
    provenance = "ZDIC first-clear-variant selection workflow; local normalized canvas"
    licenseStatus = "zdic-reuse-review-required"
    accessibilityDescription = "$Character in $($Stage.label)"
    readiness = "needsReview"
  }
}

function New-StageExplanation([string]$Key, [string]$Meaning) {
  switch ($Key) {
    "oracleBone" { return "The earliest selected form remains a visual starting point for the idea of $Meaning." }
    "bronze" { return "The selected Bronze form keeps the character's main structure while reshaping its lines." }
    "smallSeal" { return "The selected Small Seal form organizes the earlier shape into a more balanced outline." }
    "clerical" { return "The selected Clerical form brings the structure closer to the proportions familiar today." }
    default { return "The modern standardized Kai form provides a consistent endpoint for comparison." }
  }
}

function New-KaiMetadata([string]$Character, [string]$AssetRef) {
  return [ordered]@{
    characterID = $Character
    historicalStage = "regular"
    approximatePeriod = "modern reference endpoint"
    sourceInstitution = "CNS11643"
    sourcePageURL = "https://www.cns11643.gov.tw"
    sourceAssetURL = $null
    catalogueReference = "TW-Kai-98_1.ttf"
    sourceDescription = "Modern standardized Kai reference rendering used as the consistent Regular Script endpoint."
    retrievedAt = "2026-09-03"
    contentClass = "historicalEvidence"
    assetRef = $AssetRef
    artifactAssetRef = $null
    assetKind = "font-glyph-rendering"
    provenance = "Bundled CNS11643 正楷體 font renderer"
    licenseStatus = "see bundled CNS11643 notice"
    accessibilityDescription = "$Character in modern standardized Kai reference rendering"
    readiness = "needsReview"
  }
}

$manifest = Read-Json $ManifestPath
$generationInputs = @(Read-Json $GenerationInputPath)
$transitionNotes = @{}
$transitionNotesFile = Resolve-RepoPath $TransitionNotesPath
if (Test-Path -LiteralPath $transitionNotesFile) {
  $transitionSource = Get-Content -LiteralPath $transitionNotesFile -Raw | ConvertFrom-Json
  foreach ($entry in @($transitionSource.records)) {
    $transitionNotes["$($entry.character)|$($entry.stage)"] = $entry
  }
}
$legacyByCharacter = @{}
foreach ($file in Get-ChildItem -LiteralPath (Resolve-RepoPath $LegacyCorpusPath) -Filter "*.json" -File) {
  $legacy = Get-Content -LiteralPath $file.FullName -Raw | ConvertFrom-Json
  $legacyByCharacter[$legacy.coreCharacter] = $legacy
}

$outputCorpus = Resolve-RepoPath $CorpusDestination
$outputAssets = Resolve-RepoPath $AssetDestination
New-Item -ItemType Directory -Path $outputCorpus -Force | Out-Null
New-Item -ItemType Directory -Path $outputAssets -Force | Out-Null

$oldIDByCharacter = @{
  "水"="water"; "山"="mountain"; "木"="tree"; "日"="day"; "月"="moon"; "人"="person"; "大"="big"; "小"="small"; "口"="mouth"; "目"="eye"
}
$records = [System.Collections.Generic.List[object]]::new()

foreach ($manifestRecord in @($manifest.records | Sort-Object rank)) {
  $character = [string]$manifestRecord.character
  $input = $generationInputs | Where-Object character -eq $character | Select-Object -First 1
  if ($null -eq $input) { throw "No origin illustration input for $character" }
  $folder = [string]$input.folder
  $researchPath = Join-Path $folder "historical-references.json"
  $research = if (Test-Path -LiteralPath $researchPath) { Get-Content -LiteralPath $researchPath -Raw | ConvertFrom-Json } else { $null }
  $indexRow = $null
  $indexPath = Join-Path (Resolve-RepoPath "content/research/v1-symbols") "index.json"
  if (Test-Path -LiteralPath $indexPath) {
    $indexRows = Get-Content -LiteralPath $indexPath -Raw | ConvertFrom-Json
    $indexRow = @($indexRows | Where-Object character -eq $character | Sort-Object rank | Select-Object -First 1)
  }
  $legacy = $legacyByCharacter[$character]
  $id = if ($oldIDByCharacter.ContainsKey($character)) { $oldIDByCharacter[$character] } else { "symbol-$($manifestRecord.unicode.Replace('U+', 'u'))" }
  $meaning = if ($legacy) { $legacy.coreSharedMeaning } elseif ($research) { Get-Meaning $character $research } else { "shared character" }
  $traditional = if ($research -and $research.traditionalVariant) { [string]$research.traditionalVariant } elseif ($legacy -and $legacy.traditionalForm) { [string]$legacy.traditionalForm } else { $character }
  $mandarin = if ($research) { Get-ReadingValue $research.readings.mandarin } elseif ($legacy) { $legacy.focusCoverage.simplifiedChinese.readings[0].value } else { $null }
  $japanese = if ($research) { Get-ReadingValue $research.readings.japanese } elseif ($legacy) { (@($legacy.focusCoverage.japanese.readings | ForEach-Object value) -join "; ") } else { $null }
  $korean = if ($research) { Get-ReadingValue $research.readings.korean } elseif ($legacy) { $legacy.focusCoverage.korean.readings[0].value } else { $null }
  $originPath = Join-Path $folder "educational/original/origin-locked-style-v2.png"
  $v3Path = Join-Path $folder "educational/original/origin-locked-style-v3.png"
  if (Test-Path -LiteralPath $v3Path) { $originPath = $v3Path }
  if (-not (Test-Path -LiteralPath $originPath)) { throw "Missing v2 origin illustration for $character" }

  $assetRoot = Join-Path $outputAssets $id
  New-Item -ItemType Directory -Path (Join-Path $assetRoot "educational") -Force | Out-Null
  New-Item -ItemType Directory -Path (Join-Path $assetRoot "historical") -Force | Out-Null
  Copy-Item -LiteralPath $originPath -Destination (Join-Path $assetRoot "educational/origin.png") -Force
  $originAssetRef = "Assets/Symbols/$id/educational/origin.png"

  $sourceRows = if ($research) { Get-SourceRows (Get-Content -LiteralPath (Join-Path $folder "sources.json") -Raw | ConvertFrom-Json) $character } else { Get-SourceRows @() $character }
  $stages = [System.Collections.Generic.List[object]]::new()
  foreach ($selectedStage in @($manifestRecord.stages)) {
    $stageFolder = Join-Path $folder "historical/zdic-selected/$($selectedStage.key)"
    $normalized = Join-Path $stageFolder "museum-canvas.svg"
    $original = Join-Path $stageFolder "original.svg"
    if (-not (Test-Path -LiteralPath $normalized)) { throw "Missing normalized ZDIC asset for $character/$($selectedStage.key)" }
    $targetFolder = Join-Path $assetRoot "historical/$($selectedStage.key)"
    New-Item -ItemType Directory -Path $targetFolder -Force | Out-Null
    Copy-Item -LiteralPath $normalized -Destination (Join-Path $targetFolder "glyph.svg") -Force
    Copy-Item -LiteralPath $original -Destination (Join-Path $targetFolder "source-original.svg") -Force
    $assetRef = "Assets/Symbols/$id/historical/$($selectedStage.key)/glyph.svg"
    $originalRef = "Assets/Symbols/$id/historical/$($selectedStage.key)/source-original.svg"
    $runtimeStageKey = if ($selectedStage.key -eq "smallSeal") { "seal" } else { [string]$selectedStage.key }
    $assetRef = "Assets/Symbols/$id/historical/$runtimeStageKey/glyph.svg"
    $originalRef = "Assets/Symbols/$id/historical/$runtimeStageKey/source-original.svg"
    $runtimeTargetFolder = Join-Path $assetRoot "historical/$runtimeStageKey"
    if ($runtimeTargetFolder -ne $targetFolder) {
      New-Item -ItemType Directory -Path $runtimeTargetFolder -Force | Out-Null
      Move-Item -LiteralPath (Join-Path $targetFolder "glyph.svg") -Destination (Join-Path $runtimeTargetFolder "glyph.svg") -Force
      Move-Item -LiteralPath (Join-Path $targetFolder "source-original.svg") -Destination (Join-Path $runtimeTargetFolder "source-original.svg") -Force
    }
    $transitionEntry = $transitionNotes["$character|$runtimeStageKey"]
    $transitionNote = if ($transitionEntry -and $transitionEntry.transitionNote) {
      [string]$transitionEntry.transitionNote
    } elseif ($stages.Count -eq 0) {
      "The illustrated idea is condensed into a small group of ancient strokes, turning the concept into a written form."
    } else {
      "The selected form preserves the central idea while changing its line arrangement."
    }
    $transitionNeedsReview = if ($transitionEntry) { [bool]$transitionEntry.transitionNoteNeedsReview } else { $true }
    $stages.Add([ordered]@{
      stage = $runtimeStageKey
      label = [string]$selectedStage.label
      form = $null
      assetRef = $assetRef
      changeNoteFromPrevious = $transitionNote
      certainty = "supported"
      sourceIds = @("source-zdic-$character")
      historicalSound = $null
      assetMetadata = (New-HistoricalMetadata $selectedStage $assetRef $originalRef $character $runtimeStageKey)
      introducedComponentIds = @()
      stageExplanation = New-StageExplanation $selectedStage.key $meaning
      transitionNote = $transitionNote
      transitionNoteNeedsReview = $transitionNeedsReview
      availabilityState = "available"
    }) | Out-Null
  }
  $regularTransitionEntry = $transitionNotes["$character|regular"]
  $regularTransitionNote = if ($regularTransitionEntry -and $regularTransitionEntry.transitionNote) {
    [string]$regularTransitionEntry.transitionNote
  } else {
    "The broad clerical form tightens into the balanced proportions and distinct strokes of the modern Kai reference."
  }
  $regularTransitionNeedsReview = if ($regularTransitionEntry) { [bool]$regularTransitionEntry.transitionNoteNeedsReview } else { $true }
  $stages.Add([ordered]@{
    stage = "regular"; label = "Regular Script"; form = $character; assetRef = $null
    changeNoteFromPrevious = $regularTransitionNote
    certainty = "high"; sourceIds = @("source-kai-font"); historicalSound = $null; assetMetadata = (New-KaiMetadata $character "Assets/Fonts/TW-Kai-98_1.ttf")
    introducedComponentIds = @(); stageExplanation = "A modern standardized Kai reference rendering provides the consistent endpoint for comparison."; transitionNote = $regularTransitionNote; transitionNoteNeedsReview = $regularTransitionNeedsReview; availabilityState = "available"
  }) | Out-Null

  $baseExamples = if ($legacy) { $legacy.focusCoverage.simplifiedChinese.examples } else { @() }
  $baseTraditionalTaiwan = if ($legacy) { $legacy.focusCoverage.traditionalChinese.taiwanExamples } else { @() }
  $baseTraditionalHongKong = if ($legacy) { $legacy.focusCoverage.traditionalChinese.hongKongExamples } else { @() }
  $baseJapaneseExamples = if ($legacy) { $legacy.focusCoverage.japanese.examples } else { @() }
  $baseKoreanExamples = if ($legacy) { $legacy.focusCoverage.korean.examples } else { @() }
  $fallbackReading = $mandarin
  if (-not $fallbackReading) { $fallbackReading = $japanese }
  if (-not $fallbackReading) { $fallbackReading = $korean }
  $fallbackExamples = @(
    (New-Example $character $fallbackReading $meaning $true "word" $character),
    (New-Example "$character·" $fallbackReading "Core character reference" $true "phrase" $character),
    (New-Example "$character…" $fallbackReading "Usage example pending language-editor review" $false "sentence" $character)
  )
  $japaneseFallbackExamples = @(
    (New-Example $character $japanese $meaning $true "word" $character),
    (New-Example "$character·" $japanese "Core character reference" $true "phrase" $character),
    (New-Example "$character…" $japanese "Usage example pending language-editor review" $false "sentence" $character)
  )
  $koreanFallbackExamples = @(
    (New-Example $traditional $korean $meaning $true "word" $character),
    (New-Example "$traditional·" $korean "Core character reference" $true "phrase" $character),
    (New-Example "$traditional…" $korean "Usage example pending language-editor review" $false "sentence" $character)
  )
  $simplifiedExamples = if (@($baseExamples).Count -ge 2) { @($baseExamples) } else { $fallbackExamples }
  $taiwanExamples = if (@($baseTraditionalTaiwan).Count -ge 2) { @($baseTraditionalTaiwan) } else { $fallbackExamples }
  $hongKongExamples = if (@($baseTraditionalHongKong).Count -ge 2) { @($baseTraditionalHongKong) } else { $fallbackExamples }
  $japaneseExamples = if (@($baseJapaneseExamples).Count -ge 2) { @($baseJapaneseExamples) } else { $japaneseFallbackExamples }
  $koreanExamples = if (@($baseKoreanExamples).Count -ge 2) { @($baseKoreanExamples) } else { $koreanFallbackExamples }
  # Wrap the entire conditional in @() so PowerShell preserves one-item and
  # empty collections instead of serializing them as an object or null.
  $jpReadings = @(if ($legacy) { @($legacy.focusCoverage.japanese.readings) } elseif ($japanese) { New-Reading "on / kun" $japanese })
  $krReadings = @(if ($legacy) { @($legacy.focusCoverage.korean.readings) } elseif ($korean) { New-Reading "hanja" $korean })
  $cnReadings = @(if ($legacy) { @($legacy.focusCoverage.simplifiedChinese.readings) } elseif ($mandarin) { New-Reading "pinyin" $mandarin })
  $focus = [ordered]@{
    simplifiedChinese = [ordered]@{ form = $character; readings = $cnReadings; glosses = @($meaning); examples = $simplifiedExamples; variants = @() }
    traditionalChinese = [ordered]@{ form = $traditional; readings = $cnReadings; glosses = @($meaning); taiwanExamples = $taiwanExamples; hongKongExamples = $hongKongExamples; taiwanReadings = $cnReadings; hongKongReadings = $cnReadings; variants = @() }
    japanese = [ordered]@{ form = $traditional; readings = $jpReadings; glosses = @($meaning); examples = $japaneseExamples; variants = @() }
    korean = [ordered]@{ form = $traditional; readings = $krReadings; glosses = @($meaning); examples = $koreanExamples; variants = @() }
  }
  $origin = [ordered]@{ concept = $meaning; explanation = "A friendly educational reconstruction of $meaning comes first, followed by the separately sourced historical glyphs."; asset = [ordered]@{ characterID = $id; historicalStage = $null; approximatePeriod = $null; sourceInstitution = "Script Roots"; sourcePageURL = $null; sourceAssetURL = $null; catalogueReference = $null; sourceDescription = "Internal educational reconstruction; not historical evidence."; retrievedAt = "2026-09-03"; contentClass = "educationalReconstruction"; assetRef = $originAssetRef; artifactAssetRef = $null; assetKind = "illustrated-concept"; provenance = "OpenAI image generation; approved Soft Ink & Wash museum style"; licenseStatus = "internal-authored"; accessibilityDescription = "Illustration of $meaning"; readiness = "needsReview" }; sourceIds = @("source-generated-origin-$character") }
  $record = [ordered]@{
    id = $id; version = 1; coreCharacter = $character; coreSharedMeaning = $meaning; recognitionTakeaway = "$character connects the idea of $meaning to a complete visual journey from origin through historical forms and into modern language use."; publicationStatus = "draft"; unicodeCodePoint = [string]$manifestRecord.unicode; simplifiedForm = $character; traditionalForm = $traditional; additionalMeanings = @(); formationType = Normalize-FormationType $(if ($research -and $research.formationType) { [string]$research.formationType } else { "uncertain" }); visualTeachingNotes = @("Compare the friendly origin illustration with the selected Oracle Bone form.", "Historical glyphs are shown as source-backed evidence, not reconstructed artwork."); contentFolder = "content/research/v1-symbols/$([IO.Path]::GetFileName($folder))"; learnerCopyPath = $null; researchNotesPath = "content/research/v1-symbols/$([IO.Path]::GetFileName($folder))/research.md"; reviewPath = $null; sourceConflicts = @(); editorialStatus = "needsReview"; teachingSequence = [int]$manifestRecord.rank; focusCoverage = $focus; visuals = [ordered]@{ evolutionAssetRefs = $null; assetStatus = "local-source-backed-draft"; note = "Origin illustration and normalized ZDIC historical stages are bundled for this implementation pass. ZDIC reuse permission remains a release gate." }; history = [ordered]@{ originAnchor = "Begin with the real-world idea of $meaning, then compare the selected forms without treating the illustration as a historical glyph."; stages = @($stages.ToArray()); origin = $origin }; structure = [ordered]@{ summary = if ($research -and $research.ideographicDescription) { "The research record describes this structure as $($research.ideographicDescription)." } else { "$character is presented first as a complete shared character." }; components = @(); certainty = if ($research -and $research.confidence -ge 85) { "high" } else { "medium" }; caveat = "Formation and component explanations remain subject to editorial review."; sourceIds = @("source-zdic-$character") }; usage = [ordered]@{ coreMeaningFirst = "Start with '$meaning', then compare the modern forms and readings across the four focus tracks."; notes = @("Modern examples are installed as initial content and should receive language-editor review before publication.", "Japanese and Korean regional forms are rendered through their intentional locale font roles.") }; sources = $sourceRows; notes = @("V1 runtime import from the 126-character complete-evolution manifest.", "ZDIC historical visual reuse remains review-required before commercial release.", "Origin artwork is an educational reconstruction, not historical evidence.", "Examples are shown in the Today section; generated fallback examples require language-editor review.")
  }
  $record | ConvertTo-Json -Depth 60 | Set-Content -LiteralPath (Join-Path $outputCorpus "$id.json") -Encoding utf8
  $records.Add($record) | Out-Null
}

$records | Sort-Object teachingSequence | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Resolve-RepoPath "Resources/V1CorpusManifest.json") -Encoding utf8
Write-Output "OK: imported $($records.Count) complete-evolution V1 records and local museum assets."
