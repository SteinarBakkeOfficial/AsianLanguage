param(
    [string]$SymbolsPath = "content/release/symbols"
)

$ErrorActionPreference = "Stop"

function New-EquivalentFromExample($Example, [string]$System, [string]$Language) {
    [ordered]@{
        system = $System
        value = "$($Example.text) — $($Example.reading)"
        audioAssetRef = $null
        speechText = $Example.text
        speechLanguage = $Language
        nativeReading = $Example.text
        romanization = $Example.reading
        gloss = $Example.translation
    }
}

function New-ReplacementExample([hashtable]$Definition, [string]$Language) {
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
        introducedSymbols = @($Definition.character)
    }
}

function New-JapaneseEquivalent([string]$Text, [string]$Reading, [string]$Gloss) {
    [ordered]@{
        system = "semanticEquivalent"
        value = "$Text — $Reading"
        audioAssetRef = $null
        speechText = $Text
        speechLanguage = "japanese"
        nativeReading = $Text
        romanization = $Reading
        gloss = $Gloss
    }
}

function New-JapaneseExample([string]$Character, [string]$Text, [string]$Reading, [string]$Translation) {
    [ordered]@{
        text = $Text
        reading = $Reading
        translation = $Translation
        speechText = $Text
        speechLanguage = "japanese"
        showsCoreMeaning = $true
        exampleLevel = "word"
        parallelExampleGroupID = $null
        reusesKnownSymbols = @()
        introducedSymbols = @($Character)
    }
}

# These are complete lexical equivalents, not compounds whose meaning becomes
# narrower when translated. The removed example is replaced with a new context
# word so every changed lane retains four useful examples.
$definitions = @{
    beautiful = @{ character = "美"; sText = "美术"; twText = "美術"; hkText = "美術"; sReading = "měishù"; twReading = "měishù"; hkReading = "mei5 seot6"; translation = "art" }
    bright = @{ character = "明"; sText = "明月"; twText = "明月"; hkText = "明月"; sReading = "míngyuè"; twReading = "míngyuè"; hkReading = "ming4 jyut6"; translation = "bright moon" }
    child = @{ character = "子"; sText = "儿童"; twText = "兒童"; hkText = "兒童"; sReading = "értóng"; twReading = "értóng"; hkReading = "ji4 tung4"; translation = "children" }
    classic = @{ character = "典"; sText = "古典音乐"; twText = "古典音樂"; hkText = "古典音樂"; sReading = "gǔdiǎn yīnyuè"; twReading = "gǔdiǎn yīnyuè"; hkReading = "gu2 din2 jam1 ngok6"; translation = "classical music" }
    direction = @{ character = "向"; sText = "方向感"; twText = "方向感"; hkText = "方向感"; sReading = "fāngxiànggǎn"; twReading = "fāngxiànggǎn"; hkReading = "fong1 hoeng3 gam2"; translation = "sense of direction" }
    ear = @{ character = "耳"; sText = "耳鸣"; twText = "耳鳴"; hkText = "耳鳴"; sReading = "ěrmíng"; twReading = "ěrmíng"; hkReading = "ji5 ming4"; translation = "ringing in the ears" }
    enter = @{ character = "入"; sText = "入场"; twText = "入場"; hkText = "入場"; sReading = "rùchǎng"; twReading = "rùchǎng"; hkReading = "jap6 coeng4"; translation = "enter the venue" }
    exit = @{ character = "出"; sText = "出境"; twText = "出境"; hkText = "出境"; sReading = "chūjìng"; twReading = "chūjìng"; hkReading = "ceot1 ging2"; translation = "leave the country" }
    follow = @{ character = "从"; sText = "跟随"; twText = "跟隨"; hkText = "跟隨"; sReading = "gēnsuí"; twReading = "gēnsuí"; hkReading = "gan1 ceoi4"; translation = "follow along" }
    forest = @{ character = "林"; sText = "林地"; twText = "林地"; hkText = "林地"; sReading = "líndì"; twReading = "líndì"; hkReading = "lam4 dei6"; translation = "woodland" }
    friend = @{ character = "友"; sText = "友谊"; twText = "友誼"; hkText = "友誼"; sReading = "yǒuyì"; twReading = "yǒuyì"; hkReading = "jau5 ji5"; translation = "friendship" }
    life = @{ character = "生"; sText = "生存"; twText = "生存"; hkText = "生存"; sReading = "shēngcún"; twReading = "shēngcún"; hkReading = "sang1 cyun4"; translation = "survival" }
    man = @{ character = "男"; sText = "男性"; twText = "男性"; hkText = "男性"; sReading = "nánxìng"; twReading = "nánxìng"; hkReading = "naam4 sing3"; translation = "male / man" }
    middle = @{ character = "中"; sText = "中部"; twText = "中部"; hkText = "中部"; sReading = "zhōngbù"; twReading = "zhōngbù"; hkReading = "zung1 bou6"; translation = "central region" }
    moon = @{ character = "月"; sText = "月食"; twText = "月食"; hkText = "月食"; sReading = "yuèshí"; twReading = "yuèshí"; hkReading = "jyut6 sik6"; translation = "lunar eclipse" }
    mother = @{ character = "母"; sText = "母校"; twText = "母校"; hkText = "母校"; sReading = "mǔxiào"; twReading = "mǔxiào"; hkReading = "mou5 haau6"; translation = "alma mater" }
    official = @{ character = "官"; sText = "官职"; twText = "官職"; hkText = "官職"; sReading = "guānzhí"; twReading = "guānzhí"; hkReading = "gun1 zik1"; translation = "official position" }
    public = @{ character = "公"; sText = "公告"; twText = "公告"; hkText = "公告"; sReading = "gōnggào"; twReading = "gōnggào"; hkReading = "gung1 gou3"; translation = "public announcement" }
    rest = @{ character = "休"; sText = "休息室"; twText = "休息室"; hkText = "休息室"; sReading = "xiūxīshì"; twReading = "xiūxīshì"; hkReading = "jau1 sik1 sat1"; translation = "rest room" }
    sky = @{ character = "天"; sText = "天际"; twText = "天際"; hkText = "天際"; sReading = "tiānjì"; twReading = "tiānjì"; hkReading = "tin1 zai3"; translation = "horizon" }
    soldier = @{ character = "兵"; sText = "兵营"; twText = "兵營"; hkText = "兵營"; sReading = "bīngyíng"; twReading = "bīngyíng"; hkReading = "bing1 jing4"; translation = "military barracks" }
    stand = @{ character = "立"; sText = "站台"; twText = "站臺"; hkText = "站臺"; sReading = "zhàntái"; twReading = "zhàntái"; hkReading = "zaam6 toi4"; translation = "platform" }
    stone = @{ character = "石"; sText = "石碑"; twText = "石碑"; hkText = "石碑"; sReading = "shíbēi"; twReading = "shíbēi"; hkReading = "sek6 bei1"; translation = "stone stele" }
    stop = @{ character = "止"; sText = "止血"; twText = "止血"; hkText = "止血"; sReading = "zhǐxuè"; twReading = "zhǐxuè"; hkReading = "zi2 hyut3"; translation = "stop bleeding" }
    strength = @{ character = "力"; sText = "有力"; twText = "有力"; hkText = "有力"; sReading = "yǒulì"; twReading = "yǒulì"; hkReading = "jau5 lik6"; translation = "powerful / strong" }
    summer = @{ character = "夏"; sText = "夏令营"; twText = "夏令營"; hkText = "夏令營"; sReading = "xiàlìngyíng"; twReading = "xiàlìngyíng"; hkReading = "haa6 ling6 jing4"; translation = "summer camp" }
    sweet = @{ character = "甘"; sText = "甘美"; twText = "甘美"; hkText = "甘美"; sReading = "gānměi"; twReading = "gānměi"; hkReading = "gam1 mei5"; translation = "sweet / delicious" }
    tell = @{ character = "告"; sText = "告知"; twText = "告知"; hkText = "告知"; sReading = "gàozhī"; twReading = "gàozhī"; hkReading = "gou3 zi1"; translation = "inform" }
    tiger = @{ character = "虎"; sText = "虎皮"; twText = "虎皮"; hkText = "虎皮"; sReading = "hǔpí"; twReading = "hǔpí"; hkReading = "fu2 pei4"; translation = "tiger skin" }
    tongue = @{ character = "舌"; sText = "舌苔"; twText = "舌苔"; hkText = "舌苔"; sReading = "shétāi"; twReading = "shétāi"; hkReading = "sit6 toi1"; translation = "tongue coating" }
    tree = @{ character = "木"; sText = "木板"; twText = "木板"; hkText = "木板"; sReading = "mùbǎn"; twReading = "mùbǎn"; hkReading = "muk6 baan2"; translation = "wooden board" }
    walk = @{ character = "走"; sText = "走廊"; twText = "走廊"; hkText = "走廊"; sReading = "zǒuláng"; twReading = "zǒuláng"; hkReading = "zau2 long4"; translation = "corridor" }
    wife = @{ character = "妻"; sText = "妻儿"; twText = "妻兒"; hkText = "妻兒"; sReading = "qī'ér"; twReading = "qī'ér"; hkReading = "cai1 ji4"; translation = "wife and children" }
    winter = @{ character = "冬"; sText = "冬眠"; twText = "冬眠"; hkText = "冬眠"; sReading = "dōngmián"; twReading = "dōngmián"; hkReading = "dung1 min4"; translation = "hibernation" }
    woman = @{ character = "女"; sText = "女士"; twText = "女士"; hkText = "女士"; sReading = "nǚshì"; twReading = "nǚshì"; hkReading = "neoi5 si6"; translation = "lady / Ms." }
    work = @{ character = "工"; sText = "工地"; twText = "工地"; hkText = "工地"; sReading = "gōngdì"; twReading = "gōngdì"; hkReading = "gung1 dei6"; translation = "construction site" }
    sheep = @{ character = "羊"; sText = "羊群"; twText = "羊群"; hkText = "羊群"; sReading = "yángqún"; twReading = "yángqún"; hkReading = "joeng4 kwan4"; translation = "flock of sheep" }
}

$movedByID = @{
    beautiful = @{ S = "美丽"; TW = "美麗"; HK = "美麗" }
    bright = @{ S = "明亮"; TW = "明亮"; HK = "明亮" }
    child = @{ S = "孩子"; TW = "孩子" }
    classic = @{ S = "经典"; TW = "經典"; HK = "經典" }
    direction = @{ S = "方向"; TW = "方向"; HK = "方向" }
    ear = @{ S = "耳朵"; TW = "耳朵"; HK = "耳仔" }
    enter = @{ S = "进入"; TW = "進入"; HK = "進入" }
    exit = @{ S = "出口"; TW = "出口"; HK = "出口" }
    follow = @{ S = "跟从"; TW = "跟從"; HK = "跟從" }
    forest = @{ S = "森林"; TW = "森林"; HK = "森林" }
    friend = @{ S = "朋友"; TW = "朋友"; HK = "朋友" }
    life = @{ S = "生命"; TW = "生命"; HK = "生命" }
    man = @{ S = "男人"; TW = "男人"; HK = "男人" }
    middle = @{ S = "中间"; TW = "中間"; HK = "中間" }
    moon = @{ S = "月亮"; TW = "月亮"; HK = "月亮" }
    mother = @{ S = "母亲"; TW = "母親"; HK = "母親" }
    official = @{ S = "官员"; TW = "官員"; HK = "官員" }
    public = @{ S = "公共"; TW = "公共"; HK = "公共" }
    rest = @{ S = "休息"; TW = "休息"; HK = "休息" }
    sky = @{ S = "天空"; TW = "天空"; HK = "天空" }
    soldier = @{ S = "士兵"; TW = "士兵"; HK = "士兵" }
    stand = @{ S = "站立"; TW = "站立" }
    stone = @{ S = "石头"; TW = "石頭"; HK = "石頭" }
    stop = @{ S = "停止"; TW = "停止"; HK = "停止" }
    strength = @{ S = "力量"; TW = "力量"; HK = "力量" }
    summer = @{ S = "夏天"; TW = "夏天"; HK = "夏天" }
    sweet = @{ S = "甘甜"; TW = "甘甜"; HK = "甘甜" }
    tell = @{ S = "告诉"; TW = "告訴"; HK = "告訴" }
    tiger = @{ S = "老虎"; TW = "老虎"; HK = "老虎" }
    tongue = @{ S = "舌头"; TW = "舌頭"; HK = "舌頭" }
    tree = @{ S = "木头"; TW = "木頭"; HK = "木頭" }
    walk = @{ S = "走路"; TW = "走路"; HK = "走路" }
    wife = @{ S = "妻子"; TW = "妻子"; HK = "妻子" }
    winter = @{ S = "冬天"; TW = "冬天"; HK = "冬天" }
    woman = @{ S = "女人"; TW = "女人"; HK = "女人" }
    work = @{ S = "工作"; TW = "工作"; HK = "工作" }
    sheep = @{ TW = "綿羊" }
}

function Update-Lane($Coverage, [string]$Lane, [string]$ID, [string]$CoreCharacter) {
    $definition = $definitions[$ID]
    $move = $movedByID[$ID].$Lane
    if ($null -eq $definition -or [string]::IsNullOrWhiteSpace($move)) { return }

    $examplesProperty = if ($Lane -eq "S") { "examples" } elseif ($Lane -eq "TW") { "taiwanExamples" } else { "hongKongExamples" }
    $examples = [System.Collections.ArrayList]@($Coverage.$examplesProperty)
    $removed = @($examples | Where-Object { $_.text -eq $move })
    if ($removed.Count -eq 0) {
        $existingEquivalents = if ($Lane -eq "S") { @($Coverage.semanticEquivalents) } elseif ($Lane -eq "TW") { @($Coverage.taiwanSemanticEquivalents) } else { @($Coverage.hongKongSemanticEquivalents) }
        if (@($existingEquivalents | Where-Object { $_.nativeReading -eq $move }).Count -eq 1) { return }
    }
    if ($removed.Count -ne 1) { throw "$ID [$Lane] expected one removable example '$move', found $($removed.Count)." }
    $example = $removed[0]
    [void]$examples.Remove($example)

    $language = if ($Lane -eq "HK") { "cantonese" } else { "mandarin" }
    $system = if ($Lane -eq "HK") { "jyutping" } else { "pinyin" }
    $equivalent = New-EquivalentFromExample $example $system $language
    $equivalent.gloss = $example.translation

    if ($Lane -eq "S") {
        $Coverage.semanticEquivalents = @($Coverage.semanticEquivalents) + $equivalent
        $replacement = [ordered]@{ text = $definition.sText; reading = $definition.sReading; translation = $definition.translation }
    } elseif ($Lane -eq "TW") {
        if (-not ($Coverage.PSObject.Properties.Name -contains "taiwanSemanticEquivalents")) {
            $Coverage | Add-Member -MemberType NoteProperty -Name "taiwanSemanticEquivalents" -Value @()
        }
        $Coverage.taiwanSemanticEquivalents = @($Coverage.taiwanSemanticEquivalents) + $equivalent
        $replacement = [ordered]@{ text = $definition.twText; reading = $definition.twReading; translation = $definition.translation }
    } else {
        if (-not ($Coverage.PSObject.Properties.Name -contains "hongKongSemanticEquivalents")) {
            $Coverage | Add-Member -MemberType NoteProperty -Name "hongKongSemanticEquivalents" -Value @()
        }
        $Coverage.hongKongSemanticEquivalents = @($Coverage.hongKongSemanticEquivalents) + $equivalent
        $replacement = [ordered]@{ text = $definition.hkText; reading = $definition.hkReading; translation = $definition.translation }
    }
    $replacement.character = $CoreCharacter
    [void]$examples.Add((New-ReplacementExample $replacement $language))
    $Coverage.$examplesProperty = @($examples)
}

foreach ($folder in Get-ChildItem -LiteralPath $SymbolsPath -Directory) {
    $path = Join-Path $folder.FullName "symbol.json"
    if (-not (Test-Path -LiteralPath $path)) { continue }
    $record = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json -Depth 100
    $id = [string]$record.id
    if (-not $movedByID.ContainsKey($id) -and $id -notin @("horn", "well", "black", "white", "increase", "body", "direction", "evening", "exit", "forest", "mother", "public", "stretch", "sky")) { continue }

    $core = [string]$record.coreCharacter
    Update-Lane $record.focusCoverage.simplifiedChinese "S" $id $core
    Update-Lane $record.focusCoverage.traditionalChinese "TW" $id $core
    Update-Lane $record.focusCoverage.traditionalChinese "HK" $id $core

    if ($id -eq "strength") {
        foreach ($example in @($record.focusCoverage.simplifiedChinese.examples, $record.focusCoverage.traditionalChinese.taiwanExamples, $record.focusCoverage.traditionalChinese.hongKongExamples)) {
            foreach ($row in @($example)) { if ($row.text -in @("力气", "力氣")) { $row.translation = "physical strength" } }
        }
    }
    if ($id -eq "life") {
        foreach ($example in @($record.focusCoverage.simplifiedChinese.examples, $record.focusCoverage.traditionalChinese.taiwanExamples, $record.focusCoverage.traditionalChinese.hongKongExamples)) {
            foreach ($row in @($example)) { if ($row.text -in @("生活")) { $row.translation = "daily life" } }
        }
    }
    if ($id -eq "well") {
        foreach ($example in @($record.focusCoverage.simplifiedChinese.examples, $record.focusCoverage.traditionalChinese.taiwanExamples, $record.focusCoverage.traditionalChinese.hongKongExamples)) {
            foreach ($row in @($example)) { if ($row.text -eq "水井") { $row.translation = "water well" } }
        }
    }
    if ($id -eq "horn") {
        foreach ($row in @($record.focusCoverage.simplifiedChinese.examples)) { if ($row.text -eq "墙角") { $row.translation = "wall corner" } }
        foreach ($row in @($record.focusCoverage.traditionalChinese.taiwanExamples)) { if ($row.text -eq "屋角") { $row.translation = "house corner" } }
        foreach ($row in @($record.focusCoverage.japanese.examples)) { if ($row.text -eq "角度") { $row.translation = "angle / degree" } }
        foreach ($row in @($record.focusCoverage.korean.examples)) { if ($row.text -eq "각도") { $row.translation = "angle / degree" } }
    }
    if ($id -in @("black", "white")) {
        foreach ($example in @($record.focusCoverage.simplifiedChinese.examples, $record.focusCoverage.traditionalChinese.taiwanExamples, $record.focusCoverage.traditionalChinese.hongKongExamples)) {
            foreach ($row in @($example)) {
                if ($row.text -in @("黑色", "黑色")) { $row.translation = "black color" }
                if ($row.text -in @("白色", "白色")) { $row.translation = "white color" }
            }
        }
    }
    if ($id -eq "increase") {
        foreach ($example in @($record.focusCoverage.simplifiedChinese.examples, $record.focusCoverage.traditionalChinese.taiwanExamples, $record.focusCoverage.traditionalChinese.hongKongExamples)) {
            foreach ($row in @($example)) { if ($row.text -in @("有益")) { $row.translation = "beneficial / useful" } }
        }
    }

    if ($id -eq "friend") {
        $japanese = $record.focusCoverage.japanese
        $friendExamples = [System.Collections.ArrayList]@($japanese.examples)
        foreach ($candidate in @(@{ text = "友達"; reading = "tomodachi"; gloss = "friend" }, @{ text = "友人"; reading = "yūjin"; gloss = "friend" })) {
            $row = @($friendExamples | Where-Object { $_.text -eq $candidate.text })
            if ($row.Count -eq 1) {
                [void]$friendExamples.Remove($row[0])
                if (@($japanese.semanticEquivalents | Where-Object { $_.nativeReading -eq $candidate.text }).Count -eq 0) {
                    $japanese.semanticEquivalents = @($japanese.semanticEquivalents) + (New-JapaneseEquivalent $candidate.text $candidate.reading $candidate.gloss)
                }
            }
        }
        if (@($friendExamples | Where-Object { $_.text -eq "友愛" }).Count -eq 0) { [void]$friendExamples.Add((New-JapaneseExample $core "友愛" "yūai" "friendship / brotherly love")) }
        if (@($friendExamples | Where-Object { $_.text -eq "友好" }).Count -eq 0) { [void]$friendExamples.Add((New-JapaneseExample $core "友好" "yūkō" "friendship / friendly relations")) }
        $japanese.examples = @($friendExamples)
    }

    if ($id -eq "soldier") {
        $japanese = $record.focusCoverage.japanese
        $soldierExamples = [System.Collections.ArrayList]@($japanese.examples)
        foreach ($candidate in @(@{ text = "兵士"; reading = "heishi"; gloss = "soldier" }, @{ text = "兵隊"; reading = "heitai"; gloss = "soldiers / troops" })) {
            $row = @($soldierExamples | Where-Object { $_.text -eq $candidate.text })
            if ($row.Count -eq 1) {
                [void]$soldierExamples.Remove($row[0])
                if (@($japanese.semanticEquivalents | Where-Object { $_.nativeReading -eq $candidate.text }).Count -eq 0) {
                    $japanese.semanticEquivalents = @($japanese.semanticEquivalents) + (New-JapaneseEquivalent $candidate.text $candidate.reading $candidate.gloss)
                }
            }
        }
        if (@($soldierExamples | Where-Object { $_.text -eq "兵営" }).Count -eq 0) { [void]$soldierExamples.Add((New-JapaneseExample $core "兵営" "heiei" "military barracks")) }
        $japanese.examples = @($soldierExamples)
    }

    $japaneseMoves = @{
        body = @{ text = "身体"; reading = "shintai"; gloss = "body"; replacementText = "身近"; replacementReading = "mijika"; replacementTranslation = "close / familiar" }
        direction = @{ text = "方向"; reading = "hōkō"; gloss = "direction" }
        evening = @{ text = "夕方"; reading = "yūgata"; gloss = "evening" }
        exit = @{ text = "出口"; reading = "deguchi"; gloss = "exit" }
        forest = @{ text = "森林"; reading = "shinrin"; gloss = "forest"; replacementText = "森林浴"; replacementReading = "shinrin-yoku"; replacementTranslation = "forest bathing" }
        mother = @{ text = "母親"; reading = "hahaoya"; gloss = "mother"; replacementText = "母語"; replacementReading = "bogo"; replacementTranslation = "mother tongue" }
        public = @{ text = "公共"; reading = "kōkyō"; gloss = "public"; replacementText = "公務"; replacementReading = "kōmu"; replacementTranslation = "public service" }
        stretch = @{ text = "申す"; reading = "mōsu"; gloss = "say (humble)" }
        well = @{ text = "井戸"; reading = "ido"; gloss = "well" }
    }
    if ($japaneseMoves.ContainsKey($id)) {
        $japanese = $record.focusCoverage.japanese
        $move = $japaneseMoves[$id]
        $rows = [System.Collections.ArrayList]@($japanese.examples)
        $candidate = @($rows | Where-Object { $_.text -eq $move.text })
        if ($candidate.Count -eq 1) {
            [void]$rows.Remove($candidate[0])
            if (@($japanese.semanticEquivalents | Where-Object { $_.nativeReading -eq $move.text }).Count -eq 0) {
                $japanese.semanticEquivalents = @($japanese.semanticEquivalents) + (New-JapaneseEquivalent $move.text $move.reading $move.gloss)
            }
            if ($move.ContainsKey("replacementText") -and @($rows | Where-Object { $_.text -eq $move.replacementText }).Count -eq 0) {
                [void]$rows.Add((New-JapaneseExample $core $move.replacementText $move.replacementReading $move.replacementTranslation))
            }
            $japanese.examples = @($rows)
        }
    }
    if ($id -eq "life") {
        foreach ($row in @($record.focusCoverage.japanese.examples)) { if ($row.text -eq "人生") { $row.translation = "human life / lifetime" } }
    }
    if ($id -eq "sky") {
        foreach ($row in @($record.focusCoverage.japanese.examples)) { if ($row.text -eq "天空") { $row.translation = "the heavens / sky" } }
    }

    $record | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $path -Encoding utf8
}

Write-Output "Applied explicit direct-equivalent moves, replacement examples, and scoped compound-gloss corrections to canonical Symbol records."
