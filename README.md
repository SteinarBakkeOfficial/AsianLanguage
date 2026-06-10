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
- Account page
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
2. optional intermediate script stages when they add recognition value
3. characterized or regular-script form
4. modern Simplified Chinese, Traditional Chinese, Japanese Kanji, and Korean Hanja forms

The canonical history spine is Oracle Bone, Bronze, Seal, Clerical, Regular, then modern focus-track forms. Not every lesson must show every stage; incomplete or disputed paths must be marked with certainty notes.

## User Experience

Home behavior:

- If a lesson is in progress, show `Resume current lesson`
- Otherwise show the `New Symbol` / `Next Symbol` primary action for the next featured Shared Character
- Keep `Search`, `Browse`, and `Collections` secondary
- Keep the shell page label as `Home`

Collections:

- `Your Collections`
- `Review later`
- `Favorites`
- `Explore Collections`

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
- Treat reference screenshots as design inspiration, not production app assets
- Avoid speculative mnemonic claims presented as fact
- Keep source transparency available through lightweight `Sources/Notes`
- Use editorially written recognition takeaways

## Current State

The repo now contains the V1 product foundation, SwiftUI app shell, local user-state layer, guided lesson shell, offline discovery surfaces, corpus tooling, and Windows-runnable verification scripts.

Implemented locally:

- SwiftUI tab shell for Home, Search, Browse, Collections, and Settings
- bundled read-only Prototype 1 draft corpus with 11 basic Shared Characters
- local JSON-backed user-state store for focus language, lesson progress, favorites, and review-later
- six-step guided `Shared Character` lesson shell
- local search, browse, and collection entry points
- reusable history spine and modern-forms comparison views
- corpus validator, draft-record generator, corpus readiness report, and release readiness check
- future XCTest target scaffold for macOS/Xcode verification

Windows verification:

```powershell
& .\Tools\Run-Checks.ps1
```

Remaining blockers:

- real SwiftUI compile, simulator, and device testing require macOS/Xcode
- production launch corpus requires source-backed editorial work beyond the current 11 draft prototype records
- prototype visual cards are included for testing, but publication visuals still need source-backed redraws or licensed/source-backed assets
- TestFlight/App Store release requires Apple signing and upload tooling
