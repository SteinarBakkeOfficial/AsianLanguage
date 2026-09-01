# CURRENT STEP

## Goal

Implement the AppShell_VisualReference_v1 fidelity pass: clay-and-white shell, clean Today language pages, Browse collection separation, and source-backed pilot artwork while preserving the verified Shared Character, navigation, and local-state contracts.

## Branding update

- The product-facing name is now Script Roots.
- AsianLanguage remains the internal project/module/bundle identifier.
- The product icon is `Reference Pictures/Chatgpt/Logo/Logo_V1.png`, copied into the bundled `Resources/Assets.xcassets/AppIcon.appiconset/` catalog and wired as `AppIcon` for Debug and Release.

## Current product truth

- The core object is Shared Character.
- The hero experience is one continuous Symbol Journey through time into Today and word-level modern context.
- Root areas are Home, Symbol, History, Browse, and More.
- Search and Collections belong in Browse; Languages, Settings, Account, About / Method, and reset belong in More.
- Focus tracks are four multi-select values, all enabled by default.
- Historical Assets are source-backed/licensed or explicit Missing Historical Assets; fabricated glyphs are prohibited.
- Current corpus records are draft prototype fixtures.
- Today remains one horizontal page per selected language for now; a future scrollable all-language page is intentionally deferred.

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

## Completed visual implementation slice

- Add semantic light/dark AppColors, AppTypography, AppSpacing, AppRadius, and AppMotion tokens.
- Add reusable PrimaryActionButton, SecondaryActionButton, IconActionButton, GroupedSurface, ArtifactField, HistoricalMissingState, LineagePreview, CharacterTile, AppSearchField, and SettingsRow foundations.
- Wire the shared design foundation into the Xcode project and preserve transitional ShellStyle aliases for screens not yet migrated.
- Replace the generic Evolution stage cards with open exhibit-style pages, horizontal swipe paging, and a content-driven current/next stage rail.
- Keep Today as the final journey endpoint while routing it through the canonical host section.
- Add the Symbol About sheet for character context, sources, and a quiet learning action.
- Ensure direct view/stage entry does not create progress; meaningful start/resume and in-journey navigation still persist exact position.
- Replace Home's Fire-shaped hardcoded lineage preview with a reusable data-driven LineagePreview that only shows actual available corpus forms.
- Rework Today into one horizontal exhibit page per selected language track, without arbitrary language colors; keep every page in the same swipeable historical spine.
- Add a dedicated learned Revisit entry that does not restart or downgrade progress.
- Add a lightweight Quick Review recognition state that uses only an available corpus form and always links back to the full journey.
- Complete the horizontal Symbol Journey with an automatic learned transition and Next Symbol action.
- Add the final-record Completion state with Return Home and Revisit actions.
- Apply CharacterTile to Browse-owned in-progress and status collections.
- Move structure and source detail behind the character `…` menu so they do not interrupt the museum flow.
- Rework Usage into one selected-track word-context panel per Today page with readable readings and translations; do not teach unexplained sentences.
- Remove the Summary/Recall page from the primary Symbol Journey.
- Migrate Search to AppSearchField with explicit Cancel behavior and text-first result rows.
- Apply semantic design tokens to the Settings background, tint, and supporting copy while retaining native controls.
- Migrate Home to shared page/title/action hierarchy while keeping the Symbol Journey as the dominant content.
- Migrate Collections and More utility surfaces to semantic backgrounds, native navigation, and CharacterTile records.
- Migrate onboarding to the shared editorial hierarchy, primary actions, and semantic surfaces; enter the Fire exhibit before optional language controls.
- Migrate Languages, Account, and About/Method; remove the fake profile identity card and keep local-only account scope explicit.
- Migrate History detail to open editorial context with deliberate missing-content treatment; migrate More utility/source rows to quiet semantic presentation while retaining native navigation.
- Align historical availability and confidence semantics across the runtime model, draft tooling, validator, and contract tests; preserve backwards compatibility for existing draft records.
- Implement per-Symbol editorial folders, reusable component references, separated educational/historical asset provenance, review reports, and deterministic offline packaging for the 11-record pilot.
- Add Fire's educational Origin reconstruction as a clearly classified draft asset; preserve missing historical stages where no approved evidence exists.
- Align the light shell to the approved reference palette: `#F7F3EE` paper, `#EFE9E1` clay, `#1C1C1C` ink, `#686868` secondary text, `#C23A2B` cinnabar, and `#2E7D6E` jade.
- Make Light the default appearance and retain Dark as the single alternative; legacy System preference values migrate to Light.
- Add reviewed source-backed SVG intake for Fire, Water, and Tree where the allowlisted Commons files exist, while preserving explicit unavailable stages.
- Add separate internal-authored Fire, Water, and Tree educational concept illustrations with provenance; these are never used as historical evidence.
- Keep `Your Library` only on Browse and render collection artwork/cards separately in Browse and Collections.
- Replace pilot Today seed copy with language-appropriate readings, romanization, kana/Hangul context, word examples, and translations; retain one page per selected language.

## Verification status

- `Tools/Run-Checks.ps1`: passing all available checks.
- `git diff --check`: passing.
- SwiftUI compilation, XCTest execution, simulator screenshots, and device checks: not available in this Windows workspace; require macOS/Xcode.

## Design reference boundary

Use `Reference Pictures/Chatgpt/AsianLanguage_AppShell_VisualReference_v1.png` as the primary visual reference. Do not introduce unrelated colors, typography, or decorative treatment; the clay-and-white shell and restrained editorial cards are the current target.

## Current next design deliverable

Run macOS/Xcode validation and visual comparison for Home, Browse, Collections, Today, onboarding, Quick Review, and the Fire Symbol Journey sequence; then complete native-speaker and specialist review of the pilot copy/assets.

The design freeze is active: neutral structural surfaces may be exercised, but approved Fire references determine final screen composition.

## Blockers

- SwiftUI/Xcode compilation and XCTest execution require macOS/Xcode or macOS CI.
- Historical stage interpretation, regional readings, and specialist/native-speaker editorial review remain incomplete.
- Horse must not be added until sourced.

## Pilot findings

- The folder workflow successfully prepared and packaged all 11 existing draft records.
- Fire, Water, and Tree have local educational concept illustrations; Fire Oracle Bone/Bronze/Seal, Water Oracle/Bronze/Seal, and Tree Oracle have source-backed SVGs, while stages without approved files remain explicit unavailable-asset states.
- The current package contains source-backed local raster glyphs for the 11-record pilot, plus explicit missing-stage states where no approved file was acquired; iOS rendering and screenshot comparison require macOS/Xcode verification.
- The generated review report makes each Symbol folder and its remaining editorial actions directly locatable.
- Onboarding now prioritizes the Fire museum journey; all four language tracks remain enabled by default and may later be adjusted in More → Languages, including turning all tracks off.

## Repository/layout note

Strict layout verification reports the existing top-level `MAC_TESTING.md` as outside the canonical iOS layout contract. It has not been moved or deleted; resolving that layout issue requires an explicit repository-structure decision.

## V1 to VNext tracking

The current pass stays within V1: it improves the pilot's visual fidelity, source-backed asset handling, and language copy. Scrollable all-language Today, richer historical animation, audio, tracing, and larger corpus expansion remain intentional VNext carryover.
