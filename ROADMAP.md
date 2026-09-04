# ROADMAP

## Product direction

Build an offline-first iPhone experience where a learner follows one Shared Character from a recognizable origin through historical evolution into modern Chinese, Japanese, and Korean recognition.

The official product-facing name is Script Roots. AsianLanguage remains the internal development identifier.

## Phases

1. Product foundation — complete; product language and scope are resolved
2. App skeleton — complete; five-area root shell is wired
3. Local data layer — complete; bundled corpus and separate local user state are wired
4. Symbol Journey — in progress; structural pager, one context-aware stage rail, Modern/Usage endpoints, exact-position resume, and initial visual slice are implemented
5. Discovery — foundation implemented; visual refinement remains
6. Content contract — folder-based editorial layer implemented; current records remain draft and require editorial review
7. Asset pipeline — offline preparation/package path implemented; production provenance and historical assets remain incomplete
8. Pilot corpus — in progress; Fire, Water, Mountain, and Tree are draft fixtures, Horse remains blocked
9. Design and QA — visual implementation started; simulator comparison and Mac/iPhone checks remain
10. V1 release — not started; publication, signing, and delivery remain ahead

## Current status

Phases 1–3 are complete. Phase 4 is active: the former six-step lesson and poster-like EvolutionBoardView are no longer on the production path, and the canonical Symbol Journey now has data-driven horizontal swipe pages, persistent stage navigation, Today routing, and exact-position persistence. The first shared visual foundation and Fire stage composition are now in the repository.

Discovery and content-contract foundations are also present, including Browse-owned Search/Collections/status lists, four focus tracks, regional Traditional Chinese coverage, stage-owned asset metadata, migration support, and release/readiness checks. The runtime now loads the 126-record complete-evolution V1 package; the original 11 records remain as repository reference fixtures.

## Current implementation snapshot — 2026-09-03

### Implemented

- Five root destinations: Home, Symbol, History, Browse, and More.
- Shared `openSymbol` routing with start, resume, view, review, and direct-stage foundations.
- Separate `selectedSymbolID` and `activeJourneySymbolID` concepts.
- Local JSON user state with independent progress, Favorite, Review Later, focus-language, appearance, onboarding, and reset behavior.
- Data-driven Origin, historical stages, Modern, and Usage language pages in one continuous horizontal journey; each page owns its own vertical content.
- One context-aware rail: Origin → Oracle → Bronze → Seal → Clerical → Modern in the museum room, then Modern → selected target-language pages in Usage.
- Semantic design tokens for light/dark colors, typography, spacing, radii, and motion.
- Reusable foundation components for primary/secondary actions, icon actions, grouped surfaces, artifact fields, missing historical content, lineage previews, character tiles, search fields, and settings rows.
- Home lineage preview now uses actual available corpus forms only.
- Today now presents one horizontal exhibit page per selected language track, without language-specific color coding.
- Ordinary Symbol viewing no longer records progress merely because a Browse/Search result was opened.
- Learned Symbols now have a dedicated revisit entry with Revisit Journey, Quick Review, and View Usage actions.
- Quick Review is a lightweight recognition surface with a complete-journey escape hatch and no scoring or gamification.
- The final installed record now has a calm Completion state with Return Home and Revisit actions.
- Browse status and in-progress records now use the shared CharacterTile primitive.
- Structure and source detail now live behind the character `…` menu rather than interrupting the museum flow.
- Usage now presents one restrained word-context panel on each selected-track Today page.
- Summary is not part of the primary museum journey.
- Search now uses the shared native-feeling search field, explicit Cancel behavior, text-first results, and semantic status labels.
- Settings now uses semantic app background, tint, and explanatory typography while retaining native Form controls.
- Home now uses the shared page hierarchy, data-driven lineage preview, primary action, and restrained grouped support modules.
- Collections and More now use semantic app surfaces, native navigation, and shared CharacterTile presentation where records are listed.
- Onboarding now uses the shared editorial hierarchy, primary actions, grouped focus-track controls, and semantic surfaces.
- Languages, Account, and About/Method now use semantic surfaces and typography; Account does not present a fake profile identity.
- The earlier detailed History period implementation remains retained for later expansion; the current V1 History tab now follows the supplied overview natively with its title treatment, landscape, five timeline stages, cropped material illustrations, explanations, and living-tradition footer.
- More utility rows and source/license entries now use quiet semantic presentation while preserving native navigation behavior.
- Historical stage availability is now distinct from confidence in the runtime model; legacy certainty labels normalize for presentation, draft tooling emits availability, and corpus validation rejects invalid or contradictory states.
- Per-Symbol folders now contain structured lesson data, learner copy, research notes, review checklist, sources, visual teaching notes, historical-stage provenance, and reusable component references.
- The preparation workflow remains available for the original pilot; the current V1 import is handled by `Import-V1RuntimeCorpus.ps1`, and no generated content is auto-approved.
- All 630 V1 museum transition captions now use concise neighboring-stage visual language; source and runtime caption contracts reject stage-name prefixes, modern-character prose references, empty notes, and notes over 25 words.
- Fire now includes a clearly classified educational Origin reconstruction; it is not presented as historical evidence.
- Offline packaging now validates Symbol folders, synchronizes flat bundle records, copies local app derivatives, and emits an asset manifest with runtime networking disabled.
- A generated human review report lists each Symbol's folder, status, formation mode, stage availability, asset references, and editorial files.
- All available Windows layout, model, content, visual, discovery, and release checks pass.
- AppShell light tokens now match the approved clay-and-white reference, with Light as the default and Dark as the sole alternative.
- Browse and Collections now separate Your Library status lists from editorial collections, with collection artwork previews.
- Today now uses one page per selected language with four draft starter entries per track; native-speaker review must replace or approve the neutral learning-context additions before publication.
- Fire, Water, and Tree now have separate educational concept illustrations, and the allowlisted historical SVG intake preserves source/license provenance.
- The approved correction pass keeps the Symbol Journey rail persistent and visibly labeled, isolates Fire onboarding from the compact Home preview, fixes Home's orphaned active-state fallback, uses the complete collection banner on Home, identifies Hong Kong Cantonese/Jyutping readings, and recreates the History overview natively from the approved reference content.
- The Symbol Journey now separates the single Modern/Regular Script museum endpoint from later language Usage pages; one visible rail changes its destinations at that boundary.

### Transitional or incomplete

- Fire, Water, and Tree concept art renders as educational reconstruction only and remains under editorial review.
- Allowlisted Fire, Water, and Tree historical SVGs are bundled where acquired; named stages without approved files remain unavailable. Local SVG rendering still requires macOS/Xcode verification.
- The Modern/Usage page composition and word-context layout still need simulator comparison and interaction polish; the four starter entries per track still need reviewed, character-relevant vocabulary.
- Completion, Revisit, and Quick Review have initial behavior and structure but still need simulator visual QA and final interaction polish.
- Shared components are available; History still needs final simulator comparison for crop positioning and typography, while More needs any future approved representative content.
- The approved Symbol / History / modern-language polish implementation is in progress: stage backgrounds, period removal, one-page onboarding, iOS pronunciation seam, clickable History detail destinations, and modern-language branches are now wired; simulator/device verification remains.
- Historical asset provenance, renderability, and specialist confidence review remain required before publication; the availability/confidence contract itself is now aligned.
- The current prototype SVG assets are packaged locally but still require native rendering verification and final asset treatment on macOS.
- The 148-character research-only ZDIC intake produced 568 of 592 possible Oracle Bone/Bronze/Small Seal/Clerical selections; V1 is now restricted to the 126 characters with all four stages. These copied files are not cleared for commercial bundling.
- The 126-character V1 historical selection is now imported into `Resources/Assets/Symbols` as 504 normalized ZDIC SVG pairs plus retained originals and is wired to the 126-record runtime manifest. Assets remain rights-review-required.
- CNS11643 Kai and the four approved Adobe Source Han Serif locale faces are downloaded, documented, bundled, and registered for Regular Script and Used Today. Source Han Sans and additional weights remain intentionally deferred.

### Current next steps

1. Complete native-speaker review of pilot Today readings, romanization, examples, and translations.
2. Complete specialist review of historical stage interpretation and source-backed derivatives.
3. Confirm ZDIC reuse permission or replace the bundled historical selections with cleared/public-domain equivalents before commercial distribution.
4. Complete native-speaker and macOS visual verification of the newly bundled locale-aware glyph rendering.
5. Run macOS/Xcode simulator screenshot comparison for the reference-target screens.
6. Run physical iPhone checks for touch, safe areas, gestures, and rendering.

### Screenshot-review follow-ups and polish boundary

- Deferred outside the current polish implementation: move the Home Regular Script artwork upward to preserve space for the Continue button.
- Included in the current polish implementation: remove the previously tested age/period line from Symbol Journey stage headers; retain chronology in History and source metadata.
- Included in the current polish implementation: consolidate the two similar Fire onboarding pages into one direct-entry page using the existing first-page concept.
- Deferred outside the current polish implementation: expand Regular Script transition captions where they are too brief.
- Deferred outside the current polish implementation: replace the four-track starter examples with fully reviewed, character-relevant Chinese, Japanese, and Korean usage content.
- Included in the current polish implementation: correct the existing History header crop/layout collision and remaining artwork/text fit issues after comparing the supplied screenshots; preserve the approved composition and existing History artwork.
- Deferred outside the current polish implementation: audit the complete Sources / Licenses page and resolve the broader About-versus-Sources content-architecture question. Apple Speech Synthesis technical attribution is included with the approved audio work.
- Browse and More are currently accepted and are out of scope for this fix pass.

The complete 2026-09-04 final-polish brief is preserved in [`docs/design/symbol-history-modern-final-polish-feedback.md`](docs/design/symbol-history-modern-final-polish-feedback.md). Its approved implementation boundary is recorded in [`docs/design/symbol-history-modern-final-polish-implementation-plan.md`](docs/design/symbol-history-modern-final-polish-implementation-plan.md).

The separate [Pronunciation Audio handoff](docs/architecture/pronunciation-audio-apple-avspeechsynthesizer-feedback.md) is approved for this pass: use an isolated iOS AVSpeechSynthesizer service, explicit draft speech text, and small speaker controls; no cloud TTS or bundled MP3 files. User and native-speaker verification is a later release-testing step, not an implementation gate.

## V1 to VNext Carryover Register

- Grammar and rule lessons
- Android pronunciation renderer: a future Android port replaces the iOS speech renderer with Android TextToSpeech while retaining the same verified platform-independent pronunciation data.
- Tracing/handwriting
- Android
- Sync and deep account systems
- Ads/monetization
- User-created collection folders
- richer historical animation
- Deeper Fire onboarding language orientation covering all four target writing traditions; this applies only to the onboarding symbol experience.
- History page rework: the broader History overview redesign is intentionally the next implementation after this surgical polish pass.
- Future Home cleanup: replace the standalone “X symbols learned” footer with a deliberate destination such as History or the Learned library; do not change the current footer during this pass.
- Future language-orientation content: broader language-family/context explanation beyond the approved modern-language branches and their intentionally unfinished detail destinations remains deferred.

## Future considerations — undecided

- Consider future V2/V3 expansion packs beyond the current 126-character V1 design target, then evaluate optional online symbol/content packs so users can download additional symbols without requiring a full app update.
- Evaluate the trade-offs among initial app size, offline availability, pack versioning, storage management, content provenance, and whether future symbol additions should remain app-update based or become downloadable packs.

This is exploratory only and is not currently a product requirement or implementation decision.

## Launch targets

The first credible V1 target is about 100 high-quality Shared Characters. The longer-term product vision is 500–1000, after the pilot proves the content and design system.
