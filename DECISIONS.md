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
- Today / Modern Endpoint is the final room in the same continuous Symbol Journey, containing selected focus-track forms and word-level context.
- Historical stages and Today are horizontally swiped exhibit pages; page-local overflow may scroll, but there is no single vertical journey scroll or Continue gate between historical concepts.
- Exact SymbolJourneyPosition, including stage ID, is persisted for resume.

## Content and assets

- Authored JSON under content/shared-characters is the source of truth; Resources/Corpus is generated.
- Historical Assets are source-backed or licensed, bundled, and separately provenance-tracked.
- Missing Historical Assets are explicit content gaps. Fabricated glyphs and modern-form historical fallbacks are prohibited.
- Each stage owns its canonical asset reference; visuals must not duplicate a stage map.
- Character structure is stage-aware. Components have stable identities and a first-meaningful stage.
- Modern focus tracks are four values: Simplified Chinese, Traditional Chinese, Japanese, and Korean. All are selected by default; users may turn off any or all tracks; there is no All enum case.
- Taiwan and Hong Kong readings may be represented independently.
- Publication status is draft, review, or published. Release content must pass the publication gate.

## User state

- User state is local, separate from the read-only corpus.
- Learned, Review later, and Favorites are independent relationships; ordinary navigation does not change any of them.
- Ordinary navigation through Learned content cannot downgrade it.
- Restart explicitly clears Learned and resets the position while preserving Favorites and Review later.
- Completing Today is an explicit Next Symbol / Complete Symbol action that marks the current Symbol learned, preserves Review later/Favorite, and opens the next non-Learned record. The final record shows corpus completion; the character menu remains available for independent library actions.
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
- The first visual slice uses a restrained current/next rail and horizontally swiped stage pages.
- The active AppShell typography reference names Playfair Display for editorial/display headings and Inter for interface/body text. CNS11643 Kai is bundled and registered for the Regular Script endpoint, and locale-specific Source Han Serif Regular faces are bundled and registered for Simplified Chinese, Traditional Chinese Taiwan, Japanese, and Korean modern forms. Source Han Sans and extra weights are deferred.
- Today is the final room in the continuous journey, with one section per selected modern language track and word-level context only; when no tracks are selected it presents an explicit museum-only state; language identity is not communicated by arbitrary color.
- Structure is a vertical recap, not a second navigation rail; it may show only stage forms and component insights supported by the record.
- Usage context is a vertical list of selected-track character words, prioritizing the written character, reading, and meaning over unexplained sentences.
- There is no Summary/Recall screen in the primary museum flow; character recognition, structure, and source detail live behind the `…` character menu.
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
- The approved AppShell reference uses `#F7F3EE` paper, `#EFE9E1` clay, `#1C1C1C` ink, `#686868` secondary text, `#C23A2B` cinnabar, and `#2E7D6E` jade. Light is the default appearance; Dark is the only alternate, and legacy System values decode to Light.
- Today remains one horizontal page per selected language until a later content decision approves a scrollable all-language page. Each page must show the correct writing, pronunciation/reading, romanization, and a reviewed word example.
- Browse owns the Your Library status lists. Collections owns editorial sets only; status lists must not be duplicated on the Collections index.
- Editorial collections use explicit bundled horizontal cover panels. Their artwork is separate from symbol-origin and historical assets, and collection covers must not be derived from whichever symbol happens to appear first in a collection.
- Educational concept illustrations and historical glyph evidence are separate asset classes. Concept art must carry internal-authored provenance and must never fill a missing historical stage.
- The pilot's source-backed historical SVG allowlist is Fire, Water, and Tree; missing named files remain explicit unavailable states until an approved source is acquired.
- The initial preparation experiment covers the existing 11 draft records; generated records remain `needsReview` and require human approval.
- Onboarding uses the same semantic design system as the main shell and routes directly into the canonical Fire Symbol Journey before optional language preferences; More → Languages owns those preferences.
- Account V1 describes local device state only; it must not imply a real identity, profile, sync account, or cloud capability.
- Final visual QA requires macOS/Xcode simulator screenshots against the Fire reference before screen-level geometry is considered complete.

### Binding V1 museum-content rule — 2026-09-03

### Primary museum journey — 2026-09-03

- The primary historical learner-facing journey has five stops: `Origin / Illustration` → `Oracle Bone / 甲骨文` → `Bronze / 金文` → `Small Seal / 小篆` → `Clerical / 隶书`.
- `Origin / Illustration` is an educational reconstruction of the object, action, or meaningful scene. It is not a historical glyph and must remain separately labeled.
- Regular Script and present-day Chinese, Japanese Kanji, Korean Hanja, and other modern-language usage are handled in a separate Modern/Regular overview and design system. They are not counted as historical-stage coverage or as a requirement for the source-backed museum chain.
- EVOBC’s six research labels remain valuable for evidence collection, but they are not the six learner-facing stops. Spring and Autumn (`SAC`) and Warring States (`WSC`) are optional intermediate evidence/detail within the Bronze-to-Seal transition, not required primary cards.

- The Symbol Journey must feel like a museum visit: the learner sees the real object, action, or meaningful visual scene, then the earliest documented glyph, successive script stages, and finally the modern forms used today.
- A historical reference is not considered acquired merely because a dataset index, filename, or metadata record exists. Before a symbol is called source-backed for the museum, the actual reviewable historical image files and their provenance must be present or the stage must be explicitly marked Missing Historical Assets.
- V1 candidates are selected from the shared 808-character universe by applying the four-language eligibility gate first, then prioritizing simple pictographs and visually transparent indicators/compounds. Preference goes to forms that became reusable meaningful components and can be taught before the compounds that depend on them.
- A candidate’s visual story must explain its meaning: the object or scene itself, or multiple meaning-bearing components that form a coherent scene. Characters whose important components are primarily phonetic are not preferred for V1 and require explicit justification.
- The illustration must be a stylized, readable, comic/editorial museum illustration—not a generic realistic rendering. It should show the referent in a way that makes comparison with the earliest glyph intelligible, while never pretending to be the historical glyph.
- Illustration style must be agreed against a small sample before generating a full corpus batch. No future bulk generation is authorized until the style sample is approved.
- Historical completeness is the first V1 selection gate: begin with every shared identity for which Oracle Bone evidence can be acquired and verified across multiple sources. Do not reduce the pool for simplicity or visual optimization until the verified full-history pool exceeds 200; use non-full-history candidates only after that pool has been exhausted.
- “Recorded” and “proof acquired” are separate metrics. Dataset indexes may define a research pool, but only locally reviewable, provenance-tracked historical images count toward the verified full-history pool.

### ZDIC-first historical glyph intake — 2026-09-03

- For the current V1 design/content asset pass, use the 126-character complete-evolution manifest in `content/research/zdic-v1-complete-manifest.json`. The 148-character intake and broader 306-character six-stage pool remain research and replacement references, not the immediate V1 runtime corpus.
- ZDIC is the primary visual reference for the four learner-facing historical stages: Oracle Bone, Bronze, Small Seal, and Clerical.
- Select the first available ZDIC glyph image by default for each stage. Advance to the next candidate only when retrieval fails or the file is empty; do not manually review every ZDIC variant as part of intake.
- Preserve each original source SVG, create a consistent transparent museum-canvas derivative without changing the glyph geometry, and record the ZDIC page URL, image URL, stage, and local paths.
- The 2026-09-03 research intake processed all 148 V1 reference characters and selected 568 of 592 possible stage images. Missing stage slots remain explicit and are not filled from EVOBC, generated artwork, or modern fonts.
- Copied ZDIC images remain research-only until reuse permission is confirmed. Commercial publication requires permission or cleared/public-domain replacements; attribution alone is not treated as sufficient.
- EVOBC remains a fallback/research source because its published CC BY-NC-SA 4.0 license does not permit commercial use. Regular Script remains generated from the approved Kai font rather than copied from ZDIC.
- The 126 V1 historical packages are local research assets only. They are not “in the app” until copied into the approved runtime asset path, wired to reviewed corpus records, validated on macOS, and cleared for redistribution.
- Modern forms are a parallel Used Today layer. CNS11643 Kai and Adobe Source Han Serif are bundled source choices, and the app explicitly selects the appropriate locale face rather than relying on a universal Han fallback.

### V1 runtime implementation lock — 2026-09-03

- The runtime V1 corpus is exactly the 126-character complete-evolution manifest. The incomplete Fire pilot remains repository reference content and is not loaded by `SeedCorpusManifest`.
- Every runtime V1 record has a local origin illustration, selected/normalized ZDIC Oracle Bone, Bronze, Small Seal, and Clerical assets, and a Regular Script endpoint rendered from CNS11643 Kai.
- The four Used Today lanes render through the locale-specific Source Han Serif JP/KR/SC/TC files. Japanese and Korean form/readings remain distinct data lanes rather than universal Han fallback.
- Browse is search-first. It owns learner libraries, one All Symbols destination, and editorial collections; All Symbols is a separate searchable library screen.
- The History tab recreates the supplied `History_V1.png` overview natively for this release. Its five timeline stages, materials, explanations, and living-tradition footer are implemented without rendering the reference screenshot; the previous detailed period implementation remains retained for a later release.
- Origin artwork remains educational reconstruction; ZDIC remains a bundled reference asset with reuse permission unresolved. Records and assets are not release-cleared merely because they are local.

### Per-stage museum transition captions — 2026-09-03

- Museum explanatory text belongs to the destination stage as `transitionNote`; it describes the visible change from the previous available exhibit.
- The first available stage compares against the Origin Illustration. Later stages compare only against their immediately preceding available stage. Missing stages are never invented.
- The 126-record V1 package contains 630 concise transition captions. The source package is `content/research/v1-symbols/transition-notes-v1.json`; 78 conservative origin captions are flagged for visual/editorial review.
- Captions do not name the stage transition or repeat the modern character. They use short, concrete observations: Origin → Oracle connects the illustrated subject to the first glyph; later captions compare only neighboring forms.
- The app prioritizes `transitionNote` while retaining `changeNoteFromPrevious` for legacy records and compatibility.

### Fire onboarding reference restored — 2026-09-03

- The original Fire introduction remains the first-launch introduction, including its local origin imagery and Fire-specific copy.
- Fire is loaded directly from its repository reference record for onboarding; it is not added to `SeedCorpusManifest` and does not change the 126-record V1 learning corpus.
- The runtime importer normalizes research formation labels into the canonical `SymbolFormationType` values required by Swift decoding.

### Browse and museum rail clarification — 2026-09-03

- Browse shows its search field first, followed by Learned, Favorites, Review Later, one All Symbols library entry, and editorial Collections.
- All Symbols is a separate pushed page with the same visual treatment and its own search field; this does not add a sixth root navigation area.
- The Origin-to-Today rail uses a visibly different warm surface from the Symbol page, labels each available stage for persistent orientation, and preserves compact circles/connectors for non-endpoint stages. Regular Script has no decorative circle or connector, and no next-stage cue is added.

### Future language-orientation content — 2026-09-03

- The onboarding Symbol experience will eventually provide a deeper introduction to all four target language traditions: Simplified Chinese, Traditional Chinese, Japanese, and Korean. This is onboarding-symbol content only and does not change the main V1 Symbol Journey.
- The future History overview will place a language-development section beneath the main historical timeline, using four illustrated cards in a 2×2 layout. Each card will explain the language’s separate development and present-day writing context.
- The language cards may be tappable from the overview, but their detailed destination pages are deliberately deferred. The future copy and artwork must be source-backed and must distinguish Japanese Kanji, Korean Hanja/Hangul, and regional Chinese forms rather than flattening them into one generic CJK story.
- Sound effects, reviewed usage examples, native-speaker review, Home Library surfacing, and the final museum-complete decision remain on hold.

## Delivery

- Windows checks cover content and pure model contracts.
- macOS/Xcode or macOS CI is required for actual SwiftUI compilation and XCTest execution.
- Physical iPhone testing is reserved for touch, gestures, safe areas, rendering, and final device behavior.

## Implementation status record — 2026-09-02

- Foundation architecture, local state, content tooling, root shell, discovery foundations, and the first Symbol visual slice are implemented.
- Fire, Water, and Tree remain draft corpus records. Their acquired historical SVGs and educational concept illustrations are locally packaged with provenance, while unresolved stages intentionally expose missing-content states.
- Completion, Today/Structure/Usage/Summary visual polish, History/utility-row migration, Revisit/Quick Review visual polish, and final historical asset provenance remain active work.
- Windows verification is green; native SwiftUI compilation and visual QA remain external macOS work.
