# Shared CJK V1 Visual-Story Gate

Status: superseded discussion decision artifact. This document records the inclusion principle that led to the earlier 148-symbol design reference; the current V1 selection is the 126-character ZDIC-complete subset recorded in [the V1 manifest](../../content/research/zdic-v1-complete-manifest.json). It does not approve runtime content or historical assets.

Date: 2026-09-02

## Core decision

The museum is not trying to reach exactly 120 characters. The earlier 120 was a review pool, not a release quota. The current V1 selection is the 126-character ZDIC-complete set; the existing 100–200 planning envelope remains useful for future expansion, but incomplete-evolution characters are not added to this V1.

Visual storytelling is the primary V1 gate. Simple, historically early pictographs are the foundation and the model candidates for the beginning of the museum. Every character admitted to the initial Symbol Journey must let a learner see a defensible relationship between an early form, its meaningful parts, and the later character. Where the evidence does not support that relationship, the character stays out of the museum even if it is useful or historically old. Meaningful indicators and transparent multi-component characters are valuable later teaching layers because they show how writing evolved beyond the first simple pictures.

## What counts as a visual story

A candidate can qualify through one of these forms:

1. **Direct pictograph:** the early sign depicts the referent or a recognizable part of it, such as `火`, `木`, `山`, or `目`.
2. **Meaningful indicator:** marks, position, or spatial arrangement contribute directly to the concept, such as an upper/lower or boundary relationship.
3. **Meaningful compound:** two or more components contribute to the concept, and the relationship can be shown honestly. `光` is an excellent advanced example: fire above a kneeling person, with the arrangement supporting the early meaning of light. It belongs after the foundational pictographs, as evidence of the writing system becoming more complex.
4. **Component-family story:** a historically meaningful component is reused or transformed in a way that teaches how the new meaning developed.

The lesson does not need to claim that a modern character is a literal drawing. It must distinguish what is visually meaningful, what is phonetic, and what remains debated.

## What does not qualify by itself

- A historical record without a meaningful visual explanation is not enough.
- A phonosemantic character whose components mainly provide sound is not suitable for the initial museum journey merely because it is common or historically old.
- A semantic component may be included in a mixed formation only when its independent visual role is clear and the sound-bearing component is labelled honestly rather than depicted as meaning.
- A generated or modern glyph styled to look ancient must never stand in for missing historical evidence.

`花` is the current cautionary example. The available explanation identifies `艹` as the semantic domain and `化` as the sound component, while the current cross-check did not find the source-backed historical sequence needed for the museum lesson. It should therefore stay out of visual-story V1 for now, while remaining eligible for the broader library or later research.

`光` is a preferred advanced candidate for review because its early explanation has the kind of meaningful multi-component relationship the museum should eventually teach: fire over a person. It is not a replacement for the simple pictograph foundation. The direct [Dong Chinese `光` page](https://www.dong-chinese.com/wiki/%E5%85%89) shows Oracle Bone, Bronze, Seal, and Clerical stages and describes that visual story. It still needs the normal four-language, rights, and specialist review before runtime approval.

## Evidence snapshot

The 808-character universe remains the allowed shared Chinese/Japanese/Korean identity boundary. Screening of the 808 produced:

- 122 pictographic-only identities;
- 13 pictographic + ideographic identities;
- 5 indicative-only identities; and
- 16 identities labelled pictographic + phono-semantic, plus 2 with pictographic + ideographic + phono-semantic labels.

The first three groups form a 140-identity no-phono image-led screening pool. This is a useful place to look first, not an automatic V1 list. Some ideographic compounds outside that 140 may also have excellent visual stories; they should be judged by the explanation, not rejected by label alone. Conversely, an entry labelled pictographic still requires source and interpretation review.

For the earlier 120-row research pool, the independent checks found 119/120 Xiaoxuetang evolution records, 108/120 EVOBC Oracle Bone indexed records, and 120/120 EVOBC records at some historical stage. These figures establish research availability, not museum eligibility. The current V1 asset gate is the actual four-stage ZDIC selection recorded in the V1 manifest.

## Proposed status vocabulary

Use these statuses in the future row-level candidate sheet:

| Status | Meaning |
|---|---|
| `visual_story_candidate` | A direct pictograph, indicator, or meaningful compound appears teachable; evidence review continues. |
| `visual_story_review` | A plausible story exists, but the formation, component roles, or historical interpretation needs specialist review. |
| `visual_story_excluded` | The current evidence is primarily phonetic, too uncertain, or not honestly drawable for the museum lesson. |
| `library_or_v2` | Useful shared character, but not a strong initial Symbol Journey candidate. |
| `asset_pending` | The explanation qualifies in principle, but approved historical assets are not yet available. |

These are not language proficiency or popularity ratings. A character must also pass the shared Kanji/Hanja identity check and four-track relevance review.

## Sequencing implication

The museum should follow a dependency-first teaching order, not just a list of easy characters. The learner should first meet simple pictographs that later function as meaningful components, then encounter compounds built from components they already know. For example, teach fire and the human/kneeling-person idea before introducing `光` as fire above a person.

Every recommended row must receive a numeric `teaching_order` from `1 → X` and a `prerequisites` field. The number is the museum's instructional sequence, not a ranking of cultural importance or modern frequency. A compound should not appear before the component ideas needed to understand its visual story.

The first approximately 50 journeys should be selected across the ten semantic collections, but should be dominated by simple pictographs and ordered by clarity, component usefulness, and historical/structural complexity rather than by collection completion:

1. recognizable single images;
2. simple indicators and spatial signs;
3. transparent combinations with meaningful components;
4. component-family lessons; and
5. more complex or disputed stories, only when their caveats can be taught clearly.

The ten collections can remain the discovery structure. Pictographs, indicators, meaningful compounds, and historical continuity are better treated as cross-cutting lenses or filters. The Pictographs lens should be a genuine foundation, not merely a label applied to advanced compounds. Collection balance matters, but it cannot promote a candidate that fails the visual-story gate.

## Next artifact

The next corpus artifact should audit each current candidate row-by-row, including `光` and the removal/holdout status of `花`. Required fields are: `teaching_order` (`1 → X`), prerequisites, visual-story summary, meaningful component roles, sound component roles where applicable, earliest verified stage, exact source links and rights, Kanji/Hanja/shared-identity evidence, four-track usage, example words, illustration brief, and reviewer status. Only after this audit should the final V1 count be chosen.

Related research:

- [Shared CJK 808 V1 recommendation](shared-cjk-808-v1-recommendation.md)
- [120 historical cross-check](shared-cjk-120-historical-cross-check.md)
- [808 historical evidence register](shared-cjk-808-historical-evidence.md)
- [808 allowed character universe](shared-cjk-allowed-character-universe.md)
