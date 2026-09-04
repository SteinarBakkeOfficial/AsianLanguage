# V1 Runtime Implementation

Status: implemented locally; publication and commercial asset clearance remain open gates.

Runtime record filenames and IDs use readable, meaning-based names (for example, `one.json`). Collision cases use a deterministic Unicode suffix. Research/source folder names remain Unicode-based because they are archival evidence paths rather than app-facing record names.

## Bundled scope

- 126 complete-evolution Shared Character records from `content/research/zdic-v1-complete-manifest.json`.
- 126 approved-for-review Soft Ink & Wash origin illustrations from `content/research/v1-symbols/**/origin-locked-style-v2.png`; the two compound rerenders use v3.
- 504 normalized ZDIC historical glyphs: Oracle Bone, Bronze, Small Seal, and Clerical for every V1 record. The original selected SVG is retained beside each normalized glyph.
- 630 destination-stage transition captions: one for every available journey stage in every V1 record, comparing Origin → Oracle (or the first available stage) and each subsequent stage to its previous available image.
- Regular Script is rendered dynamically from `Resources/Fonts/TW-Kai-98_1.ttf`.
- Used Today renders Simplified Chinese, Traditional Chinese Taiwan, Japanese Kanji, and Korean Hanja with the intentional locale-specific Source Han Serif faces.
- The visible History tab uses `Resources/History/History_V1.png`; the former period-by-period History implementation remains in `LegacyHistoryRootView`.

## Runtime content boundary

The old 11-record pilot files remain in the repository for comparison, but `SeedCorpusManifest` loads only the 126 complete-evolution records. This means the incomplete Fire pilot is not silently counted as V1. Onboarding loads the first-ranked runtime record, currently 一, while Fire remains available separately as a repository pilot/reference record.

## Discovery behavior

Browse is search-first. Below the search field it presents the learner's Learned, Favorites, and Review Later libraries, one All Symbols destination, and collections. All Symbols is a separate same-style library screen with its own search field and the complete corpus. Collection membership is editorially mapped from the research taxonomy and filtered against the installed runtime IDs.

## Museum transition captions

`content/research/v1-symbols/transition-notes-v1.json` is the reviewable source package for the per-stage `transitionNote` fields. The generator compares the local selected historical SVG assets and uses deliberately conservative visual language; `transitionNoteNeedsReview` identifies captions requiring human visual/editorial review. Captions do not replace the historical assets or invent omitted stages.

Run `Tools/Generate-MuseumTransitionNotes.ps1` after changing selected museum assets. The app displays `transitionNote` beneath the destination stage and retains `changeNoteFromPrevious` for legacy compatibility.

## Content and rights status

The runtime is offline and read-only, but records remain `needsReview`. ZDIC is a reference source and not assumed commercially redistributable by attribution alone. Confirm permission or replace the historical assets with cleared/public-domain equivalents before shipping. Origin illustrations are educational reconstructions, not historical evidence. Generated fallback usage examples are explicitly marked for language-editor review.

## Rebuild

Run `Tools/Import-V1RuntimeCorpus.ps1` after changing the approved research manifest or origin-artwork selection. Then run `Tools/Generate-MuseumTransitionNotes.ps1`, validate the generated corpus, and perform macOS/Xcode build and simulator review.
Runtime record filenames and IDs use the readable meaning-based naming convention used by the V1 corpus (for example, `one.json`). When two records share a meaning, the later collision receives a deterministic Unicode suffix. Source/research folder names remain Unicode-based for stable archival identity.
