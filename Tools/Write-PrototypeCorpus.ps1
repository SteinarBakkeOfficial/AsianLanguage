$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$contentPath = Join-Path $repoRoot "content/shared-characters"
$visualPath = Join-Path $repoRoot "Resources/Assets/PrototypeVisuals"

New-Item -ItemType Directory -Path $contentPath -Force | Out-Null
New-Item -ItemType Directory -Path $visualPath -Force | Out-Null

$records = @(
  @{ id="day"; sequence=1; char="日"; meaning="sun; day"; pinyin="ri4"; japanese="nichi"; korean="일"; wordSc="日子"; wordTc="日子"; wordJp="日"; wordKr="일"; sentenceSc="今天是好日子。"; sentenceTc="今天是好日子。"; sentenceHk="今日係好日子。"; sentenceJp="今日はよい日です。"; sentenceKr="오늘은 좋은 날입니다."; reuse=@(); intro=@("日") },
  @{ id="moon"; sequence=2; char="月"; meaning="moon; month"; pinyin="yue4"; japanese="getsu"; korean="월"; wordSc="月亮"; wordTc="月亮"; wordJp="月"; wordKr="월"; sentenceSc="月亮很明亮。"; sentenceTc="月亮很明亮。"; sentenceHk="月亮好光。"; sentenceJp="月が明るいです。"; sentenceKr="달이 밝습니다."; reuse=@(); intro=@("月") },
  @{ id="person"; sequence=3; char="人"; meaning="person"; pinyin="ren2"; japanese="jin"; korean="인"; wordSc="人"; wordTc="人"; wordJp="人"; wordKr="인"; sentenceSc="这个人很好。"; sentenceTc="這個人很好。"; sentenceHk="呢個人好好。"; sentenceJp="この人はよい人です。"; sentenceKr="이 사람은 좋은 사람입니다."; reuse=@("日"); intro=@("人") },
  @{ id="big"; sequence=4; char="大"; meaning="big; great"; pinyin="da4"; japanese="dai"; korean="대"; wordSc="大人"; wordTc="大人"; wordJp="大人"; wordKr="대인"; sentenceSc="大人来了。"; sentenceTc="大人來了。"; sentenceHk="大人嚟咗。"; sentenceJp="大きい人が来ます。"; sentenceKr="큰 사람이 옵니다."; reuse=@("人"); intro=@("大") },
  @{ id="small"; sequence=5; char="小"; meaning="small"; pinyin="xiao3"; japanese="shou"; korean="소"; wordSc="小人"; wordTc="小人"; wordJp="小さい人"; wordKr="소인"; sentenceSc="小人也在这里。"; sentenceTc="小人也在這裡。"; sentenceHk="小人都喺呢度。"; sentenceJp="小さい人もここにいます。"; sentenceKr="작은 사람도 여기 있습니다."; reuse=@("人"); intro=@("小") },
  @{ id="mountain"; sequence=6; char="山"; meaning="mountain"; pinyin="shan1"; japanese="san"; korean="산"; wordSc="山"; wordTc="山"; wordJp="山"; wordKr="산"; sentenceSc="山上有木。"; sentenceTc="山上有木。"; sentenceHk="山上有木。"; sentenceJp="山の上に木があります。"; sentenceKr="산 위에 나무가 있습니다."; reuse=@("木"); intro=@("山") },
  @{ id="water"; sequence=7; char="水"; meaning="water"; pinyin="shui3"; japanese="sui"; korean="수"; wordSc="水"; wordTc="水"; wordJp="水"; wordKr="수"; sentenceSc="水在山下。"; sentenceTc="水在山下。"; sentenceHk="水喺山下。"; sentenceJp="水は山の下にあります。"; sentenceKr="물은 산 아래에 있습니다."; reuse=@("山"); intro=@("水") },
  @{ id="fire"; sequence=8; char="火"; meaning="fire"; pinyin="huo3"; japanese="ka"; korean="화"; wordSc="火"; wordTc="火"; wordJp="火"; wordKr="화"; sentenceSc="火很大。"; sentenceTc="火很大。"; sentenceHk="火好大。"; sentenceJp="火が大きいです。"; sentenceKr="불이 큽니다."; reuse=@("大"); intro=@("火") },
  @{ id="tree"; sequence=9; char="木"; meaning="tree; wood"; pinyin="mu4"; japanese="moku"; korean="목"; wordSc="木头"; wordTc="木頭"; wordJp="木"; wordKr="목재"; sentenceSc="山上有木。"; sentenceTc="山上有木。"; sentenceHk="山上有木。"; sentenceJp="山の上に木があります。"; sentenceKr="산 위에 나무가 있습니다."; reuse=@("山"); intro=@("木") },
  @{ id="mouth"; sequence=10; char="口"; meaning="mouth; opening"; pinyin="kou3"; japanese="kou"; korean="구"; wordSc="口"; wordTc="口"; wordJp="口"; wordKr="구"; sentenceSc="人有口。"; sentenceTc="人有口。"; sentenceHk="人有口。"; sentenceJp="人には口があります。"; sentenceKr="사람에게는 입이 있습니다."; reuse=@("人"); intro=@("口") },
  @{ id="eye"; sequence=11; char="目"; meaning="eye"; pinyin="mu4"; japanese="moku"; korean="목"; wordSc="目光"; wordTc="目光"; wordJp="目"; wordKr="목"; sentenceSc="人有目。"; sentenceTc="人有目。"; sentenceHk="人有目。"; sentenceJp="人には目があります。"; sentenceKr="사람에게는 눈이 있습니다."; reuse=@("人"); intro=@("目") }
)

function New-Example {
  param($Text, $Reading, $Translation, $Level, $Group, $Reuse, $Intro)
  return [ordered]@{
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

function Write-Visual {
  param($Record)

  $fileName = "$($Record.id)-regular.svg"
  $path = Join-Path $visualPath $fileName
  $title = $Record.meaning
  $character = $Record.char

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
  <text x="256" y="292" text-anchor="middle" font-family="KaiTi, STKaiti, YuMincho, serif" font-size="210" font-weight="700" fill="url(#ink)">$character</text>
  <text x="256" y="462" text-anchor="middle" font-family="Avenir, Arial, sans-serif" font-size="24" fill="#6c5842">$title</text>
</svg>
"@

  $svg | Set-Content -Path $path -Encoding utf8
  return "Assets/PrototypeVisuals/$fileName"
}

foreach ($record in $records) {
  $assetRef = Write-Visual -Record $record
  $group = "$($record.id)-parallel-1"

  $json = [ordered]@{
    id = $record.id
    version = 1
    prototypeSequence = $record.sequence
    coreCharacter = $record.char
    coreSharedMeaning = $record.meaning
    recognitionTakeaway = "Prototype draft: $($record.char) anchors the shared meaning '$($record.meaning)' and gives learners a basic symbol for later word and sentence examples."
    publicationStatus = "draft"
    visuals = [ordered]@{
      evolutionAssetRefs = [ordered]@{ regular = $assetRef }
      assetStatus = "prototype-draft"
      note = "Draft app-native visual card for prototype testing. Replace with source-backed historical redraws before publication."
    }
    focusCoverage = [ordered]@{
      simplifiedChinese = [ordered]@{
        form = $record.char
        readings = @([ordered]@{ system = "pinyin"; value = $record.pinyin })
        glosses = @($record.meaning)
        examples = @(
          (New-Example $record.wordSc $record.pinyin $record.meaning "word" $null @() @($record.char)),
          (New-Example $record.sentenceSc $null "Prototype sentence using $($record.meaning)." "sentence" $group $record.reuse $record.intro)
        )
      }
      traditionalChinese = [ordered]@{
        form = $record.char
        readings = @([ordered]@{ system = "pinyin"; value = $record.pinyin })
        glosses = @($record.meaning)
        taiwanExamples = @(
          (New-Example $record.wordTc $record.pinyin $record.meaning "word" $null @() @($record.char)),
          (New-Example $record.sentenceTc $null "Prototype Taiwan sentence using $($record.meaning)." "sentence" $group $record.reuse $record.intro)
        )
        hongKongExamples = @(
          (New-Example $record.wordTc $null $record.meaning "word" $null @() @($record.char)),
          (New-Example $record.sentenceHk $null "Prototype Hong Kong sentence using $($record.meaning)." "sentence" $group $record.reuse $record.intro)
        )
      }
      japanese = [ordered]@{
        form = $record.char
        readings = @([ordered]@{ system = "on"; value = $record.japanese })
        glosses = @($record.meaning)
        examples = @(
          (New-Example $record.wordJp $record.japanese $record.meaning "word" $null @() @($record.char)),
          (New-Example $record.sentenceJp $null "Prototype Japanese sentence using $($record.meaning)." "sentence" $group $record.reuse $record.intro)
        )
      }
      korean = [ordered]@{
        form = $record.char
        readings = @([ordered]@{ system = "hangul"; value = $record.korean })
        glosses = @($record.meaning)
        examples = @(
          (New-Example $record.wordKr $record.korean $record.meaning "word" $null @() @($record.char)),
          (New-Example $record.sentenceKr $null "Prototype Korean sentence using $($record.meaning)." "sentence" $group $record.reuse $record.intro)
        )
      }
    }
    history = [ordered]@{
      originAnchor = "Prototype visual anchor for $($record.char). Replace with source-backed historical origin notes before publication."
      stages = @(
        [ordered]@{
          stage = "regular"
          label = "Regular Script"
          form = $record.char
          assetRef = $assetRef
          changeNoteFromPrevious = $null
          certainty = "limited"
          sourceIds = @("source-prototype-visual")
          historicalSound = $null
        }
      )
    }
    structure = [ordered]@{
      summary = "Prototype structure note for $($record.char). Replace with source-backed character/component explanation before publication."
      components = @([ordered]@{ label = $record.char; role = "prototype symbol"; meaningHint = $record.meaning })
      certainty = "limited"
      caveat = "Prototype placeholder; source-backed structure review required before publication."
      sourceIds = @("source-prototype-visual")
    }
    usage = [ordered]@{
      coreMeaningFirst = "Prototype usage starts with a word-level example and then a basic sentence, preferably reusing earlier symbols where possible."
      notes = @("Prototype examples are for app-flow testing and require native-speaker/editorial review before publication.")
    }
    sources = @(
      [ordered]@{
        id = "source-prototype-visual"
        label = "Prototype visual and usage placeholder"
        type = "prototype"
        citation = "Internal draft asset and example placeholder for Prototype 1 testing; not publication-ready."
      }
    )
    notes = @(
      "Prototype 1 record generated for app testing.",
      "Visual asset is a draft app-native card, not a source-backed historical form."
    )
  }

  $json |
    ConvertTo-Json -Depth 30 |
    Set-Content -Path (Join-Path $contentPath "$($record.id).json") -Encoding utf8
}

Write-Output "OK: wrote $($records.Count) prototype corpus record(s) and visual asset(s)."
