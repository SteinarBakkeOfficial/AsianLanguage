# CURRENT STEP

## Goal

Reconcile the repository to the Symbol Journey product model and make it ready for the approved Fire visual design.

## Current product truth

- The core object is Shared Character.
- The hero experience is one Symbol Journey through time into Today / Modern Forms.
- Root areas are Home, Symbol, History, Browse, and More.
- Search and Collections belong in Browse; Languages, Settings, Account, About / Method, and reset belong in More.
- Focus tracks are four multi-select values, all enabled by default.
- Historical Assets are source-backed/licensed or explicit Missing Historical Assets; fabricated glyphs are prohibited.
- Current corpus records are draft prototype fixtures.

## Completed functional reconciliation

- Replace the six-button lesson rail with data-driven Evolution Stages and a Today endpoint.
- Persist exact SymbolJourneyPosition, including historical stage ID.
- Protect Learned from ordinary reopening/navigation; keep Restart explicit.
- Make Home display the same record its action opens.
- Align the Swift model, JSON schema, validator, and migration behavior.
- Make origin content and asset references data-driven.
- Use one canonical per-stage asset mapping and a real renderable asset resolver.
- Reorder the prototype path to Fire, Water, Mountain, Tree, then remaining records.
- Replace stale tests that force EvolutionBoardView or the old six-step rail.
- Add explicit current-character state, Browse-owned status collections, History period stubs, collection IDs, onboarding, appearance preference, and separate reset actions.

## Design freeze boundary

Do not invent final colors, typography, card geometry, animation, decorative textures, or final stage composition. Those come from the approved Light-mode Fire design.

## Next design deliverable

Design the complete Fire Symbol Journey: Origin, Oracle Bone, Bronze, Seal, Clerical, Regular, Today, stage navigator, Character structure behavior, scrolling, completion, and supporting Content Phases.

The design freeze is active: neutral structural surfaces may be exercised, but approved Fire references determine final screen composition.

## Blockers

- SwiftUI/Xcode compilation and XCTest execution require macOS/Xcode or macOS CI.
- Historical assets, source review, regional readings, and specialist editorial review remain incomplete.
- Horse must not be added until sourced.
