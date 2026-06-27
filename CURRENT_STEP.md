# CURRENT STEP

## Goal

Correct the runnable iPhone prototype so it matches the agreed V1 app structure, page behavior, lesson flow, focus-track model, and visual direction before release-candidate hardening.

## Focus

- Treat the macOS/iPhone test feedback in `MAC_TESTING.md` as the active correction input
- Keep the app aligned to the resolved V1 Shared Character lesson model
- Preserve local/offline behavior for corpus, progress, preferences, and discovery
- Bring Home, Symbol, History, Browse, More / Settings, and Lesson back to the agreed structure and content intent
- Replace the single focus-language picker with multi-select focus tracks defaulting all tracks on
- Rebuild the visual treatment against the reference character-evolution product target while clearly marking draft/source-backed asset limits
- Preserve agreed-but-deferred app concepts as shallow placeholders or carryover, not as erased scope
- Provide Windows-runnable verification for every implementable slice
- Clearly mark blockers that require macOS/Xcode, source-backed corpus work, licensed/source-backed visuals, or Apple release access

## Current Priorities

1. Fix tested lesson behavior: Restart Lesson, Mark as Learned, Continue, resume, and Next Symbol progression.
2. Replace the single focus-language model with multi-select Mandarin, Traditional Chinese, Japanese, and Korean tracks.
3. Rebuild Home around the agreed resume/new-symbol/next-symbol hierarchy and progress context.
4. Rework Lesson so each of the six steps presents the agreed information, not just placeholder text.
5. Rework the primary shell to Home, Symbol / New Symbol, History, Browse, and More / Settings.
6. Rework Browse so it contains Search, Saved, Favorites, Review later, and collections.
7. Rework More / Settings so it contains Languages, Account, Settings, About / Method, reset, and utility pages.
8. Rebuild prototype visuals to match the reference-led evolution direction while keeping source-backed publication visuals as a known blocker.
9. Wait for the Figma-first symbol evolution design handoff in `docs/content/symbol-evolution-design-handoff.md`, then prove the source-backed JSON/content format with 3-5 pilot symbols before expanding to the reordered first 50.
10. Keep Windows checks green and produce a focused Mac retest checklist after each correction pass.

## In Scope

- iPhone-first architecture
- SwiftUI shell planning
- local/offline data model
- focus-language selection for Simplified Chinese, Traditional Chinese, Japanese, and Korean
- lesson UX structure
- V1 Shared Character content model
- shallow placeholders or documented carryover for agreed pages that are not yet central to testing

## Out of Scope

- Android
- grammar lesson model
- rule-based common-denominator lessons
- voice/audio
- tracing/handwriting
- deep sync/account implementation
- monetization

## Done

- Product brief captured in repo
- Initial glossary created in `CONTEXT.md`
- Core product decisions resolved through grilling
- V1 lesson/publication/progress/navigation model agreed
- V1 foundation layout created for `ios-swiftui`
- Initial implementation-facing architecture doc created in `docs/architecture/v1-foundation.md`
- Initial Shared Character schema doc created in `docs/content/shared-character-schema.md`
- Source-backed seed Shared Character corpus created with 11 basic symbols
- SwiftUI app entry point and root tab shell created
- Placeholder Home, Search, Browse, Saved/Archive, Languages, Account, and Settings screens created
- Lesson-step route primitives created
- Minimal `AsianLanguage.xcodeproj` and shared scheme created for macOS/Xcode verification
- Home shell now reads from a draft featured Shared Character summary
- Windows-runnable corpus validator created in `Tools/Validate-Corpus.ps1`
- Corpus validation tests created in `Tests/CorpusValidation.Tests.ps1`
- Bundled runtime corpus copies added under `Resources/Corpus`
- First read-only Swift corpus model and bundle repository added
- App dependencies now load the bundled source-backed seed manifest records for Home and discovery
- Corpus sync script created in `Tools/Sync-Corpus.ps1`
- Validator now checks direct core-meaning examples and source references
- Windows one-command local check runner added at `Tools/Run-Checks.ps1`
- First Home-to-lesson route added for the featured bundled seed record
- Swift XCTest target scaffold and initial model tests prepared for future macOS/Xcode verification
- Windows-runnable Swift model contract tests added for route, focus-track, lesson-step, and corpus model source contracts
- Local JSON-backed user-state store added for focus track, progress, favorites, and review-later
- Home now supports resume behavior for the latest in-progress lesson
- Settings now persists focus language and confirms reset before clearing local state
- Concrete six-step `LessonView` added with step progress, restart, and Mark as Learned
- Search, Browse, and Collections now use the bundled offline corpus and route into lessons
- Reusable history spine and modern forms comparison views added for lesson visuals
- Reference-led `EvolutionBoardView` added so the Origin step shows original picture idea, staged glyph evolution, modern descendants, and a mini timeline together; this is now considered an insufficient transitional implementation because the product target is full-page horizontal stage navigation, not a single poster-like board
- Draft `SymbolPictogramView` and historical glyph sketches added so missing final assets no longer collapse into repeated modern characters
- Home, Browse, and Search now use symbol-first framed cards instead of plain default list rows
- Prototype visual SVG cards added under `Resources/Assets/PrototypeVisuals`
- Historical glyph asset downloader added for available Wikimedia Commons SVGs under `Resources/Assets/HistoricalGlyphs`
- Progressive word/sentence example metadata added for seed records
- Draft Shared Character authoring script added at `Tools/New-SharedCharacterDraft.ps1`
- Corpus readiness report added at `Tools/Report-CorpusReadiness.ps1`
- Release readiness check added at `Tools/Check-ReleaseReadiness.ps1`
- About / Method screen and empty-state polish added
- Symbol source strategy, first-50 proof set, and broader candidate pool captured in `docs/content/symbol-source-plan.md`
- Next approach captured in `docs/content/symbol-evolution-design-handoff.md`: user designs first, implementation pilots 3-5 visual symbols, then expands to the reordered first 50
- Target shell updated to Home, Symbol / New Symbol, History, Browse, and More / Settings; current prototype shell still needs implementation alignment

## Prototype 2 Acceptance Checklist

- Lesson is visually centered on the historical evolution of one symbol, not a generic list of sections.
- The main lesson surface treats the character-evolution reference pictures as product targets: origin idea, staged evolution, stage explanations/sound notes, modern descendants, examples, and summary must follow the same hierarchy and visual intent.
- Evolution is split into horizontal full-page stage views rather than one long vertical list or one all-in-one poster.
- Origin, Oracle Bone, Bronze, Seal, Clerical, and Regular visuals use image assets or explicit missing-asset placeholders; the modern regular character must not be reused as a false historical stage.
- The bottom evolution strip is pressable navigation for the current symbol: origin picture -> oracle bone -> bronze -> seal -> clerical -> regular -> modern forms.
- Bottom stage navigation remains fixed/floating near the bottom when the stage content scrolls vertically.
- Components are shown at the stage where they first appear or become meaningful; one-component symbols still identify the single component, while multi-component symbols explain each source-backed component.
- Generic explanations of Oracle Bone, Bronze, Seal, Clerical, and Regular periods are kept out of individual symbol pages and moved to a separate History or Method / History page.
- The first lesson screen shows visible draft evolution drawings even when final source-backed glyph redraws are unavailable.
- Missing historical drawings or source-backed stage content are visibly marked as content gaps, not hidden.
- Available source-backed historical SVGs are bundled and attached to matching stages; unavailable stages remain visible as content gaps.
- Home shows the agreed primary action: Resume current lesson when one exists, otherwise New Symbol / Next Symbol for the next featured Shared Character.
- Primary shell uses Home, Symbol / New Symbol, History, Browse, and More / Settings.
- Browse includes Search, Saved, Favorites, Review later, and collections.
- More / Settings includes Languages, Account, Settings, About / Method, reset, and utility pages.
- Lesson supports the six agreed steps: Origin, Character, Modern Forms, Structure, Usage, and Summary.
- Lesson controls work on-device: Continue, Restart Lesson, Mark as Learned, and Next Symbol after completion.
- Learned lessons are not accidentally converted back to in-progress when reopened.
- Focus tracks are multi-select: Simplified Chinese, Traditional Chinese, Japanese, and Korean are all on by default; there is no separate All option.
- Modern Forms and Usage respect the selected focus tracks.
- Search supports character, English gloss, and readings with offline local results inside Browse.
- Browse stays shallow and curated, with status context rather than a generic raw list.
- Collections inside Browse include Your Collections, Review later, Favorites, and Explore Collections.
- More / Settings includes focus tracks, display preferences, offline/app information, About / Method, Account, Languages, and reset.
- Account, Saved/Archive, and Languages remain visible/deferred app concepts where appropriate, even when shallow.
- Visual treatment matches the agreed Shared Character product direction closely enough that the reference character-evolution target is recognizable in layout, hierarchy, and navigation, even while prototype assets remain marked as draft.

## Next Concrete Output

Deliver a corrected Prototype 2 pass that is product-faithful enough for another iPhone test round, starting with the horizontal image-backed symbol evolution experience.

- wait for the Figma-first symbol evolution design handoff, then pilot the schema and screen with 3-5 visual symbols before filling the reordered first 50
- include the component-introduction rule and separate History explainer in that design handoff
- keep Swift/Xcode compile execution deferred until macOS/Xcode or macOS CI is available
- keep production corpus expansion and publication status blocked until source-backed editorial content is available
- keep publication visual assets blocked until source-backed redraws or licensed/source-backed assets are available
- keep TestFlight/App Store release blocked until Apple signing/upload access is available

## V1 to VNext Tracking

V1 intentionally prioritizes Shared Character symbol-lineage lessons. `Structure` means character/component structure, not grammar or sentence structure. Traditional Chinese is included as a modern focus track with separate Taiwan/Hong Kong usage examples when that focus is selected or when all tracks are selected. Account pages, grammar comparison, rule-based common-denominator lessons, broader cross-language structure teaching, voice, Android, sync, and monetization remain deferred for depth of implementation, but agreed app concepts should not be erased or replaced.
