# V1 Runtime Implementation

Status: V1.0 approved and published in the local package; post-release corrections are tracked for Patch 0.1.

Runtime record filenames and IDs use readable, meaning-based names (for example, `one.json`). Collision cases use a deterministic Unicode suffix. Research/source folder names remain Unicode-based because they are archival evidence paths rather than app-facing record names.

## Bundled scope

- 126 complete-evolution Shared Character records from `content/research/zdic-v1-complete-manifest.json`.
- 126 approved Soft Ink & Wash origin illustrations stored beside their release Symbol records under `content/release/symbols/<id>/educational/`; the two compound rerenders use v3.
- 504 normalized ZDIC historical glyphs: Oracle Bone, Bronze, Small Seal, and Clerical for every V1 record. The original selected SVG is retained beside each normalized glyph.
- 630 destination-stage transition captions: one for every available journey stage in every V1 record, comparing Origin → Oracle (or the first available stage) and each subsequent stage to its previous available image.
- Regular Script is rendered dynamically from `Resources/Fonts/TW-Kai-98_1.ttf`.
- Used Today renders Simplified Chinese, Traditional Chinese Taiwan, Japanese Kanji, and Korean Hanja with the intentional locale-specific Source Han Serif faces.
- The visible History tab uses `Resources/History/History_V1.png`; the former period-by-period History implementation remains in `LegacyHistoryRootView`.

## Runtime content boundary

The old 11-record pilot files are archived under `docs/archive/legacy-pilot/` for comparison, but `SeedCorpusManifest` loads only the 126 complete-evolution records. This means the incomplete Fire pilot is not silently counted as V1. Onboarding loads the curated Mountain record while Fire remains available separately as a repository pilot/reference record.

## Discovery behavior

Browse is search-first. Below the search field it presents the learner's Learned, Favorites, and Review Later libraries, one All Symbols destination, and collections. All Symbols is a separate same-style library screen with its own search field and the complete corpus. Collection membership is editorially mapped from the research taxonomy and filtered against the installed runtime IDs.

## Museum transition captions

`content/research/v1-symbols/transition-notes-v1.json` is the audit source package for the per-stage `transitionNote` fields. The generator compares the local selected historical SVG assets and uses deliberately conservative visual language; the approved runtime contains no outstanding transition-note review flags. Captions do not replace the historical assets or invent omitted stages.

Run `Tools/Generate-MuseumTransitionNotes.ps1` after changing selected museum assets. The app displays `transitionNote` beneath the destination stage and retains `changeNoteFromPrevious` for legacy compatibility.

## Content and rights status

The runtime is offline and read-only, and the V1 records are approved/published. Historical source, language, editorial, and reuse review is recorded as complete for V1. Origin illustrations remain educational reconstructions, not historical evidence. Post-release corrections may be issued through Patch 0.1.

## Corrected target-language handoff

The corrected modern-language content is maintained in `Reference Pictures/Chatgpt/Corpus_corrected_target_languages/`. Its 126 records provide approved Chinese, Japanese, and Korean forms, readings, examples, and explicit native-script speech text. Automated QA remains a maintenance safeguard; it does not reopen the completed V1 review decision.

Run `Tools/Import-CorrectedTargetLanguageCorpus.ps1` to merge that content into the runtime corpus. The merge preserves current readable record IDs, filenames, historical asset references, and Fire exclusion because the handoff was generated before the runtime naming cleanup. Example `speechText` remains stored for future use, while the current UI exposes pronunciation controls only for main readings.

## Rebuild

Run `Tools/Import-V1RuntimeCorpus.ps1` after changing the approved research manifest or origin-artwork selection. Then run `Tools/Generate-MuseumTransitionNotes.ps1` and validate the generated corpus. Any release-candidate or post-release correction remains a Patch 0.1 maintenance change.
Runtime record filenames and IDs use the readable meaning-based naming convention used by the V1 corpus (for example, `one.json`). When two records share a meaning, the later collision receives a deterministic Unicode suffix. Source/research folder names remain Unicode-based for stable archival identity.
