# AsianLanguage

AsianLanguage is an English-first, offline-first iPhone experience about shared Chinese-character heritage across Mandarin, Traditional Chinese usage communities, Japanese Kanji, and Korean Hanja.

The core object is one \`Shared Character\`. Its primary experience is a \`Symbol Journey\`: a recognizable origin moves through defensible historical Evolution Stages into Modern Forms, then continues into Usage across the selected focus tracks.

## Root shell

The app has five root areas: Home, Symbol, History, Browse, and More. Search and Collections belong in Browse. Languages, Settings, Account, About / Method, reset, and offline information belong in More.

## V1

V1 is local and offline. The bundled corpus is read-only; progress, Favorites, Review later, and focus-track selection are local user state. All four focus tracks are enabled by default, but users may disable every track for a museum-only Symbol Journey; there is no separate All enum value. Language controls live in More rather than blocking the first exhibit.

The runtime V1 manifest contains 126 complete-evolution records in teaching order. The earlier 11-record pilot remains in the repository as historical design/reference content; the incomplete Fire pilot is not included in the V1 runtime manifest.

Each available museum stage has a short destination-stage transition caption. Origin → Oracle connects the illustrated subject to the first glyph; later captions describe only visible changes between neighboring forms, without repeating the modern character or naming the transition.

The original Fire introduction remains available as a repository-backed onboarding reference and is opened directly from the local repository when the learner enters the introduction. It does not change the 126-record V1 learning corpus.

Historical Assets must be source-backed or licensed, explicitly unavailable, or editorially omitted. Fabricated historical glyphs and modern-form fallbacks are prohibited.

The current V1 runtime is the 126-character complete-evolution selection with 504 selected/normalized ZDIC stage assets, local origin illustrations, and a Regular Script Kai endpoint. The app also bundles the History reference artwork and uses its illustrations inside a native timeline layout. ZDIC assets remain marked reuse-review-required before commercial distribution.

The approved modern-form plan uses locale-specific Chinese, Japanese, and Korean rendering. The selected Regular faces from CNS11643 Kai and Adobe Source Han Serif are bundled and registered locally; Source Han Sans and additional weights remain intentionally excluded.

Approved visual references are stored under `Reference Pictures/Chatgpt/`. The written Design System and Symbol Experience handoffs take precedence over generated labels or factual details in those images.

## Symbol content workspace

Each prepared Symbol has a human-editable folder under `content/symbols/`, with learner copy, research notes, review status, sources, educational visual instructions, historical-stage provenance, and component references. Reusable concepts live under `content/components/`. The preparation, validation, review, and offline packaging commands are documented in `Tools/README.md`.

The import source is `Tools/Import-V1RuntimeCorpus.ps1`; it keeps the human-readable research package under `content/research/` and produces the read-only runtime records/assets under `Resources/Corpus` and `Resources/Assets/Symbols`. Records remain `needsReview` until rights, language copy, and editorial QA are complete.

## Development

Windows checks validate content, state contracts, project wiring, and static product contracts. Actual SwiftUI compilation and XCTest execution require macOS/Xcode. The intended workflow is approved design → SwiftUI → simulator screenshot → visual comparison → physical iPhone verification.

Run available checks:

\`\`\`powershell
& .\Tools\Run-Checks.ps1
\`\`\`

Current implementation status and next steps are tracked in `ROADMAP.md` and `CURRENT_STEP.md`; architectural decisions are recorded in `DECISIONS.md`.
