# Shared CJK 808 V1 Recommendation

Status: superseded discussion proposal. The current V1 target is the 126-character ZDIC-complete selection in [`zdic-v1-complete-manifest.json`](../../content/research/zdic-v1-complete-manifest.json). This document remains useful for earlier 120-character screening history and does not approve runtime content or historical assets.

Date: 2026-09-02

## Recommendation in one sentence

The earlier proposal used **120 characters as a review pool**, not a release quota. It has been superseded by the 126-character ZDIC-complete V1 target. The beginning of the museum remains built around simple pictographs with the strongest early evidence; advanced meaningful compounds can follow to show how the writing system evolved.

## Why the 808 is not the V1 list

The official shared-character set is the right master boundary, but it is not a museum curriculum. It contains:

- characters with direct visual origins;
- indicators and associative compounds;
- phonetic loans and phono-semantic formations;
- later abstractions whose modern form no longer explains its meaning visually; and
- characters that are shared in the Chinese/Japanese/Korean inventory but may have very different contemporary usage patterns.

The 808 remains the library and reference universe. V1 should be the smaller set with the strongest combination of visual story, historical evidence, modern relevance, teaching usefulness, collection balance, and asset availability.

## Formation-type evidence

The following is a screening result from the open-source [Hanzi/Kanji Etymology Dictionary](https://github.com/lbm364dl/hanzi-etymology-dict), after matching the 808 identities with regional variant normalization. That project combines many sources and explicitly preserves conflicts; it is useful for candidate discovery, not a substitute for specialist adjudication.

| Normalized formation labels | Identities | V1 implication |
|---|---:|---|
| Pictographic only | 122 | Strongest initial image-led pool. |
| Pictographic + ideographic | 13 | Good candidates when the visual relationship is clear. |
| Pictographic + phono-semantic | 16 | Review only when a meaningful visual role remains independently defensible; never depict the sound component as meaning. |
| Pictographic + ideographic + phono-semantic | 2 | Review only with a clear meaningful story and specialist interpretation. |
| Indicative only | 5 | Strong museum candidates when the spatial/marking explanation is defensible. |
| Ideographic only | 169 | Useful meaningful compounds; selectively add when the components visibly explain the concept. |
| Ideographic + phono-semantic | 68 | Usually V2; consider only when the semantic component independently creates a clear visual lesson. |
| Phono-semantic only | 410 | Default V1 exclusion under the current museum principle. |
| Phonetic loan only | 1 | Default exclusion from the origin museum. |
| No formation classification in this source | 2 | Research queue, not automatic inclusion. |
| **Total** | **808** | Conflicting labels are retained rather than silently flattened. |

The broad source label “pictographic” appears on 153 identities. The cleaner no-phono image-led pool is 140 identities: 122 pictographic-only, 13 pictographic/ideographic, and 5 indicative. This is the most defensible starting pool for the Symbol Journey, but not every one of those 140 is automatically relevant or asset-ready.

The [EVOBC historical pass](shared-cjk-808-historical-evidence.md) independently found 404 identities with an OBC-indexed record and 397 with other pre-imperial indexed evidence. These numbers overlap the formation categories in different ways: an OBC record does not make a character pictographic, and a pictograph does not guarantee that every proposed historical form is securely interpreted.

## V1 gates

Each candidate should pass these gates before becoming a release record:

1. **Shared identity gate:** it is one of the 808 allowed identities and has verified Chinese, Japanese Kanji, and Korean Hanja forms. Regional glyph differences are stored as local forms, not treated as new identities.
2. **Visual-story gate:** the early form and meaningful parts support a defensible explanation. Direct pictographs, indicators, and meaningful multi-component compounds are welcome; sound-only formations are not.
3. **Historical gate:** at least one source-backed stage is available, with exact identity mapping and provenance. Oracle Bone, Bronze, and Seal evidence must not be conflated.
4. **Teaching gate:** a learner can compare the early form, the meaningful transformation, and the modern form without a false “this picture directly became this meaning” story.
5. **Four-language relevance gate:** Mandarin/Traditional Chinese, Japanese Kanji, and Korean Hanja entries have useful modern recognition or cultural/lexical context. Korean relevance must be labelled honestly where Hanja is not ordinary daily spelling.
6. **Asset gate:** historical glyphs are source-backed/licensed or remain an explicit missing asset. Educational reconstructions may explain an idea but may never substitute for historical evidence.

Purely phonetic constructions should normally remain in the 808 library or a later release. They can be useful language-learning data, but they do not satisfy the first-release museum promise unless their semantic component has a separately defensible visual role.

## Earlier 120-row research pool

The list below is a deliberately reviewable **research pool**, not a final V1 list. The previous “104 Core / 16 Conditional” wording is retired as an approval model: a row marked conditional is not promised inclusion, and even a previously stronger row must pass the visual-story audit. The collections are instructional homes, not exclusive linguistic classes. A final record may receive additional collection/lens memberships.

### Collection coverage in the earlier draft

The two middle columns preserve the earlier screening split for traceability only. They are not current approval statuses: every row must now pass the visual-story audit individually.

| Collection | Earlier stronger screen | Earlier review screen | Pool total |
|---|---:|---:|---:|
| Nature & Cosmos | 14 | 1 | 15 |
| Plants, Animals & Food | 13 | 1 | 14 |
| People, Body & Life | 18 | 2 | 20 |
| Home, Tools & Materials | 10 | 0 | 10 |
| Place, Direction & Movement | 11 | 0 | 11 |
| Time, Number & Measure | 11 | 0 | 11 |
| Family, Society & Institutions | 7 | 3 | 10 |
| Action, Work & Change | 8 | 4 | 12 |
| Mind, Speech & Learning | 4 | 5 | 9 |
| Qualities, Relations & Abstract Ideas | 8 | 0 | 8 |
| **Earlier draft total** | **104** | **16** | **120** |

The release count remains open. If a candidate does not clear the visual-story gate, keep it in the 808 library or a later release—even if that produces fewer than 120 museum journeys. The broader V1 planning envelope remains 100–200; if the audited candidates do not reach 100, expand the same research process before release. If a 120-sized review pool is useful, `光` is the preferred replacement discussion for the current `花` holdout.

### 1. Nature & Cosmos — 15

```text
Earlier screen: 上 下 中 土 山 川 日 月 木 水 火 雨 风 天
Earlier review: 云
```

### 2. Plants, Animals & Food — 14

```text
Earlier screen: 牛 犬 羊 马 鱼 鸟 虫 虎 竹 米 豆 麦 果
Earlier review: 花
```

### 3. People, Body & Life — 20

```text
Earlier screen: 人 女 子 夫 儿 兄 目 耳 口 手 足 身 心 首 面 鼻 齿 骨
Earlier review: 父 母
```

### 4. Home, Tools & Materials — 10

```text
Earlier screen: 刀 弓 册 门 户 衣 车 片 玉 王
```

### 5. Place, Direction & Movement — 11

```text
Earlier screen: 入 出 北 南 来 从 行 走 见 乡 通
```

### 6. Time, Number & Measure — 11

```text
Earlier screen: 一 七 十 二 三 五 八 九 百 千 万
```

### 7. Family, Society & Institutions — 10

```text
Earlier screen: 公 士 民 兵 祖 神 友
Earlier review: 信 武 祭
```

### 8. Action, Work & Change — 12

```text
Earlier screen: 反 交 看 立 止 采 回 开
Earlier review: 休 伐 取 受
```

### 9. Mind, Speech & Learning — 9

```text
Earlier screen: 言 文 字 书
Earlier review: 学 思 念 问 闻
```

### 10. Qualities, Relations & Abstract Ideas — 8

```text
Earlier screen: 大 小 多 少 正 直 明 美
```

## Important candidate notes

- `止` appears in both movement/action teaching conceptually; it should have one primary home and a cross-cutting component link.
- `云`, `父`, `母`, `信`, `武`, `祭`, `休`, `伐`, `取`, `受`, `学`, `思`, `念`, `问`, and `闻` remain row-level visual-story review candidates; their former “conditional” label is not an inclusion promise.
- `花` is currently excluded from visual-story V1 because the available explanation is phono-semantic (`艹` meaning plus `化` sound) and the historical sequence was not found in the current cross-check. Keep it in the library/research queue unless stronger source-backed evidence changes that judgment.
- `光` is the preferred replacement candidate to audit because its fire-over-person explanation is a meaningful multi-component visual story. It may be added to the research pool without implying that the final release must contain exactly 120.
- The candidate list intentionally includes a small number of associative compounds—such as person + tree, person + speech, or weapon + foot—because these can teach how visual components combine without pretending they are simple pictographs.
- No review candidate should receive a “pure picture” illustration. Its lesson must show which parts contribute meaning, which parts contribute sound, and what remains uncertain.
- The current list is a content/design research pool, not a final frequency ranking or release commitment. The row-level audit may promote, demote, replace, or remove entries; no minimum count is created by this document.

## What should stay out of V1 by default

- The 410 identities classified as phono-semantic only, unless a specialist review shows that the semantic component itself gives a strong, honest visual lesson.
- The 68 identities classified as ideographic + phono-semantic until the semantic/phonetic roles are documented separately.
- Any character whose only available “ancient” image is a generated reconstruction, an unlicensed derivative, or a modern form styled to look old.
- Any entry that fails the Japanese Kanji or Korean Hanja identity gate, even if it is historically beautiful or highly useful in Chinese.
- Any character with an attractive but disputed story where the uncertainty cannot be explained clearly to a learner.

## Decision requested

For the next discussion, review these three choices:

1. Keep the 10 semantic collections as the main V1 discovery structure.
2. Adopt the visual-story gate and choose the final release count only after the row-level audit; do not force the museum to 120.
3. Keep Pictographs, Indicators, Associative Compounds, Meaning + Sound, and Historical Continuity as lenses rather than competing peer collections.

After that decision, the next research artifact should be a row-level visual-story candidate sheet for the current pool (including `光` and the `花` holdout): meaningful component roles, sound roles where applicable, four-language readings/usages, exact historical stages, source/rights, example words, image brief, and reviewer status.
