# Symbol Final Audit Ruleset

**Status:** mandatory process for future Symbol-content work

**Purpose:** prevent another incomplete “all 126 Symbols checked” claim. This ruleset applies before editing, regenerating, committing, or calling the Symbol content release-ready.

This is a process contract, not permission to change content. A future task must still state its exact scope before implementation.

## Final approved scope for the next implementation pass

The next implementation pass is strictly limited to the Symbol pages:

- Primarily the four target-language sections: Simplified Chinese, Traditional Chinese/Taiwan and Hong Kong, Japanese, and Korean.
- Limited Symbol-page Origin/Illustration copy corrections where the approved Origin baseline and the clarified meaning rules require them.
- Limited Symbol-page Regular Script summary corrections so the visible evolution is accurately summarized.
- The corresponding canonical Symbol JSON, generated runtime JSON, and review/audit documentation required to keep those Symbol pages synchronized.

Explicit no-change areas:

- Home
- History pages and History reading guides
- Browse and Search
- Quick Review
- Onboarding
- More, Settings, About, and Sources/Licenses
- Navigation, page layout, toolbar behavior, and unrelated SwiftUI views
- Approved examples or content outside the Symbol-page audit scope

Any proposed change outside the Symbol pages must be reported separately and approved before implementation. A passing check, a discovered inconsistency, or a convenient shared component must not be used as permission to change another page.

## 1. Scope gate before any work

1. Repeat the user’s requested changes in plain language.
2. List the exact allowed surfaces: source JSON, runtime JSON, Swift rendering, documentation, or other files.
3. List explicit no-change areas.
4. Do not expand one example into a corpus-wide content rewrite unless the user explicitly requests a corpus-wide audit.
5. Do not infer approval from an old proposal, an earlier conversation, or a generic “release-ready” note.
6. If the user requests a check only, inspect and report; do not silently implement repairs.

## 2. Source-of-truth and projection rules

For every Symbol, treat these as separate layers and compare them explicitly:

- `content/release/symbols/<id>/symbol.json`: human-edited canonical source.
- `Resources/Corpus/<id>.json`: generated runtime projection.
- Swift model decoding and view rendering.
- Home, Browse, Quick Review, accessibility, and Symbol Journey projections.

The source and runtime records must agree on identity, canonical meaning, forms, readings, glosses, examples, and stage copy. A passing JSON decode does not prove semantic correctness.

Never accept a UI fallback as a substitute for missing editorial data. A fallback that fills a blank reading gloss with the shared Symbol meaning is prohibited for a multi-sense Symbol.

## 3. Meaning vocabulary: fields must not be conflated

Every displayed English string must be classified before it is reviewed:

- **Canonical shared meaning:** the learner-facing meaning set of the written character across current target-language use.
- **Lane meaning:** the meaning relevant to one language or region.
- **Reading gloss:** the exact meaning of one pronunciation or reading.
- **Native equivalent gloss:** the exact meaning of a different native word expressing the concept.
- **Variant note:** the relationship of a different written form.
- **Example translation:** the meaning of the complete word, phrase, or sentence shown.
- **Origin explanation:** what the original illustration depicts and why it represents the starting concept.
- **Historical transition text:** what visibly changed between stages.
- **Regular Script summary:** how the form settled and what semantic development matters at the endpoint.

These fields must never be populated by copying the nearest available meaning merely to avoid an empty field.

## 4. Canonical meaning and slash rules

1. Include a meaning in the shared header only when the same written character has that established current meaning in at least one current target language and the meaning is useful to teach.
2. Do not promote a historical dictionary sense, rare specialized compound, synonym, or example translation into the shared header.
3. Use `/` only for genuinely distinct current senses that belong to the same written character and need to be presented together.
4. Do not use `/` for ordinary synonyms or explanatory padding:
   - `woman / female` is normally one learner meaning, not two.
   - `old / elderly` is normally one learner meaning, not two.
   - `sheep / goat` is not automatically one meaning.
   - `ox / cattle` is not automatically one meaning.
5. If a character’s core meaning remains Ox, keep the header as `ox`. A word example may translate as `cattle` when that is the actual word’s use; that does not rewrite the header.
6. If a language separates two meanings into different readings, words, or characters, preserve the shared meaning only when the relationship is explained and show the language-specific distinction separately.
7. Never derive the header by collecting every English translation found in the examples.
8. Check the header independently in the Symbol page, Home, Browse, Quick Review, accessibility text, source usage projection, and runtime projection.

## 5. Required per-reading audit

Every reading shown to the learner is an individual content row, even when it is one of ten readings for one character.

For each reading, verify:

1. Native script is correct.
2. Romanization is correct.
3. Reading system is correct: Pinyin, Jyutping, On, Kun, Hanja, native Korean, or another explicitly supported system.
4. `gloss` is present when the UI displays an English meaning beside the reading.
5. The gloss describes that reading’s actual sense, not the entire Symbol’s canonical meaning.
6. The reading is useful enough to display; otherwise remove it from the learner-facing list rather than showing an unexplained dictionary inventory.
7. A reading may share the same gloss as another reading only when both genuinely carry the same meaning. This must be verified, not assumed.
8. A blank gloss must fail the audit. It may never be silently replaced with `coreSharedMeaning`.
9. At least one suitable example must demonstrate each reading that is intentionally retained when the reading is not self-evident.

**Mandatory regression check:** create or run an audit that reports every reading with a missing gloss. The audit must identify the Symbol, language, reading, romanization, and rendered fallback value. A result of zero is required before completion.

## 6. Equivalents, variants, and readings

- A different pronunciation of the same written character is a **reading**, not a variant.
- A different native word expressing the concept is a **semantic/native equivalent**.
- A different written graph is an **orthographic variant**.
- A compound containing the character is an **example**, not automatically an equivalent or variant.
- A word with a narrower or different meaning must receive that exact English gloss.
- Exact duplicates may remain only when they communicate a real same-meaning relationship that the learner needs to see; they must not be repeated as filler examples.
- Every stored equivalent or variant must be checked for actual UI rendering. Data presence alone is not enough.
- If the UI intentionally hides a category, the audit must say so explicitly; it must not be reported as displayed.

## 7. Example rules for all four target-language lanes

For Simplified Chinese, Traditional Chinese/Taiwan, Traditional Chinese/Hong Kong, Japanese, and Korean:

1. Use approximately four or five useful source examples per lane, preserving the approved lane count.
2. Do not repeat the standalone top form as a filler example.
3. Each example must be checked as a complete unit:
   - written form,
   - language/region,
   - pronunciation,
   - romanization,
   - English translation,
   - example level,
   - reading or sense demonstrated.
4. The English translation must describe the complete example, not merely repeat the Symbol header.
5. A compound may show a related or narrower meaning without changing the Symbol header.
6. The longest sentence belongs last when a sentence is included.
7. Taiwan and Hong Kong may share a natural expression, but identical examples must not be copied by default.
8. Japanese examples must use natural Kanji with correct furigana, reading, romaji, and English translation.
9. Korean Hanja examples and native Korean equivalents must not be mixed into one undifferentiated list.
10. A mechanical audit must report duplicate standalone forms, blank translations, missing reading metadata, and all examples whose translation exactly equals the header.

## 8. Origin and historical-stage rules

### Origin / Illustration

Origin answers: “What does our illustration show, and why does it represent the starting meaning?”

- The previously approved Origin text is the baseline. Recent commits must not rewrite or expand approved Origin copy merely because a later meaning was discovered during target-language review.
- If the illustration is obvious, keep the explanation short.
- If the Oracle Bone form does not resemble the illustration, that explanation belongs in the Oracle stage, not repeated as Origin.
- Mention a second meaning in Origin only when omitting it would make the starting explanation materially misleading or prevent the learner from understanding the Symbol’s basic identity.
- Otherwise, keep Origin focused on the approved illustration and explain later meanings in Regular Script, the target-language reading/equivalent rows, or the examples.
- Example: Sun/Day may keep Origin as “This is a sun.” Regular Script can explain how the written character also came to be used for “day.”
- If the historical picture was borrowed for a later sound or meaning and that borrowing is essential to understanding why the Symbol means something different from the illustration, explain it once at Origin; do not add it merely for completeness.
- Bean is the model case: the illustration may show a vessel while the written meaning became bean through sound borrowing.
- Do not add unnecessary semantic lectures for obvious natural extensions such as a sheep-related form appearing in a goat context, unless the meaning genuinely changed and the learner needs the distinction.

### Oracle Bone, Bronze, Small Seal, and Clerical

Each stage must describe the visible form selected for that stage and the change from the previous stage:

- strokes retained,
- strokes added,
- strokes removed,
- parts merged,
- orientation or layout changed,
- form made more regular or compressed,
- why the selected glyph is or is not immediately recognizable.

Do not repeat the Origin explanation as a historical caption.

### Regular Script

Regular Script is the endpoint summary. It must state the visible changes that settle the modern form: retained lines, added or removed elements, mergers, reorganization, and final proportions. “The form became standardized” alone fails.

Regular Script may mention a later semantic development only when it adds necessary endpoint information. It must not copy the same semantic sentence already used in Origin without a distinct purpose.

## 9. Four-language rendering rules

- **Simplified Chinese:** render the actual simplified character; Pinyin is underneath, never used as the character itself.
- **Traditional Chinese:** render the actual Traditional character; keep Taiwan Mandarin/Pinyin and Hong Kong Cantonese/Jyutping visibly separated.
- **Japanese:** render the Kanji; show On/Kun or other retained readings with reading-specific glosses; render furigana and romaji correctly.
- **Korean:** render Hanja; label the Hanja pronunciation separately from Native Korean equivalents; give every distinct native word its own English meaning.
- All four use the approved relationship: native writing left, English meaning right on the same row, pronunciation beneath.
- Verify the actual rendered page, not just the data objects.

## 10. Required 126-Symbol audit evidence

The audit is not complete because an aggregate command passed. It is complete only when there is a per-Symbol ledger for all 126 records containing:

- Symbol ID and character,
- canonical header meaning,
- Origin status,
- Oracle caption status,
- Bronze caption status,
- Small Seal caption status,
- Clerical caption status,
- Regular Script summary status,
- reading count and missing-gloss count for every lane,
- equivalent count and gloss status,
- variant count and render status,
- example count and duplicate count for every lane,
- source/runtime parity,
- UI projection/rendering result,
- explicit failure notes or “passed” evidence.

Any one failed row means the whole audit is incomplete. Do not say “all 126 checked” when only aggregate counts or selected examples were inspected.

## 11. Required automated checks

Before claiming completion, run checks that specifically cover:

1. All 126 source records parse.
2. All 126 runtime records parse.
3. Source and runtime agree on every learner-facing field.
4. Every displayed reading has a non-empty, reading-specific gloss or is intentionally omitted from the learner-facing list.
5. No generic fallback supplies a multi-sense shared meaning for a missing reading gloss.
6. No unnecessary slash pairs occur in headers or reading glosses without an audit justification.
7. No standalone duplicate core examples remain.
8. Every example has exact written-form, pronunciation, and translation data.
9. Example counts and sentence ordering meet the approved rules.
10. Every Regular Script caption records visible form changes.
11. Every stored equivalent and variant has a rendering path or is explicitly marked non-learner-facing.
12. The normal project checks pass.

Passing the normal project checks is necessary but not sufficient. The semantic audit must also pass.

## 12. Completion and communication rule

The final report must state separately:

- what was inspected,
- what was changed,
- what automated checks passed,
- what visual checks were actually run,
- any remaining failures,
- whether the result is content-ready, locally test-ready, or Apple/Xcode marketplace-ready.

Never use “double-checked,” “triple-checked,” “all Symbols reviewed,” or “release-ready” unless the per-Symbol evidence and all required checks support that exact claim.

## 13. Implementation result — 2026-10-03

The approved Symbol-only implementation pass is complete and recorded in [`symbol-final-audit-ledger-2026-10-03.md`](symbol-final-audit-ledger-2026-10-03.md).

- All 126 canonical Symbol records and all 126 generated runtime records were inspected.
- 742 previously blank displayed-reading glosses were filled with reading-specific meanings. Japanese glosses were recovered from existing reviewed examples that explicitly covered each reading; Chinese alternate readings received sense-specific glosses; Korean Hanja rows received their lane meaning while native equivalents retained their own glosses.
- The shared-meaning fallback was removed from the Symbol-page renderer. A blank reading can no longer display the full shared meaning as if it applied to that reading.
- The Symbol-page header now uses the selected language lane’s meaning set. The native form remains left-aligned, the English meaning remains on the right, and romanization matches the English gloss typography.
- Approved Origin copy was restored wherever later review had expanded it without a stage-specific need. The explicitly required self-origin explanation remains because the nose-to-self borrowing is essential to understanding that Symbol.
- Clear synonym/padding labels were normalized, including `woman`, `old`, `sheep`, `ox`, `big`, `bright`, `center`, `forest`, `fragrance`, `journey`, `lodging`, `man`, `people`, and related cases. Distinct current senses such as `horn / corner / angle`, `heart / mind`, and `life / be born / grow` were retained.
- Three duplicate regional example rows were replaced rather than deleted: Taiwan `行業` for Go, Taiwan `普及` for Reach, and Hong Kong `涉及` for Reach.
- Origin, Oracle, Bronze, Small Seal, Clerical, and Regular Script captions are present for every record; Regular Script rows were checked for endpoint summaries rather than generic standardization text.
- No History, Quick Review, Home layout, Browse/Search, onboarding, More/Settings/About, navigation, toolbar, or unrelated SwiftUI view was changed. The only Swift change is the Symbol-page `UsageExamplesView` rendering correction.

Automated content checks pass for JSON parsing, zero missing displayed-reading glosses, four examples per lane, no within-lane duplicate forms, and canonical/runtime parity. Apple/Xcode simulator visual verification remains a separate test step and is not claimed here.
