# Shared Character Content Schema

## Source of truth

One UTF-8 JSON file per Shared Character under \`content/shared-characters/\` is the human-edited source. \`Resources/Corpus/\` is generated from it and is read-only at runtime.

Draft records may omit richer editorial fields. The validator and publication gate enforce stricter requirements only for \`review\` and \`published\` content.

## Record

Required top-level fields:

- \`id\`, \`version\`, \`teachingSequence\`
- \`coreCharacter\`, \`coreSharedMeaning\`, \`recognitionTakeaway\`
- \`publicationStatus\`: \`draft\`, \`review\`, or \`published\`
- \`focusCoverage\`
- \`visuals\`
- \`history\`
- \`structure\`
- \`usage\`
- \`sources\`, \`notes\`

## Evolution framework

\`history\` contains:

- \`originAnchor\`
- optional structured \`origin\` with concept, explanation, Historical Asset, and source IDs
- ordered \`stages\`

Canonical stage IDs are \`origin\`, \`oracleBone\`, \`bronze\`, \`seal\`, \`clerical\`, \`regular\`, and \`modernForms\`. The primary historical museum records use four historical IDs: Oracle Bone, Bronze, Small Seal, and Clerical. Regular is a separate modern standardized reference rendering; origin and modernForms are separate product layers.

Each historical stage may include:

- \`form\`
- canonical \`assetRef\`
- optional structured \`assetMetadata\`
- optional \`artifactAssetRef\`
- \`changeNoteFromPrevious\`
- \`stageExplanation\`
- \`transitionNote\` — short visual comparison from the previous available exhibit to this stage
- \`transitionNoteNeedsReview\` — editorial QA flag for an uncertain or provisional caption
- \`certainty\`
- \`sourceIds\`
- optional \`historicalSound\`
- optional \`introducedComponentIds\`

Stages are data-driven. Omitted stages are not implied to exist. Relevant unavailable stages may be represented as explicit Missing Historical Asset content gaps.

For the V1 museum journey, \`transitionNote\` is the displayed caption and belongs to the destination stage. The first available stage compares the Origin Illustration with that stage; each later stage compares with the previous available stage. Captions are normally one sentence and no more than 25 words. \`changeNoteFromPrevious\` remains for backward compatibility with older records.

## Historical assets

An Historical Asset is source-backed or licensed metadata for one exact stage. It includes:

- bundled \`assetRef\`
- \`assetKind\`
- provenance
- license status
- accessibility description
- readiness

\`history.stages[].assetRef\` is the canonical per-stage mapping. \`visuals\` contains only global readiness and provenance notes. New records must not duplicate a stage map under \`visuals\`.

The runtime asset module must resolve only renderable bundled iOS assets. Source SVGs are not automatically renderable; they require an approved compiled representation. Missing Historical Assets are explicit and must never use fabricated glyphs or a modern regular form.

## Modern focus coverage

Every record contains Simplified Chinese, Traditional Chinese, Japanese, and Korean coverage.

Each focus track can contain a primary form, readings, glosses, examples, and explicit modern variants. Variants may carry their own writing system, readings, notes, and examples.

Traditional Chinese coverage additionally supports:

- Taiwan examples and optional Taiwan readings
- Hong Kong examples and optional Hong Kong readings

Traditional Chinese is a written-form focus track, not one universal spoken pronunciation.

Readings may optionally carry an audio asset reference and explicit platform-independent speech data:

- `speechText` is the explicit text passed to a speech renderer; current V1 values may remain draft until user and native-speaker review. It is not inferred at playback time from the visible Han character.
- `speechLanguage` is one of `mandarin`, `cantonese`, `japanese`, or `korean` and is resolved to a platform locale by the renderer.

Absent speech data is an explicit unavailable state, not an error. iOS playback is isolated behind `AVSpeechSynthesizer`; a future Android implementation must replace only that renderer with `TextToSpeech`.

## Character structure

\`structure.components\` is stage-aware. Each component may include:

- stable \`id\`
- \`form\`
- \`label\`
- \`role\`
- \`depicts\`
- \`meaningHint\`
- \`introducedAtStage\`
- \`explanation\`
- \`certainty\`
- \`sourceIds\`

Components can appear, disappear, or change role. Simple pictographs should not receive redundant component panels when the form itself is the useful explanation.

## User state and migration

User state is separate from content and keyed by \`sharedCharacterID\`. It stores progress status, exact \`SymbolJourneyPosition\`, visited positions, independent Favorites and Review later relationships, completion timestamps, and the explicitly current character. App-level state also stores focus selection, appearance preference, and onboarding completion.

Legacy \`LessonStep\` and single-focus data decode through migration. Migration must never delete existing user state.

## Publication gate

\`published\` records require complete modern coverage, responsible examples, sources, stage change notes, stage-aware Character structure, valid asset metadata or explicit gaps, and no fabricated historical claims. Draft records may retain nil/empty richer fields and visible content TODOs.

## Editorial safety

Do not invent glyphs, historical sounds, dates, component etymologies, citations, Horse content, or regional readings. Use missing values and explicit content gaps until sourced.
