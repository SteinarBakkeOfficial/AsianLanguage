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

Prototype visual cards may be app-native draft assets for testing. Publication visuals must be source-backed redraws or licensed/source-backed assets; reference pictures are design inspiration only unless licensing and source quality are explicitly resolved.

## Historical Stages

`history.stages` is an ordered list chosen for recognition value, not a forced complete family tree.

Each stage includes:

- `stage`: one of `oracleBone`, `bronze`, `seal`, `clerical`, `regular`, or `modern`
- `label`: user-facing stage label
- `form`: text form when Unicode can represent it responsibly
- `assetRef`: optional app-native visual asset reference
- `changeNoteFromPrevious`: required for every displayed stage after the first
- `certainty`: `high`, `medium`, or `limited`
- `sourceIds`: source references supporting this stage
- `historicalSound`: optional, only when accurate enough to source and label

Do not include a stage only to complete the canonical spine. Omit or summarize stages that would create false certainty.

## Structure

The `structure` section explains character/component structure only. It must not introduce grammar or sentence-structure lessons.

Fields:

- `summary`: concise user-facing explanation
- `components`: list of displayed components when useful
- `certainty`: `high`, `medium`, or `limited`
- `caveat`: required when certainty is not high
- `sourceIds`: source references

Avoid unsupported mnemonic claims. If a component reading or function is disputed, label it as limited certainty.

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
- app-ready asset references or clear placeholders for required visuals

## Sources

Each source entry includes:

- `id`: stable id referenced by historical stages or structure notes
- `label`: short readable source label
- `type`: source category, such as `reference`, `research-paper`, or `prototype`
- `citation`: short editorial citation or replacement note
- `url`: required for non-internal source-backed records; internal prototype/redraw notes may omit this

## V1 to VNext Tracking

This schema intentionally models Shared Character symbol-lineage lessons only. It does not model grammar comparisons, rule lessons, voice assets, tracing data, cloud accounts, ads, or Android-specific delivery.
