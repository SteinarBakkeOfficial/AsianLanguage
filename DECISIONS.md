# DECISIONS

## Product

- AsianLanguage is an English-first, offline-first iPhone experience about Shared Chinese-character heritage.
- Script Roots is the official product-facing name; AsianLanguage remains the internal development/project identifier.
- Shared Character is the core content object.
- The primary outcome is cross-language recognition, not fluency or grammar mastery.
- The primary experience is the Symbol Journey: recognizable origin → historical Evolution Stages → Today / Modern Endpoint.

## Navigation

- The five root areas are Home, Symbol, History, Browse, and More.
- Symbol is the canonical owner of the active Shared Character journey.
- Search, Saved, Learned, Review later, Favorites, and Collections belong in Browse.
- Languages, Settings, Account, About / Method, reset, and offline information belong in More.
- History owns generic script-period explanations and methodology.
- The old six Content Phases may remain as internal/editorial groupings but are not six equally prominent user-facing navigation buttons.
- Use shared root navigation state and one NavigationStack per root area where practical.

## Symbol Journey

- Evolution Stages are data-driven and may be omitted when uncertain or not useful.
- Canonical IDs are origin, oracleBone, bronze, seal, clerical, regular, and modernForms/today.
- Today / Modern Endpoint is one final journey destination containing selected focus-track content.
- Horizontal swipe and fixed/floating stage navigation are the intended interaction model; stage content may scroll vertically.
- Exact SymbolJourneyPosition, including stage ID, is persisted for resume.

## Content and assets

- Authored JSON under content/shared-characters is the source of truth; Resources/Corpus is generated.
- Historical Assets are source-backed or licensed, bundled, and separately provenance-tracked.
- Missing Historical Assets are explicit content gaps. Fabricated glyphs and modern-form historical fallbacks are prohibited.
- Each stage owns its canonical asset reference; visuals must not duplicate a stage map.
- Character structure is stage-aware. Components have stable identities and a first-meaningful stage.
- Modern focus tracks are four values: Simplified Chinese, Traditional Chinese, Japanese, and Korean. All are selected by default; there is no All enum case.
- Taiwan and Hong Kong readings may be represented independently.
- Publication status is draft, review, or published. Release content must pass the publication gate.

## User state

- User state is local, separate from the read-only corpus.
- Learned, Review later, and Favorites are independent relationships; ordinary navigation does not change any of them.
- Ordinary navigation through Learned content cannot downgrade it.
- Restart explicitly clears Learned and resets the position while preserving Favorites and Review later.
- Mark Learned is explicit, can occur from any journey position, preserves Review later/Favorite, and opens the next non-Learned record. The final record shows corpus completion.
- A learned Symbol opened through ordinary view entry uses a dedicated Revisit state with Revisit Journey, Quick Review, and View Usage actions; it does not restart or replay first-completion behavior.
- Quick Review is recognition-oriented, contains no XP/score/timer mechanics, uses only approved available content, and can always open the complete Symbol Journey.
- The final installed record presents a calm Completion state with Return Home and Revisit actions; it does not use confetti, XP, streaks, or scoring.
- Legacy LessonStep and single-focus state decode through migration without deleting state.

## Design

- The product personality is modern gallery + ancient artifact.
- Home is approximately 70% current/resumable/next Symbol Journey and 30% supporting context.
- Fire is the first approved design target; the pilot is Fire, Water, Mountain, Tree, and eventually sourced Horse.
- Figma plus approved exported references and behavioral specifications are the design source of truth.
- The written Design System v0.1 and Symbol Experience Implementation Handoff now define the implementation target for tokens, component relationships, stage behavior, accessibility, and visual hierarchy.
- Semantic design tokens live in `Sources/App/SharedUI/DesignSystem.swift`; raw visual values should not be added directly to views.
- Open editorial composition is the default for Symbol stages; grouped surfaces are reserved for denser Today, settings, and utility content.
- HistoricalMissingState is the only acceptable visual response to an unavailable approved asset; modern glyphs and generated ancient-looking substitutes are prohibited.
- LineagePreview is data-driven and may render only forms present in the approved corpus.
- The first visual slice uses a restrained current/next rail and vertically scrollable stage pages inside a horizontal stage pager.
- Today is a vertical endpoint with one section per selected modern language track; language identity is not communicated by arbitrary color.
- Structure is a vertical recap, not a second navigation rail; it may show only stage forms and component insights supported by the record.
- Usage is a vertical list of selected-track examples, prioritizing readable high-value examples over dictionary completeness.
- Summary/Recall uses recognition and reveal interactions without XP, lives, timers, scoring, or punitive feedback.
- Search remains Browse-owned, uses a native-feeling field with explicit Cancel, and presents text-first results without fabricated historical thumbnails.
- Settings retains native SwiftUI controls while adopting semantic app surfaces and typography.
- Home uses one dominant primary Symbol action and open lineage artwork; supporting review and collection modules remain subordinate grouped surfaces.
- Browse-owned Collections use CharacterTile for independent progress, Favorite, and Review Later indicators without stacked status pills.
- More and other utility roots retain native list/navigation behavior over themed historical treatment.
- Generic History detail uses open editorial composition with grouped context and deliberate missing-content states until representative corpus links are approved; More utility/source rows remain quiet and native.
- Historical stage availability is modeled separately from editorial confidence. Legacy certainty labels remain decodable, explicit unsupported or intentionally omitted stages are excluded from the primary journey, and an available stage must reference an approved asset.
- The human-editable Symbol source is organized as one folder per Symbol under `content/symbols/`; the existing flat corpus is a transitional export for the current app bundle.
- Each Symbol folder separates learner copy, research notes, review status, source/provenance records, educational reconstructions, historical evidence, and reusable component references.
- Educational reconstructions are classified separately from historical evidence. Fire's Origin visual is an authored educational reconstruction and must never be presented as an ancient artifact.
- Offline packaging copies only local app derivatives into the bundle asset area and emits a manifest declaring that runtime networking is not required.
- The initial preparation experiment covers the existing 11 draft records; generated records remain `needsReview` and require human approval.
- Onboarding uses the same semantic design system as the main shell and routes directly into the canonical Fire Symbol Journey after focus selection.
- Account V1 describes local device state only; it must not imply a real identity, profile, sync account, or cloud capability.
- Final visual QA requires macOS/Xcode simulator screenshots against the Fire reference before screen-level geometry is considered complete.

## Delivery

- Windows checks cover content and pure model contracts.
- macOS/Xcode or macOS CI is required for actual SwiftUI compilation and XCTest execution.
- Physical iPhone testing is reserved for touch, gestures, safe areas, rendering, and final device behavior.

## Implementation status record — 2026-08-31

- Foundation architecture, local state, content tooling, root shell, discovery foundations, and the first Symbol visual slice are implemented.
- Fire remains a draft corpus record. Its Origin and most historical stages lack approved renderable assets, so the current app intentionally exposes missing-content states.
- Completion, Today/Structure/Usage/Summary visual polish, History/utility-row migration, Revisit/Quick Review visual polish, and final historical asset provenance remain active work.
- Windows verification is green; native SwiftUI compilation and visual QA remain external macOS work.
