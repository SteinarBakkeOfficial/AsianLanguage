# Shared CJK V1 120 Historical Cross-Check

Status: superseded discussion research artifact. This records the independent source check of the earlier proposed 120. The current V1 target is the 126-character ZDIC-complete selection in [`zdic-v1-complete-manifest.json`](../../content/research/zdic-v1-complete-manifest.json); this document does not approve historical assets.

Date: 2026-09-02

## Conclusion

The proposed 120 is useful as a historical research pool, but historical availability does not automatically make a character suitable for the museum. The primary V1 question is whether each row has a source-backed, honest visual story:

- **119/120** returned an evolution record from Academia Sinica's Xiaoxuetang character-evolution database.
- **108/120** have an Oracle Bone indexed record in EVOBC.
- **12/120** have no EVOBC OBC hit, but do have other pre-imperial EVOBC evidence.
- **`花`** is the only candidate with no Xiaoxuetang evolution result in this check and no historical image in the direct Dong Chinese page.

Recommendation at the time: preserve the 120 rows as a review pool, not as a required V1 scope. Keep `花` out of visual-story V1 for now. **`光`** was the preferred replacement candidate because a direct Dong Chinese page describes an early fire-over-person image. This recommendation is superseded by the current 126-character ZDIC-complete V1 selection.

## Sources and method

The complete candidate set is the 120 unique identities in [`shared-cjk-808-v1-recommendation.md`](shared-cjk-808-v1-recommendation.md). Each source was treated as evidence for a different question:

1. **EVOBC** — Does the identity have indexed historical-stage material across Oracle Bone, Bronze, Seal, Warring States, Spring and Autumn, or Clerical sources?
2. **Xiaoxuetang** — Does the independent Academia Sinica evolution database return a character-level historical sequence? Queries retried source-native Traditional variants when the normalized form had no result.
3. **Hanzi/Kanji Etymology Dictionary / Dong Chinese-backed metadata** — Does the record have an etymology, formation explanation, source aggregation, or Dong historical-image metadata? Direct pages were spot-checked for disputed cases, especially `花` and the proposed replacement `光`.

Sources:

- [EVOBC paper](https://arxiv.org/abs/2401.12467)
- [EVOBC repository](https://github.com/RomanticGodVAN/character-Evolution-Dataset)
- [Academia Sinica Xiaoxuetang guide](https://xiaoxue.iis.sinica.edu.tw/guide/)
- [Academia Sinica Xiaoxuetang evolution database](https://xiaoxue.iis.sinica.edu.tw/yanbian)
- [Hanzi/Kanji Etymology Dictionary](https://github.com/lbm364dl/hanzi-etymology-dict)
- [Dong Chinese `花` page](https://www.dong-chinese.com/wiki/%E8%8A%B1)
- [Dong Chinese `光` page](https://www.dong-chinese.com/wiki/%E5%85%89)
- [TCS shared 808 boundary](https://www.tcs-asia.org/en/cooperation/mechanism.php?topics=4)

Xiaoxuetang states that its evolution database covers Oracle Bone, Bronze, Warring States, Seal, and Regular materials and currently contains 13,779 head characters and 44,282 forms. Its guide also says that the database can present the historical sequence from Shang oracle-bone forms through Western Zhou Bronze, Warring States, Small Seal, and Clerical material. This makes it a useful independent cross-check, while the exact interpretation of each glyph still requires specialist review.

## Coverage by source

| Source check | Result | What it means |
|---|---:|---|
| Proposed candidates | 120/120 | The candidate list is unique and remains inside the allowed 808. |
| EVOBC any indexed stage | 120/120 | Every candidate matched an EVOBC historical-stage record. |
| EVOBC Oracle Bone indexed | 108/120 | Strongest initial OBC research pool. |
| EVOBC pre-imperial indexed, no OBC | 12/120 | Bronze/Seal/Spring/Warring evidence exists; no OBC hit in EVOBC. |
| Xiaoxuetang any evolution record | 119/120 | Independent character-level historical sequence found. |
| Xiaoxuetang Oracle Bone result | 103/120 | OBC result detected in the returned evolution sequence. |
| Xiaoxuetang Bronze result | 107/120 | Bronze result detected. |
| Xiaoxuetang Warring States result | 114/120 | Warring States result detected. |
| Xiaoxuetang Seal result | 117/120 | Seal/Small Seal result detected. |
| Xiaoxuetang Clerical result | 115/120 | Clerical result detected. |
| Hanzi/Dong-backed etymology record | 120/120 | Formation, etymology, or modern record exists in the secondary aggregation. |
| Dong historical-image metadata: Oracle | 68/120 | Historical image coverage in that source layer. |
| Dong historical-image metadata: Bronze | 78/120 | Historical image coverage in that source layer. |
| Dong historical-image metadata: Seal | 73/120 | Historical image coverage in that source layer. |

The stage counts are not expected to match exactly. These sources have different headword normalization, variant handling, source selections, and asset coverage. A missing stage in one source is a discrepancy to review, not proof that the stage never existed.

## Candidates without EVOBC OBC evidence

These 12 have other pre-imperial EVOBC evidence and therefore remain historical candidates, but they should not be described as Oracle Bone forms solely from the current EVOBC pass:

```text
果 花 手 骨 士 神 信 看 回 开 字 思
```

The independent Xiaoxuetang check returned OBC results for many candidates in this kind of cross-source discrepancy. This is why the lists should be retained as source-specific evidence rather than flattened into one “has OBC / has no OBC” truth field.

## The `花` holdout

`花` is the only candidate that returned no Xiaoxuetang evolution result in this 120-query audit. The direct [Dong Chinese page for `花`](https://www.dong-chinese.com/wiki/%E8%8A%B1) does provide a modern etymology and identifies the character as a phonosemantic formation: the grass component contributes the semantic domain and `化` contributes sound. It does not provide the historical glyph sequence needed for the museum journey.

This does not mean `花` has no history. It means that the project does not yet have a source-backed, reviewable historical asset path for this candidate. Under the project guardrails, it should remain a conditional/library entry until Xiaoxuetang, a specialist paleographic source, or another rights-cleared source supplies the missing evidence.

## Preferred visual-story candidate: `光`

`光` is a strong **advanced** candidate because it reinforces the project's component-based teaching goal after the learner has encountered the foundational pictographs. The direct [Dong Chinese page for `光`](https://www.dong-chinese.com/wiki/%E5%85%89) describes it as an early image of fire above a kneeling person and displays Oracle Bone, Bronze, Seal, and Clerical stages. It also explicitly describes the components as iconic and links the modern meaning to the visual arrangement. This is the target pattern for meaningful complex characters, not a replacement for the simple pictograph foundation or a reason to preserve an exact count.

`光` should still pass the same four-language inventory check, rights review, and specialist interpretation review before becoming runtime content. It is a replacement proposal, not yet a corpus decision.

## Recommended museum sequencing

The 120 should not be displayed in collection order. Use a cross-collection difficulty curve:

1. **Foundational pictographs:** recognizable single images of body, person, animals, natural elements, tools, and basic landscape forms.
2. **Simple indicators and spatial signs:** quantity, position, direction, boundary, and movement.
3. **Transparent combinations:** two meaningful visual parts whose relationship is easy to illustrate, introduced after the foundational pictographs.
4. **Component-family lessons:** a known visual component reused in a new meaning domain.
5. **Complex candidates with a defensible story:** compounds whose meaningful visual relationship can be shown clearly; purely phonetic or unresolved candidates remain outside the museum sequence.

The first 50 should be selected mostly from the first three groups. More complex candidates should be distributed later, after the learner has seen the component vocabulary they depend on. This supports the museum story without making the collection pages rigidly chronological or forcing each semantic category to be completed before another begins.

## Lock recommendation

Do not lock the release count from this historical cross-check alone. Instead:

- keep the 120 rows as the current review pool;
- mark `花` as outside visual-story V1 for now, while retaining it in the library/research queue;
- audit `光` as the preferred replacement/candidate because it has the desired meaningful multi-component story;
- do not generate an ancient-looking `花` glyph to fill the gap;
- continue the row-level visual-story, Japanese Kanji, Korean Hanja, Chinese usage, example-word, specialist, and rights audits before implementation.
