# CURRENT STEP

## Goal

Turn the resolved product model into a buildable V1 foundation for an offline-first SwiftUI iPhone app.

## Focus

- Freeze the product definition in project docs
- Convert the lesson model into a concrete app/content/data architecture
- Keep scope tightly on V1 Shared Character lessons

## Current Priorities

1. Define the initial SwiftUI app structure and navigation shell.
2. Define the read-only Shared Character corpus schema and separate local user-state schema.
3. Define the lesson-view model for the six-step guided flow.
4. Define the focus-language model, system collections, sorting, filtering, and search expectations in code-facing terms.
5. Define the first content-entry format for publishable lessons.
6. Define historical stage metadata for visual form, change note, optional sound reconstruction, certainty, and sources.

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

## Next Concrete Output

Produce the first implementation-facing documents or code scaffolding for:

- app navigation
- local data schema
- lesson state model
- initial sample Shared Character content record

## V1 to VNext Tracking

V1 intentionally covers Shared Character symbol-lineage lessons only. `Structure` means character/component structure, not grammar or sentence structure. Traditional Chinese is included as a modern focus track with separate Taiwan/Hong Kong usage examples when that focus is selected or when all tracks are selected. Account pages, grammar comparison, rule-based common-denominator lessons, broader cross-language structure teaching, voice, Android, sync, and monetization remain deferred and should not be silently pulled into the current step.
