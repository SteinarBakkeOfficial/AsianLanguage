# ROADMAP

## Product direction

Build an offline-first iPhone experience where a learner follows one Shared Character from a recognizable origin through historical evolution into modern Chinese, Japanese, and Korean recognition.

The official product-facing name is Script Roots. AsianLanguage remains the internal development identifier.

## Phases

1. Product foundation — complete; product language and scope are resolved
2. App skeleton — complete; five-area root shell is wired
3. Local data layer — complete; bundled corpus and separate local user state are wired
4. Symbol Journey — in progress; structural pager, stage rail, Today endpoint, exact-position resume, and initial visual slice are implemented
5. Discovery — foundation implemented; visual refinement remains
6. Content contract — folder-based editorial layer implemented; current records remain draft and require editorial review
7. Asset pipeline — offline preparation/package path implemented; production provenance and historical assets remain incomplete
8. Pilot corpus — in progress; Fire, Water, Mountain, and Tree are draft fixtures, Horse remains blocked
9. Design and QA — visual implementation started; simulator comparison and Mac/iPhone checks remain
10. V1 release — not started; publication, signing, and delivery remain ahead

## Current status

Phases 1–3 are complete. Phase 4 is active: the former six-step lesson and poster-like EvolutionBoardView are no longer on the production path, and the canonical Symbol Journey now has a data-driven horizontal pager, vertical stage scrolling, persistent stage navigation, Today routing, and exact-position persistence. The first shared visual foundation and Fire stage composition are now in the repository.

Discovery and content-contract foundations are also present, including Browse-owned Search/Collections/status lists, four focus tracks, regional Traditional Chinese coverage, stage-owned asset metadata, migration support, and release/readiness checks. The current 11 records remain draft fixtures.

## Current implementation snapshot — 2026-08-31

### Implemented

- Five root destinations: Home, Symbol, History, Browse, and More.
- Shared `openSymbol` routing with start, resume, view, review, and direct-stage foundations.
- Separate `selectedSymbolID` and `activeJourneySymbolID` concepts.
- Local JSON user state with independent progress, Favorite, Review Later, focus-language, appearance, onboarding, and reset behavior.
- Data-driven Origin, historical stages, Today, Structure, Usage, and Summary sections.
- Horizontal historical paging with content-driven stage nodes and vertically scrollable stage pages.
- Semantic design tokens for light/dark colors, typography, spacing, radii, and motion.
- Reusable foundation components for primary/secondary actions, icon actions, grouped surfaces, artifact fields, missing historical content, lineage previews, character tiles, search fields, and settings rows.
- Home lineage preview now uses actual available corpus forms only.
- Today now presents selected language tracks as one vertical cross-language relationship without language-specific color coding.
- Ordinary Symbol viewing no longer records progress merely because a Browse/Search result was opened.
- Learned Symbols now have a dedicated revisit entry with Revisit Journey, Quick Review, and View Usage actions.
- Quick Review is a lightweight recognition surface with a complete-journey escape hatch and no scoring or gamification.
- The final installed record now has a calm Completion state with Return Home and Revisit actions.
- Browse status and in-progress records now use the shared CharacterTile primitive.
- Structure now presents a stage-aware recap with available lineage forms and component notes.
- Usage now presents selected-track examples in restrained vertical groups.
- Summary now provides a calm modern-form recognition reveal without scoring.
- Search now uses the shared native-feeling search field, explicit Cancel behavior, text-first results, and semantic status labels.
- Settings now uses semantic app background, tint, and explanatory typography while retaining native Form controls.
- Home now uses the shared page hierarchy, data-driven lineage preview, primary action, and restrained grouped support modules.
- Collections and More now use semantic app surfaces, native navigation, and shared CharacterTile presentation where records are listed.
- Onboarding now uses the shared editorial hierarchy, primary actions, grouped focus-track controls, and semantic surfaces.
- Languages, Account, and About/Method now use semantic surfaces and typography; Account does not present a fake profile identity.
- History period detail now uses open editorial composition, semantic typography, grouped context, and an intentional missing-representative state until approved content is assigned.
- More utility rows and source/license entries now use quiet semantic presentation while preserving native navigation behavior.
- Historical stage availability is now distinct from confidence in the runtime model; legacy certainty labels normalize for presentation, draft tooling emits availability, and corpus validation rejects invalid or contradictory states.
- Per-Symbol folders now contain structured lesson data, learner copy, research notes, review checklist, sources, visual teaching notes, historical-stage provenance, and reusable component references.
- The preparation workflow has been experimentally run across the 11-record batch; each folder remains `needsReview` and no generated content is auto-approved.
- Fire now includes a clearly classified educational Origin reconstruction; it is not presented as historical evidence.
- Offline packaging now validates Symbol folders, synchronizes flat bundle records, copies local app derivatives, and emits an asset manifest with runtime networking disabled.
- A generated human review report lists each Symbol's folder, status, formation mode, stage availability, asset references, and editorial files.
- All available Windows layout, model, content, visual, discovery, and release checks pass.

### Transitional or incomplete

- Fire Origin now renders an educational reconstruction in the content package; it remains a draft asset and requires editorial review.
- Fire Oracle Bone, Bronze, Seal, and Clerical stages have no approved renderable assets; only a prototype Regular asset reference exists. Local SVG rendering is now implemented but still requires macOS/Xcode verification.
- Today, Structure, Usage, and Summary have initial dedicated compositions but still need simulator comparison and interaction polish.
- Completion, Revisit, and Quick Review have initial behavior and structure but still need simulator visual QA and final interaction polish.
- Shared components are available; History and More still need final simulator visual polish and any future approved representative content.
- Historical asset provenance, renderability, and specialist confidence review remain required before publication; the availability/confidence contract itself is now aligned.
- The current prototype SVG assets are packaged locally but still require native rendering verification and final asset treatment on macOS.

### Current next steps

1. Complete the Fire Origin and earliest-supported-stage content/asset review.
2. Port approved Fire historical evidence and any context/isolated derivatives into the Fire folder without fabricating unavailable stages.
3. Run the dedicated Today, Structure, Usage, and Summary visual comparison targets.
4. Run macOS/Xcode simulator screenshot comparison, then physical iPhone checks.

## V1 to VNext Carryover Register

- Grammar and rule lessons
- Voice/audio
- Tracing/handwriting
- Android
- Sync and deep account systems
- Ads/monetization
- User-created collection folders
- richer historical animation

## Future considerations — undecided

- Consider shipping V1 with a bundled offline baseline of roughly 50–100 symbols, then offering optional online symbol/content packs so users can download additional symbols without requiring a full app update.
- Evaluate the trade-offs among initial app size, offline availability, pack versioning, storage management, content provenance, and whether future symbol additions should remain app-update based or become downloadable packs.

This is exploratory only and is not currently a product requirement or implementation decision.

## Launch targets

The first credible V1 target is about 100 high-quality Shared Characters. The longer-term product vision is 500–1000, after the pilot proves the content and design system.
