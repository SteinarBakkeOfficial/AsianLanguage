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

# These are a second regional slot for Symbols that still shared three
# meanings after the four-meaning clone pass. The wording is intentionally
# explicit: each replacement is a normal word or sentence, not a gloss-only
# change and not a modification to readings or equivalents.
$replacements = @{
    above = @{ TW = @{ old = "上面"; text = "上限"; reading = "shàngxiàn"; translation = "upper limit" }; HK = @{ old = "上山"; text = "上環"; reading = "soeng6 waan4"; translation = "Sheung Wan" } }
    after = @{ TW = @{ old = "後面"; text = "後悔"; reading = "hòuhuǐ"; translation = "regret" }; HK = @{ old = "後座"; text = "後巷"; reading = "hau6 hong6"; translation = "back alley" } }
    altar = @{ TW = @{ old = "表示"; text = "示例"; reading = "shìlì"; translation = "example" }; HK = @{ old = "顯示"; text = "示意圖"; reading = "si6 ji3 tou4"; translation = "diagram / illustration" } }
    ancestor = @{ TW = @{ old = "宗族"; text = "祖籍"; reading = "zǔjí"; translation = "ancestral hometown" }; HK = @{ old = "宗派"; text = "宗祠"; reading = "zung1 ci4"; translation = "ancestral hall" } }
    auspicious = @{ TW = @{ old = "吉日"; text = "吉兆"; reading = "jízhào"; translation = "auspicious omen" }; HK = @{ old = "吉日"; text = "吉兆"; reading = "gat1 ziu6"; translation = "auspicious omen" } }
    bamboo = @{ TW = @{ old = "竹林"; text = "竹葉茶"; reading = "zhúyè chá"; translation = "bamboo-leaf tea" }; HK = @{ old = "竹筍"; text = "竹籬笆"; reading = "zuk1 lei4 baa1"; translation = "bamboo fence" } }
    bean = @{ TW = @{ old = "綠豆"; text = "豆仁"; reading = "dòurén"; translation = "bean kernels" }; HK = @{ old = "豆腐"; text = "豆豉"; reading = "dau6 si6"; translation = "fermented black beans" } }
    beautiful = @{ TW = @{ old = "美術"; text = "美景"; reading = "měijǐng"; translation = "beautiful scenery" }; HK = @{ old = "美術"; text = "美景"; reading = "mei5 ging2"; translation = "beautiful scenery" } }
    before = @{ TW = @{ old = "先生"; text = "先行"; reading = "xiānxíng"; translation = "go first / take precedence" } }
    below = @{ TW = @{ old = "下面"; text = "下令"; reading = "xiàlìng"; translation = "issue an order" } }
    benefit = @{ TW = @{ old = "有利"; text = "利器"; reading = "lìqì"; translation = "useful tool" } }
    big = @{ TW = @{ old = "大海"; text = "大雨"; reading = "dàyǔ"; translation = "heavy rain" }; HK = @{ old = "大門"; text = "大廈"; reading = "daai6 haa6"; translation = "high-rise building" } }
    black = @{ TW = @{ old = "黑豆"; text = "黑影"; reading = "hēiyǐng"; translation = "shadow / silhouette" }; HK = @{ old = "黑板"; text = "黑糖"; reading = "hak1 tong4"; translation = "brown sugar" } }
    blessing = @{ TW = @{ old = "祝願"; text = "祝詞"; reading = "zhùcí"; translation = "blessing words" }; HK = @{ old = "祝願"; text = "祝福語"; reading = "zuk1 fuk1 jyu5"; translation = "blessing words" } }
    body = @{ TW = @{ old = "身上"; text = "身心"; reading = "shēnxīn"; translation = "body and mind" }; HK = @{ old = "身上"; text = "身家"; reading = "san1 gaa1"; translation = "family fortune" } }
    book = @{ TW = @{ old = "冊頁"; text = "冊封"; reading = "cèfēng"; translation = "confer a title" }; HK = @{ old = "書冊"; text = "書展"; reading = "syu1 zin2"; translation = "book fair" } }
    bow = @{ HK = @{ old = "弓箭手"; text = "弓形"; reading = "gung1 jing4"; translation = "bow-shaped" } }
    bright = @{ TW = @{ old = "明白"; text = "明確"; reading = "míngquè"; translation = "clear / definite" }; HK = @{ old = "明白"; text = "明確"; reading = "ming4 kok3"; translation = "clear / definite" } }
    center = @{ TW = @{ old = "央求"; text = "央企"; reading = "yāngqǐ"; translation = "central state-owned enterprise" } }
    child = @{ TW = @{ old = "子孫"; text = "子弟"; reading = "zǐdì"; translation = "young people / students" }; HK = @{ old = "子女"; text = "子弟"; reading = "zi2 dai6"; translation = "young people / students" } }
    classic = @{ TW = @{ old = "典型"; text = "典藏"; reading = "diǎncáng"; translation = "archival collection" } }
    clothing = @{ TW = @{ old = "衣料"; text = "衣著"; reading = "yīzhuó"; translation = "attire" }; HK = @{ old = "衣料"; text = "衣車"; reading = "ji1 ce1"; translation = "sewing machine" } }
    cloud = @{ TW = @{ old = "烏雲"; text = "雲霧"; reading = "yúnwù"; translation = "cloud and mist" }; HK = @{ old = "白雲"; text = "雲海"; reading = "wan4 hoi2"; translation = "sea of clouds" } }
    day = @{ TW = @{ old = "日期"; text = "日曆"; reading = "rìlì"; translation = "calendar" } }
    direction = @{ TW = @{ old = "向上"; text = "向右"; reading = "xiàngyòu"; translation = "toward the right" }; HK = @{ old = "向上"; text = "向左"; reading = "hoeng3 zo2"; translation = "toward the left" } }
    divide = @{ TW = @{ old = "一分鐘"; text = "分工"; reading = "fēngōng"; translation = "division of labor" } }
    dog = @{ TW = @{ old = "獵犬"; text = "看門狗"; reading = "kānmén gǒu"; translation = "watchdog" }; HK = @{ old = "獵犬"; text = "狗仔"; reading = "gau2 zai2"; translation = "puppy" } }
    ear = @{ TW = @{ old = "耳機"; text = "耳塞"; reading = "ěrsāi"; translation = "earplugs" } }
    earth = @{ TW = @{ old = "土豆"; text = "土石流"; reading = "tǔshíliú"; translation = "mudslide" }; HK = @{ old = "泥土"; text = "泥沙"; reading = "nai4 saa1"; translation = "mud and sand" } }
    enter = @{ TW = @{ old = "入口"; text = "入境"; reading = "rùjìng"; translation = "enter a country" }; HK = @{ old = "入學"; text = "入境"; reading = "jap6 ging2"; translation = "enter a country" } }
    evening = @{ TW = @{ old = "朝夕"; text = "夕暮"; reading = "xīmù"; translation = "dusk" } }
    exit = @{ TW = @{ old = "出境"; text = "出席"; reading = "chūxí"; translation = "attend" } }
    eye = @{ TW = @{ old = "雙目"; text = "目擊"; reading = "mùjī"; translation = "witness" }; HK = @{ old = "雙目"; text = "目睹"; reading = "muk6 dou2"; translation = "witness / see with one’s own eyes" } }
    few = @{ TW = @{ old = "很少"; text = "少見"; reading = "shǎojiàn"; translation = "rare / uncommon" } }
    field = @{ TW = @{ old = "農田"; text = "田螺"; reading = "tiánluó"; translation = "field snail" }; HK = @{ old = "農田"; text = "田園"; reading = "tin4 jyun4"; translation = "rural garden" } }
    forest = @{ TW = @{ old = "林場"; text = "林區"; reading = "línqū"; translation = "forest region" }; HK = @{ old = "林蔭"; text = "林地"; reading = "lam4 dei6"; translation = "forest land" } }
    fragrance = @{ TW = @{ old = "香氣"; text = "香料"; reading = "xiāngliào"; translation = "spice / fragrance" }; HK = @{ old = "香味"; text = "香薰"; reading = "hoeng1 fan1"; translation = "aromatherapy" } }
    friend = @{ TW = @{ old = "好友"; text = "友人"; reading = "yǒurén"; translation = "friend / acquaintance" } }
    gather = @{ TW = @{ old = "採摘"; text = "採收"; reading = "cǎishōu"; translation = "harvest / collect" }; HK = @{ old = "採摘"; text = "採收"; reading = "coi2 sau1"; translation = "harvest / collect" } }
    'gather-u96c6' = @{ TW = @{ old = "集市"; text = "集團"; reading = "jítuán"; translation = "group / corporation" }; HK = @{ old = "集合"; text = "集會"; reading = "zaap6 wui6"; translation = "assembly / meeting" } }
    go = @{ TW = @{ old = "行業"; text = "行李"; reading = "xínglǐ"; translation = "luggage" }; HK = @{ old = "行人"; text = "行李"; reading = "haang4 lei5"; translation = "luggage" } }
    good = @{ TW = @{ old = "好看"; text = "好奇"; reading = "hàoqí"; translation = "curious" }; HK = @{ old = "好人"; text = "好奇"; reading = "hou2 kei4"; translation = "curious" } }
    group = @{ TW = @{ old = "族譜"; text = "族長"; reading = "zúzhǎng"; translation = "clan leader" }; HK = @{ old = "族群"; text = "氏族"; reading = "si6 zuk6"; translation = "clan" } }
    guard = @{ TW = @{ old = "守門"; text = "守法"; reading = "shǒufǎ"; translation = "obey the law" } }
    head = @{ TW = @{ old = "首先"; text = "首府"; reading = "shǒufǔ"; translation = "provincial capital" }; HK = @{ old = "首要"; text = "首飾"; reading = "sau2 sik1"; translation = "jewelry" } }
    heart = @{ TW = @{ old = "心情"; text = "心願"; reading = "xīnyuàn"; translation = "heart’s wish" }; HK = @{ old = "心情"; text = "心事"; reading = "sam1 si6"; translation = "worries / thoughts" } }
    high = @{ TW = @{ old = "高樓"; text = "高鐵"; reading = "gāotiě"; translation = "high-speed rail" } }
    horn = @{ TW = @{ old = "鹿角"; text = "角落"; reading = "jiǎoluò"; translation = "corner / nook" }; HK = @{ old = "直角"; text = "角落"; reading = "gok3 lok6"; translation = "corner / nook" } }
    increase = @{ HK = @{ old = "公益"; text = "益智"; reading = "jik1 zi3"; translation = "beneficial to the mind" } }
    jade = @{ TW = @{ old = "玉佩"; text = "玉米"; reading = "yùmǐ"; translation = "corn" }; HK = @{ old = "玉石"; text = "玉米"; reading = "juk6 mai5"; translation = "corn" } }
    join = @{ TW = @{ old = "合適"; text = "合成"; reading = "héchéng"; translation = "synthesize / combine" }; HK = @{ old = "合適"; text = "合拍"; reading = "hap6 paak3"; translation = "in sync / well-matched" } }
    journey = @{ TW = @{ old = "旅遊"; text = "旅程"; reading = "lǚchéng"; translation = "journey / itinerary" }; HK = @{ old = "旅行"; text = "旅程"; reading = "leoi5 cing4"; translation = "journey / itinerary" } }
    king = @{ TW = @{ old = "王子"; text = "王后"; reading = "wánghòu"; translation = "queen / empress" }; HK = @{ old = "王子"; text = "王妃"; reading = "wong4 fei1"; translation = "princess consort" } }
    life = @{ TW = @{ old = "生日"; text = "生態"; reading = "shēngtài"; translation = "ecology" }; HK = @{ old = "生活"; text = "生意"; reading = "saang1 ji3"; translation = "business / trade" } }
    light = @{ HK = @{ old = "光明"; text = "光纖"; reading = "gwong1 cin1"; translation = "optical fiber" } }
    lodging = @{ TW = @{ old = "住宿"; text = "宿願"; reading = "sùyuàn"; translation = "long-held wish" } }
    long = @{ TW = @{ old = "很長"; text = "長途"; reading = "chángtú"; translation = "long-distance" }; HK = @{ old = "長頭髮"; text = "長度"; reading = "coeng4 dou6"; translation = "length" } }
    'look-toward' = @{ HK = @{ old = "希望"; text = "望見"; reading = "mong6 gin3"; translation = "catch sight of" } }
    man = @{ HK = @{ old = "男生"; text = "男童"; reading = "naam4 tung4"; translation = "boy / male child" } }
    many = @{ HK = @{ old = "多數"; text = "多餘"; reading = "do1 jyu4"; translation = "extra / surplus" } }
    martial = @{ HK = @{ old = "武術"; text = "武林"; reading = "mou5 lam4"; translation = "martial arts world" } }
    meet = @{ HK = @{ old = "交通"; text = "交界"; reading = "gaau1 gaai3"; translation = "border / junction" } }
    moon = @{ TW = @{ old = "月光"; text = "月曆"; reading = "yuèlì"; translation = "calendar" }; HK = @{ old = "一月"; text = "月曆"; reading = "jyut6 lik6"; translation = "calendar" } }
    mountain = @{ TW = @{ old = "山路"; text = "山谷"; reading = "shāngǔ"; translation = "valley" }; HK = @{ old = "山頂"; text = "山腰"; reading = "saan1 jiu1"; translation = "mountainside" } }
    mouth = @{ TW = @{ old = "門口"; text = "口紅"; reading = "kǒuhóng"; translation = "lipstick" }; HK = @{ old = "口袋"; text = "口罩"; reading = "hau2 zaau3"; translation = "face mask" } }
    north = @{ TW = @{ old = "北邊"; text = "北極"; reading = "běijí"; translation = "North Pole" }; HK = @{ old = "北面"; text = "北岸"; reading = "bak1 ngon6"; translation = "north shore" } }
    obtain = @{ TW = @{ old = "獲得"; text = "得分"; reading = "défēn"; translation = "score points" }; HK = @{ old = "獲得"; text = "得悉"; reading = "dak1 sik1"; translation = "learn / find out" } }
    official = @{ TW = @{ old = "法官"; text = "官網"; reading = "guānwǎng"; translation = "official website" }; HK = @{ old = "法官"; text = "官網"; reading = "gun1 mong5"; translation = "official website" } }
    old = @{ TW = @{ old = "老師"; text = "老闆"; reading = "lǎobǎn"; translation = "boss" }; HK = @{ old = "老師"; text = "老闆"; reading = "lou5 baan2"; translation = "boss" } }
    'old-u53e4' = @{ TW = @{ old = "古城"; text = "古箏"; reading = "gǔzhēng"; translation = "guzheng zither" } }
    'older-brother' = @{ TW = @{ old = "兄妹"; text = "兄弟姊妹"; reading = "xiōngdì zǐmèi"; translation = "brothers and sisters" }; HK = @{ old = "兄弟"; text = "兄弟姊妹"; reading = "hing1 dai6 ze2 mui6"; translation = "brothers and sisters" } }
    one = @{ TW = @{ old = "一杯"; text = "一日"; reading = "yīrì"; translation = "one day" }; HK = @{ old = "一日"; text = "一世"; reading = "jat1 sai3"; translation = "a lifetime" } }
    ox = @{ TW = @{ old = "牛肉"; text = "牛仔"; reading = "niúzǎi"; translation = "cowboy" } }
    people = @{ TW = @{ old = "民眾"; text = "民間"; reading = "mínjiān"; translation = "folk / civilian" }; HK = @{ old = "人民"; text = "民居"; reading = "man4 geoi1"; translation = "residential homes" } }
    person = @{ TW = @{ old = "人們"; text = "人情"; reading = "rénqíng"; translation = "human feelings / social obligations" }; HK = @{ old = "人口"; text = "人手"; reading = "jan4 sau2"; translation = "manpower" } }
    public = @{ TW = @{ old = "公司"; text = "公車"; reading = "gōngchē"; translation = "public bus" } }
    rain = @{ TW = @{ old = "雨水"; text = "雨量"; reading = "yǔliàng"; translation = "rainfall amount" } }
    reach = @{ TW = @{ old = "及時"; text = "及早"; reading = "jízǎo"; translation = "as early as possible" }; HK = @{ old = "及時"; text = "及早"; reading = "kap6 zou2"; translation = "as early as possible" } }
    red = @{ TW = @{ old = "赤色"; text = "赤潮"; reading = "chìcháo"; translation = "red tide" }; HK = @{ old = "赤腳"; text = "赤柱"; reading = "cek3 cyu5"; translation = "Stanley, Hong Kong" } }
    rest = @{ TW = @{ old = "休養"; text = "休學"; reading = "xiūxué"; translation = "take a leave from school" }; HK = @{ old = "休假"; text = "休班"; reading = "jau1 baan1"; translation = "day off" } }
    river = @{ HK = @{ old = "川流"; text = "河口"; reading = "ho4 hau2"; translation = "river mouth / estuary" } }
    sacrifice = @{ TW = @{ old = "祭品"; text = "祭壇"; reading = "jìtán"; translation = "altar" }; HK = @{ old = "祭祖"; text = "祭神"; reading = "zai3 san4"; translation = "worship a deity" } }
    sheep = @{ TW = @{ old = "羊群"; text = "羊毛衫"; reading = "yángmáoshān"; translation = "wool sweater" } }
    sky = @{ TW = @{ old = "天氣"; text = "天花板"; reading = "tiānhuābǎn"; translation = "ceiling" }; HK = @{ old = "天地"; text = "天橋"; reading = "tin1 kiu4"; translation = "footbridge" } }
    small = @{ TW = @{ old = "小山"; text = "小吃"; reading = "xiǎochī"; translation = "snack" }; HK = @{ old = "小狗"; text = "小販"; reading = "siu2 faan2"; translation = "street vendor" } }
    soldier = @{ TW = @{ old = "兵器"; text = "兵法"; reading = "bīngfǎ"; translation = "military strategy" }; HK = @{ old = "兵器"; text = "兵書"; reading = "bing1 syu1"; translation = "military text" } }
    south = @{ TW = @{ old = "南邊"; text = "南島"; reading = "nándǎo"; translation = "southern island" }; HK = @{ old = "南面"; text = "南灣"; reading = "naam4 waan1"; translation = "South Bay" } }
    speech = @{ TW = @{ old = "言語"; text = "言談"; reading = "yántán"; translation = "conversation" }; HK = @{ old = "語言"; text = "語氣"; reading = "jyu5 hei3"; translation = "tone of voice" } }
    spring = @{ TW = @{ old = "山泉"; text = "泉眼"; reading = "quányǎn"; translation = "spring outlet" }; HK = @{ old = "溫泉"; text = "泉水"; reading = "cyun4 seoi2"; translation = "spring water" } }
    stand = @{ TW = @{ old = "成立"; text = "立場"; reading = "lìchǎng"; translation = "position / stance" }; HK = @{ old = "獨立"; text = "立法"; reading = "laap6 faat3"; translation = "legislate" } }
    step = @{ TW = @{ old = "散步"; text = "步道"; reading = "bùdào"; translation = "walking trail" }; HK = @{ old = "散步"; text = "步道"; reading = "bou6 dou6"; translation = "walking trail" } }
    stone = @{ TW = @{ old = "石材"; text = "石雕"; reading = "shídiāo"; translation = "stone carving" }; HK = @{ old = "石塊"; text = "石油"; reading = "sek6 jau4"; translation = "petroleum" } }
    stop = @{ HK = @{ old = "止痛"; text = "止蝕"; reading = "zi2 sik1"; translation = "stop a loss" } }
    strength = @{ TW = @{ old = "努力"; text = "力道"; reading = "lìdào"; translation = "force / strength" }; HK = @{ old = "力氣"; text = "力場"; reading = "lik6 coeng4"; translation = "force field" } }
    stretch = @{ TW = @{ old = "申報"; text = "申論"; reading = "shēnlùn"; translation = "discuss / essay response" } }
    summer = @{ TW = @{ old = "夏日"; text = "夏至"; reading = "xiàzhì"; translation = "summer solstice" } }
    sweet = @{ HK = @{ old = "甘草"; text = "甘藍"; reading = "gam1 laam4"; translation = "cabbage" } }
    take = @{ TW = @{ old = "取出"; text = "取代"; reading = "qǔdài"; translation = "replace / substitute" }; HK = @{ old = "取出"; text = "取代"; reading = "ceoi2 doi6"; translation = "replace / substitute" } }
    tell = @{ TW = @{ old = "告別"; text = "告白"; reading = "gàobái"; translation = "confession" }; HK = @{ old = "告別"; text = "告白"; reading = "gou3 baak6"; translation = "confession" } }
    ten = @{ TW = @{ old = "十個人"; text = "十字路口"; reading = "shízì lùkǒu"; translation = "intersection / crossroads" }; HK = @{ old = "十月"; text = "十字架"; reading = "sap6 zi6 gaa3"; translation = "cross" } }
    'things-goods' = @{ TW = @{ old = "食品"; text = "物品"; reading = "wùpǐn"; translation = "goods / articles" }; HK = @{ old = "食品"; text = "物料"; reading = "mat6 liu6"; translation = "materials" } }
    three = @{ TW = @{ old = "三個"; text = "三三兩兩"; reading = "sānsān liǎngliǎng"; translation = "in twos and threes" }; HK = @{ old = "三個"; text = "三角"; reading = "saam1 gok3"; translation = "triangle" } }
    tiger = @{ HK = @{ old = "虎皮"; text = "虎頭"; reading = "fu2 tau4"; translation = "tiger head" } }
    tongue = @{ TW = @{ old = "舌根"; text = "舌苔"; reading = "shétāi"; translation = "tongue coating" }; HK = @{ old = "舌頭"; text = "舌面"; reading = "sit6 min6"; translation = "tongue surface" } }
    tree = @{ HK = @{ old = "木門"; text = "木箱"; reading = "muk6 soeng1"; translation = "wooden box" } }
    'turn-back' = @{ TW = @{ old = "相反"; text = "反向"; reading = "fǎnxiàng"; translation = "opposite direction" } }
    two = @{ TW = @{ old = "二樓"; text = "二手市場"; reading = "èrshǒu shìchǎng"; translation = "secondhand market" } }
    upright = @{ HK = @{ old = "正中"; text = "正門"; reading = "zing3 mun4"; translation = "main gate" } }
    water = @{ HK = @{ old = "水杯"; text = "水塘"; reading = "seoi2 tong4"; translation = "reservoir / pond" } }
    west = @{ TW = @{ old = "西邊"; text = "西岸"; reading = "xī'àn"; translation = "west coast" }; HK = @{ old = "西面"; text = "西貢"; reading = "sai1 gung3"; translation = "Sai Kung, Hong Kong" } }
    white = @{ TW = @{ old = "白雲"; text = "白髮"; reading = "báifà"; translation = "white hair" }; HK = @{ old = "白色"; text = "白粥"; reading = "baak6 zuk1"; translation = "rice porridge" } }
    wife = @{ TW = @{ old = "前妻"; text = "妻小"; reading = "qīxiǎo"; translation = "wife and children" } }
    winter = @{ TW = @{ old = "冬日"; text = "冬瓜"; reading = "dōngguā"; translation = "winter melon" } }
    woman = @{ TW = @{ old = "女生"; text = "女主角"; reading = "nǚzhǔjiǎo"; translation = "female lead" }; HK = @{ old = "女士"; text = "女皇"; reading = "neoi5 wong4"; translation = "empress / queen" } }
    work = @{ TW = @{ old = "工地"; text = "工程"; reading = "gōngchéng"; translation = "project / engineering work" }; HK = @{ old = "工地"; text = "工程"; reading = "gung1 cing4"; translation = "project / engineering work" } }
    year = @{ TW = @{ old = "今年"; text = "年節"; reading = "niánjié"; translation = "New Year holiday" }; HK = @{ old = "今年"; text = "年宵"; reading = "nin4 siu1"; translation = "Lunar New Year fair" } }
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
        foreach ($definition in @($replacements[$id][$lane])) {
            $rows = @($record.focusCoverage.traditionalChinese.$($laneProperty[$lane]))
            $oldCount = @($rows | Where-Object { $_.text -eq $definition.old }).Count
            $newCount = @($rows | Where-Object { $_.text -eq $definition.text }).Count
            if ($oldCount -eq 0 -and $newCount -eq 1) { continue }
            if ($oldCount -ne 1) { [void]$preflightIssues.Add("$id [$lane] missing or duplicate '$($definition.old)'") }
            if ($newCount -gt 0) { [void]$preflightIssues.Add("$id [$lane] replacement already exists '$($definition.text)'") }
        }
    }
}
if ($preflightIssues.Count -gt 0) { throw "Chinese overlap reduction preflight failed:`n$($preflightIssues -join "`n")" }

foreach ($folder in Get-ChildItem -LiteralPath $SymbolsPath -Directory) {
    $path = Join-Path $folder.FullName "symbol.json"
    if (-not (Test-Path -LiteralPath $path)) { continue }
    $record = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json -Depth 100
    $id = [string]$record.id
    if (-not $replacements.ContainsKey($id)) { continue }
    $core = [string]$record.coreCharacter
    foreach ($lane in @("TW", "HK")) {
        if (-not $replacements[$id].ContainsKey($lane)) { continue }
        $property = $laneProperty[$lane]
        foreach ($definition in @($replacements[$id][$lane])) {
            $rows = @($record.focusCoverage.traditionalChinese.$property)
            if (@($rows | Where-Object { $_.text -eq $definition.old }).Count -eq 0 -and @($rows | Where-Object { $_.text -eq $definition.text }).Count -eq 1) { continue }
            $record.focusCoverage.traditionalChinese.$property = Replace-ChineseExample $record.focusCoverage.traditionalChinese.$property $definition.old $definition $language[$lane] $core
        }
    }
    $record | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $path -Encoding utf8
}

Write-Output "Applied the second scoped Chinese overlap-reduction audit to the regional Symbol examples."
