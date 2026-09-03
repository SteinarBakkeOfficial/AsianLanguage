# Shared CJK 808 Historical Evidence Register

Status: discussion research artifact. This is a source-indexed research register, not a final specialist-approved historical-glyph catalogue and not an approval of runtime assets.

Date: 2026-09-02

## What was checked

The 808 identities were compared with the public EVOBC metadata after applying a public Simplified-to-Traditional character-variant table. The comparison also records the source label separately from the normalized shared identity, because one historical dataset may contain `来` and another may contain `來` while the product treats them as one shared identity. The local source-normalized identity `硏` was additionally matched to dataset label `研`.

Sources used for this pass:

- [EVOBC research paper](https://arxiv.org/abs/2401.12467)
- [EVOBC repository and metadata](https://github.com/RomanticGodVAN/character-Evolution-Dataset)
- [OpenCC STCharacters variant table](https://github.com/BYVoid/OpenCC/blob/master/data/dictionary/STCharacters.txt)
- [Academia Sinica Xiaoxuetang overview](https://ascdc.sinica.edu.tw/en/single_news_page.jsp?newsId=415)
- [Unicode Oracle-Bone proposal](https://www.unicode.org/L2/2015/15280-n4687-oracle-bone.pdf)

EVOBC describes coverage across Oracle Bone, Bronze, Spring and Autumn, Warring States, Seal, and Clerical stages. Its paper also warns that only approximately 1,600 of more than 4,500 extant oracle-bone characters have been elucidated. Therefore, absence from this dataset is not proof that a character had no early form.

Xiaoxuetang is a complementary research source with a much broader historical corpus. It should be consulted for disputed or missing EVOBC records before any historical claim is published.

## Coverage result

| Research bucket | Count | Interpretation |
|---|---:|---|
| OBC-indexed | 404 | An EVOBC record contains an Oracle Bone stage label after identity/variant normalization. |
| Pre-imperial indexed, no OBC hit | 397 | An EVOBC record contains Bronze, Spring/Autumn, Warring States, or Seal evidence, but no OBC stage label in this pass. |
| No EVOBC row | 7 | No matching EVOBC identity was found after the stated normalization. This is a research gap, not a claim of no history. |
| **Total** | **808** | Complete allowed universe. |

Additional stage counts in the normalized EVOBC comparison are: Bronze 590, Seal 800, Spring and Autumn 433, Warring States 740, and Clerical 756. These are stage-presence counts, not unique historical origins, and a character can occur in multiple stage counts.

## List A — OBC-indexed candidates (404)

These are the strongest initial machine-indexed pool for an oracle-bone review. `OBC-indexed` means that EVOBC metadata contains an OBC-labelled image path; it does not yet mean that the exact glyph, reading, interpretation, stage, or rights have been manually approved for the Symbol Journey.

```text
一七三上下不中主乘九事二五井亡交京人今令以伐休何作来依保备传元兄兆先光免儿入内两八公六共兵典册再冬出刀分初利则前力助劳化北区十千午卒协南印厚去参又及友反取受口古句可史各合吉同名向君吹告品商问喜丧单四因困固土在城执基夏夕多夜大天太夫央失奉女好如妹妻姓妇子季孙学宅守安宗官定室害家宿寒射将尊对小少就尾展山岛川工左己市师年幸幼度庭广建弓引弟往律後徒得从心必念庆成我户才扶承采改效败教敢散文新方施旅族日明易昔星春昼暮暴曲更书会月有服望朝木未朱东林栽乐树权次止正步武岁历归死杀母每比氏民气水永河油泉注洗浴深温渔火无争父片牛物犬玉王甘生用田由申男画异登发白百皆皇皮益盛尽目直相省石示祖祝祭福秋谷立童竞竹米终绿续羊美义习老考者耳圣闻声听肉育能臣自至致兴旧舌舍舞良色若华万虎虫血行街衣西要见视亲角解言设证变豆丰贝责贮贵买赤走足身车辛追逆通速进游达远乡酒医重量金长门防降阴陆阳集雨雪云非面革音顶须风食饮首香马高鱼鸟鸣麦黄黑鼻齿
```

## List B — pre-imperial indexed, no OBC hit (397)

These have an EVOBC historical-stage index from Bronze, Spring and Autumn, Warring States, or Seal material in this pass. They may still be excellent museum candidates, especially when the lesson depends on a later component or a clear Seal-script transition. They should not be presented as oracle-bone forms unless another source independently supports that claim.

```text
世久仁他仙代仰伏位低住佛使例便俗信修个借假伟停伤价亿充全冰冷刑列判别到功加勇勉动务胜势勤劝半危卷原右否味呼命和哀唱善严回国园圆图团地均堂坚报场增士壮寿外妙姊始威婚字存孝宇完宙客容密富察实写寸寺尺局居屋崇巨已布希席常平序店式弱强形彼待德忍志忘忠快怒思急性怨恨恩悟患悲情惜惠恶想愁意爱感慈忧应战所手打技投抱招拜拾持指授探接推扬支收放政故救敬敌数料早昨是时晚景晴暑暖暗最期末本材村松果枝柔校根案植业极荣桥欲歌欢毛江决治法波泣泰洋活流浪浮海消凉净混浅清减湖满汉洁烈然烟热特独球理产界留番当病的看真眼着知短破硏神禁礼秀私科移税种究空窗章端笑第笔等答算节精约红纯纸素细结绝给统经线练罪耕胸脱与举船花苦英草菜落叶著艺药处虚号众表制观计训记访许试诗话语诚误说谁课调谈请论诸讲谢识议读让财贫货贺赏贤卖质起路军轻农迎近退送造连遇运过道适选遗部都里野针银钱钟铁闭开闲间关限除雄难电露青静韩顺领头题愿飞饭养馀惊骨体鲜点
```

## List C — no EVOBC row (7)

```text
忙 忆 灯 现 眠 茶 认
```

This list means “not matched in the current EVOBC metadata pass.” It should be investigated through Xiaoxuetang, paleographic dictionaries, and specialist references before being assigned a historical status. In particular, a missing dataset row must never be filled with a generated illustration or a modern form presented as an ancient one.

## Evidence status used by the product

The machine-indexed lists above should be converted into the stricter project statuses only after review:

- `O-source`: source dataset/catalogue contains an OBC candidate; specialist identity and asset review pending.
- `O-verified`: source-backed OBC form reviewed for identity, interpretation, stage, and provenance.
- `B/S-verified`: Bronze and/or Seal evidence is reviewed, with no established OBC evidence for that record.
- `C/R-verified`: Clerical and/or Regular evidence is available, while earlier evidence remains unresolved.
- `Later-or-uncertain`: lineage, interpretation, or dating is disputed or appears later.
- `Missing-evidence`: no approved historical stage is currently available to the project.

The current 404/397/7 numbers are therefore **source-index counts**, not final counts of `O-verified`, `B/S-verified`, or approved museum assets.

## Required row-level audit

Before a character enters the Symbol Journey, its research row should include:

| Field | Required question |
|---|---|
| Shared identity | Which of the 808 identities is this, and which local variants map to it? |
| Modern relevance | Is it represented in Chinese, Japanese Kanji, and Korean Hanja, with honest usage contexts? |
| Formation | Pictograph, indicator, associative compound, meaning-plus-sound, loan, or uncertain? |
| Historical stages | Which exact OBC/BI/SAC/WSC/SS/CS/R forms are present? |
| Interpretation | Is the identity and meaning secure, probable, or disputed? |
| Provenance | Which source, catalogue, image ID, and license support the form? |
| Teaching story | Can the learner compare the early form to the modern character without a false simplification? |
| Asset state | Bundled licensed/source-backed asset, pending review, or explicit missing asset? |

## Immediate conclusion for V1 discussion

The 404 OBC-indexed identities are the first pool to review for the “early bone script to modern form” experience. The 397 pre-imperial-but-no-OBC identities are not second-rate; many may have better-documented Bronze or Seal transitions and may teach complex characters more honestly. The 7 unmatched identities remain allowed by the shared-character boundary but should not receive a historical journey until independently researched.

The next selection question is not “which 100?” It is: which combination of historically defensible, cross-language relevant, visually teachable, and collection-balancing entries should form V1, with the remainder staged for V2/V3 or the library?
