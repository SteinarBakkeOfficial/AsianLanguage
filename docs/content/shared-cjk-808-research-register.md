# Shared CJK 808 Research Register

Status: discussion research artifact. This document records the proposed collection system, relevance model, historical-evidence workflow, and current research status for the 808-character allowed universe. It does not create runtime records or approve V1 content.

Date: 2026-09-02

## Scope

The complete allowed universe is documented in [`shared-cjk-allowed-character-universe.md`](shared-cjk-allowed-character-universe.md). Every V1, V2, and V3 candidate must be drawn from that list and must retain verified Japanese Kanji and Korean Hanja membership.

The 808 set is a shared/common-use boundary, not a claim that every entry has the same frequency, meaning, pronunciation, glyph shape, or writing-system prominence in China, Japan, and Korea. Local forms and local usage are separate data fields.

## Recommended collection model

Recommendation: use 10 semantic collections for primary discovery, with historical/structural lenses layered across them. Ten is a design starting point, not a requirement that every collection contain an equal number of characters.

### Semantic collections

1. **Nature & Cosmos** — earth, sky, weather, light, landscape, water, fire, seasons, and natural forces.
2. **Plants, Animals & Food** — plants, crops, animals, food, farming, growth, and domesticated life.
3. **People, Body & Life** — people, family-body vocabulary, perception, health, birth, age, and death.
4. **Home, Tools & Materials** — homes, clothing, containers, tools, weapons, vehicles, writing materials, metal, jade, and money objects.
5. **Place, Direction & Movement** — locations, inside/outside, directions, roads, travel, entering/leaving, and physical movement.
6. **Time, Number & Measure** — numbers, dates, day/night, sequence, duration, size, amount, and comparison.
7. **Family, Society & Institutions** — kinship, rank, government, law, military, community, country, ritual, and institutions.
8. **Action, Work & Change** — making, using, taking, giving, receiving, seeing, hearing, learning, changing, and states of activity.
9. **Mind, Speech & Learning** — thought, feeling, intention, speech, writing, reading, knowledge, teaching, questions, and answers.
10. **Qualities, Relations & Abstract Ideas** — good/bad, hot/cold, color, order, cause, contrast, similarity, truth, value, and other abstract relations.

The primary collection is an editorial home, not a linguistic classification. Secondary membership is allowed when a character genuinely teaches more than one idea. The complete 808-character library remains the fallback destination for anything that does not yet have a finished collection lesson.

### Cross-cutting lenses

These should not be treated as competing semantic collections:

- **Pictographs** — direct image-based origins with strong evidence.
- **Indicators** — marks or spatial signs such as quantity or position.
- **Associative compounds** — meaning assembled from multiple semantic elements.
- **Meaning + sound** — semantic and phonetic components, with historical sound evidence separated from modern pronunciation.
- **Historical continuity** — oracle-bone, bronze, seal, clerical, regular, and later evidence availability.
- **Component families** — characters that reuse a meaningful semantic or phonetic component.

This model lets the app explain complex characters without calling every character a pictograph. It also prevents `Pictographs` from becoming a generic category for every concrete noun.

## Relevance model

All 808 have relevance as members of the published trilateral shared/common set, but that is only the first relevance signal. Each character should receive a separate editorial relevance review:

- **Kanji membership:** current Japanese inventory evidence, readings, and at least one authentic modern use.
- **Hanja membership:** current Korean inventory evidence, reading, and at least one authentic lexical, educational, formal, historical, or cultural context.
- **Chinese representation:** Simplified Chinese form and Traditional Chinese form/community usage.
- **Cross-language usefulness:** whether the same character identity helps a learner compare languages without implying identical meanings or pronunciation.
- **Teaching usefulness:** whether the character has a clear lesson, useful examples, and a distinct place in the museum.
- **Collection usefulness:** whether it strengthens a collection rather than duplicating a nearby entry.

Korean Hanja relevance must be labeled honestly. Contemporary Korean is predominantly written in Hangul, so a valid Hanja entry may be relevant through compounds, names, formal vocabulary, dictionaries, education, or cultural/historical reading rather than ordinary daily spelling.

## Historical evidence model

The app must distinguish four different claims:

1. **Character identity is old:** the modern identity has a documented predecessor in older Chinese writing.
2. **A specific historical stage is attested:** a usable source-backed glyph exists for oracle bone, bronze, seal, clerical, or regular script.
3. **The interpretation is secure:** specialists agree sufficiently on the reading, identity, and meaning.
4. **A usable asset is available:** the source image or licensed derivative can legally and technically be bundled.

These are not interchangeable. A character may have an ancient history but no approved asset; an attractive generated reconstruction is not historical evidence; a Seal Script form does not prove an Oracle Bone form; and an early-looking component does not prove that the full modern character existed at that stage.

### Evidence statuses

- `O-verified` — source-backed oracle-bone glyph and character identification reviewed.
- `O-source` — oracle-bone material is present in a research dataset or catalogue but still needs specialist review and asset-rights review.
- `B/S-verified` — bronze and/or seal evidence is source-backed, but oracle-bone evidence is not established for this record.
- `C/R-verified` — clerical and/or regular historical evidence is available; earlier evidence remains unresolved.
- `Later-or-uncertain` — the identity or useful historical lineage appears later, disputed, or not yet connected securely.
- `Missing-evidence` — no approved historical stage is currently available in the project register.

`Missing-evidence` means “not currently sourced,” never “the character has no history.”

## Research sources

The historical audit should combine these sources, preserving source and confidence per field:

- [EVOBC research paper](https://arxiv.org/abs/2401.12467) — an open dataset spanning Oracle Bone, Bronze, Seal, Spring and Autumn, Warring States, and Clerical stages. It reports that only approximately 1,600 of more than 4,500 extant oracle-bone characters have been elucidated, which is why absence from a simple lookup cannot be treated as disproof.
- [EVOBC repository and metadata](https://github.com/RomanticGodVAN/character-Evolution-Dataset) — public character-to-stage metadata and image inventory, licensed CC BY-NC-SA 4.0. This is a research input, not an automatic publication approval.
- [Academia Sinica Xiaoxuetang overview](https://ascdc.sinica.edu.tw/en/single_news_page.jsp?newsId=415) — a major form/sound/meaning database covering Oracle Bone, Bronze, Warring States, Seal, and Regular materials.
- [Unicode Oracle-Bone proposal](https://www.unicode.org/L2/2015/15280-n4687-oracle-bone.pdf) — explains the status of Oracle Bone Script as an early but already mature writing system with multiple character-formation methods and variant forms.
- [TCS 808 shared-character boundary](https://www.tcs-asia.org/en/cooperation/mechanism.php?topics=4) — the source boundary for the allowed universe, not a complete historical-glyph register.

## Current historical backing status

The project currently has an approved local historical-asset path for only part of the 11-record pilot. Fire, Water, and Tree have acquired source-backed historical SVGs for selected stages; unresolved stages remain explicit missing-content states. The other pilot records and the remaining 808 entries require the historical audit described above.

The first historical research pass should produce two lists:

### List A — historical-stage availability

One row per allowed character, with `oracle`, `bronze`, `seal`, `clerical`, and `regular` status, source URL or bibliographic reference, confidence, and asset-rights status. This list answers: “What can we honestly show?”

### List B — strongest museum candidates

The subset where the historical identity, stage sequence, learner explanation, and asset path are all strong enough for a Symbol Journey. This list answers: “What should we teach first?” It must not be created by selecting every character that merely has an ancient-looking image.

The complete per-character historical list is not yet claimed as finished. The next data pass must extract the EVOBC/Xiaoxuetang stage coverage for all 808, normalize variants, and then manually review conflicts. That is the safe route to a real `O-verified` list.

## Collection and historical review record

Every allowed character should eventually have a row containing:

| Field | Purpose |
|---|---|
| Shared identity | Stable cross-language character identity |
| Primary collection | One semantic discovery home |
| Secondary collections/lenses | Honest additional relationships |
| Formation type | Pictograph, indicator, associative, meaning+sound, loan, or uncertain |
| Kanji evidence | Inventory, readings, and modern usage |
| Hanja evidence | Inventory, reading, and modern context |
| Chinese forms | Simplified and Traditional forms and usage |
| Historical stages | O/B/S/C/R availability and confidence |
| Historical sources | Source-backed provenance and rights |
| Teaching value | Visual explanation, examples, and learner payoff |
| Review state | Research, native-speaker, specialist, asset, and editorial status |

## Decision boundary

The 808 list is now the reference universe. V1/V2/V3 selection happens inside it. Collection membership, modern relevance, and historical evidence are separate dimensions; none should silently overwrite another. A character can be allowed but not yet collection-ready, historically important but asset-blocked, or highly useful but unsuitable for V1 until its story is responsibly verified.
