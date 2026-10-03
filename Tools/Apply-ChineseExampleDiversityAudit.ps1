param(
    [string]$SymbolsPath = "content/release/symbols"
)

$ErrorActionPreference = "Stop"

function New-ChineseExample([hashtable]$Definition, [string]$Language, [string]$CoreCharacter) {
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

function Replace-ChineseExample($Examples, [string]$OldText, [hashtable]$Definition, [string]$Language, [string]$CoreCharacter) {
    $rows = [System.Collections.ArrayList]@($Examples)
    $matches = @($rows | Where-Object { $_.text -eq $OldText })
    if ($matches.Count -ne 1) {
        throw "Expected exactly one Chinese example '$OldText', found $($matches.Count)."
    }
    if (@($rows | Where-Object { $_.text -eq $Definition.text }).Count -gt 0) {
        throw "Replacement Chinese example already exists '$($Definition.text)'."
    }
    $index = [array]::IndexOf(@($rows), $matches[0])
    $rows[$index] = New-ChineseExample $Definition $Language $CoreCharacter
    return @($rows)
}

# This is deliberately a row-level map rather than a generator. Each row was
# reviewed as a Chinese word or sentence so the regional lanes remain useful;
# the pass only changes examples and never edits readings, equivalents, or
# any Japanese/Korean content.
$replacements = @{
    auspicious = @{ TW = @{ old = "吉祥物"; text = "吉祥話"; reading = "jíxiánghuà"; translation = "auspicious saying" } }
    bamboo = @{ TW = @{ old = "竹葉"; text = "竹竿"; reading = "zhúgān"; translation = "bamboo pole" } }
    bean = @{ TW = @{ old = "豆漿"; text = "豆芽"; reading = "dòuyá"; translation = "bean sprouts" } }
    before = @{ HK = @{ old = "先後"; text = "先例"; reading = "sin1 lai6"; translation = "precedent" } }
    below = @{ TW = @{ old = "下雨"; text = "下午"; reading = "xiàwǔ"; translation = "afternoon" } }
    child = @{ TW = @{ old = "兒童"; text = "兒歌"; reading = "érgē"; translation = "children's song" } }
    classic = @{ HK = @{ old = "典型"; text = "典故"; reading = "din2 gu3"; translation = "historical allusion" } }
    cloud = @{ TW = @{ old = "天上有白雲。"; text = "雲海很壯觀。"; reading = "yúnhǎi hěn zhuàngguān."; translation = "The sea of clouds is magnificent." } }
    command = @{ HK = @{ old = "令牌"; text = "號令"; reading = "hou6 ling6"; translation = "issue an order" } }
    day = @{
        TW = @{ old = "日光"; text = "日常"; reading = "rìcháng"; translation = "daily life" }
        HK = @{ old = "日光"; text = "日落"; reading = "jat6 lok6"; translation = "sunset" }
    }
    divide = @{
        TW = @{ old = "分量"; text = "分店"; reading = "fēndiàn"; translation = "branch store" }
        HK = @{ old = "分量"; text = "分寸"; reading = "fan1 cyun3"; translation = "sense of proportion" }
    }
    dog = @{ TW = @{ old = "警犬"; text = "導盲犬"; reading = "dǎomángquǎn"; translation = "guide dog" } }
    ear = @{ TW = @{ old = "耳鳴"; text = "耳語"; reading = "ěryǔ"; translation = "whisper" } }
    earth = @{ TW = @{ old = "泥土很乾。"; text = "土地很肥沃。"; reading = "tǔdì hěn féiwò."; translation = "The land is fertile." } }
    enter = @{ TW = @{ old = "入場"; text = "入座"; reading = "rùzuò"; translation = "take one's seat" } }
    evening = @{ HK = @{ old = "夕照"; text = "暮色"; reading = "mou6 sik1"; translation = "evening twilight" } }
    exit = @{ HK = @{ old = "出境"; text = "出口"; reading = "ceot1 hau2"; translation = "exit / outlet" } }
    friend = @{ HK = @{ old = "佢係我好友。"; text = "佢有好多朋友。"; reading = "keoi5 jau5 hou2 do1 pang4 jau5."; translation = "He/She has many friends." } }
    gather = @{ TW = @{ old = "採集"; text = "集合"; reading = "jíhé"; translation = "assemble / gather" } }
    guard = @{ HK = @{ old = "守門"; text = "門衛"; reading = "mun4 wai6"; translation = "gate guard" } }
    head = @{ TW = @{ old = "這首歌很好聽。"; text = "這位是我們的首長。"; reading = "zhè wèi shì wǒmen de shǒuzhǎng."; translation = "This is our leader." } }
    join = @{ TW = @{ old = "合約"; text = "合併"; reading = "hébìng"; translation = "merge" } }
    king = @{ TW = @{ old = "他是國王。"; text = "王室住在宮殿裡。"; reading = "wángshì zhù zài gōngdiàn lǐ."; translation = "The royal family lives in the palace." } }
    life = @{ TW = @{ old = "我喜歡這裡的生活。"; text = "這座城市充滿生機。"; reading = "zhè zuò chéngshì chōngmǎn shēngjī."; translation = "This city is full of vitality." } }
    lodging = @{ HK = @{ old = "宿營"; text = "宿醉"; reading = "suk1 zeoi3"; translation = "hangover" } }
    long = @{
        TW = @{ old = "長大"; text = "長期"; reading = "chángqí"; translation = "long term" }
        HK = @{ old = "長大"; text = "長久"; reading = "coeng4 gau2"; translation = "long-lasting" }
    }
    middle = @{
        TW = @{ old = "中部"; text = "中秋"; reading = "zhōngqiū"; translation = "Mid-Autumn Festival" }
        HK = @{ old = "中部"; text = "中環"; reading = "zung1 waan4"; translation = "Central district" }
    }
    mother = @{ HK = @{ old = "母親"; text = "母女"; reading = "mou5 neoi5"; translation = "mother and daughter" } }
    'old-u53e4' = @{ HK = @{ old = "呢座係古城。"; text = "呢件係古董。"; reading = "ni1 gin6 hai6 gu2 dung2."; translation = "This is an antique." } }
    'older-brother' = @{ HK = @{ old = "兄長"; text = "兄嫂"; reading = "hing1 sou2"; translation = "elder brother and sister-in-law" } }
    one = @{ TW = @{ old = "一同"; text = "一律"; reading = "yīlǜ"; translation = "uniformly / without exception" } }
    ox = @{ HK = @{ old = "牛車"; text = "牛扒"; reading = "ngau4 paa4"; translation = "steak" } }
    public = @{ HK = @{ old = "公務"; text = "公民"; reading = "gung1 man4"; translation = "citizen" } }
    rain = @{ HK = @{ old = "雨傘"; text = "雨聲"; reading = "jyu5 sing1"; translation = "sound of rain" } }
    red = @{ TW = @{ old = "他赤腳走路。"; text = "紅包放在桌上。"; reading = "hóngbāo fàng zài zhuō shàng."; translation = "The red envelope is on the table." } }
    river = @{ HK = @{ old = "山川好靚。"; text = "條河流好寬。"; reading = "tiu4 ho4 lau4 hou2 fun1."; translation = "The river is wide." } }
    sacrifice = @{ HK = @{ old = "祭典"; text = "祭祀祖先"; reading = "zai3 zi6 zou2 sin1"; translation = "worship ancestors" } }
    same = @{
        TW = @{ old = "胡同"; text = "同事"; reading = "tóngshì"; translation = "colleague" }
        HK = @{ old = "胡同"; text = "同屋"; reading = "tung4 uk1"; translation = "housemate / roommate" }
    }
    sheep = @{ TW = @{ old = "草地上有羊。"; text = "羊肉爐很有名。"; reading = "yángròulú hěn yǒumíng."; translation = "Mutton hot pot is famous." } }
    speech = @{ TW = @{ old = "他正在發言。"; text = "媒體常討論這項言論。"; reading = "méitǐ cháng tǎolùn zhè xiàng yánlùn."; translation = "The media often discuss this remark." } }
    stand = @{ TW = @{ old = "請立正。"; text = "立刻回到座位。"; reading = "lìkè huí dào zuòwèi."; translation = "Return to your seat immediately." } }
    stop = @{ TW = @{ old = "請停止。"; text = "前方施工，請止步。"; reading = "qiánfāng shīgōng, qǐng zhǐbù."; translation = "Construction ahead; please stop." } }
    stretch = @{ HK = @{ old = "申訴"; text = "申明立場"; reading = "san1 ming4 lap6 coeng4"; translation = "state a position" } }
    summer = @{ HK = @{ old = "夏夜"; text = "夏至日最長。"; reading = "haa6 zi3 jat6 zeoi3 coeng4."; translation = "The summer solstice has the longest day." } }
    sweet = @{ TW = @{ old = "這個水果很甘甜。"; text = "甘藷是常見的點心。"; reading = "gānshǔ shì chángjiàn de diǎnxīn."; translation = "Sweet potato is a common snack." } }
    'turn-back' = @{ HK = @{ old = "反應"; text = "佢開始反省自己。"; reading = "keoi5 hoi1 ci2 faan2 saang2 zi6 gei2."; translation = "He/She began self-reflection." } }
    two = @{ HK = @{ old = "二手"; text = "兩個人一齊行。"; reading = "loeng5 go3 jan4 jat1 cai4 haang4."; translation = "Two people walk together." } }
    upright = @{ TW = @{ old = "正月"; text = "正午陽光最強。"; reading = "zhèngwǔ yángguāng zuì qiáng."; translation = "The noon sun is strongest." } }
    walk = @{ TW = @{ old = "走廊"; text = "他在路上走失了。"; reading = "tā zài lùshàng zǒushī le."; translation = "He got lost on the way." } }
    wife = @{ HK = @{ old = "妻子"; text = "妻女都在屋企。"; reading = "cai1 neoi5 dou1 zoi6 uk1 kei2."; translation = "His wife and daughter are at home." } }
    winter = @{ HK = @{ old = "冬至"; text = "冬瓜湯好好飲。"; reading = "dung1 gwaa1 tong1 hou2 hou2 jam2."; translation = "Winter melon soup is delicious." } }
    woman = @{ TW = @{ old = "她是女生。"; text = "女王出席了典禮。"; reading = "nǚwáng chūxí le diǎnlǐ."; translation = "The queen attended the ceremony." } }
    work = @{ TW = @{ old = "我在工作。"; text = "工資已經發下來了。"; reading = "gōngzī yǐjīng fā xiàlái le."; translation = "The wages have been paid." } }
}

$laneProperty = @{ TW = "taiwanExamples"; HK = "hongKongExamples" }
$language = @{ TW = "mandarin"; HK = "cantonese" }
$preflightIssues = [System.Collections.ArrayList]@()

foreach ($folder in Get-ChildItem -LiteralPath $SymbolsPath -Directory) {
    $path = Join-Path $folder.FullName "symbol.json"
    if (-not (Test-Path -LiteralPath $path)) { continue }
    $record = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json -Depth 100
    $id = [string]$record.id
    if (-not $replacements.ContainsKey($id)) { continue }
    foreach ($lane in @("TW", "HK")) {
        if (-not $replacements[$id].ContainsKey($lane)) { continue }
        $definition = $replacements[$id][$lane]
        $property = $laneProperty[$lane]
        $rows = @($record.focusCoverage.traditionalChinese.$property)
        $oldCount = @($rows | Where-Object { $_.text -eq $definition.old }).Count
        $newCount = @($rows | Where-Object { $_.text -eq $definition.text }).Count
        if ($oldCount -eq 0 -and $newCount -eq 1) { continue }
        if ($oldCount -ne 1) {
            [void]$preflightIssues.Add("$id [$lane] missing or duplicate '$($definition.old)'")
        }
        if ($newCount -gt 0) {
            [void]$preflightIssues.Add("$id [$lane] replacement already exists '$($definition.text)'")
        }
    }
}

if ($preflightIssues.Count -gt 0) {
    throw "Chinese example audit preflight failed:`n$($preflightIssues -join "`n")"
}

foreach ($folder in Get-ChildItem -LiteralPath $SymbolsPath -Directory) {
    $path = Join-Path $folder.FullName "symbol.json"
    if (-not (Test-Path -LiteralPath $path)) { continue }
    $record = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json -Depth 100
    $id = [string]$record.id
    if (-not $replacements.ContainsKey($id)) { continue }
    $core = [string]$record.coreCharacter
    foreach ($lane in @("TW", "HK")) {
        if (-not $replacements[$id].ContainsKey($lane)) { continue }
        $definition = $replacements[$id][$lane]
        $property = $laneProperty[$lane]
        $rows = @($record.focusCoverage.traditionalChinese.$property)
        if (@($rows | Where-Object { $_.text -eq $definition.old }).Count -eq 0 -and @($rows | Where-Object { $_.text -eq $definition.text }).Count -eq 1) { continue }
        $record.focusCoverage.traditionalChinese.$property = Replace-ChineseExample $record.focusCoverage.traditionalChinese.$property $definition.old $definition $language[$lane] $core
    }
    $record | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $path -Encoding utf8
}

Write-Output "Applied the scoped Chinese regional example diversity audit to $($replacements.Count) Symbol records."
