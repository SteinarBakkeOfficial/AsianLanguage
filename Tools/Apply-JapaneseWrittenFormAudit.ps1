param(
    [string]$SymbolsPath = "content/release/symbols"
)

$ErrorActionPreference = "Stop"

function Set-Field($Object, [string]$Name, $Value) {
    if ($Object.PSObject.Properties.Name -contains $Name) {
        $Object.$Name = $Value
    } else {
        $Object | Add-Member -MemberType NoteProperty -Name $Name -Value $Value
    }
}

function Convert-ToHiragana([string]$Text) {
    $builder = [System.Text.StringBuilder]::new()
    foreach ($character in $Text.ToCharArray()) {
        $codePoint = [int][char]$character
        if ($codePoint -ge 0x30A1 -and $codePoint -le 0x30F6) {
            [void]$builder.Append([char]($codePoint - 0x60))
        } else {
            [void]$builder.Append($character)
        }
    }
    return $builder.ToString()
}

# Kun'yomi with okurigana must show the actual Japanese spelling rather than
# presenting kana as though it were the written word. Bare character readings
# fall back to the lane's Kanji form below.
$writtenForms = @{
    "above|あがる" = "上がる"; "above|あげる" = "上げる"; "above|のぼる" = "上る"
    "after|うしろ" = "後ろ"
    "altar|しめす" = "示す"
    "beautiful|うつくしい" = "美しい"
    "below|さがる" = "下がる"; "below|さげる" = "下げる"; "below|くだる" = "下る"; "below|おろす" = "下ろす"; "below|おりる" = "下りる"
    "big|おおきい" = "大きい"
    "black|くろい" = "黒い"
    "blessing|いわう" = "祝う"
    "bright|あかるい" = "明るい"; "bright|あかり" = "明かり"; "bright|あきらか" = "明らか"; "bright|あける" = "明ける"; "bright|あく" = "明く"; "bright|あかす" = "明かす"
    "direction|むかう" = "向かう"; "direction|むける" = "向ける"; "direction|むこう" = "向こう"
    "divide|わける" = "分ける"; "divide|わかる" = "分かる"; "divide|わかれる" = "分かれる"; "divide|わかつ" = "分かつ"
    "each|おのおの" = "各々"
    "enter|はいる" = "入る"; "enter|いれる" = "入れる"
    "exit|でる" = "出る"; "exit|だす" = "出す"
    "few|すくない" = "少ない"; "few|すこし" = "少し"
    "follow|したがう" = "従う"; "follow|したがえる" = "従える"
    "fragrance|かおり" = "香り"; "fragrance|かおる" = "香る"
    "gather-u96c6|あつまる" = "集まる"; "gather-u96c6|あつめる" = "集める"; "gather-u96c6|つどう" = "集う"
    "go|いく" = "行く"; "go|ゆく" = "行く"; "go|おこなう" = "行う"
    "good|すく" = "好く"; "good|このむ" = "好む"
    "guard|まもる" = "守る"
    "high|たかい" = "高い"; "high|たかまる" = "高まる"; "high|たかめる" = "高める"
    "join|あわせる" = "合わせる"; "join|あわす" = "合わす"
    "life|いきる" = "生きる"; "life|うまれる" = "生まれる"; "life|うむ" = "生む"; "life|はえる" = "生える"; "life|いかす" = "生かす"; "life|いける" = "生ける"; "life|はやす" = "生やす"
    "light|ひかる" = "光る"
    "lodging|やどる" = "宿る"; "lodging|やどす" = "宿す"
    "long|ながい" = "長い"
    "look-toward|のぞむ" = "望む"
    "many|おおい" = "多い"
    "meet|まじわる" = "交わる"; "meet|まじえる" = "交える"; "meet|かわす" = "交わす"
    "old|おいる" = "老いる"; "old|ふける" = "老ける"
    "old-u53e4|ふるい" = "古い"; "old-u53e4|ふるす" = "古す"
    "one|ひとつ" = "一つ"; "obtain|える" = "得る"
    "reach|およぶ" = "及ぶ"; "reach|および" = "及び"; "reach|およぼす" = "及ぼす"
    "red|あかい" = "赤い"
    "rest|やすむ" = "休む"
    "sacrifice|まつり" = "祭り"; "sacrifice|まつる" = "祭る"
    "same|おなじ" = "同じ"
    "self|みずから" = "自ら"
    "small|ちいさい" = "小さい"
    "speech|いう" = "言う"
    "stand|たつ" = "立つ"; "stand|たてる" = "立てる"
    "step|あるく" = "歩く"; "step|あゆむ" = "歩む"
    "stop|とまる" = "止まる"; "stop|とめる" = "止める"
    "sweet|あまい" = "甘い"; "sweet|あまえる" = "甘える"; "sweet|あまやかす" = "甘やかす"
    "take|とる" = "取る"
    "stretch|もうす" = "申す"
    "tell|つげる" = "告げる"
    "three|みっつ" = "三つ"
    "turn-back|そる" = "反る"; "turn-back|そらす" = "反らす"
    "two|ふたつ" = "二つ"
    "upright|ただしい" = "正しい"; "upright|ただす" = "正す"
    "walk|はしる" = "走る"
    "white|しろい" = "白い"
}

# Semantic-equivalent rows are actual written Japanese words, so their sound
# must use the kana reading rather than the Kanji spelling.
$equivalentFurigana = @{
    "身体" = "しんたい"; "衣類" = "いるい"; "方向" = "ほうこう"; "夕方" = "ゆうがた"
    "出口" = "でぐち"; "森林" = "しんりん"; "友達" = "ともだち"; "友人" = "ゆうじん"
    "母親" = "ははおや"; "公共" = "こうきょう"; "兵士" = "へいし"; "兵隊" = "へいたい"
    "申す" = "もうす"; "井戸" = "いど"
}

# A few replacement examples introduced by the previous audit did not carry
# kana metadata. Keep them playable without changing their wording.
$exampleFurigana = @{
    "身近" = "みぢか"; "森林浴" = "しんりんよく"; "友愛" = "ゆうあい"; "友好" = "ゆうこう"
    "母語" = "ぼご"; "公務" = "こうむ"; "兵営" = "へいえい"
}

# These are reading-specific gloss corrections found during the full semantic
# audit. Keep the correction keyed by Symbol and kana so a future rerun cannot
# accidentally rewrite a different language lane or a different reading.
$readingGlossCorrections = @{
    "below|おりる" = "go down / descend"
    "ear|ジ" = "ear"
    "follow|したがえる" = "make someone follow / command"
    "life|いける" = "arrange flowers"
    "old|ふける" = "look / grow older"
    "turn-back|そらす" = "bend backward / arch"
    "white|しら" = "white (in compounds)"
}

# A word that only repeats the standalone reading gloss wastes one of the
# learner's example slots. Each replacement remains a natural written form,
# retains the lane count, and teaches a distinct use of the same Symbol.
$exampleReplacements = @{
    "big|大きい" = [ordered]@{ text = "大声"; kana = "おおごえ"; reading = "ōgoe"; translation = "loud voice"; coversReadings = @("おお") }
    "field|田んぼ" = [ordered]@{ text = "田舎"; kana = "いなか"; reading = "inaka"; translation = "countryside"; coversReadings = @() }
    "field|田舎" = [ordered]@{ text = "田舎"; kana = "いなか"; reading = "inaka"; translation = "countryside"; coversReadings = @() }
    "middle|中央" = [ordered]@{ text = "中身"; kana = "なかみ"; reading = "nakami"; translation = "contents / substance"; coversReadings = @("なか") }
    "reach|及び" = [ordered]@{ text = "及第"; kana = "きゅうだい"; reading = "kyūdai"; translation = "pass / qualify"; coversReadings = @("キュウ") }
    "things-goods|品物" = [ordered]@{ text = "食品"; kana = "しょくひん"; reading = "shokuhin"; translation = "food products"; coversReadings = @("ヒン") }
}

function Set-JapaneseExampleMetadata($Example, [string]$CoreCharacter, $Replacement) {
    Set-Field $Example "text" $Replacement.text
    Set-Field $Example "reading" $Replacement.reading
    Set-Field $Example "translation" $Replacement.translation
    Set-Field $Example "speechText" $Replacement.kana
    Set-Field $Example "speechLanguage" "japanese"
    Set-Field $Example "showsCoreMeaning" $true
    Set-Field $Example "exampleLevel" "word"
    Set-Field $Example "parallelExampleGroupID" $null
    Set-Field $Example "reusesKnownSymbols" @()
    Set-Field $Example "introducedSymbols" @($CoreCharacter)
    Set-Field $Example "kanaReading" $Replacement.kana
    if ($Replacement.coversReadings.Count -eq 0) {
        $Example.coversReadings = @()
    } else {
        Set-Field $Example "coversReadings" @($Replacement.coversReadings)
    }
    Set-Field $Example "furiganaSegments" @([ordered]@{ text = $Replacement.text; reading = $Replacement.kana })
    Set-Field $Example "furiganaHtml" "<ruby>$($Replacement.text)<rt>$($Replacement.kana)</rt></ruby>"
}

$symbolFolders = @(Get-ChildItem -LiteralPath $SymbolsPath -Directory)
if ($symbolFolders.Count -ne 126) { throw "Japanese written-form audit expected 126 Symbols, found $($symbolFolders.Count)." }

$readingCount = 0
$exampleCount = 0
$equivalentCount = 0
foreach ($folder in $symbolFolders) {
    $path = Join-Path $folder.FullName "symbol.json"
    $record = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json -Depth 100
    $japanese = $record.focusCoverage.japanese

    foreach ($reading in @($japanese.readings)) {
        $readingCount++
        $native = [string]$reading.nativeReading
        if ([string]::IsNullOrWhiteSpace($native)) { throw "$($record.id) has a Japanese reading without nativeReading." }
        $key = "$($record.id)|$native"
        $written = if ($writtenForms.ContainsKey($key)) { $writtenForms[$key] } else { [string]$japanese.form }
        $furigana = Convert-ToHiragana $native
        Set-Field $reading "writtenForm" $written
        Set-Field $reading "furigana" $furigana
        Set-Field $reading "speechText" $furigana
        if ($readingGlossCorrections.ContainsKey($key)) {
            Set-Field $reading "gloss" $readingGlossCorrections[$key]
        }
    }

    foreach ($equivalent in @($japanese.semanticEquivalents)) {
        $equivalentCount++
        $written = [string]$equivalent.nativeReading
        if (-not $equivalentFurigana.ContainsKey($written)) { throw "$($record.id) Japanese equivalent '$written' has no reviewed furigana." }
        Set-Field $equivalent "writtenForm" $written
        Set-Field $equivalent "furigana" $equivalentFurigana[$written]
        Set-Field $equivalent "speechText" $equivalentFurigana[$written]
    }

    # 申す is already displayed as the Japanese lexical reading for 申. It is
    # not a second semantic equivalent, so remove only that duplicate row.
    if ($record.id -eq "stretch") {
        $japanese.semanticEquivalents = @($japanese.semanticEquivalents | Where-Object { [string]$_.nativeReading -ne "申す" })
    }

    foreach ($example in @($japanese.examples)) {
        $exampleCount++
        $kana = [string]$example.kanaReading
        if ([string]::IsNullOrWhiteSpace($kana)) {
            $text = [string]$example.text
            if (-not $exampleFurigana.ContainsKey($text)) { throw "$($record.id) Japanese example '$text' has no kana reading." }
            $kana = $exampleFurigana[$text]
            Set-Field $example "kanaReading" $kana
            Set-Field $example "furiganaSegments" @([ordered]@{ text = $text; reading = $kana })
            Set-Field $example "furiganaHtml" "<ruby>$text<rt>$kana</rt></ruby>"
        }
        Set-Field $example "speechText" $kana

        $replacementKey = "$($record.id)|$($example.text)"
        if ($exampleReplacements.ContainsKey($replacementKey)) {
            Set-JapaneseExampleMetadata $example $japanese.form $exampleReplacements[$replacementKey]
        }

        # 田園 is a useful field example, but its kana and romanization were
        # mistyped. Correct the Japanese metadata without changing its gloss.
        if ($record.id -eq "field" -and [string]$example.text -eq "田園") {
            Set-Field $example "reading" "den'en"
            Set-Field $example "speechText" "でんえん"
            Set-Field $example "kanaReading" "でんえん"
            Set-Field $example "furiganaSegments" @([ordered]@{ text = "田園"; reading = "でんえん" })
            Set-Field $example "furiganaHtml" "<ruby>田園<rt>でんえん</rt></ruby>"
        }
    }

    $record | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $path -Encoding utf8
}

Write-Output "Applied Japanese written-form/furigana metadata to $readingCount readings, $equivalentCount equivalents, and $exampleCount examples across 126 Symbols."
