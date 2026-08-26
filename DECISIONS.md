# DECISIONS

## Product

- AsianLanguage is an English-first, offline-first iPhone experience about Shared Chinese-character heritage.
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
- Legacy LessonStep and single-focus state decode through migration without deleting state.

## Design

- The product personality is modern gallery + ancient artifact.
- Home is approximately 70% current/resumable/next Symbol Journey and 30% supporting context.
- Fire is the first approved design target; the pilot is Fire, Water, Mountain, Tree, and eventually sourced Horse.
- Figma plus approved exported references and behavioral specifications are the design source of truth.
- Final visual tokens and screen geometry are deferred until the Fire handoff.

## Delivery

- Windows checks cover content and pure model contracts.
- macOS/Xcode or macOS CI is required for actual SwiftUI compilation and XCTest execution.
- Physical iPhone testing is reserved for touch, gestures, safe areas, rendering, and final device behavior.
