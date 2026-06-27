# ROADMAP

## Product Direction

Build an offline-first iPhone app that teaches shared Chinese-character heritage across Mandarin, Traditional Chinese usage communities, Japanese, and Korean through guided `Shared Character` lessons.

## Phase 1. Product Foundation

- Turn the resolved product model into stable project documentation
- Finalize V1 lesson contract, progress model, and navigation model
- Define the initial local content schema and app architecture direction

## Phase 2. App Skeleton

- Create the SwiftUI app shell
- Establish navigation structure for Home, Symbol / New Symbol, History, Browse, and More / Settings
- Implement light/dark mode intentionally from the start

## Phase 3. Local Data Layer

- Design the bundled read-only corpus model for Shared Characters
- Design separate local writable user-state storage
- Support progress, favorites, review-later, preferences, and installed corpus metadata

## Phase 4. Lesson Experience

- Implement the six-step guided lesson shell
- Build the tappable progress bar with current, visited, and unvisited states
- Support resume, restart lesson, Mark as Learned, and step-controlled visuals

## Phase 5. Discovery

- Implement Browse as the discovery hub
- Include Search, Saved/Favorites/Review later, and system/editorial Collections inside Browse
- Support filters, sorting, and compact list items with status indicators

## Phase 6. Content Tooling and Corpus Format

- Define the publishable Shared Character content format
- Support certainty notes, sources, editorial callouts, historical stage metadata, focus-track examples, and recognition takeaway fields
- Prepare the first production-ready corpus pipeline for lesson entry

## Phase 7. Visual Content System

- Establish image-backed asset handling for origin, Oracle Bone, Bronze, Seal, Clerical, Regular, and stroke-order visuals
- Support horizontal stage-by-stage viewing with pressable bottom evolution navigation and optional auto-play later
- Define the reusable visual treatment from the character-evolution reference target, then transition into Modern Forms
- Keep stroke order view-only for modern focus-track forms where authoritative data is available

## Phase 8. Initial Corpus

- Produce the first launch-quality Shared Characters
- Use `docs/content/symbol-source-plan.md` as the source strategy and first-50 proof-set plan
- Validate publication gate, notes quality, and example consistency
- Reach the first meaningful launch corpus target

## Phase 9. Polish and QA

- Refine onboarding, About/Method, and empty states
- Add a primary-shell History explainer for Oracle Bone, Bronze, Seal, Clerical, and Regular periods outside individual symbol pages
- Validate offline behavior and local reset flow
- Test lesson UX, search tolerance, and collection behavior

## Phase 10. V1 Release

- Ship the first iPhone version
- Bundle the installed corpus with the app release
- Keep the product focused on shared characters and modern usage only

## Implementation Status

- Phase 1 Product Foundation: implemented in project docs
- Phase 2 App Skeleton: implemented with SwiftUI shell and Xcode project scaffold; target shell has been updated to Home, Symbol, History, Browse, and More / Settings
- Phase 3 Local Data Layer: implemented locally for user state and bundled corpus access
- Phase 4 Lesson Experience: implemented as a six-step guided lesson shell
- Phase 5 Discovery: implemented for local Search, Browse, and Collections over bundled records
- Phase 6 Content Tooling and Corpus Format: implemented for validation, draft creation, sync, and readiness reporting
- Phase 7 Visual Content System: partially implemented as structured SwiftUI history spine, modern-form comparison views, prototype regular-script cards, and partial source-backed historical SVG intake; it must be reworked so the reference character-evolution layout is treated as the product target, with horizontal full-page stage views and fixed bottom evolution navigation
- Phase 8 Initial Corpus: source-backed seed corpus has 11 draft basic-symbol records and readiness tooling; launch-quality breadth remains blocked on deeper editorial work, broader historical visual coverage, and specialist review
- Phase 9 Polish and QA: partially implemented for reset confirmation, About / Method, empty states, and Windows checks
- Phase 10 V1 Release: blocked until macOS/Xcode signing, simulator/device verification, and App Store/TestFlight access are available

## V1 to VNext Carryover Register

- Grammar comparison is intentionally deferred beyond V1
- Rule-based common-denominator lessons are intentionally deferred beyond V1
- Voice/audio is intentionally deferred beyond V1
- Android support is intentionally deferred beyond V1
- Sync/account systems are intentionally deferred beyond V1
- Account page depth is intentionally deferred during the core symbol-recognition prototype, but the app concept remains reserved for public testing readiness
- Ads/monetization are intentionally deferred beyond V1
- Handwriting/tracing interaction is intentionally deferred beyond V1
- Richer historical transformation animation may begin simple in V1 and deepen later
- Expanded corpus beyond the first launch set is intentionally deferred beyond V1

## Launch Target

- Product vision corpus: `500-1000` Shared Characters
- First credible V1 launch target: about `100` high-quality Shared Characters
