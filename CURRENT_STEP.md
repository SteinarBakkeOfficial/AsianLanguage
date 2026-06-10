# CURRENT STEP

## Goal

Create the initial SwiftUI app shell for an offline-first iPhone app.

## Focus

- Establish the Home, Search, Browse, Collections, and Settings navigation shell
- Keep the first app surface aligned to the resolved V1 lesson model
- Prepare shell routes for the six-step Shared Character lesson flow
- Keep scope tightly on V1 Shared Character lessons

## Current Priorities

1. Create the SwiftUI root app entry and tab shell.
2. Add placeholder screens for Home, Search, Browse, Collections, and Settings.
3. Add code-facing enums for app tabs and lesson steps.
4. Add the first app-level dependency container placeholder.
5. Keep the shell ready for local corpus loading and local user state without implementing those systems yet.
6. Verify layout and any available Swift tooling locally.

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
- Draft sample Shared Character content record created in `content/shared-characters/tree.json`
- SwiftUI app entry point and root tab shell created
- Placeholder Home, Search, Browse, Collections, and Settings screens created
- Lesson-step route primitives created
- Minimal `AsianLanguage.xcodeproj` and shared scheme created for macOS/Xcode verification
- Home shell now reads from a draft featured Shared Character summary
- Windows-runnable corpus validator created in `Tools/Validate-Corpus.ps1`
- Corpus validation tests created in `Tests/CorpusValidation.Tests.ps1`
- Bundled runtime corpus copy added at `Resources/Corpus/tree.json`
- First read-only Swift corpus model and bundle repository added
- App dependencies now load the bundled draft `tree` record for the Home featured card when available
- Corpus sync script created in `Tools/Sync-Corpus.ps1`
- Validator now checks direct core-meaning examples and source references

## Next Concrete Output

Produce the next Windows-testable app-shell slice:

- add a Windows test runner script that executes all local checks in one command
- add a first lesson placeholder route from Home using the bundled `tree` id
- prepare Swift model tests for macOS/Xcode once CI or macOS access is available
- keep user-state persistence deferred until the local data layer slice
- keep Swift/Xcode compile verification deferred until macOS/Xcode or macOS CI is available

## V1 to VNext Tracking

V1 intentionally covers Shared Character symbol-lineage lessons only. `Structure` means character/component structure, not grammar or sentence structure. Traditional Chinese is included as a modern focus track with separate Taiwan/Hong Kong usage examples when that focus is selected or when all tracks are selected. Account pages, grammar comparison, rule-based common-denominator lessons, broader cross-language structure teaching, voice, Android, sync, and monetization remain deferred and should not be silently pulled into the current step.
