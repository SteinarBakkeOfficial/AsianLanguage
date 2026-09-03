# Shared CJK 306 Six-Stage EVOBC Pool

Status: broader discussion/replacement pool. This is not the current V1 list; V1 is the 126-character ZDIC-complete selection in [`zdic-v1-complete-manifest.json`](../../content/research/zdic-v1-complete-manifest.json).

Date: 2026-09-03

## Gate

This pool contains shared identities from the 808-character China–Japan–Korea universe that have an EVOBC index entry for all six historical stages:

`Oracle Bone → Bronze → Spring and Autumn → Warring States → Seal → Clerical`

The six-stage result is a source-index result. It means EVOBC lists at least one image reference in every stage; it does not yet mean that all six actual image files have been downloaded, rights-cleared, visually inspected, or specialist-approved.

## Counts

| Pool | Count | Status |
|---|---:|---|
| Shared four-language universe | 808 | Allowed identity boundary |
| EVOBC Oracle Bone-indexed shared identities | 404 | Broad research pool |
| EVOBC Oracle + Bronze + Seal + Clerical | 369 | Four-major-stage index pool |
| EVOBC all six stages | **306** | Broader research/replacement pool |
| Previous 148 visual-story reference retained in the six-stage pool | **119** | Superseded research candidate |

The 119-symbol candidate is not a new quota. It is the previous visual-story sequence intersected with the stricter six-stage pool. It preserves the earlier teaching order wherever the character satisfies the new completeness gate.

## Complete 306 identity list

```text
一七万三上下不东两丧中丰义乐乘九书买事二云五井亡交京亲人今从令以伐休会何保儿元兄先光入八公六共兴兵典内再出分则初利力劳化北区十千午华协卒单南印历厚去又及友反发取受古句可史各合吉同名听告商喜四固土圣在城基备夏夕多夜大天夫央奉女好妇妹妻姓子孙季学宅守安宗定室害家宿对射尊少尽尾山岁工左己师年广庆度建异弓引弟归往後徒得心念成我才执扶承改效教敢散文新方旅族无日旧易曲月有服朝木未朱杀来林树次止正武死母每比氏民气水永河泉浴深渔游父牛犬玉王甘生用田由申男登白百皆皇皮益盛目直相石视祖祝祭福秋立竞童终羊老考者耳育能臣自至舍舞良色若虎行衣西见角言谷豆责败贵赤走身车辛达远追逆通速重金长门闻阳阴陆降雨非革音须食饮首香马高鱼鸟鸣黄黑
```

This list is normalized to the shared identity forms. Local Simplified, Traditional, Japanese, and Korean display forms must remain separate in the per-character records.

## Provisional V1 candidate

The earlier recommendation was **119 provisional V1 symbols**, made by retaining the previous ordered visual-story reference only where the character occurred in this 306 pool. It has been superseded by the ZDIC-first decision: current V1 uses the 126 characters with all four ZDIC museum-stage selections.

1. Use full historical coverage first.
2. Then optimize for simple pictographs, reusable meaningful components, and compelling visual stories.

The previous 148 sequence is documented in [`shared-cjk-v1-visual-story-oracle-assessment.md`](shared-cjk-v1-visual-story-oracle-assessment.md). Of its 148 entries, 119 are in this six-stage pool and 29 are outside it:

```text
小 口 手 足 面 舌 肉 火 川 竹 米 刀 户 贝 片 册 示 明 采 向 望 步 前 集 争 冬 美 官 品
```

The retained 119 are:

```text
1 人   2 女   3 子   4 大   7 目   8 耳   11 身  12 首  16 心  17 言
18 自  20 水  21 山  22 木  23 土  24 石  26 日  27 月  28 天  29 雨
30 田  31 井  32 泉  33 牛  34 犬  35 羊  36 马  37 鱼  38 鸟  39 虎
40 角  43 豆  44 衣  45 皮  46 玉  47 王  49 弓  50 车  51 门  57 工
58 力  59 夕  60 由  61 申  62 云  63 西  64 南  65 北  66 东  67 年
68 老  69 白  70 黑  71 赤  72 黄  73 长  74 高  75 多  76 少  77 正
78 上  79 下  80 中  81 一  82 十  83 二  84 三  85 出  86 入  87 来
88 行  89 走  90 见  91 立  92 止  93 生  94 央  95 林  96 光  98 休
99 好  100 男  101 母  102 兄  103 友  104 公  105 民  106 兵  107 典
108 令  109 先  110 及  111 从  112 取  114 反  115 交  116 同  117 合
118 各  119 告  123 分  124 利  126 後  128 得  129 益  130 甘  132 祭
133 武  134 族  135 旅  136 夏  139 宗  140 守  142 宿  143 妻  144 祝
145 香  146 古  147 吉
```

Those 29 are not declared historically impossible. They are excluded from the provisional six-stage V1 until another source supplies and verifies the missing stage evidence. They become fallback candidates only after the 306 pool has been fully asset-audited.

## Multiple-source image audit

The research has checked more than one source family, with different roles:

- [Trilateral Cooperation Secretariat 808 publication](https://www.tcs-asia.org/data/etcData/PUB_jp_1689038202.pdf), plus [Aige’s transcription](https://www.aige.co.uk/resource/details.asp?id=5) and [Kangxi Dictionary’s transcription](https://www.kangxizidian5.com/zhongrihan808/), for the shared four-language universe.
- [EVOBC paper](https://arxiv.org/abs/2401.12467) and [EVOBC dataset](https://huggingface.co/datasets/HaisuGuan/EVOBC), for the six-stage image inventory.
- [Xiaoxuetang / Academia Sinica Oracle Bone database](https://xiaoxue.iis.sinica.edu.tw/jiaguwen), which reports 2,548 Oracle Bone character heads and 24,701 glyph forms.
- [HUST-OBC research dataset](https://doi.org/10.1038/s41597-024-03807-x), an independent Oracle Bone image dataset with 1,588 deciphered categories and 9,411 undeciphered categories.
- [Hanzi/Kanji Etymology Dictionary](https://github.com/lbm364dl/hanzi-etymology-dict), including its Dong Chinese historical SVG collection and aggregated etymology sources.
- [Unicode Old Hanzi proposal](https://www.unicode.org/L2/2015/15280-n4687-oracle-bone.pdf), for the broader encoding and source landscape.
- [Tencent’s Oracle Bones Corpus summary](https://www.tencent.com/en-us/articles/2201854.html), for the broader archaeological estimate of approximately 4,500 discovered unique characters.

Current actual-file status is stricter than the 306 index result: the Dong Chinese repository provides local Oracle SVGs for 146 of the shared 808, while the EVOBC raw archive has not yet been unpacked into the project. Separately, the ZDIC-first intake has acquired 568 research-only images for the 148-candidate assessment, with 504 images covering the 126 current V1 records. These ZDIC files are not commercially cleared or runtime-bundled.

The exact manual-review paths for every row are documented in the [306 source-link register](shared-cjk-306-source-link-register.md). It includes EVOBC IDs, representative filenames by stage/source, the archive path, Xiaoxuetang lookup instructions, and direct Dong SVG links where available.

## V1 decision rule

Do not confuse the 306 research pool with the current V1. The current V1 has already been restricted to the 126 complete ZDIC selections; use the 306 pool for future source comparison, replacements, and V2/V3 expansion.
