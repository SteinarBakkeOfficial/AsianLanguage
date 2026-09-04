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

function New-Reading([string]$System, [string]$Value, [string]$SpeechText = $null, [string]$SpeechLanguage = $null) {
  # Keep incomplete draft pronunciation metadata unavailable instead of exposing
  # a language intent with no native text for the platform speech renderer.
  $hasSpeechText = -not [string]::IsNullOrWhiteSpace($SpeechText)
  return [ordered]@{ system = $System; value = $Value; audioAssetRef = $null; speechText = if ($hasSpeechText) { $SpeechText } else { $null }; speechLanguage = if ($hasSpeechText) { $SpeechLanguage } else { $null } }
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

function New-StarterExamples([string]$Language, [string]$Form, [string]$Character) {
  # These starter sentences fill the initial review surface only. Replace
  # them with native-speaker vocabulary examples before publication.
  switch ($Language) {
    "simplifiedChinese" {
      return @(
        (New-Example -Text "这是$Form。" -Reading $null -Translation "This is the character $Form." -ShowsCoreMeaning $false -Level "sentence" -Character $Character),
        (New-Example -Text "我学习$Form。" -Reading $null -Translation "I am learning the character $Form." -ShowsCoreMeaning $false -Level "sentence" -Character $Character),
        (New-Example -Text "我会读$Form。" -Reading $null -Translation "I can read the character $Form." -ShowsCoreMeaning $false -Level "sentence" -Character $Character)
      )
    }
    "traditionalChinese" {
      return @(
        (New-Example -Text "這是「$Form」。" -Reading $null -Translation "This is the character 「$Form」." -ShowsCoreMeaning $false -Level "sentence" -Character $Character),
        (New-Example -Text "我學習「$Form」。" -Reading $null -Translation "I am learning the character 「$Form」." -ShowsCoreMeaning $false -Level "sentence" -Character $Character),
        (New-Example -Text "我會讀「$Form」。" -Reading $null -Translation "I can read the character 「$Form」." -ShowsCoreMeaning $false -Level "sentence" -Character $Character)
      )
    }
    "japanese" {
      return @(
        (New-Example -Text "これは「$Form」です。" -Reading $null -Translation "This is the kanji 「$Form」." -ShowsCoreMeaning $false -Level "sentence" -Character $Character),
        (New-Example -Text "「$Form」を学びます。" -Reading $null -Translation "I am learning 「$Form」." -ShowsCoreMeaning $false -Level "sentence" -Character $Character),
        (New-Example -Text "「$Form」を読みます。" -Reading $null -Translation "I read 「$Form」." -ShowsCoreMeaning $false -Level "sentence" -Character $Character)
      )
    }
    "korean" {
      return @(
        (New-Example -Text "이것은 ‘$Form’입니다." -Reading $null -Translation "This is the Hanja ‘$Form’." -ShowsCoreMeaning $false -Level "sentence" -Character $Character),
        (New-Example -Text "‘$Form’를 배웁니다." -Reading $null -Translation "I am learning ‘$Form’." -ShowsCoreMeaning $false -Level "sentence" -Character $Character),
        (New-Example -Text "‘$Form’를 읽습니다." -Reading $null -Translation "I read ‘$Form’." -ShowsCoreMeaning $false -Level "sentence" -Character $Character)
      )
    }
  }
  return @()
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

function Get-DraftSpeechText([string]$Value, [string]$Language, [string]$Form) {
  # Current V1 content is intentionally draft. This creates explicit speech
  # input for implementation while leaving later language/editorial review open.
  if ($Language -eq "mandarin" -or $Language -eq "cantonese") { return $Form }

  if ($Language -eq "japanese") {
    $kana = [regex]::Matches($Value, '[ぁ-ゖァ-ヺー]+')
    if ($kana.Count -gt 0) { return (($kana | ForEach-Object Value) -join " ") }
  }

  if ($Language -eq "korean") {
    $hangul = [regex]::Matches($Value, '[가-힣]+')
    if ($hangul.Count -gt 0) { return (($hangul | ForEach-Object Value) -join " ") }
  }

  # Do not send romanized draft labels to a Japanese or Korean voice. Keep the
  # reading visible in content, but leave playback unavailable until native
  # kana/Hangul speech text is supplied.
  return $null
}

function Normalize-DraftReading($Reading, [string]$Language, [string]$Form) {
  if ($null -eq $Reading) { return $null }
  $value = Get-ReadingValue $Reading.value
  if (-not $value) { return $null }

  $speechText = Get-ReadingValue $Reading.speechText
  if ($Language -eq "japanese" -or $Language -eq "korean") {
    # Existing source rows may contain mixed native-script and romanized labels;
    # retain only the native writing system for speech playback.
    $speechText = Get-DraftSpeechText $speechText $Language $Form
  }
  if (-not $speechText) { $speechText = Get-DraftSpeechText $value $Language $Form }
  $speechLanguage = Get-ReadingValue $Reading.speechLanguage
  if (-not $speechLanguage) { $speechLanguage = $Language }

  return (New-Reading -System ([string]$Reading.system) -Value $value -SpeechText $speechText -SpeechLanguage $speechLanguage)
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

function Get-MaterialProcessCaption([string]$Key) {
  switch ($Key) {
    "oracleBone" { return "Bone / shell · carved" }
    "bronze" { return "Bronze vessel · cast / inscribed" }
    "smallSeal" { return "Bamboo / manuscript · brush" }
    "seal" { return "Bamboo / manuscript · brush" }
    "clerical" { return "Paper · brush" }
    "regular" { return "Paper · brush" }
    default { return $null }
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

$idByCharacter = @{
  "一"="one"; "日"="day"; "月"="moon"; "夕"="evening"; "山"="mountain"; "水"="water"; "川"="river"; "木"="tree"; "竹"="bamboo"; "土"="earth"; "石"="stone"; "雨"="rain"; "云"="cloud"; "田"="field"; "井"="well"; "泉"="spring"; "生"="life"; "人"="person"; "大"="big"; "女"="woman"; "子"="child"; "母"="mother"; "目"="eye"; "耳"="ear"; "口"="mouth"; "舌"="tongue"; "自"="self"; "首"="head"; "身"="body"; "心"="heart"; "老"="old"; "长"="long"; "天"="sky"; "牛"="ox"; "羊"="sheep"; "犬"="dog"; "虎"="tiger"; "角"="horn"; "刀"="knife"; "弓"="bow"; "衣"="clothing"; "豆"="bean"; "工"="work"; "册"="book"; "玉"="jade"; "王"="king"; "示"="altar"; "力"="strength"; "二"="two"; "三"="three"; "十"="ten"; "上"="above"; "下"="below"; "中"="middle"; "小"="small"; "少"="few"; "多"="many"; "高"="high"; "入"="enter"; "出"="exit"; "立"="stand"; "央"="center"; "南"="south"; "北"="north"; "西"="west"; "林"="forest"; "休"="rest"; "从"="follow"; "好"="good"; "男"="man"; "明"="bright"; "美"="beautiful"; "兄"="older-brother"; "品"="things-goods"; "告"="tell"; "合"="join"; "取"="take"; "采"="gather"; "止"="stop"; "步"="step"; "走"="walk"; "行"="go"; "正"="upright"; "先"="before"; "及"="reach"; "交"="meet"; "反"="turn-back"; "友"="friend"; "向"="direction"; "分"="divide"; "利"="benefit"; "武"="martial"; "得"="obtain"; "後"="after"; "集"="gather-u96c6"; "言"="speech"; "公"="public"; "民"="people"; "典"="classic"; "兵"="soldier"; "令"="command"; "各"="each"; "同"="same"; "妻"="wife"; "古"="old-u53e4"; "吉"="auspicious"; "旅"="journey"; "族"="group"; "守"="guard"; "官"="official"; "申"="stretch"; "光"="light"; "白"="white"; "黑"="black"; "赤"="red"; "年"="year"; "夏"="summer"; "冬"="winter"; "望"="look-toward"; "甘"="sweet"; "香"="fragrance"; "益"="increase"; "祭"="sacrifice"; "宗"="ancestor"; "宿"="lodging"; "祝"="blessing"
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
  $id = if ($idByCharacter.ContainsKey($character)) { $idByCharacter[$character] } else { "symbol-$($manifestRecord.unicode.Replace('U+', 'u'))" }
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
      materialProcessCaption = Get-MaterialProcessCaption $selectedStage.key
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
    introducedComponentIds = @(); stageExplanation = "A modern standardized Kai reference rendering provides the consistent endpoint for comparison."; transitionNote = $regularTransitionNote; transitionNoteNeedsReview = $regularTransitionNeedsReview; materialProcessCaption = (Get-MaterialProcessCaption "regular"); availabilityState = "available"
  }) | Out-Null

  $baseExamples = if ($legacy) { $legacy.focusCoverage.simplifiedChinese.examples } else { @() }
  $baseTraditionalTaiwan = if ($legacy) { $legacy.focusCoverage.traditionalChinese.taiwanExamples } else { @() }
  $baseTraditionalHongKong = if ($legacy) { $legacy.focusCoverage.traditionalChinese.hongKongExamples } else { @() }
  $baseJapaneseExamples = if ($legacy) { $legacy.focusCoverage.japanese.examples } else { @() }
  $baseKoreanExamples = if ($legacy) { $legacy.focusCoverage.korean.examples } else { @() }
  $fallbackReading = $mandarin
  if (-not $fallbackReading) { $fallbackReading = $japanese }
  if (-not $fallbackReading) { $fallbackReading = $korean }
  $simplifiedStarterExamples = @((New-Example $character $fallbackReading $meaning $true "word" $character)) + @(New-StarterExamples "simplifiedChinese" $character $character)
  $traditionalStarterExamples = @((New-Example $traditional $fallbackReading $meaning $true "word" $character)) + @(New-StarterExamples "traditionalChinese" $traditional $character)
  $japaneseStarterExamples = @((New-Example $traditional $japanese $meaning $true "word" $character)) + @(New-StarterExamples "japanese" $traditional $character)
  $koreanStarterExamples = @((New-Example $traditional $korean $meaning $true "word" $character)) + @(New-StarterExamples "korean" $traditional $character)
  # Preserve existing seed entries first, then fill each track to four
  # examples. This keeps the initial corpus useful without fake dictionary
  # compounds; native-speaker vocabulary replaces these starters later.
  $simplifiedExamples = @(@($baseExamples) + @($simplifiedStarterExamples) | Select-Object -First 4)
  $taiwanExamples = @(@($baseTraditionalTaiwan) + @($traditionalStarterExamples) | Select-Object -First 4)
  # Cantonese examples must remain absent when no reviewed Hong Kong content exists;
  # Mandarin starter content must never appear under a Cantonese heading.
  $hongKongExamples = @(@($baseTraditionalHongKong) | Select-Object -First 4)
  $japaneseExamples = @(@($baseJapaneseExamples) + @($japaneseStarterExamples) | Select-Object -First 4)
  $koreanExamples = @(@($baseKoreanExamples) + @($koreanStarterExamples) | Select-Object -First 4)
  # Wrap the entire conditional in @() so PowerShell preserves one-item and
  # empty collections instead of serializing them as an object or null.
  $jpReadings = @(if ($legacy) { @($legacy.focusCoverage.japanese.readings | ForEach-Object { Normalize-DraftReading $_ "japanese" $traditional }) } elseif ($japanese) { New-Reading "on / kun" $japanese (Get-DraftSpeechText $japanese "japanese" $traditional) "japanese" })
  $krReadings = @(if ($legacy) { @($legacy.focusCoverage.korean.readings | ForEach-Object { Normalize-DraftReading $_ "korean" $traditional }) } elseif ($korean) { New-Reading "hanja" $korean (Get-DraftSpeechText $korean "korean" $traditional) "korean" })
  $cnReadings = @(if ($legacy) { @($legacy.focusCoverage.simplifiedChinese.readings | ForEach-Object { Normalize-DraftReading $_ "mandarin" $character }) } elseif ($mandarin) { New-Reading "pinyin" $mandarin $character "mandarin" })
  $twReadings = @(if ($legacy -and $legacy.focusCoverage.traditionalChinese.taiwanReadings) { @($legacy.focusCoverage.traditionalChinese.taiwanReadings | ForEach-Object { Normalize-DraftReading $_ "mandarin" $traditional }) } else { @($cnReadings) })
  # Missing Cantonese data remains missing; it must never become Mandarin data.
  $hkReadings = @(if ($legacy -and $legacy.focusCoverage.traditionalChinese.hongKongReadings) { @($legacy.focusCoverage.traditionalChinese.hongKongReadings | ForEach-Object { Normalize-DraftReading $_ "cantonese" $traditional }) } else { @() })
  $focus = [ordered]@{
    simplifiedChinese = [ordered]@{ form = $character; readings = $cnReadings; glosses = @($meaning); examples = $simplifiedExamples; variants = @() }
    traditionalChinese = [ordered]@{ form = $traditional; readings = $cnReadings; glosses = @($meaning); taiwanExamples = $taiwanExamples; hongKongExamples = $hongKongExamples; taiwanReadings = $twReadings; hongKongReadings = $hkReadings; variants = @() }
    japanese = [ordered]@{ form = $traditional; readings = $jpReadings; glosses = @($meaning); examples = $japaneseExamples; variants = @() }
    korean = [ordered]@{ form = $traditional; readings = $krReadings; glosses = @($meaning); examples = $koreanExamples; variants = @() }
  }
  $origin = [ordered]@{ concept = $meaning; explanation = "A friendly educational reconstruction of $meaning comes first, followed by the separately sourced historical glyphs."; asset = [ordered]@{ characterID = $id; historicalStage = $null; approximatePeriod = $null; sourceInstitution = "Script Roots"; sourcePageURL = $null; sourceAssetURL = $null; catalogueReference = $null; sourceDescription = "Internal educational reconstruction; not historical evidence."; retrievedAt = "2026-09-03"; contentClass = "educationalReconstruction"; assetRef = $originAssetRef; artifactAssetRef = $null; assetKind = "illustrated-concept"; provenance = "OpenAI image generation; approved Soft Ink & Wash museum style"; licenseStatus = "internal-authored"; accessibilityDescription = "Illustration of $meaning"; readiness = "needsReview" }; sourceIds = @("source-generated-origin-$character") }
  $record = [ordered]@{
    id = $id; version = 1; coreCharacter = $character; coreSharedMeaning = $meaning; recognitionTakeaway = "$character connects the idea of $meaning to a complete visual journey from origin through historical forms and into modern language use."; publicationStatus = "draft"; unicodeCodePoint = [string]$manifestRecord.unicode; simplifiedForm = $character; traditionalForm = $traditional; additionalMeanings = @(); formationType = Normalize-FormationType $(if ($research -and $research.formationType) { [string]$research.formationType } else { "uncertain" }); visualTeachingNotes = @("Compare the friendly origin illustration with the selected Oracle Bone form.", "Historical glyphs are shown as source-backed evidence, not reconstructed artwork."); contentFolder = "content/research/v1-symbols/$([IO.Path]::GetFileName($folder))"; learnerCopyPath = $null; researchNotesPath = "content/research/v1-symbols/$([IO.Path]::GetFileName($folder))/research.md"; reviewPath = $null; sourceConflicts = @(); editorialStatus = "needsReview"; teachingSequence = [int]$manifestRecord.rank; focusCoverage = $focus; visuals = [ordered]@{ evolutionAssetRefs = $null; assetStatus = "local-source-backed-draft"; note = "Origin illustration and normalized ZDIC historical stages are bundled for this implementation pass. ZDIC reuse permission remains a release gate." }; history = [ordered]@{ originAnchor = "Begin with the real-world idea of $meaning, then compare the selected forms without treating the illustration as a historical glyph."; stages = @($stages.ToArray()); origin = $origin }; structure = [ordered]@{ summary = if ($research -and $research.ideographicDescription) { "The research record describes this structure as $($research.ideographicDescription)." } else { "$character is presented first as a complete shared character." }; components = @(); certainty = if ($research -and $research.confidence -ge 85) { "high" } else { "medium" }; caveat = "Formation and component explanations remain subject to editorial review."; sourceIds = @("source-zdic-$character") }; usage = [ordered]@{ coreMeaningFirst = "Start with '$meaning', then compare the modern forms and readings across the four focus tracks."; notes = @("Modern examples are installed as initial content and should receive language-editor review before publication.", "Japanese and Korean regional forms are rendered through their intentional locale font roles.") }; sources = $sourceRows; notes = @("V1 runtime import from the 126-character complete-evolution manifest.", "ZDIC historical visual reuse remains review-required before commercial release.", "Origin artwork is an educational reconstruction, not historical evidence.", "Examples are shown in the Today section; generated fallback examples require language-editor review.")
  }
  # Keep the runtime note aligned with the starter-example policy above.
  $record.notes[3] = "Each focus track contains up to four starter examples; learning-context sentences require native-speaker vocabulary review before publication."
  $record | ConvertTo-Json -Depth 60 | Set-Content -LiteralPath (Join-Path $outputCorpus "$id.json") -Encoding utf8
  $records.Add($record) | Out-Null
}

$records | Sort-Object teachingSequence | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Resolve-RepoPath "Resources/V1CorpusManifest.json") -Encoding utf8
Write-Output "OK: imported $($records.Count) complete-evolution V1 records and local museum assets."
