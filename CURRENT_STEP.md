# CURRENT STEP

## Goal

Complete the Windows-implementable V1 implementation pass for the offline-first iPhone app.

## Focus

- Keep the app aligned to the resolved V1 Shared Character lesson model
- Preserve local/offline behavior for corpus, progress, preferences, and discovery
- Provide Windows-runnable verification for every implementable slice
- Clearly mark blockers that require macOS/Xcode, source-backed corpus work, or Apple release access

## Current Priorities

1. Create the SwiftUI root app entry and tab shell.
2. Add placeholder screens for Home, Search, Browse, Collections, and Settings.
3. Add code-facing enums for app tabs and lesson steps.
4. Add the first app-level dependency container placeholder.
5. Keep the shell ready for local corpus loading and local user state without implementing those systems yet.
6. Verify layout and any available Swift tooling locally.
7. Add local user-state storage for progress and preferences.
8. Implement the six-step guided lesson shell.
9. Implement local Search, Browse, and Collections over the bundled corpus.
10. Add content tooling, visual treatment, polish, and release-readiness checks.

## In Scope

- iPhone-first architecture
- SwiftUI shell planning
- local/offline data model
- focus-language selection for Simplified Chinese, Traditional Chinese, Japanese, Korean, or All
- lesson UX structure
- V1 Shared Character content model

## Out of Scope

- Android
- grammar lesson model
- rule-based common-denominator lessons
- voice/audio
- tracing/handwriting
- sync/accounts
- account page
- monetization

## Done

- Product brief captured in repo
- Initial glossary created in `CONTEXT.md`
- Core product decisions resolved through grilling
- V1 lesson/publication/progress/navigation model agreed
- V1 foundation layout created for `ios-swiftui`
- Initial implementation-facing architecture doc created in `docs/architecture/v1-foundation.md`
- Initial Shared Character schema doc created in `docs/content/shared-character-schema.md`
- Prototype 1 draft Shared Character corpus created with 11 basic symbols
- SwiftUI app entry point and root tab shell created
- Placeholder Home, Search, Browse, Collections, and Settings screens created
- Lesson-step route primitives created
- Minimal `AsianLanguage.xcodeproj` and shared scheme created for macOS/Xcode verification
- Home shell now reads from a draft featured Shared Character summary
- Windows-runnable corpus validator created in `Tools/Validate-Corpus.ps1`
- Corpus validation tests created in `Tests/CorpusValidation.Tests.ps1`
- Bundled runtime corpus copies added under `Resources/Corpus`
- First read-only Swift corpus model and bundle repository added
- App dependencies now load the bundled Prototype 1 manifest records for Home and discovery
- Corpus sync script created in `Tools/Sync-Corpus.ps1`
- Validator now checks direct core-meaning examples and source references
- Windows one-command local check runner added at `Tools/Run-Checks.ps1`
- First Home-to-lesson route added for the featured bundled prototype record
- Swift XCTest target scaffold and initial model tests prepared for future macOS/Xcode verification
- Windows-runnable Swift model contract tests added for route, focus-track, lesson-step, and corpus model source contracts
- Local JSON-backed user-state store added for focus track, progress, favorites, and review-later
- Home now supports resume behavior for the latest in-progress lesson
- Settings now persists focus language and confirms reset before clearing local state
- Concrete six-step `LessonView` added with step progress, restart, and Mark as Learned
- Search, Browse, and Collections now use the bundled offline corpus and route into lessons
- Reusable history spine and modern forms comparison views added for lesson visuals
- Prototype visual SVG cards added under `Resources/Assets/PrototypeVisuals`
- Progressive word/sentence example metadata added for prototype records
- Draft Shared Character authoring script added at `Tools/New-SharedCharacterDraft.ps1`
- Corpus readiness report added at `Tools/Report-CorpusReadiness.ps1`
- Release readiness check added at `Tools/Check-ReleaseReadiness.ps1`
- About / Method screen and empty-state polish added

## Next Concrete Output

The Windows-implementable V1 implementation pass is complete up to the known blockers.

- keep Swift/Xcode compile execution deferred until macOS/Xcode or macOS CI is available
- keep production corpus expansion and publication status blocked until source-backed editorial content is available
- keep publication visual assets blocked until source-backed redraws or licensed/source-backed assets are available
- keep TestFlight/App Store release blocked until Apple signing/upload access is available

## V1 to VNext Tracking

V1 intentionally covers Shared Character symbol-lineage lessons only. `Structure` means character/component structure, not grammar or sentence structure. Traditional Chinese is included as a modern focus track with separate Taiwan/Hong Kong usage examples when that focus is selected or when all tracks are selected. Account pages, grammar comparison, rule-based common-denominator lessons, broader cross-language structure teaching, voice, Android, sync, and monetization remain deferred and should not be silently pulled into the current step.
