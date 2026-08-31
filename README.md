# AsianLanguage

AsianLanguage is an English-first, offline-first iPhone experience about shared Chinese-character heritage across Mandarin, Traditional Chinese usage communities, Japanese Kanji, and Korean Hanja.

The core object is one \`Shared Character\`. Its primary experience is a \`Symbol Journey\`: a recognizable origin moves through defensible historical Evolution Stages and then reaches Today / Modern Forms across the selected focus tracks.

## Root shell

The app has five root areas: Home, Symbol, History, Browse, and More. Search and Collections belong in Browse. Languages, Settings, Account, About / Method, reset, and offline information belong in More.

## V1

V1 is local and offline. The bundled corpus is read-only; progress, Favorites, Review later, and focus-track selection are local user state. All four focus tracks are enabled by default, but users may disable every track for a museum-only Symbol Journey; there is no separate All enum value. Language controls live in More rather than blocking the first exhibit.

The current 11 records are draft prototype fixtures. Fire is the first design and schema pilot, followed by Water, Mountain, Tree, and eventually Horse when sourced.

Historical Assets must be source-backed or licensed, explicitly unavailable, or editorially omitted. Fabricated historical glyphs and modern-form fallbacks are prohibited.

Approved visual references are stored under `Reference Pictures/Chatgpt/`. The written Design System and Symbol Experience handoffs take precedence over generated labels or factual details in those images.

## Symbol content workspace

Each prepared Symbol has a human-editable folder under `content/symbols/`, with learner copy, research notes, review status, sources, educational visual instructions, historical-stage provenance, and component references. Reusable concepts live under `content/components/`. The preparation, validation, review, and offline packaging commands are documented in `Tools/README.md`.

The current experimental package contains 11 draft Symbols. All remain `needsReview`; historical evidence and educational reconstructions are classified separately, and runtime lesson assets are local-only.

## Development

Windows checks validate content, state contracts, project wiring, and static product contracts. Actual SwiftUI compilation and XCTest execution require macOS/Xcode. The intended workflow is approved design → SwiftUI → simulator screenshot → visual comparison → physical iPhone verification.

Run available checks:

\`\`\`powershell
& .\Tools\Run-Checks.ps1
\`\`\`

Current implementation status and next steps are tracked in `ROADMAP.md` and `CURRENT_STEP.md`; architectural decisions are recorded in `DECISIONS.md`.
