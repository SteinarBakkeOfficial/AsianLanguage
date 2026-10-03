param(
    [string]$SymbolsPath = "content/release/symbols"
)

$ErrorActionPreference = "Stop"

function New-RegionalExample([hashtable]$Definition, [string]$Language, [string]$CoreCharacter) {
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

function Replace-ExampleAtText($Examples, [string]$OldText, [hashtable]$Definition, [string]$Language, [string]$CoreCharacter) {
    $rows = [System.Collections.ArrayList]@($Examples)
    $matches = @($rows | Where-Object { $_.text -eq $OldText })
    if ($matches.Count -ne 1) {
        throw "Expected exactly one example '$OldText', found $($matches.Count)."
    }
    $index = [array]::IndexOf(@($rows), $matches[0])
    $replacement = New-RegionalExample $Definition $Language $CoreCharacter
    $rows[$index] = $replacement
    return @($rows)
}

function Replace-JapaneseExample($Examples, [string]$OldText, [hashtable]$Definition, [string]$CoreCharacter) {
    $rows = [System.Collections.ArrayList]@($Examples)
    $matches = @($rows | Where-Object { $_.text -eq $OldText })
    if ($matches.Count -ne 1) {
        throw "Expected exactly one Japanese example '$OldText', found $($matches.Count)."
    }
    $index = [array]::IndexOf(@($rows), $matches[0])
    $replacement = New-JapaneseExample $Definition $CoreCharacter
    $rows[$index] = $replacement
    return @($rows)
}

# One deliberately different, natural regional word replaces the third shared
# word example in each cloned Chinese lane. Two shared examples may remain when
# they are genuinely useful comparisons; all four must not be copied wholesale.
$regionalReplacements = @{
    above = @{
        TW = @{ old = "上衣"; text = "上旬"; reading = "shàngxún"; translation = "first ten days of the month" }
        HK = @{ old = "上衣"; text = "上班"; reading = "soeng6 baan1"; translation = "go to work" }
    }
    after = @{
        TW = @{ old = "後來"; text = "後門"; reading = "hòumén"; translation = "back door" }
        HK = @{ old = "後來"; text = "後座"; reading = "hau6 zo6"; translation = "back seat" }
    }
    altar = @{
        TW = @{ old = "示意"; text = "示範"; reading = "shìfàn"; translation = "demonstration" }
        HK = @{ old = "示意"; text = "示威"; reading = "si6 wai1"; translation = "protest" }
    }
    ancestor = @{
        TW = @{ old = "祖宗"; text = "宗旨"; reading = "zōngzhǐ"; translation = "guiding principle" }
        HK = @{ old = "祖宗"; text = "宗派"; reading = "zung1 paai3"; translation = "sect" }
    }
    auspicious = @{
        TW = @{ old = "吉利"; text = "吉祥物"; reading = "jíxiángwù"; translation = "mascot" }
        HK = @{ old = "吉利"; text = "吉日"; reading = "gat1 jat6"; translation = "lucky day" }
    }
    beautiful = @{
        TW = @{ old = "美好"; text = "美容"; reading = "měiróng"; translation = "beauty care" }
        HK = @{ old = "美好"; text = "美食"; reading = "mei5 sik6"; translation = "delicious food" }
    }
    black = @{
        TW = @{ old = "黑板"; text = "黑豆"; reading = "hēidòu"; translation = "black beans" }
        HK = @{ old = "黑板"; text = "黑白"; reading = "hak1 baak6"; translation = "black and white" }
    }
    blessing = @{
        TW = @{ old = "祝福"; text = "祝賀"; reading = "zhùhè"; translation = "congratulate" }
        HK = @{ old = "祝福"; text = "祝酒"; reading = "zuk1 zau2"; translation = "make a toast" }
    }
    body = @{
        TW = @{ old = "身高"; text = "身分"; reading = "shēnfèn"; translation = "identity" }
        HK = @{ old = "身高"; text = "身世"; reading = "san1 sai3"; translation = "family background" }
    }
    book = @{
        TW = @{ old = "冊子"; text = "冊頁"; reading = "cèyè"; translation = "book pages" }
        HK = @{ old = "冊子"; text = "書冊"; reading = "syu1 caak3"; translation = "books" }
    }
    bright = @{
        TW = @{ old = "明月"; text = "明年"; reading = "míngnián"; translation = "next year" }
        HK = @{ old = "明月"; text = "明白"; reading = "ming4 baak6"; translation = "understand / clear" }
    }
    center = @{
        TW = @{ old = "央求"; text = "央視"; reading = "yāngshì"; translation = "CCTV" }
        HK = @{ old = "央求"; text = "中央"; reading = "zung1 joeng1"; translation = "central" }
    }
    classic = @{
        TW = @{ old = "古典音樂"; text = "典禮"; reading = "diǎnlǐ"; translation = "ceremony" }
        HK = @{ old = "古典音樂"; text = "典型"; reading = "din2 jing4"; translation = "typical example" }
    }
    clothing = @{
        TW = @{ old = "衣櫃"; text = "衣襬"; reading = "yībǎi"; translation = "clothing hem" }
        HK = @{ old = "衣櫃"; text = "衣領"; reading = "ji1 ling5"; translation = "collar" }
    }
    command = @{
        TW = @{ old = "口令"; text = "令牌"; reading = "lìngpái"; translation = "token / pass" }
        HK = @{ old = "口令"; text = "命令"; reading = "ming6 ling6"; translation = "command / order" }
    }
    direction = @{
        TW = @{ old = "方向感"; text = "向量"; reading = "xiàngliàng"; translation = "vector" }
        HK = @{ old = "方向感"; text = "向來"; reading = "hoeng3 loi4"; translation = "always / formerly" }
    }
    each = @{
        TW = @{ old = "各有不同。"; text = "各位"; reading = "gèwèi"; translation = "everyone" }
        HK = @{ old = "各有不同。"; text = "各自"; reading = "gok3 zi6"; translation = "each on one’s own" }
    }
    earth = @{
        TW = @{ old = "土壤"; text = "土豆"; reading = "tǔdòu"; translation = "potato" }
        HK = @{ old = "土壤"; text = "土質"; reading = "tou2 zat1"; translation = "soil quality" }
    }
    evening = @{
        TW = @{ old = "除夕"; text = "夕陽"; reading = "xīyáng"; translation = "sunset" }
        HK = @{ old = "除夕"; text = "夕陽"; reading = "zik6 joeng4"; translation = "sunset" }
    }
    exit = @{
        TW = @{ old = "出去"; text = "出發"; reading = "chūfā"; translation = "depart" }
        HK = @{ old = "出去"; text = "出街"; reading = "ceot1 gaai1"; translation = "go out" }
    }
    eye = @{
        TW = @{ old = "目的"; text = "目標"; reading = "mùbiāo"; translation = "goal / target" }
        HK = @{ old = "目的"; text = "目錄"; reading = "muk6 luk6"; translation = "catalogue" }
    }
    field = @{
        TW = @{ old = "田野"; text = "田園"; reading = "tiányuán"; translation = "rural fields" }
        HK = @{ old = "田野"; text = "田徑"; reading = "tin4 ging3"; translation = "track and field" }
    }
    follow = @{
        TW = @{ old = "跟隨"; text = "從不"; reading = "cóngbù"; translation = "never" }
        HK = @{ old = "跟隨"; text = "從不"; reading = "cung4 bat1"; translation = "never" }
    }
    forest = @{
        TW = @{ old = "林地"; text = "林場"; reading = "línchǎng"; translation = "forest farm" }
        HK = @{ old = "林地"; text = "林蔭"; reading = "lam4 jam3"; translation = "tree shade" }
    }
    fragrance = @{
        TW = @{ old = "香水"; text = "香蕉"; reading = "xiāngjiāo"; translation = "banana" }
        HK = @{ old = "香水"; text = "香口膠"; reading = "hoeng1 hau2 gaau1"; translation = "chewing gum" }
    }
    friend = @{
        TW = @{ old = "友好"; text = "友情"; reading = "yǒuqíng"; translation = "friendship" }
        HK = @{ old = "友好"; text = "友善"; reading = "jau5 sin6"; translation = "friendly / kind" }
    }
    gather = @{
        TW = @{ old = "採集"; text = "採訪"; reading = "cǎifǎng"; translation = "interview" }
        HK = @{ old = "採集"; text = "採摘"; reading = "coi2 zaak6"; translation = "pick / gather" }
    }
    'gather-u96c6' = @{
        TW = @{ old = "集中"; text = "集市"; reading = "jíshì"; translation = "market" }
        HK = @{ old = "集中"; text = "集郵"; reading = "zaap6 jau4"; translation = "stamp collecting" }
    }
    group = @{
        TW = @{ old = "族人"; text = "族譜"; reading = "zúpǔ"; translation = "genealogy" }
        HK = @{ old = "族人"; text = "族群"; reading = "zuk6 kwan4"; translation = "ethnic group" }
    }
    guard = @{
        TW = @{ old = "遵守"; text = "守時"; reading = "shǒushí"; translation = "punctual" }
        HK = @{ old = "遵守"; text = "守護"; reading = "sau2 wu6"; translation = "protect / guard" }
    }
    high = @{
        TW = @{ old = "高度"; text = "高原"; reading = "gāoyuán"; translation = "plateau" }
        HK = @{ old = "高度"; text = "高峰"; reading = "gou1 fung1"; translation = "peak" }
    }
    increase = @{
        TW = @{ old = "有益"; text = "益處"; reading = "yìchù"; translation = "benefit" }
        HK = @{ old = "有益"; text = "公益"; reading = "gung1 jik1"; translation = "public welfare" }
    }
    join = @{
        TW = @{ old = "合同"; text = "合約"; reading = "héyuē"; translation = "contract" }
        HK = @{ old = "合同"; text = "合作"; reading = "hap6 zok3"; translation = "cooperation" }
    }
    journey = @{
        TW = @{ old = "旅客"; text = "旅遊"; reading = "lǚyóu"; translation = "travel / tourism" }
        HK = @{ old = "旅客"; text = "旅館"; reading = "lou5 gun2"; translation = "hotel" }
    }
    lodging = @{
        TW = @{ old = "宿命"; text = "宿營"; reading = "sùyíng"; translation = "camp overnight" }
        HK = @{ old = "宿命"; text = "宿舍"; reading = "suk1 se3"; translation = "dormitory" }
    }
    'look-toward' = @{
        TW = @{ old = "失望"; text = "願望"; reading = "yuànwàng"; translation = "wish" }
        HK = @{ old = "失望"; text = "望遠鏡"; reading = "mong6 jyun5 geng3"; translation = "telescope" }
    }
    man = @{
        TW = @{ old = "男性"; text = "男孩"; reading = "nánhái"; translation = "boy" }
        HK = @{ old = "男性"; text = "男士"; reading = "naam4 si6"; translation = "gentleman" }
    }
    many = @{
        TW = @{ old = "多少"; text = "多數"; reading = "duōshù"; translation = "majority" }
        HK = @{ old = "多少"; text = "多謝"; reading = "do1 ze6"; translation = "thank you" }
    }
    martial = @{
        TW = @{ old = "武功"; text = "武術"; reading = "wǔshù"; translation = "martial arts" }
        HK = @{ old = "武功"; text = "武器"; reading = "mou5 hei3"; translation = "weapon" }
    }
    meet = @{
        TW = @{ old = "交朋友"; text = "交流"; reading = "jiāoliú"; translation = "exchange / communicate" }
        HK = @{ old = "交朋友"; text = "交收"; reading = "gaau1 sau1"; translation = "handover / transaction" }
    }
    moon = @{
        TW = @{ old = "月食"; text = "月餅"; reading = "yuèbǐng"; translation = "mooncake" }
        HK = @{ old = "月食"; text = "月台"; reading = "jyut6 toi4"; translation = "platform" }
    }
    mother = @{
        TW = @{ old = "母校"; text = "母語"; reading = "mǔyǔ"; translation = "mother tongue" }
        HK = @{ old = "母校"; text = "母親"; reading = "mou5 can1"; translation = "mother" }
    }
    north = @{
        TW = @{ old = "北京"; text = "北方"; reading = "běifāng"; translation = "north / northern area" }
        HK = @{ old = "北京"; text = "北角"; reading = "bak1 gok3"; translation = "North Point" }
    }
    obtain = @{
        TW = @{ old = "覺得"; text = "得益"; reading = "déyì"; translation = "benefit" }
        HK = @{ old = "覺得"; text = "得閒"; reading = "dak1 haan4"; translation = "be free / available" }
    }
    official = @{
        TW = @{ old = "官職"; text = "官邸"; reading = "guāndǐ"; translation = "official residence" }
        HK = @{ old = "官職"; text = "官司"; reading = "gun1 si1"; translation = "lawsuit" }
    }
    old = @{
        TW = @{ old = "老家"; text = "老年"; reading = "lǎonián"; translation = "old age" }
        HK = @{ old = "老家"; text = "老友"; reading = "lou5 jau5"; translation = "old friend" }
    }
    'old-u53e4' = @{
        TW = @{ old = "古老"; text = "古代"; reading = "gǔdài"; translation = "ancient times" }
        HK = @{ old = "古老"; text = "古蹟"; reading = "gu2 zik1"; translation = "historic site" }
    }
    people = @{
        TW = @{ old = "居民"; text = "民眾"; reading = "mínzhòng"; translation = "the populace" }
        HK = @{ old = "居民"; text = "民意"; reading = "man4 ji3"; translation = "public opinion" }
    }
    public = @{
        TW = @{ old = "公告"; text = "公園"; reading = "gōngyuán"; translation = "park" }
        HK = @{ old = "公告"; text = "公司"; reading = "gung1 si1"; translation = "company" }
    }
    rain = @{
        TW = @{ old = "雨傘"; text = "雨衣"; reading = "yǔyī"; translation = "raincoat" }
        HK = @{ old = "雨傘"; text = "雨衣"; reading = "jyu5 ji1"; translation = "raincoat" }
    }
    rest = @{
        TW = @{ old = "休閒"; text = "休養"; reading = "xiūyǎng"; translation = "rest and recuperation" }
        HK = @{ old = "休息室"; text = "休憩"; reading = "jau1 hei3"; translation = "rest" }
    }
    river = @{
        TW = @{ old = "四川"; text = "川流"; reading = "chuānliú"; translation = "river flow" }
        HK = @{ old = "四川"; text = "山川"; reading = "saan1 cyun1"; translation = "mountains and rivers" }
    }
    sacrifice = @{
        TW = @{ old = "祭祀"; text = "祭典"; reading = "jìdiǎn"; translation = "ritual ceremony" }
        HK = @{ old = "祭祀"; text = "祭品"; reading = "zai3 ban2"; translation = "ritual offering" }
    }
    self = @{
        TW = @{ old = "自由"; text = "自動"; reading = "zìdòng"; translation = "automatic" }
        HK = @{ old = "自由"; text = "自從"; reading = "zi6 cung4"; translation = "since" }
    }
    sky = @{
        TW = @{ old = "天際"; text = "天氣"; reading = "tiānqì"; translation = "weather" }
        HK = @{ old = "天際"; text = "天台"; reading = "tin1 toi4"; translation = "rooftop" }
    }
    small = @{
        TW = @{ old = "小孩"; text = "小學"; reading = "xiǎoxué"; translation = "primary school" }
        HK = @{ old = "小孩"; text = "小心"; reading = "siu2 sam1"; translation = "careful" }
    }
    soldier = @{
        TW = @{ old = "兵營"; text = "兵站"; reading = "bīngzhàn"; translation = "military supply station" }
        HK = @{ old = "兵營"; text = "兵工廠"; reading = "bing1 gung1 cong2"; translation = "arsenal" }
    }
    south = @{
        TW = @{ old = "南門"; text = "南方"; reading = "nánfāng"; translation = "south / southern area" }
        HK = @{ old = "南門"; text = "南區"; reading = "naam4 keoi1"; translation = "Southern District" }
    }
    spring = @{
        TW = @{ old = "泉水"; text = "泉源"; reading = "quányuán"; translation = "spring / source" }
        HK = @{ old = "泉水"; text = "泉源"; reading = "cyun4 jyun4"; translation = "source / spring" }
    }
    step = @{
        TW = @{ old = "腳步"; text = "步驟"; reading = "bùzhòu"; translation = "steps / procedure" }
        HK = @{ old = "腳步"; text = "步行"; reading = "bou6 haang4"; translation = "walk" }
    }
    stone = @{
        TW = @{ old = "石碑"; text = "石材"; reading = "shícái"; translation = "stone material" }
        HK = @{ old = "石碑"; text = "石屎"; reading = "sek6 si2"; translation = "concrete" }
    }
    stop = @{
        TW = @{ old = "止血"; text = "止痛"; reading = "zhǐtòng"; translation = "relieve pain" }
        HK = @{ old = "止血"; text = "止咳"; reading = "zi2 kat1"; translation = "stop a cough" }
    }
    strength = @{
        TW = @{ old = "有力"; text = "力氣"; reading = "lìqì"; translation = "physical strength" }
        HK = @{ old = "有力"; text = "力學"; reading = "lik6 hok6"; translation = "mechanics" }
    }
    stretch = @{
        TW = @{ old = "申訴"; text = "申請"; reading = "shēnqǐng"; translation = "apply / application" }
        HK = @{ old = "申訴"; text = "申報"; reading = "san1 bou3"; translation = "declare / report" }
    }
    summer = @{
        TW = @{ old = "夏令營"; text = "夏夜"; reading = "xiàyè"; translation = "summer night" }
        HK = @{ old = "夏令營"; text = "夏夜"; reading = "haa6 je6"; translation = "summer night" }
    }
    tell = @{
        TW = @{ old = "告知"; text = "告密"; reading = "gàomì"; translation = "inform on / betray" }
        HK = @{ old = "告知"; text = "告示"; reading = "gou3 si6"; translation = "notice" }
    }
    ten = @{
        TW = @{ old = "十個"; text = "十全"; reading = "shíquán"; translation = "complete / perfect" }
        HK = @{ old = "十個"; text = "十足"; reading = "sap6 zuk1"; translation = "full / completely" }
    }
    'things-goods' = @{
        TW = @{ old = "產品"; text = "物價"; reading = "wùjià"; translation = "commodity prices" }
        HK = @{ old = "產品"; text = "物業"; reading = "mat6 jip6"; translation = "property" }
    }
    three = @{
        TW = @{ old = "三月"; text = "三角"; reading = "sānjiǎo"; translation = "triangle" }
        HK = @{ old = "三月"; text = "三文治"; reading = "saam1 man4 zi6"; translation = "sandwich" }
    }
    tiger = @{
        TW = @{ old = "虎紋"; text = "虎牙"; reading = "hǔyá"; translation = "canine tooth" }
        HK = @{ old = "虎紋"; text = "虎口"; reading = "fu2 hau2"; translation = "tiger’s mouth / dangerous situation" }
    }
    tongue = @{
        TW = @{ old = "舌苔"; text = "舌尖"; reading = "shéjiān"; translation = "tip of the tongue" }
        HK = @{ old = "舌苔"; text = "舌頭"; reading = "sit6 tau4"; translation = "tongue" }
    }
    tree = @{
        TW = @{ old = "木板"; text = "木材"; reading = "mùcái"; translation = "timber / wood" }
        HK = @{ old = "木板"; text = "木門"; reading = "muk6 mun4"; translation = "wooden door" }
    }
    'turn-back' = @{
        TW = @{ old = "反應"; text = "反對"; reading = "fǎnduì"; translation = "oppose" }
        HK = @{ old = "反應"; text = "反應"; reading = "faan2 jing3"; translation = "reaction" }
    }
    two = @{
        TW = @{ old = "第二"; text = "二月"; reading = "èryuè"; translation = "February" }
        HK = @{ old = "第二"; text = "二樓"; reading = "ji6 lau4"; translation = "second floor" }
    }
    west = @{
        TW = @{ old = "西門"; text = "西方"; reading = "xīfāng"; translation = "west / western area" }
        HK = @{ old = "西門"; text = "西區"; reading = "sai1 keoi1"; translation = "Western District" }
    }
    white = @{
        TW = @{ old = "白紙"; text = "白酒"; reading = "báijiǔ"; translation = "white liquor" }
        HK = @{ old = "白紙"; text = "白紙"; reading = "baak6 zi2"; translation = "blank paper" }
    }
    wife = @{
        TW = @{ old = "妻兒"; text = "妻子"; reading = "qīzi"; translation = "wife" }
        HK = @{ old = "妻兒"; text = "妻子"; reading = "cai1 zi2"; translation = "wife" }
    }
    winter = @{
        TW = @{ old = "冬眠"; text = "冬至"; reading = "dōngzhì"; translation = "winter solstice" }
        HK = @{ old = "冬眠"; text = "冬至"; reading = "dung1 zi3"; translation = "winter solstice" }
    }
    year = @{
        TW = @{ old = "年齡"; text = "年初"; reading = "niánchū"; translation = "beginning of the year" }
        HK = @{ old = "年齡"; text = "年尾"; reading = "nin4 mei5"; translation = "end of the year" }
    }
}

# These examples duplicated the meaning of an already-displayed Japanese
# reading. They are replaced by a distinct compound so the reading row teaches
# the direct sense and the example row teaches a new use.
$japaneseReplacements = @{
    above = @(
        @{ old = "上る"; text = "上記"; kana = "じょうき"; romanization = "jōki"; translation = "above-mentioned" },
        @{ old = "上がる"; text = "上空"; kana = "じょうくう"; romanization = "jōkū"; translation = "sky above" }
    )
    after = @(@{ old = "後ろ"; text = "後半"; kana = "こうはん"; romanization = "kōhan"; translation = "latter half" })
    altar = @(@{ old = "示す"; text = "展示"; kana = "てんじ"; romanization = "tenji"; translation = "exhibition / display" })
    beautiful = @(@{ old = "美しい"; text = "美術館"; kana = "びじゅつかん"; romanization = "bijutsukan"; translation = "art museum" })
    below = @(
        @{ old = "下がる"; text = "下宿"; kana = "げしゅく"; romanization = "geshuku"; translation = "lodging / boarding house" },
        @{ old = "下げる"; text = "下書き"; kana = "したがき"; romanization = "shitagaki"; translation = "draft" }
    )
    benefit = @(@{ old = "利益"; text = "利口"; kana = "りこう"; romanization = "rikō"; translation = "clever / smart" })
    black = @(@{ old = "黒い"; text = "黒幕"; kana = "くろまく"; romanization = "kuromaku"; translation = "mastermind behind the scenes" })
    blessing = @(@{ old = "祝う"; text = "祝宴"; kana = "しゅくえん"; romanization = "shukuen"; translation = "celebratory banquet" })
    bright = @(
        @{ old = "明るい"; text = "明細"; kana = "めいさい"; romanization = "meisai"; translation = "itemized details" },
        @{ old = "明確"; text = "明記"; kana = "めいき"; romanization = "meiki"; translation = "clearly state in writing" }
    )
    center = @(@{ old = "中央"; text = "中庭"; kana = "なかにわ"; romanization = "nakaniwa"; translation = "courtyard" })
    child = @(@{ old = "子ども"; text = "子守"; kana = "こもり"; romanization = "komori"; translation = "childcare" })
    command = @(@{ old = "命令"; text = "命日"; kana = "めいにち"; romanization = "meinichi"; translation = "death anniversary" })
    direction = @(
        @{ old = "向く"; text = "向き"; kana = "むき"; romanization = "muki"; translation = "direction / orientation" },
        @{ old = "向かう"; text = "向かい"; kana = "むかい"; romanization = "mukai"; translation = "opposite / across from" }
    )
    divide = @(
        @{ old = "分ける"; text = "分野"; kana = "ぶんや"; romanization = "bun'ya"; translation = "field / area" },
        @{ old = "分かる"; text = "分析"; kana = "ぶんせき"; romanization = "bunseki"; translation = "analysis" }
    )
    each = @(
        @{ old = "各自"; text = "各種"; kana = "かくしゅ"; romanization = "kakushu"; translation = "various kinds" },
        @{ old = "各々"; text = "各駅"; kana = "かくえき"; romanization = "kakueki"; translation = "every station" }
    )
    ear = @(@{ old = "耳鼻科"; text = "耳鳴り"; kana = "みみなり"; romanization = "miminari"; translation = "ringing in the ears" })
    earth = @(@{ old = "土地"; text = "土産"; kana = "みやげ"; romanization = "miyage"; translation = "souvenir" })
    enter = @(@{ old = "入る"; text = "入手"; kana = "にゅうしゅ"; romanization = "nyūshu"; translation = "obtain / get" })
    exit = @(@{ old = "出る"; text = "出身"; kana = "しゅっしん"; romanization = "shusshin"; translation = "one’s origin / background" })
    eye = @(@{ old = "目的"; text = "目印"; kana = "めじるし"; romanization = "mejirushi"; translation = "landmark / sign" })
    few = @(
        @{ old = "少ない"; text = "少量"; kana = "しょうりょう"; romanization = "shōryō"; translation = "small quantity" },
        @{ old = "少し"; text = "少女"; kana = "しょうじょ"; romanization = "shōjo"; translation = "girl" },
        @{ old = "少数"; text = "少額"; kana = "しょうがく"; romanization = "shōgaku"; translation = "small amount of money" }
    )
    field = @(@{ old = "水田"; text = "田植え"; kana = "たうえ"; romanization = "taue"; translation = "rice planting" })
    follow = @(@{ old = "従う"; text = "従属"; kana = "じゅうぞく"; romanization = "jūzoku"; translation = "subordination / subordinate" })
    fragrance = @(
        @{ old = "香り"; text = "香ばしい"; kana = "こうばしい"; romanization = "kōbashii"; translation = "fragrant / savory" },
        @{ old = "香る"; text = "香炉"; kana = "こうろ"; romanization = "kōro"; translation = "incense burner" }
    )
    'gather-u96c6' = @(
        @{ old = "集まる"; text = "集団"; kana = "しゅうだん"; romanization = "shūdan"; translation = "group" },
        @{ old = "集める"; text = "集計"; kana = "しゅうけい"; romanization = "shūkei"; translation = "tabulation" }
    )
    go = @(
        @{ old = "行く"; text = "行先"; kana = "いきさき"; romanization = "ikisaki"; translation = "destination" },
        @{ old = "行列"; text = "行程"; kana = "こうてい"; romanization = "kōtei"; translation = "itinerary / route" },
        @{ old = "行う"; text = "行政"; kana = "ぎょうせい"; romanization = "gyōsei"; translation = "administration" }
    )
    good = @(
        @{ old = "好き"; text = "好調"; kana = "こうちょう"; romanization = "kōchō"; translation = "in good condition" },
        @{ old = "好む"; text = "好景気"; kana = "こうけいき"; romanization = "kōkeiki"; translation = "prosperity / boom" }
    )
    group = @(@{ old = "家族"; text = "族長"; kana = "ぞくちょう"; romanization = "zokuchō"; translation = "clan chief" })
    guard = @(@{ old = "守る"; text = "守衛"; kana = "しゅえい"; romanization = "shuei"; translation = "guard / watchman" })
    high = @(@{ old = "高い"; text = "高温"; kana = "こうおん"; romanization = "kōon"; translation = "high temperature" })
    increase = @(@{ old = "利益"; text = "利用"; kana = "りよう"; romanization = "riyō"; translation = "use / utilization" })
    jade = @(@{ old = "宝玉"; text = "玉ねぎ"; kana = "たまねぎ"; romanization = "tamanegi"; translation = "onion" })
    join = @(
        @{ old = "合う"; text = "合図"; kana = "あいず"; romanization = "aizu"; translation = "signal / sign" },
        @{ old = "合わせる"; text = "合唱"; kana = "がっしょう"; romanization = "gasshō"; translation = "chorus / singing together" }
    )
    journey = @(@{ old = "旅行"; text = "旅費"; kana = "りょひ"; romanization = "ryohi"; translation = "travel expenses" })
    life = @(
        @{ old = "生きる"; text = "生地"; kana = "きじ"; romanization = "kiji"; translation = "fabric / material" },
        @{ old = "生まれる"; text = "生涯"; kana = "しょうがい"; romanization = "shōgai"; translation = "lifetime" }
    )
    light = @(@{ old = "光る"; text = "光景"; kana = "こうけい"; romanization = "kōkei"; translation = "scene / sight" })
    lodging = @(
        @{ old = "宿る"; text = "宿命"; kana = "しゅくめい"; romanization = "shukumei"; translation = "fate / destiny" },
        @{ old = "宿す"; text = "宿舎"; kana = "しゅくしゃ"; romanization = "shukusha"; translation = "quarters / dormitory" }
    )
    long = @(@{ old = "長い"; text = "長期"; kana = "ちょうき"; romanization = "chōki"; translation = "long term" })
    'look-toward' = @(
        @{ old = "望む"; text = "望ましい"; kana = "のぞましい"; romanization = "nozomashii"; translation = "desirable" },
        @{ old = "希望"; text = "絶望"; kana = "ぜつぼう"; romanization = "zetsubō"; translation = "despair" }
    )
    man = @(@{ old = "男性"; text = "男声"; kana = "だんせい"; romanization = "dansei"; translation = "male voice" })
    many = @(@{ old = "多い"; text = "多額"; kana = "たがく"; romanization = "tagaku"; translation = "large sum" })
    meet = @(
        @{ old = "交わる"; text = "交番"; kana = "こうばん"; romanization = "kōban"; translation = "police box" },
        @{ old = "交換"; text = "交代"; kana = "こうたい"; romanization = "kōtai"; translation = "replacement / shift change" }
    )
    middle = @(@{ old = "中心"; text = "中旬"; kana = "ちゅうじゅん"; romanization = "chūjun"; translation = "middle ten days of the month" })
    obtain = @(@{ old = "得る"; text = "得失"; kana = "とくしつ"; romanization = "tokushitsu"; translation = "gains and losses" })
    old = @(@{ old = "老いる"; text = "老舗"; kana = "しにせ"; romanization = "shinise"; translation = "long-established shop" })
    'old-u53e4' = @(@{ old = "古い"; text = "古典"; kana = "こてん"; romanization = "koten"; translation = "classical literature" })
    people = @(@{ old = "国民"; text = "民家"; kana = "みんか"; romanization = "minka"; translation = "private house" })
    reach = @(
        @{ old = "及ぶ"; text = "及び"; kana = "および"; romanization = "oyobi"; translation = "and / as well as" },
        @{ old = "及ぼす"; text = "言及"; kana = "げんきゅう"; romanization = "genkyū"; translation = "mention / refer to" }
    )
    red = @(@{ old = "赤い"; text = "赤面"; kana = "せきめん"; romanization = "sekimen"; translation = "blushing / embarrassment" })
    rest = @(@{ old = "休む"; text = "休講"; kana = "きゅうこう"; romanization = "kyūkō"; translation = "class cancellation" })
    sacrifice = @(
        @{ old = "祭り"; text = "祭壇"; kana = "さいだん"; romanization = "saidan"; translation = "altar" },
        @{ old = "祭る"; text = "祭礼"; kana = "さいれい"; romanization = "sairei"; translation = "ritual ceremony" }
    )
    same = @(@{ old = "同じ"; text = "同僚"; kana = "どうりょう"; romanization = "dōryō"; translation = "colleague" })
    self = @(
        @{ old = "自分"; text = "自転車"; kana = "じてんしゃ"; romanization = "jitensha"; translation = "bicycle" },
        @{ old = "自ら"; text = "自主"; kana = "じしゅ"; romanization = "jishu"; translation = "independence / self-directed" }
    )
    small = @(
        @{ old = "小さい"; text = "小鳥"; kana = "ことり"; romanization = "kotori"; translation = "small bird" },
        @{ old = "小型"; text = "小売"; kana = "こうり"; romanization = "kōri"; translation = "retail" }
    )
    speech = @(
        @{ old = "言う"; text = "言明"; kana = "げんめい"; romanization = "genmei"; translation = "statement / declaration" },
        @{ old = "言葉"; text = "言動"; kana = "げんどう"; romanization = "gendō"; translation = "words and actions" }
    )
    stand = @(@{ old = "立つ"; text = "立体"; kana = "りったい"; romanization = "rittai"; translation = "three-dimensional form" })
    step = @(@{ old = "歩く"; text = "歩行"; kana = "ほこう"; romanization = "hokō"; translation = "walking" })
    stop = @(
        @{ old = "止まる"; text = "止まり木"; kana = "とまりぎ"; romanization = "tomarigi"; translation = "perch" },
        @{ old = "止める"; text = "禁止"; kana = "きんし"; romanization = "kinshi"; translation = "prohibition" }
    )
    sweet = @(@{ old = "甘い"; text = "甘酒"; kana = "あまざけ"; romanization = "amazake"; translation = "sweet rice drink" })
    take = @(@{ old = "取る"; text = "取り消す"; kana = "とりけす"; romanization = "torikesu"; translation = "cancel / revoke" })
    tell = @(@{ old = "告げる"; text = "告発"; kana = "こくはつ"; romanization = "kokuhatsu"; translation = "accusation / indictment" })
    'things-goods' = @(@{ old = "商品"; text = "物語"; kana = "ものがたり"; romanization = "monogatari"; translation = "story / tale" })
    'turn-back' = @(@{ old = "反対"; text = "反復"; kana = "はんぷく"; romanization = "hanpuku"; translation = "repetition" })
    two = @(@{ old = "二つ"; text = "二重"; kana = "にじゅう"; romanization = "nijū"; translation = "double / twofold" })
    upright = @(@{ old = "正しい"; text = "正門"; kana = "せいもん"; romanization = "seimon"; translation = "main gate" })
    walk = @(@{ old = "走る"; text = "走馬灯"; kana = "そうまとう"; romanization = "sōmatō"; translation = "revolving lantern" })
    white = @(@{ old = "白い"; text = "白昼"; kana = "はくちゅう"; romanization = "hakuchū"; translation = "broad daylight" })
    woman = @(@{ old = "女性"; text = "女優"; kana = "じょゆう"; romanization = "joyū"; translation = "actress" })
}

# Validate every requested replacement before writing any record. This keeps a
# typo in a row mapping from producing a partially applied content pass.
$preflightIssues = [System.Collections.ArrayList]@()
foreach ($folder in Get-ChildItem -LiteralPath $SymbolsPath -Directory) {
    $path = Join-Path $folder.FullName "symbol.json"
    if (-not (Test-Path -LiteralPath $path)) { continue }
    $record = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json -Depth 100
    $id = [string]$record.id
    if ($regionalReplacements.ContainsKey($id)) {
        $regional = $regionalReplacements[$id]
        if (@($record.focusCoverage.traditionalChinese.taiwanExamples | Where-Object { $_.text -eq $regional.TW.old }).Count -ne 1) { [void]$preflightIssues.Add("$id [TW] missing or duplicate '$($regional.TW.old)'") }
        if (@($record.focusCoverage.traditionalChinese.hongKongExamples | Where-Object { $_.text -eq $regional.HK.old }).Count -ne 1) { [void]$preflightIssues.Add("$id [HK] missing or duplicate '$($regional.HK.old)'") }
    }
    if ($japaneseReplacements.ContainsKey($id)) {
        foreach ($replacement in @($japaneseReplacements[$id])) {
            if (@($record.focusCoverage.japanese.examples | Where-Object { $_.text -eq $replacement.old }).Count -ne 1) { [void]$preflightIssues.Add("$id [J] missing or duplicate '$($replacement.old)'") }
            if (@($record.focusCoverage.japanese.examples | Where-Object { $_.text -eq $replacement.text }).Count -gt 0) { [void]$preflightIssues.Add("$id [J] replacement already exists '$($replacement.text)'") }
        }
    }
}
if ($preflightIssues.Count -gt 0) {
    throw "Example audit preflight failed:`n$($preflightIssues -join "`n")"
}

foreach ($folder in Get-ChildItem -LiteralPath $SymbolsPath -Directory) {
    $path = Join-Path $folder.FullName "symbol.json"
    if (-not (Test-Path -LiteralPath $path)) { continue }
    $record = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json -Depth 100
    $id = [string]$record.id
    $core = [string]$record.coreCharacter

    if ($regionalReplacements.ContainsKey($id)) {
        $regional = $regionalReplacements[$id]
        $record.focusCoverage.traditionalChinese.taiwanExamples = Replace-ExampleAtText $record.focusCoverage.traditionalChinese.taiwanExamples $regional.TW.old $regional.TW "mandarin" $core
        $record.focusCoverage.traditionalChinese.hongKongExamples = Replace-ExampleAtText $record.focusCoverage.traditionalChinese.hongKongExamples $regional.HK.old $regional.HK "cantonese" $core
    }

    if ($japaneseReplacements.ContainsKey($id)) {
        foreach ($replacement in @($japaneseReplacements[$id])) {
            $record.focusCoverage.japanese.examples = Replace-JapaneseExample $record.focusCoverage.japanese.examples $replacement.old $replacement $core
        }
    }

    $record | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $path -Encoding utf8
}

Write-Output "Applied row-level example diversity and Japanese reading/example de-duplication mappings to canonical Symbol records."
