# AsianLanguage

AsianLanguage is an English-first, offline-first iPhone experience about shared Chinese-character heritage across Mandarin, Traditional Chinese usage communities, Japanese Kanji, and Korean Hanja.

The core object is one \`Shared Character\`. Its primary experience is a \`Symbol Journey\`: a recognizable origin moves through defensible historical Evolution Stages into Modern Forms, then continues into Usage across the selected focus tracks.

## Root shell

The app has five root areas: Home, Symbol, History, Browse, and More. Search and Collections belong in Browse. Languages, Settings, Account, About / Method, reset, and offline information belong in More.

## V1

**Current status: V1.0 release candidate complete; preparing for marketplace submission.**

V1 is local and offline. The bundled corpus is read-only; progress, Favorites, Review later, and focus-track selection are local user state. All four focus tracks are enabled by default, but users may disable every track for a museum-only Symbol Journey; there is no separate All enum value. Language controls live in More rather than blocking the first exhibit.

The runtime V1 manifest contains 126 complete-evolution records in teaching order. The earlier 11-record pilot remains in the repository as historical design/reference content; the incomplete Fire pilot is not included in the V1 runtime manifest.

Each available museum stage has a short destination-stage transition caption. Origin → Oracle connects the illustrated subject to the first glyph; later captions describe only visible changes between neighboring forms, without repeating the modern character or naming the transition.

Onboarding opens the curated Mountain symbol directly from the bundled corpus. This onboarding choice does not change the 126-record V1 teaching order; Fire remains available as a separate repository pilot/reference record and is not added to that corpus.

Historical Assets must be source-backed or licensed, explicitly unavailable, or editorially omitted. Fabricated historical glyphs and modern-form fallbacks are prohibited.

The current V1.0 release candidate is the approved 126-character complete-evolution selection with 504 selected/normalized historical stage assets, cleared historical/reference material, local origin illustrations, and a Regular Script Kai endpoint. The app also bundles the History reference artwork and uses its illustrations inside a native editorial timeline and article layout. V1 content review, native-speaker review, Apple device testing on an iPhone 14 Pro, and the latest focused UI corrections are complete, including Home Quick Review, the Japanese furigana/example-gloss alignment, the full Japanese Symbol-page semantic gloss audit, and the final Chinese example audit. This release candidate is code-frozen and cleared for marketplace packaging and submission.

Quick Review appears on Home after the learner completes at least one Symbol. It randomizes one three-choice recognition card for every learned Symbol and does not alter learning state. Review Later remains a separate Browse bookmark for reopening a full Symbol Journey.

The approved modern-form plan uses locale-specific Chinese, Japanese, and Korean rendering. The selected Regular faces from CNS11643 Kai and Adobe Source Han Serif are bundled and registered locally; Source Han Sans and additional weights remain intentionally excluded.

Approved visual references are stored under `Reference Pictures/Chatgpt/`. The written Design System and Symbol Experience handoffs take precedence over generated labels or factual details in those images.

## Symbol content workspace

Each active release Symbol has a human-editable folder under `content/release/symbols/`, with learner copy, research notes, review status, sources, educational visual instructions, historical-stage provenance, and component references. Previous versions are retained separately under `content/archive/symbols/`. Reusable concepts live under `content/components/`. The release preparation, validation, review, and offline packaging commands are documented in `Tools/README.md`.

The import source is `Tools/Import-V1RuntimeCorpus.ps1`; it keeps the human-readable research package under `content/research/` and produces the read-only runtime records/assets under `Resources/Corpus` and `Resources/Assets/Symbols`. The current V1.0 records are marked `approved` / `published`. Future corrections belong to Patch 0.1 and must be based on confirmed post-release feedback; they are not part of this release candidate.

## Development

Windows checks validate content, state contracts, project wiring, and static product contracts. V1.0 review and local acceptance checks are complete. The repository is now documenting the release candidate, not authorizing further code changes before marketplace submission. macOS/Xcode packaging and marketplace submission are distribution actions; issues discovered after release are tracked for Patch 0.1. The first planned Patch 0.1 topic is improved pronunciation playback and optional speech for usage examples; see [`docs/patches/patch-0.1-pronunciation-audio.md`](docs/patches/patch-0.1-pronunciation-audio.md).

Run available checks:

\`\`\`powershell
& .\Tools\Run-Checks.ps1
\`\`\`

Current implementation status and next steps are tracked in `ROADMAP.md` and `CURRENT_STEP.md`; architectural decisions are recorded in `DECISIONS.md`.
