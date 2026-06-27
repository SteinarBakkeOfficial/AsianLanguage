# Shared Character Content Schema

## Goal

Define the first content-entry shape for publishable V1 `Shared Character` lessons.

## File Format

Use one UTF-8 JSON file per Shared Character record during early development. This keeps review diffs small and lets content validation run per lesson.

Recommended path:

`content/shared-characters/{id}.json`

The `id` is stable, lowercase ASCII, and should not encode app ordering. Editorial sequence belongs in collection or corpus metadata.

## Top-Level Fields

- `id`: stable corpus identifier
- `version`: integer schema/content version for this record
- `coreCharacter`: the canonical underlying character label for editorial use
- `coreSharedMeaning`: one teachable overlapping meaning across all required focus tracks
- `recognitionTakeaway`: editorial summary shown in `Summary`
- `publicationStatus`: `draft`, `review`, or `published`
- `teachingSequence`: early editorial teaching order for seed and launch sequencing
- `focusCoverage`: required modern coverage for all focus tracks
- `visuals`: app-facing visual asset metadata
- `history`: historical origin and displayed script stages
- `structure`: component or character-structure analysis
- `usage`: modern examples grouped by focus track
- `sources`: lightweight source list used by history, structure, forms, readings, and examples
- `notes`: editorial caveats that should remain available in app-facing source notes

## Focus Coverage

Each record must include:

- Simplified Chinese form, readings, glosses, and examples
- Traditional Chinese form, readings, glosses, Taiwan examples, and Hong Kong examples
- Japanese form, readings, glosses, and examples
- Korean Hanja form, Korean readings, glosses, and examples

Each language needs at least two examples. At least one example per language must directly show the core shared meaning.

Each example includes:

- `text`: modern example text
- `reading`: optional learner-support reading
- `translation`: English translation
- `showsCoreMeaning`: whether the example directly shows the lesson meaning
- `exampleLevel`: `word`, `phrase`, or `sentence`
- `parallelExampleGroupID`: optional id for examples that should be compared across focus tracks
- `reusesKnownSymbols`: previously introduced symbols reused by the example
- `introducedSymbols`: symbols introduced or emphasized by the example

Seed sequencing starts with very basic symbols that carry their own meaning, then uses examples that increasingly reuse previously learned symbols. Prefer shared words or compounds across languages when possible, then add basic sentence examples. Parallel sentence examples across focus tracks are preferred when they are natural modern usage.

## Visuals

`visuals` records app-facing asset metadata:

- `evolutionAssetRefs`: asset references keyed by stage or role
- `assetStatus`: `prototype-draft`, `source-backed-draft`, or `publication-ready`
- `note`: editorial note about provenance and replacement needs

Prototype visual cards may be app-native draft assets for testing. Publication visuals must be source-backed redraws or licensed/source-backed assets.

The character-evolution reference pictures are product targets for layout, hierarchy, and stage navigation. They are not production assets themselves unless licensing and source quality are explicitly resolved. Content records must support the iPhone adaptation of that target: horizontal full-page stage views with fixed bottom stage navigation.

Origin, Oracle Bone, Bronze, Seal, Clerical, and Regular visuals must be represented by image assets or explicit missing-asset placeholders. Do not reuse the modern regular character as a substitute for missing historical images.

## Historical Stages

`history.stages` is an ordered list chosen for recognition value, not a forced complete family tree.

The symbol page sequence is stage-first:

1. origin image and earliest defensible script form, usually Oracle Bone when available
2. Bronze Script
3. Seal Script
4. Clerical Script
5. Regular Script
6. modern focus-language pages for Mandarin, Traditional Chinese, Japanese, Korean, and any required regional Traditional Chinese usage split

If the origin image and Oracle Bone form need too much space, the design may split them into separate pages and push later pages forward by one. The bottom stage navigation must make that split explicit.

Each stage includes:

- `stage`: one of `oracleBone`, `bronze`, `seal`, `clerical`, `regular`, or `modern`
- `label`: user-facing stage label
- `form`: text form when Unicode can represent it responsibly
- `assetRef`: optional app-native visual asset reference
- `artifactAssetRef`: optional supporting artifact image, such as an oracle bone, bronze vessel, rubbing, or inscription sample
- `changeNoteFromPrevious`: required for every displayed stage after the first
- `certainty`: `high`, `medium`, or `limited`
- `sourceIds`: source references supporting this stage
- `historicalSound`: optional, only when accurate enough to source and label
- `introducedComponentIds`: components that first become visible or editorially meaningful at this stage
- `stageExplanation`: stage-specific explanation for this exact symbol, not a generic period explanation

Do not include a stage only to complete the canonical spine. Omit or summarize stages that would create false certainty.

The app-facing order for stage navigation is:

1. `origin`
2. `oracleBone`
3. `bronze`
4. `seal`
5. `clerical`
6. `regular`
7. `modernForms`

The bottom navigation may hide or mark unavailable stages, but it must not imply that a missing stage has a real asset.

## Structure

The `structure` section explains character/component structure only. It must not introduce grammar or sentence-structure lessons.

Fields:

- `summary`: concise user-facing explanation
- `components`: list of displayed components when useful
- `certainty`: `high`, `medium`, or `limited`
- `caveat`: required when certainty is not high
- `sourceIds`: source references

Each component should include:

- `id`: stable component id inside the record
- `label`: readable label, such as `person`, `head`, or `tree`
- `form`: component character or glyph when representable
- `role`: `iconic`, `meaning`, `sound`, `remnant`, or `uncertain`
- `depicts`: what the component is understood to depict
- `introducedAtStage`: first stage where this component is visible or interpretively useful
- `explanation`: short symbol-specific explanation
- `sourceIds`: source references supporting the component analysis

Avoid unsupported mnemonic claims. If a component reading or function is disputed, label it as limited certainty.

## History Explainer Content

Generic historical-period explanations do not belong inside each symbol page. Create separate app content for the history overview covering:

- Oracle Bone Script: what it was written on, why it was used, approximate period, and how the script relates to pictographic forms
- Bronze Script: inscriptions on ritual bronzes, approximate period, and why forms became more formalized
- Seal Script: standardization, approximate period, and how forms became more symbolic
- Clerical Script: administrative writing, approximate period, and the flattening/brush transformation
- Regular Script: later standard written form and its relationship to modern forms

Symbol pages should link to this explainer where useful, but the symbol page text should focus on that symbol's image, components, stage changes, and accessible sound notes.

## User State Schema

User state is not stored inside content records. The local store should use separate records keyed by `sharedCharacterID`.

Recommended fields:

- `sharedCharacterID`
- `progressStatus`: `unseen`, `inProgress`, or `learned`
- `reviewLater`: boolean
- `starred`: boolean
- `lastStep`: nullable lesson-step enum
- `visitedSteps`: list of lesson-step enum values
- `updatedAt`: local timestamp

Rules:

- `reviewLater = true` forces `progressStatus` away from `learned`
- setting `progressStatus = learned` clears `reviewLater`
- `starred` never changes progress or review state

## Publication Gate

A record cannot be `published` until it has:

- one underlying character record
- one core shared meaning
- complete required focus coverage
- separate Taiwan and Hong Kong Traditional Chinese examples
- at least one historical origin anchor
- characterized or regular-script form
- modern focus-track forms
- stage-to-stage change notes for every shown historical stage after the first
- responsible history, structure, usage, and summary sections
- at least two examples per language
- at least one direct core-meaning example per language
- at least one word-level example and one sentence-level example
- progressive example metadata for known-symbol reuse and introduced symbols
- source support for editorial claims
- app-ready asset references or explicit missing-asset placeholders for required visuals
- horizontal stage-navigation metadata sufficient to render origin picture, historical stages, regular form, and modern forms in the bottom evolution strip
- component metadata for every component displayed in the symbol evolution, including the stage where the component first appears or becomes meaningful

## Sources

Each source entry includes:

- `id`: stable id referenced by historical stages or structure notes
- `label`: short readable source label
- `type`: source category, such as `reference`, `research-paper`, or `prototype`
- `citation`: short editorial citation or replacement note
- `url`: required for non-internal source-backed records; internal prototype/redraw notes may omit this

Recommended source categories for visual sourcing include Chinese Etymology or similar paleography references, Wiktionary or dictionary entries when they expose old forms, Hanziyuan or similar character-evolution references, CHISE/Unihan-style structured character data, Wikimedia Commons, museum collections, and peer-reviewed/open datasets such as EVOBC/Open-Oracle. Every imported visual still needs license and provenance review before publication.

## V1 to VNext Tracking

This schema intentionally models Shared Character symbol-lineage lessons only. It does not model grammar comparisons, rule lessons, voice assets, tracing data, cloud accounts, ads, or Android-specific delivery.
