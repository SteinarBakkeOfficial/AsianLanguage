param(
  [string]$ContentPath = "content/shared-characters",
  [string]$VisualPath = "Resources/Assets/PrototypeVisuals",
  [string]$HistoricalGlyphPath = "Resources/Assets/HistoricalGlyphs"
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$contentRoot = Join-Path $repoRoot $ContentPath
$visualRoot = Join-Path $repoRoot $VisualPath
$historicalGlyphRoot = Join-Path $repoRoot $HistoricalGlyphPath

New-Item -ItemType Directory -Path $contentRoot -Force | Out-Null
New-Item -ItemType Directory -Path $visualRoot -Force | Out-Null
New-Item -ItemType Directory -Path $historicalGlyphRoot -Force | Out-Null

$sharedSources = @(
  [ordered]@{
    id = "source-character-classification"
    label = "Chinese character classification reference"
    type = "reference"
    citation = "Chinese character classification explains the pictographic origin of many early Chinese characters and includes examples such as sun, moon, mountain, water, and wood/tree."
    url = "https://en.wikipedia.org/wiki/Chinese_character_classification"
  },
  [ordered]@{
    id = "source-oracle-bone-script"
    label = "Oracle bone script reference"
    type = "reference"
    citation = "Oracle bone script is the oldest attested substantial Chinese writing corpus and an ancestor of later Chinese-family scripts."
    url = "https://en.wikipedia.org/wiki/Oracle_bone_script"
  },
  [ordered]@{
    id = "source-seal-script"
    label = "Seal script reference"
    type = "reference"
    citation = "Seal script developed from earlier bronze/large-seal traditions and was standardized in Qin usage."
    url = "https://en.wikipedia.org/wiki/Seal_script"
  },
  [ordered]@{
    id = "source-clerical-script"
    label = "Clerical script reference"
    type = "reference"
    citation = "Clerical script matured and became dominant during the Han dynasty, flattening and regularizing earlier forms."
    url = "https://en.wikipedia.org/wiki/Clerical_script"
  },
  [ordered]@{
    id = "source-evobc"
    label = "EVOBC dataset paper"
    type = "research-paper"
    citation = "Guan et al., 'An open dataset for the evolution of oracle bone characters: EVOBC', documents ancient-character evolution categories including oracle bone, bronze, seal, and clerical stages."
    url = "https://arxiv.org/abs/2401.12467"
  },
  [ordered]@{
    id = "source-prototype-redraw"
    label = "Internal app-native prototype redraw"
    type = "prototype"
    citation = "Internal schematic redraw used only for prototype testing; specialist review and source-backed final redraws are still required."
  }
)

$records = @(
  [ordered]@{
    id = "day"; sequence = 1; char = "日"; meaning = "sun; day"; pinyin = "ri4 / rì"; jpOn = "nichi / jitsu"; jpKun = "hi"; krHanja = "일 / il"; krNative = "날 / nal"; radical = "Radical 72"; radicalSource = "source-radical-72"; radicalUrl = "https://en.wikipedia.org/wiki/Radical_72"; radicalCitation = "Radical 72 lists 日 as the sun/day radical with Mandarin rì, Japanese nichi/jitsu and hi, and Korean 일 il / 날 nal."; original = "a picture of the sun, later squared into the written form 日"; wordSc = "日子"; wordTc = "日子"; wordJp = "日"; wordKr = "일"; sentenceSc = "今天是好日子。"; sentenceTc = "今天是好日子。"; sentenceHk = "今日係好日子。"; sentenceJp = "今日はよい日です。"; sentenceKr = "오늘은 좋은 날입니다."; reuse = @(); intro = @("日") },
  [ordered]@{
    id = "moon"; sequence = 2; char = "月"; meaning = "moon; month"; pinyin = "yue4 / yuè"; jpOn = "getsu / gatsu"; jpKun = "tsuki"; krHanja = "월 / wol"; krNative = "달 / dal"; radical = "Radical 74"; radicalSource = "source-radical-74"; radicalUrl = "https://en.wikipedia.org/wiki/Radical_74"; radicalCitation = "Radical 74 lists 月 as the moon/month radical with Mandarin yuè, Japanese getsu/gatsu and tsuki, and Korean 월 wol / 달 dal."; original = "a picture of the moon, later written as 月 and extended to month"; wordSc = "月亮"; wordTc = "月亮"; wordJp = "月"; wordKr = "월"; sentenceSc = "月亮很明亮。"; sentenceTc = "月亮很明亮。"; sentenceHk = "月亮好光。"; sentenceJp = "月が明るいです。"; sentenceKr = "달이 밝습니다."; reuse = @("日"); intro = @("月") },
  [ordered]@{
    id = "person"; sequence = 3; char = "人"; meaning = "person"; pinyin = "ren2 / rén"; jpOn = "jin / nin"; jpKun = "hito"; krHanja = "인 / in"; krNative = "사람 / saram"; radical = "Radical 9"; radicalSource = "source-radical-9"; radicalUrl = "https://en.wikipedia.org/wiki/Radical_9"; radicalCitation = "Radical 9 lists 人 as the person radical with Mandarin rén, Japanese jin/nin and hito, and Korean 인 in / 사람 saram."; original = "a side-view human figure, later abstracted into 人"; wordSc = "人"; wordTc = "人"; wordJp = "人"; wordKr = "인"; sentenceSc = "这个人很好。"; sentenceTc = "這個人很好。"; sentenceHk = "呢個人好好。"; sentenceJp = "この人はよい人です。"; sentenceKr = "이 사람은 좋은 사람입니다."; reuse = @("日"); intro = @("人") },
  [ordered]@{
    id = "big"; sequence = 4; char = "大"; meaning = "big; great"; pinyin = "da4 / dà"; jpOn = "dai / tai"; jpKun = "oo / ookii"; krHanja = "대 / dae"; krNative = "큰 / keun"; radical = "Radical 37"; radicalSource = "source-radical-37"; radicalUrl = "https://en.wikipedia.org/wiki/Radical_37"; radicalCitation = "Radical 37 lists 大 as the big/great radical with Mandarin dà, Japanese dai/tai and ō/ōkii, and Korean 대 dae / 큰 keun."; original = "a person with arms and legs spread wide, used for the idea big/great"; wordSc = "大人"; wordTc = "大人"; wordJp = "大人"; wordKr = "대인"; sentenceSc = "大人来了。"; sentenceTc = "大人來了。"; sentenceHk = "大人嚟咗。"; sentenceJp = "大きい人が来ます。"; sentenceKr = "큰 사람이 옵니다."; reuse = @("人"); intro = @("大") },
  [ordered]@{
    id = "small"; sequence = 5; char = "小"; meaning = "small"; pinyin = "xiao3 / xiǎo"; jpOn = "shou"; jpKun = "chiisai"; krHanja = "소 / so"; krNative = "작은 / jageun"; radical = "Radical 42"; radicalSource = "source-radical-42"; radicalUrl = "https://en.wikipedia.org/wiki/Radical_42"; radicalCitation = "Radical 42 lists 小 as the small/insignificant radical with Mandarin xiǎo, Japanese shō/chiisai, and Korean 소 so / 작은 jageun."; original = "small separated dots or strokes, later standardized as 小"; wordSc = "小人"; wordTc = "小人"; wordJp = "小さい人"; wordKr = "소인"; sentenceSc = "小人也在这里。"; sentenceTc = "小人也在這裡。"; sentenceHk = "小人都喺呢度。"; sentenceJp = "小さい人もここにいます。"; sentenceKr = "작은 사람도 여기 있습니다."; reuse = @("人"); intro = @("小") },
  [ordered]@{
    id = "mountain"; sequence = 6; char = "山"; meaning = "mountain"; pinyin = "shan1 / shān"; jpOn = "san"; jpKun = "yama"; krHanja = "산 / san"; krNative = "산 / san"; radical = "Radical 46"; radicalSource = "source-radical-46"; radicalUrl = "https://en.wikipedia.org/wiki/Radical_46"; radicalCitation = "Radical 46 lists 山 as the mountain radical with Mandarin shān, Japanese san/yama, and Korean 산 san."; original = "mountain peaks, later reduced to the three-stroke form 山"; wordSc = "山"; wordTc = "山"; wordJp = "山"; wordKr = "산"; sentenceSc = "山上有木。"; sentenceTc = "山上有木。"; sentenceHk = "山上有木。"; sentenceJp = "山の上に木があります。"; sentenceKr = "산 위에 나무가 있습니다."; reuse = @("木"); intro = @("山") },
  [ordered]@{
    id = "water"; sequence = 7; char = "水"; meaning = "water"; pinyin = "shui3 / shuǐ"; jpOn = "sui"; jpKun = "mizu"; krHanja = "수 / su"; krNative = "물 / mul"; radical = "Radical 85"; radicalSource = "source-radical-85"; radicalUrl = "https://en.wikipedia.org/wiki/Radical_85"; radicalCitation = "Radical 85 lists 水 as the water radical with Mandarin shuǐ, Japanese sui/mizu, and Korean 수 su / 물 mul."; original = "flowing water lines, later standardized as 水"; wordSc = "水"; wordTc = "水"; wordJp = "水"; wordKr = "수"; sentenceSc = "水在山下。"; sentenceTc = "水在山下。"; sentenceHk = "水喺山下。"; sentenceJp = "水は山の下にあります。"; sentenceKr = "물은 산 아래에 있습니다."; reuse = @("山"); intro = @("水") },
  [ordered]@{
    id = "fire"; sequence = 8; char = "火"; meaning = "fire"; pinyin = "huo3 / huǒ"; jpOn = "ka / ko"; jpKun = "hi"; krHanja = "화 / hwa"; krNative = "불 / bul"; radical = "Radical 86"; radicalSource = "source-radical-86"; radicalUrl = "https://en.wikipedia.org/wiki/Radical_86"; radicalCitation = "Radical 86 lists 火 as the fire radical with Mandarin huǒ, Japanese ka/ko and hi, and Korean 화 hwa / 불 bul."; original = "flames rising upward, later regularized as 火"; wordSc = "火"; wordTc = "火"; wordJp = "火"; wordKr = "화"; sentenceSc = "火很大。"; sentenceTc = "火很大。"; sentenceHk = "火好大。"; sentenceJp = "火が大きいです。"; sentenceKr = "불이 큽니다."; reuse = @("大"); intro = @("火") },
  [ordered]@{
    id = "tree"; sequence = 9; char = "木"; meaning = "tree; wood"; pinyin = "mu4 / mù"; jpOn = "moku / boku"; jpKun = "ki"; krHanja = "목 / mok"; krNative = "나무 / namu"; radical = "Radical 75"; radicalSource = "source-radical-75"; radicalUrl = "https://en.wikipedia.org/wiki/Radical_75"; radicalCitation = "Radical 75 lists 木 as the tree radical with Mandarin mù, Japanese moku/boku and ki, and Korean 목 mok / 나무 namu."; original = "a tree with trunk and branches, later standardized as 木"; wordSc = "木头"; wordTc = "木頭"; wordJp = "木"; wordKr = "목재"; sentenceSc = "山上有木。"; sentenceTc = "山上有木。"; sentenceHk = "山上有木。"; sentenceJp = "山の上に木があります。"; sentenceKr = "산 위에 나무가 있습니다."; reuse = @("山"); intro = @("木") },
  [ordered]@{
    id = "mouth"; sequence = 10; char = "口"; meaning = "mouth; opening"; pinyin = "kou3 / kǒu"; jpOn = "kou"; jpKun = "kuchi"; krHanja = "구 / gu"; krNative = "입 / ip"; radical = "Radical 30"; radicalSource = "source-radical-30"; radicalUrl = "https://en.wikipedia.org/wiki/Radical_30"; radicalCitation = "Radical 30 lists 口 as the mouth radical with Mandarin kǒu, Japanese kō/kuchi, and Korean 구 gu / 입 ip."; original = "an opening or mouth shape, later written as 口"; wordSc = "口"; wordTc = "口"; wordJp = "口"; wordKr = "구"; sentenceSc = "人有口。"; sentenceTc = "人有口。"; sentenceHk = "人有口。"; sentenceJp = "人には口があります。"; sentenceKr = "사람에게는 입이 있습니다."; reuse = @("人"); intro = @("口") },
  [ordered]@{
    id = "eye"; sequence = 11; char = "目"; meaning = "eye"; pinyin = "mu4 / mù"; jpOn = "moku / boku"; jpKun = "me"; krHanja = "목 / mok"; krNative = "눈 / nun"; radical = "Radical 109"; radicalSource = "source-radical-109"; radicalUrl = "https://en.wikipedia.org/wiki/Radical_109"; radicalCitation = "Radical 109 lists 目 as the eye radical with Mandarin mù, Japanese moku/boku and me, and Korean 목 mok / 눈 nun."; original = "an eye shape turned into the rectangular written form 目"; wordSc = "目光"; wordTc = "目光"; wordJp = "目"; wordKr = "목"; sentenceSc = "人有目。"; sentenceTc = "人有目。"; sentenceHk = "人有目。"; sentenceJp = "人には目があります。"; sentenceKr = "사람에게는 눈이 있습니다."; reuse = @("人"); intro = @("目") }
)

function New-Example {
  param($Text, $Reading, $Translation, $Level, $Group, $Reuse, $Intro)
  [ordered]@{
    text = $Text
    reading = $Reading
    translation = $Translation
    showsCoreMeaning = $true
    exampleLevel = $Level
    parallelExampleGroupID = $Group
    reusesKnownSymbols = @($Reuse)
    introducedSymbols = @($Intro)
  }
}

function New-Stage {
  param($Record, $Stage, $Label, $ChangeNote, $SourceIds, $Sound)
  $historicalFileName = switch ($Stage) {
    "oracleBone" { "$($Record.id)-oracle.svg" }
    "bronze" { "$($Record.id)-bronze.svg" }
    "seal" { "$($Record.id)-seal.svg" }
    default { $null }
  }
  $historicalAssetRef = $null
  if ($null -ne $historicalFileName) {
    $historicalAssetPath = Join-Path $historicalGlyphRoot $historicalFileName
    if (Test-Path $historicalAssetPath) {
      $historicalAssetRef = "Assets/HistoricalGlyphs/$historicalFileName"
    }
  }

  [ordered]@{
    stage = $Stage
    label = $Label
    form = $(if ($Stage -eq "regular") { $Record.char } else { $null })
    assetRef = $(if ($Stage -eq "regular") { "Assets/PrototypeVisuals/$($Record.id)-regular.svg" } else { $historicalAssetRef })
    changeNoteFromPrevious = $ChangeNote
    certainty = $(if ($Stage -eq "regular") { "high" } else { "medium" })
    sourceIds = @($SourceIds)
    historicalSound = $Sound
  }
}

function Write-RegularVisual {
  param($Record)
  $path = Join-Path $visualRoot "$($Record.id)-regular.svg"
  $svg = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
  <defs>
    <radialGradient id="paper" cx="50%" cy="42%" r="70%">
      <stop offset="0%" stop-color="#fff8ec"/>
      <stop offset="100%" stop-color="#e8dcc8"/>
    </radialGradient>
    <linearGradient id="ink" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#17110c"/>
      <stop offset="100%" stop-color="#5c4632"/>
    </linearGradient>
  </defs>
  <rect width="512" height="512" rx="48" fill="url(#paper)"/>
  <circle cx="256" cy="238" r="158" fill="#f5ead6" stroke="#c7aa7a" stroke-width="6"/>
  <path d="M104 418 C166 388, 344 388, 408 418" fill="none" stroke="#b89862" stroke-width="8" stroke-linecap="round"/>
  <text x="256" y="292" text-anchor="middle" font-family="KaiTi, STKaiti, YuMincho, serif" font-size="210" font-weight="700" fill="url(#ink)">$($Record.char)</text>
  <text x="256" y="462" text-anchor="middle" font-family="Avenir, Arial, sans-serif" font-size="24" fill="#6c5842">$($Record.meaning)</text>
</svg>
"@
  Set-Content -Path $path -Value $svg -Encoding utf8
}

foreach ($record in $records) {
  Write-RegularVisual -Record $record
  $group = "$($record.id)-parallel-1"
  $evolutionAssetRefs = [ordered]@{
    regular = "Assets/PrototypeVisuals/$($record.id)-regular.svg"
  }
  foreach ($assetStage in @("oracle", "bronze", "seal")) {
    $assetFileName = "$($record.id)-$assetStage.svg"
    if (Test-Path (Join-Path $historicalGlyphRoot $assetFileName)) {
      $evolutionAssetRefs[$assetStage] = "Assets/HistoricalGlyphs/$assetFileName"
    }
  }
  $sources = @($sharedSources)
  $sources += [ordered]@{
    id = $record.radicalSource
    label = "$($record.radical) / $($record.char) reference"
    type = "reference"
    citation = $record.radicalCitation
    url = $record.radicalUrl
  }

  $json = [ordered]@{
    id = $record.id
    version = 2
    teachingSequence = $record.sequence
    coreCharacter = $record.char
    coreSharedMeaning = $record.meaning
    recognitionTakeaway = "$($record.char) links the idea '$($record.meaning)' from an ancient graphic origin through regular script into modern Chinese, Japanese Kanji, and Korean Hanja usage."
    publicationStatus = "draft"
    visuals = [ordered]@{
      evolutionAssetRefs = $evolutionAssetRefs
      assetStatus = "source-backed-draft"
      note = "Regular-script prototype card exists. Historical Oracle/Bronze/Seal assets are attached when source-backed Wikimedia Commons SVGs are available; final publication still needs licensing review and specialist redraw approval."
    }
    focusCoverage = [ordered]@{
      simplifiedChinese = [ordered]@{
        form = $record.char
        readings = @([ordered]@{ system = "pinyin"; value = $record.pinyin })
        glosses = @($record.meaning)
        examples = @(
          (New-Example $record.wordSc $record.pinyin $record.meaning "word" $null @() @($record.char)),
          (New-Example $record.sentenceSc $null "Basic sentence using $($record.meaning)." "sentence" $group $record.reuse $record.intro)
        )
      }
      traditionalChinese = [ordered]@{
        form = $record.char
        readings = @([ordered]@{ system = "pinyin"; value = $record.pinyin })
        glosses = @($record.meaning)
        taiwanExamples = @(
          (New-Example $record.wordTc $record.pinyin $record.meaning "word" $null @() @($record.char)),
          (New-Example $record.sentenceTc $null "Basic Taiwan sentence using $($record.meaning)." "sentence" $group $record.reuse $record.intro)
        )
        hongKongExamples = @(
          (New-Example $record.wordTc $null $record.meaning "word" $null @() @($record.char)),
          (New-Example $record.sentenceHk $null "Basic Hong Kong sentence using $($record.meaning)." "sentence" $group $record.reuse $record.intro)
        )
      }
      japanese = [ordered]@{
        form = $record.char
        readings = @(
          [ordered]@{ system = "on"; value = $record.jpOn },
          [ordered]@{ system = "kun"; value = $record.jpKun }
        )
        glosses = @($record.meaning)
        examples = @(
          (New-Example $record.wordJp $record.jpKun $record.meaning "word" $null @() @($record.char)),
          (New-Example $record.sentenceJp $null "Basic Japanese sentence using $($record.meaning)." "sentence" $group $record.reuse $record.intro)
        )
      }
      korean = [ordered]@{
        form = $record.char
        readings = @(
          [ordered]@{ system = "hanja"; value = $record.krHanja },
          [ordered]@{ system = "native Korean"; value = $record.krNative }
        )
        glosses = @($record.meaning)
        examples = @(
          (New-Example $record.wordKr $record.krHanja $record.meaning "word" $null @() @($record.char)),
          (New-Example $record.sentenceKr $null "Basic Korean sentence using $($record.meaning)." "sentence" $group $record.reuse $record.intro)
        )
      }
    }
    history = [ordered]@{
      originAnchor = "$($record.char) is taught here from its original idea: $($record.original)."
      stages = @(
        (New-Stage $record "oracleBone" "Oracle Bone Script" $null @("source-oracle-bone-script", "source-character-classification", "source-evobc", $record.radicalSource) "Old Chinese sound not shown yet; add only after dedicated reconstruction review."),
        (New-Stage $record "bronze" "Bronze Script" "Bronze inscriptions continue the ancient graph tradition after the oracle-bone period; final $($record.char)-specific redraw still required." @("source-evobc", $record.radicalSource) "Not shown in this seed record."),
        (New-Stage $record "seal" "Seal Script" "Seal script formalizes earlier graph traditions into a more standardized archaic written style." @("source-seal-script", "source-evobc", $record.radicalSource) "Not shown in this seed record."),
        (New-Stage $record "clerical" "Clerical Script" "Clerical script flattens and regularizes earlier forms before later regular-script writing." @("source-clerical-script", "source-evobc", $record.radicalSource) "Not shown in this seed record."),
        (New-Stage $record "regular" "Regular Script" "The regular form stabilizes as $($record.char), still recognizable in modern focus-track usage." @($record.radicalSource, "source-prototype-redraw") $null)
      )
    }
    structure = [ordered]@{
      summary = "$($record.char) is handled as a basic graph/radical for '$($record.meaning)'. It can appear as a standalone character and as a component in related characters."
      components = @([ordered]@{ label = $record.char; role = "basic graph / radical"; meaningHint = $record.meaning })
      certainty = "medium"
      caveat = "Seed record uses public reference sources; publication requires specialist paleography review and final source-backed glyph redraws."
      sourceIds = @($record.radicalSource, "source-character-classification")
    }
    usage = [ordered]@{
      coreMeaningFirst = "Start with '$($record.meaning)', then compare how $($record.char) is read and used across Mandarin, Traditional Chinese usage communities, Japanese, and Korean."
      notes = @(
        "Japanese often has separate Sino-Japanese on readings and native kun readings.",
        "Korean examples separate the Hanja reading from the native Korean everyday word when they differ.",
        "Modern examples are seed content and still need native-speaker review before publication."
      )
    }
    sources = $sources
    notes = @(
      "Source-backed seed pass generated from public radical/script references.",
      "Historical stage explanations are sourced, but final stage glyphs still require licensed/source-backed redraws.",
      "Modern examples need native-speaker/editorial review before publication."
    )
  }

  $json | ConvertTo-Json -Depth 30 | Set-Content -Path (Join-Path $contentRoot "$($record.id).json") -Encoding utf8
}

Write-Output "OK: wrote $($records.Count) source-backed seed corpus record(s)."
