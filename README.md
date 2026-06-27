# Asian Language

English-first iPhone app about shared Chinese-character heritage across Mandarin, Traditional Chinese usage communities, Japanese, and Korean.

The app is not a general language course. Its purpose is cross-language recognition through guided `Shared Character` lessons that show how one underlying character lineage evolves from a historical origin anchor, through defensible script stages, to modern usage across the required focus tracks.

## Product Summary

- Platform: iPhone first
- UI framework: SwiftUI
- App type: guided educational reference
- Core value: help learners recognize shared character lineage and modern overlap across Mandarin, Traditional Chinese usage communities, Japanese, and Korean
- Primary lesson unit: `Shared Character`
- Primary learning outcome: `cross-language recognition`
- App language: English-first
- Core usage: fully offline for the shipped corpus

## V1 Scope

V1 focuses only on `shared characters and their modern usage`.

Included in V1:

- Guided `Shared Character` lessons
- One underlying character record per lesson
- Coverage across Mandarin, Traditional Chinese, Japanese, and Korean in every lesson
- Historical origin and evolution
- Defensible or explicitly limited-certainty character/component structure
- View-only modern stroke order when authoritative data is available
- Modern readings and examples
- Search, browse, and collections
- Local-only progress and preferences
- Offline bundled corpus

Excluded from V1:

- Grammar comparison
- Rule-based common-denominator lessons
- General language-structure lessons
- Voice/audio
- Handwriting or tracing interaction
- Android launch target
- Sync/accounts
- Deep account implementation
- Ads/monetization

## Shared Character Lesson Model

Each V1 lesson is centered on one underlying character record and must satisfy the publication gate:

- one teachable core shared meaning across all required focus tracks
- complete Mandarin, Traditional Chinese, Japanese, and Korean coverage
- separate Taiwan/Hong Kong usage examples when `All` or `Traditional Chinese` focus is selected
- at least one historical origin anchor
- characterized or regular-script form
- modern focus-track forms
- stage-to-stage change notes for every displayed historical stage after the first
- four required content sections supported responsibly
- at least two examples per language
- at least one example per language directly showing the core shared meaning
- editorial source standard met for all published content

The guided lesson flow is:

1. `Origin`
2. `Character`
3. `Modern Forms`
4. `Structure`
5. `Usage`
6. `Summary`

## Evolution Framework

The lesson framework is:

1. historical origin anchor
2. image-backed intermediate script stages when they add recognition value
3. image-backed characterized or regular-script form
4. modern Simplified Chinese, Traditional Chinese, Japanese Kanji, and Korean Hanja forms

The canonical history spine is Oracle Bone, Bronze, Seal, Clerical, Regular, then modern focus-track forms. Not every lesson must show every stage; incomplete or disputed paths must be marked with certainty notes.

The reference `Evolution of the Horse Character` and related character-evolution mockups are product targets for the evolution experience, not loose inspiration. The app adapts that reference from one poster into a horizontal, stage-by-stage iPhone lesson: each origin or script stage owns the page, the user swipes left/right between stages, and the bottom evolution strip acts as persistent stage navigation.

## User Experience

Primary shell layout:

1. `Home`
2. `Symbol` / `New Symbol`
3. `History`
4. `Browse`
5. `More` / `Settings`

Names may still change during design, but the functional grouping is stable. `Browse` includes discovery functions such as Search, Saved, Favorites, Review later, and collections. `More` / `Settings` includes Languages, Account, Settings, About / Method, reset, and other utility pages.

Home behavior:

- If a lesson is in progress, show `Resume current lesson`
- Otherwise show the `New Symbol` / `Next Symbol` primary action for the next featured Shared Character
- Keep `Symbol`, `History`, `Browse`, and `More` / `Settings` available from the primary shell
- Keep the shell page label as `Home`

Collections:

- `Your Collections`
- `Review later`
- `Favorites`
- `Explore Collections`

Deferred but preserved app concepts:

- `Account` remains an agreed app concept for public testing, but it can stay shallow while the core symbol-recognition experience is being tested
- `Saved/Archive` can initially live inside `Browse` as lightweight saved collections
- `Languages` can initially live inside `More` / `Settings` as focus-track controls

Settings:

- `Focus language`
- display preferences
- offline/app information
- reset app progress

Progress model:

- `unseen`
- `in progress`
- `learned`
- `review later`
- `starred`

Notes:

- `learned` and `review later` are mutually exclusive
- `Favorites` is separate from retention state
- corpus progress is shown as `learned / total available`

## Data Model Direction

- Shared Character corpus is bundled locally and treated as read-only
- User state is stored locally on-device
- No sync in V1
- No online dependency for core study flow

## Content Principles

- Prefer defensible simplified historical evolution
- Allow limited-certainty history or structure only when uncertainty is explicit
- Treat `Structure` as character/component structure, not grammar or sentence structure
- Use intermediate script stages only when they improve recognition or clarify the historical path
- Require a short change note from the previous shown stage for every displayed historical stage after the first
- Use richer side-by-side stage comparison only when the visual change is important or confusing
- Keep historical transformation and modern stroke order separate
- Include historical sound information only when accurate enough to source and label responsibly
- Treat character-evolution reference screenshots as the product target for composition, hierarchy, and stage navigation, while replacing screenshot content with app-native, licensed, or source-backed assets
- Use image assets for Origin, Oracle Bone, Bronze, Seal, Clerical, and Regular visuals; do not reuse the modern regular character as a stand-in for missing historical stages
- Present evolution stages as horizontal full-page pages with fixed bottom stage navigation; allow vertical scrolling only inside a page when a stage needs more text than fits
- Avoid speculative mnemonic claims presented as fact
- Keep source transparency available through lightweight `Sources/Notes`
- Use editorially written recognition takeaways

## Current State

The repo now contains the V1 product foundation, SwiftUI app shell, local user-state layer, guided lesson shell, offline discovery surfaces, corpus tooling, and Windows-runnable verification scripts.

Implemented locally:

- SwiftUI tab shell currently exists for Home, Search, Browse, Saved, Languages, Account, and Settings; target shell is now Home, Symbol, History, Browse, and More / Settings
- bundled read-only source-backed seed corpus with 11 basic Shared Characters
- local JSON-backed user-state store for focus language, lesson progress, favorites, and review-later
- six-step guided `Shared Character` lesson shell
- local search, browse, and collection entry points
- reusable history spine and modern-forms comparison views
- source-backed seed corpus generator with optional Wikimedia Commons historical glyph asset intake
- corpus validator, draft-record generator, corpus readiness report, and release readiness check
- future XCTest target scaffold for macOS/Xcode verification

Windows verification:

```powershell
& .\Tools\Run-Checks.ps1
```

Remaining blockers:

- real SwiftUI compile, simulator, and device testing require macOS/Xcode
- production launch corpus requires deeper editorial work beyond the current 11 source-backed draft seed records
- prototype regular-script visual cards and a small set of source-backed historical SVGs are included for testing, but publication visuals still need licensing review, broader historical coverage, and specialist redraw approval
- TestFlight/App Store release requires Apple signing and upload tooling
