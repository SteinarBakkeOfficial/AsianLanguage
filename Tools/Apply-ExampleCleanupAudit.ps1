param(
    [string]$SymbolsPath = "content/release/symbols"
)

$ErrorActionPreference = "Stop"

function New-Example([hashtable]$Definition, [string]$Language, [string]$CoreCharacter) {
    [ordered]@{
        text = $Definition.text
        reading = $Definition.reading
        translation = $Definition.translation
        speechText = $Definition.text
        speechLanguage = $Language
        showsCoreMeaning = $true
        exampleLevel = "word"
        parallelExampleGroupID = $null
        reusesKnownSymbols = @()
        introducedSymbols = @($CoreCharacter)
    }
}

function New-JapaneseExample([hashtable]$Definition, [string]$CoreCharacter) {
    [ordered]@{
        text = $Definition.text
        reading = $Definition.romanization
        translation = $Definition.translation
        speechText = $Definition.text
        speechLanguage = "japanese"
        showsCoreMeaning = $true
        exampleLevel = "word"
        parallelExampleGroupID = $null
        reusesKnownSymbols = @()
        introducedSymbols = @($CoreCharacter)
        kanaReading = $Definition.kana
        coversReadings = @()
        furiganaSegments = @([ordered]@{ text = $Definition.text; reading = $Definition.kana })
        furiganaHtml = "<ruby>$($Definition.text)<rt>$($Definition.kana)</rt></ruby>"
    }
}

function Replace-Row($Examples, [string]$OldText, [hashtable]$Definition, [string]$Language, [string]$CoreCharacter, [bool]$Japanese = $false) {
    $rows = [System.Collections.ArrayList]@($Examples)
    $matches = @($rows | Where-Object { $_.text -eq $OldText })
    $existingReplacement = @($rows | Where-Object { $_.text -eq $Definition.text })
    if ($existingReplacement.Count -eq 1 -and $matches.Count -le 1) { return @($rows) }
    if ($matches.Count -lt 1) { throw "Expected at least one row '$OldText', found none." }
    if ($existingReplacement.Count -gt 0) { throw "Replacement already exists '$($Definition.text)'." }
    # When the same written word appears twice, replace the final occurrence;
    # the first remains as the primary useful example and the duplicate slot is
    # the one being corrected.
    $index = [array]::IndexOf(@($rows), $matches[$matches.Count - 1])
    $rows[$index] = if ($Japanese) { New-JapaneseExample $Definition $CoreCharacter } else { New-Example $Definition $Language $CoreCharacter }
    return @($rows)
}

function New-Equivalent([string]$Text, [string]$Reading, [string]$Gloss, [string]$System, [string]$Language, [string]$Origin) {
    [ordered]@{
        system = "semanticEquivalent"
        value = "$Text — $Reading"
        audioAssetRef = $null
        speechText = $Text
        speechLanguage = $Language
        nativeReading = $Text
        romanization = $Reading
        relationship = "$Origin semantic equivalent; not a reading of the shared character."
        gloss = $Gloss
        displayTier = "secondary"
        lexicalOrigin = $Origin
    }
}

function Remove-DuplicateEquivalents($Equivalents) {
    $seen = @{}
    $result = [System.Collections.ArrayList]::new()
    foreach ($equivalent in @($Equivalents)) {
        if ($null -eq $equivalent) { continue }
        $key = ("$($equivalent.speechLanguage)|$($equivalent.speechText)|$($equivalent.romanization)|$($equivalent.gloss)").ToLowerInvariant()
        if (-not $seen.ContainsKey($key)) {
            [void]$seen.Add($key, $true)
            [void]$result.Add($equivalent)
        }
    }
    # Preserve the collection object when it contains one item; otherwise
    # PowerShell unwraps it during assignment and ConvertTo-Json emits an
    # object where Swift expects an array.
    return ,$result
}

# Remaining regional clones and within-lane duplicate translations. These are
# explicit because a generic synonym generator cannot judge lexical meaning.
$regional = @{
    benefit = @{
        TW = @{ old = "利用"; text = "利潤"; reading = "lìrùn"; translation = "profit margin" }
        HK = @{ old = "利用"; text = "利是"; reading = "lai6 si6"; translation = "lucky money" }
    }
    few = @{
        TW = @{ old = "少年"; text = "少量"; reading = "shǎoliàng"; translation = "small quantity" }
        HK = @{ old = "少年"; text = "少少"; reading = "siu2 siu2"; translation = "a little" }
    }
    take = @{
        TW = @{ old = "取錢"; text = "取票"; reading = "qǔpiào"; translation = "take a ticket" }
        HK = @{ old = "取錢"; text = "取笑"; reading = "ceoi2 siu3"; translation = "make fun of" }
    }
    well = @{
        TW = @{ old = "井口"; text = "井蓋"; reading = "jǐnggài"; translation = "well cover" }
        HK = @{ old = "井口"; text = "井架"; reading = "zeng2 gaa3"; translation = "well rig" }
    }
}

$duplicates = @{
    bow = @(
        @{ lane = "TW"; old = "弓箭手"; text = "弓弦"; reading = "gōngxián"; translation = "bowstring"; language = "mandarin" },
        @{ lane = "K"; old = "궁술"; text = "국궁"; reading = "gukgung"; translation = "Korean traditional archery"; language = "korean" }
    )
    auspicious = @(
        @{ lane = "S"; old = "吉利"; text = "吉祥物"; reading = "jíxiángwù"; translation = "mascot"; language = "mandarin" },
        @{ lane = "HK"; old = "吉日"; text = "吉利"; reading = "gat1 lei6"; translation = "lucky / auspicious"; language = "cantonese" }
    )
    bright = @(@{ lane = "HK"; old = "明白"; text = "明朗"; reading = "ming4 long5"; translation = "bright / cheerful"; language = "cantonese" })
    classic = @(@{ lane = "TW"; old = "典禮"; text = "典型"; reading = "diǎnxíng"; translation = "typical example"; language = "mandarin" })
    command = @(@{ lane = "HK"; old = "命令"; text = "令牌"; reading = "ling6 paai4"; translation = "token / pass"; language = "cantonese" })
    earth = @(@{ lane = "S"; old = "土壤"; text = "土豆"; reading = "tǔdòu"; translation = "potato"; language = "mandarin" })
    evening = @(
        @{ lane = "TW"; old = "夕陽"; text = "夕照"; reading = "xīzhào"; translation = "evening sunlight"; language = "mandarin" },
        @{ lane = "HK"; old = "夕陽"; text = "夕照"; reading = "zik6 ziu3"; translation = "evening sunlight"; language = "cantonese" }
    )
    friend = @(@{ lane = "TW"; old = "友誼"; text = "友善"; reading = "yǒushàn"; translation = "friendly / kind"; language = "mandarin" })
    gather = @(
        @{ lane = "TW"; old = "採訪"; text = "採集"; reading = "cǎijí"; translation = "collect / gather"; language = "mandarin" },
        @{ lane = "HK"; old = "採摘"; text = "採購"; reading = "coi2 kau3"; translation = "procurement"; language = "cantonese" }
    )
    guard = @(@{ lane = "HK"; old = "守護"; text = "守時"; reading = "sau2 si4"; translation = "punctual"; language = "cantonese" })
    lodging = @(@{ lane = "HK"; old = "宿舍"; text = "宿命"; reading = "suk1 ming6"; translation = "fate / destiny"; language = "cantonese" })
    'look-toward' = @(@{ lane = "HK"; old = "望遠鏡"; text = "望月"; reading = "mong6 jyut6"; translation = "moon viewing"; language = "cantonese" })
    man = @(@{ lane = "TW"; old = "男孩"; text = "男子"; reading = "nánzǐ"; translation = "man / male person"; language = "mandarin" })
    martial = @(
        @{ lane = "TW"; old = "武術"; text = "武力"; reading = "wǔlì"; translation = "military force"; language = "mandarin" },
        @{ lane = "HK"; old = "武器"; text = "武裝"; reading = "mou5 zong1"; translation = "armed forces / equipment"; language = "cantonese" },
        @{ lane = "K"; old = "무도"; text = "무력"; reading = "muryeok"; translation = "military force"; language = "korean" }
    )
    meet = @(@{ lane = "TW"; old = "交流"; text = "交際"; reading = "jiāojì"; translation = "social interaction"; language = "mandarin" })
    middle = @(@{ lane = "K"; old = "중앙"; text = "중간"; reading = "junggan"; translation = "middle / in between"; language = "korean" })
    mother = @(@{ lane = "TW"; old = "母語"; text = "母親"; reading = "mǔqīn"; translation = "mother"; language = "mandarin" })
    'old-u53e4' = @(@{ lane = "TW"; old = "古代"; text = "古蹟"; reading = "gǔjī"; translation = "historic site"; language = "mandarin" })
    public = @(
        @{ lane = "TW"; old = "公園"; text = "公務"; reading = "gōngwù"; translation = "public service"; language = "mandarin" },
        @{ lane = "HK"; old = "公司"; text = "公務"; reading = "gung1 mou6"; translation = "public service"; language = "cantonese" }
    )
    river = @(@{ lane = "HK"; old = "山川"; text = "川流"; reading = "cyun1 lau4"; translation = "river flow"; language = "cantonese" })
    sacrifice = @(@{ lane = "HK"; old = "祭品"; text = "祭典"; reading = "zai3 din2"; translation = "ritual ceremony"; language = "cantonese" })
    sky = @(@{ lane = "TW"; old = "天氣"; text = "天文"; reading = "tiānwén"; translation = "astronomy"; language = "mandarin" })
    stop = @(@{ lane = "TW"; old = "止痛"; text = "止血"; reading = "zhǐxuè"; translation = "stop bleeding"; language = "mandarin" })
    strength = @(@{ lane = "TW"; old = "力氣"; text = "力量"; reading = "lìliàng"; translation = "strength / power"; language = "mandarin" })
    stretch = @(
        @{ lane = "TW"; old = "申請"; text = "申訴"; reading = "shēnsù"; translation = "appeal / complaint"; language = "mandarin" },
        @{ lane = "HK"; old = "申報"; text = "申訴"; reading = "san1 sou3"; translation = "appeal / complaint"; language = "cantonese" }
    )
    summer = @(@{ lane = "K"; old = "하계휴가"; text = "하계훈련"; reading = "hagyehunryeon"; translation = "summer training"; language = "korean" })
    sweet = @(@{ lane = "J"; old = "甘さ"; text = "甘党"; kana = "あまとう"; romanization = "amatō"; translation = "person with a sweet tooth"; language = "japanese" })
    tongue = @(@{ lane = "TW"; old = "舌尖"; text = "舌癌"; reading = "shé'ái"; translation = "tongue cancer"; language = "mandarin" })
    tree = @(@{ lane = "HK"; old = "木門"; text = "木工"; reading = "muk6 gung1"; translation = "woodworking"; language = "cantonese" })
    'turn-back' = @(@{ lane = "TW"; old = "反對"; text = "反應"; reading = "fǎnyìng"; translation = "reaction"; language = "mandarin" })
    two = @(
        @{ lane = "TW"; old = "二月"; text = "二手"; reading = "èrshǒu"; translation = "secondhand"; language = "mandarin" },
        @{ lane = "HK"; old = "二樓"; text = "二手"; reading = "ji6 sau2"; translation = "secondhand"; language = "cantonese" }
    )
    walk = @(@{ lane = "HK"; old = "走廊"; text = "走路"; reading = "zau2 lou6"; translation = "walk"; language = "cantonese" })
    winter = @(@{ lane = "K"; old = "동절기"; text = "겨울철"; reading = "gyeoulcheol"; translation = "wintertime"; language = "korean" })
}

$japaneseLane = @{ J = "japanese" }
$regionalLane = @{ S = "examples"; TW = "taiwanExamples"; HK = "hongKongExamples" }

foreach ($folder in Get-ChildItem -LiteralPath $SymbolsPath -Directory) {
    $path = Join-Path $folder.FullName "symbol.json"
    if (-not (Test-Path -LiteralPath $path)) { continue }
    $record = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json -Depth 100
    $id = [string]$record.id
    $core = [string]$record.coreCharacter

    if ($regional.ContainsKey($id)) {
        foreach ($lane in @("TW", "HK")) {
            $d = $regional[$id][$lane]
            $property = $regionalLane[$lane]
            $record.focusCoverage.traditionalChinese.$property = Replace-Row $record.focusCoverage.traditionalChinese.$property $d.old $d $(if ($lane -eq "HK") { "cantonese" } else { "mandarin" }) $core
        }
    }

    if ($duplicates.ContainsKey($id)) {
        foreach ($d in @($duplicates[$id])) {
            if ($d.lane -eq "J") {
                $record.focusCoverage.japanese.examples = Replace-Row $record.focusCoverage.japanese.examples $d.old $d "japanese" $core $true
            } elseif ($d.lane -eq "K") {
                $record.focusCoverage.korean.examples = Replace-Row $record.focusCoverage.korean.examples $d.old $d "korean" $core
            } else {
                if ($d.lane -eq "S") {
                    $record.focusCoverage.simplifiedChinese.examples = Replace-Row $record.focusCoverage.simplifiedChinese.examples $d.old $d $d.language $core
                } else {
                    $property = $regionalLane[$d.lane]
                    $record.focusCoverage.traditionalChinese.$property = Replace-Row $record.focusCoverage.traditionalChinese.$property $d.old $d $d.language $core
                }
            }
        }
    }

    # These are direct lexical words for Clothing, not narrower usage examples.
    if ($id -eq "clothing") {
        $s = $record.focusCoverage.simplifiedChinese
        $t = $record.focusCoverage.traditionalChinese
        $j = $record.focusCoverage.japanese
        $k = $record.focusCoverage.korean
        if (@($s.semanticEquivalents | Where-Object { $_.nativeReading -eq "衣服" }).Count -eq 0) {
            $s.semanticEquivalents = @($s.semanticEquivalents) + (New-Equivalent "衣服" "yīfu" "clothes / clothing" "pinyin" "mandarin" "modernChinese")
            $s.examples = @($s.examples) + (New-Example @{ text = "衣架"; reading = "yījià"; translation = "clothes hanger" } "mandarin" $core)
        }
        if (-not ($t.PSObject.Properties.Name -contains "taiwanSemanticEquivalents")) {
            $t | Add-Member -MemberType NoteProperty -Name "taiwanSemanticEquivalents" -Value @()
        }
        if (-not ($t.PSObject.Properties.Name -contains "hongKongSemanticEquivalents")) {
            $t | Add-Member -MemberType NoteProperty -Name "hongKongSemanticEquivalents" -Value @()
        }
        if (@($t.taiwanSemanticEquivalents | Where-Object { $_.nativeReading -eq "衣服" }).Count -eq 0) {
            $t.taiwanSemanticEquivalents = @($t.taiwanSemanticEquivalents) + (New-Equivalent "衣服" "yīfú" "clothes / clothing" "pinyin" "mandarin" "modernChinese")
        }
        if (@($t.hongKongSemanticEquivalents | Where-Object { $_.nativeReading -eq "衣服" }).Count -eq 0) {
            $t.hongKongSemanticEquivalents = @($t.hongKongSemanticEquivalents) + (New-Equivalent "衣服" "ji1 fuk6" "clothes / clothing" "jyutping" "cantonese" "modernChinese")
        }
        if (@($j.semanticEquivalents | Where-Object { $_.nativeReading -eq "衣類" }).Count -eq 0) {
            $j.examples = Replace-Row $j.examples "衣類" @{ text = "衣料品"; kana = "いりょうひん"; romanization = "iryōhin"; translation = "clothing goods" } "japanese" $core $true
            $j.semanticEquivalents = @($j.semanticEquivalents) + (New-Equivalent "衣類" "irui" "clothes / garments" "semanticEquivalent" "japanese" "nativeJapanese")
        }
        if (@($k.semanticEquivalents | Where-Object { $_.nativeReading -eq "의류" }).Count -eq 0) {
            $k.examples = Replace-Row $k.examples "의류" @{ text = "의류점"; reading = "uiryujeom"; translation = "clothing store" } "korean" $core
            $k.semanticEquivalents = @($k.semanticEquivalents) + (New-Equivalent "의류" "uiryu" "clothing" "semanticEquivalent" "korean" "nativeKorean")
        }
        $hangers = @($s.examples | Where-Object { $_.text -eq "衣架" })
        if ($hangers.Count -gt 1) {
            $keptHanger = $hangers[0]
            $s.examples = @($s.examples | Where-Object { $_.text -ne "衣架" }) + $keptHanger
        }
    }

    # Keep the legacy focusCoverage projection idempotent as well as the
    # learner-facing usage projection. Equivalent rows are keyed by their
    # spoken form, romanization, and complete English gloss.
    $s = $record.focusCoverage.simplifiedChinese
    $t = $record.focusCoverage.traditionalChinese
    foreach ($property in @("taiwanSemanticEquivalents", "hongKongSemanticEquivalents")) {
        if (-not ($t.PSObject.Properties.Name -contains $property)) {
            $t | Add-Member -MemberType NoteProperty -Name $property -Value @()
        }
    }
    $record.focusCoverage.simplifiedChinese.semanticEquivalents = Remove-DuplicateEquivalents $s.semanticEquivalents
    $record.focusCoverage.traditionalChinese.taiwanSemanticEquivalents = Remove-DuplicateEquivalents $t.taiwanSemanticEquivalents
    $record.focusCoverage.traditionalChinese.hongKongSemanticEquivalents = Remove-DuplicateEquivalents $t.hongKongSemanticEquivalents
    $record.focusCoverage.japanese.semanticEquivalents = Remove-DuplicateEquivalents $record.focusCoverage.japanese.semanticEquivalents
    $record.focusCoverage.korean.semanticEquivalents = Remove-DuplicateEquivalents $record.focusCoverage.korean.semanticEquivalents

    $record | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $path -Encoding utf8
}

Write-Output "Applied remaining duplicate-meaning cleanup, Clothing classifications, and direct-example replacements."
