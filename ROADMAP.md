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
- Today now uses one page per selected language with corrected draft word/phrase/sentence examples per track; native-speaker review remains required before publication.
- Fire, Water, and Tree now have separate educational concept illustrations, and the allowlisted historical SVG intake preserves source/license provenance.
- The approved correction pass keeps the Symbol Journey rail persistent and visibly labeled, isolates onboarding from the compact Home preview, fixes Home's orphaned active-state fallback, uses the complete collection banner on Home, identifies Hong Kong Cantonese/Jyutping readings, and recreates the History overview natively from the approved reference content.
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
- Included in the current polish implementation: consolidate the two similar onboarding pages into one direct-entry page for the first-ranked runtime symbol using the existing first-page concept.
- Deferred outside the current polish implementation: expand Regular Script transition captions where they are too brief.
- The corrected target-language handoff has replaced the former neutral four-track starter examples; native-speaker review and publication approval remain deferred.
- Included in the current polish implementation: correct the existing History header crop/layout collision and remaining artwork/text fit issues after comparing the supplied screenshots; preserve the approved composition and existing History artwork.
- Deferred outside the current polish implementation: audit the complete Sources / Licenses page and resolve the broader About-versus-Sources content-architecture question. Apple Speech Synthesis technical attribution is included with the approved audio work.
- Browse and More are currently accepted and are out of scope for this fix pass.

The complete 2026-09-04 final-polish brief is preserved in [`docs/design/symbol-history-modern-final-polish-feedback.md`](docs/design/symbol-history-modern-final-polish-feedback.md). Its approved implementation boundary is recorded in [`docs/design/symbol-history-modern-final-polish-implementation-plan.md`](docs/design/symbol-history-modern-final-polish-implementation-plan.md).

The separate [Pronunciation Audio handoff](docs/architecture/pronunciation-audio-apple-avspeechsynthesizer-feedback.md) is approved for this pass: use an isolated iOS AVSpeechSynthesizer service, explicit draft speech text, and small speaker controls; no cloud TTS or bundled MP3 files. User and native-speaker verification is a later release-testing step, not an implementation gate.

#### Testing08_09 follow-up notes — next implementation

- Deferred: reduce the current exhibit transition modestly from `0.64s`; the new timing is much more visible than before but is slightly too slow.
- Deferred: move in-square material/process captions down by approximately 1 mm while keeping them inside the exhibit square and unclipped.
- Deferred: repair and verify full-row History navigation for all remaining script and modern-language entries. Oracle and Bronze are the currently known working rows.

#### Testing09_09 follow-up notes — next implementation only

- Deferred: repair History navigation so every historical stage row and all four modern-language branch rows open their own detail destination across the full row. Preserve the current History composition and use the smallest reliable hit-testing/navigation change.
- Deferred: verify History scrolling against the safe areas; content must not sit beneath the status/navigation area or the fixed root tab bar on supported simulator/device sizes.
- Deferred: correct the existing History detail and footer crop rectangles so bundled reference artwork does not expose clipped infographic labels or unrelated source-image text fragments.
- Deferred: replace the Sources / Licenses record-level `flatMap` presentation with one canonical, deduplicated entry per reference. Keep per-character provenance IDs internally, but show the ZDIC historical-image source once and avoid repeated font/research/origin entries. Preserve the Apple Speech Synthesis attribution.
- Deferred: remove source links and source-attribution content from About / Method. Keep About focused on the teaching method, Shared Character, offline behavior, and corpus scope; Sources / Licenses owns external references and licensing information.
- Deferred: correct Home's learned-count grammar so singular and plural forms read naturally (for example, `1 symbol learned`).
- Future feature, separate from surgical polish: add an offline Browse entry point for taking/importing a picture or scan of a present-day symbol, recognize it on-device, match it against the bundled dictionary/corpus, and open the existing Symbol route only for an exact match. Historical-glyph recognition, cloud processing, and automatic photo storage are out of scope unless separately approved.
- These notes were held for discussion and were approved for the current implementation on 2026-09-08. New History artwork and monetization remain excluded.

## ChatGPT final hand-off review — discussion record — 2026-09-08

The source documents are [`ScriptRoots_History_Codex_Handoff.md`](Reference%20Pictures/Chatgpt/ScriptRoots_History_Codex_Handoff.md) and [`Script Roots — Final Product Polish, Launch & Monetization Codex Handoff.md`](Reference%20Pictures/Chatgpt/Script%20Roots%20%E2%80%94%20Final%20Product%20Polish%2C%20Launch%20%26%20Monetization%20Codex%20Handoff.md). This section records analysis and candidates for our next discussion. It is not approval to implement the complete hand-off.

### What the hand-off says about History

- History should explain why writing traditions changed at the system level; Symbol should remain focused on what changed in one character. Avoid duplicating stage-material explanations in every Symbol caption.
- The historical model is Oracle Bone, Bronze, Small Seal, Clerical, Regular, then a Modern / A Living Tradition bridge into Traditional Chinese, Simplified Chinese, Japanese, and Korean. These are overlapping traditions and different relationships to a shared inheritance, not a simple primitive-to-advanced ladder or four equal splits.
- The five ancient landing cards should use the supplied museum copy and careful framing: Oracle Bone as the earliest large surviving body of mature Chinese writing; Bronze as beginning before the principal Zhou period; Small Seal as Qin standardization of inherited forms; Clerical as a gradual Qin–Han transformation driven partly by practical writing; and Regular as an evolution over centuries that matured by Tang and remains foundational.
- The landing introduction should use the supplied concise explanation of three thousand years of change, new tools, institutions, and communities, followed by the five stages and a clearly clickable living-tradition bridge.
- The bridge and four modern articles should explain continuity, reform, language adaptation, readings, kana, shinjitai, Hanja, and Hangul distinctly. In particular, Traditional Chinese is not a dated divergence, Simplified Chinese has older roots as well as 20th-century standardization, Japanese did not diverge only after World War II, and Hangul must never be depicted as a graphical simplification of Hanja.
- The proposed deep-page sequence is: native eyebrow/title/era/date; large separate artwork; native intro and short text cards; a “Look closely” area with 2–4 verified examples; a representative-form note; and a next-article action. The supplied page titles and section copy are the editorial source to review before implementation.
- History examples may deep-link to the existing Symbol route only when the displayed historical form maps to a verified corpus record and stage. Korean examples use a separate Hanja-reading presentation without a morph arrow.
- Body copy must remain native UI text for Dynamic Type, localization, VoiceOver, and accessibility. Artwork must not contain paragraphs, labels, or unverified glyphs. A compact per-article “Sources & historical notes” surface is preferable to repeating the global source inventory.

### History feasibility and boundary found in the repository

- The current runtime has the five landing rows and four modern branch rows, but the detail views remain minimal and explicitly unfinished. The modern bridge is not yet a full article, and the current page still uses crops from the single `History_V1.png` infographic.
- The requested full article set is larger than a crop or hit-testing fix. It needs an agreed reusable article/content model, article data, verified corpus-example mapping, and nine complete destinations while preserving the existing root shell.
- The supplied artwork direction calls for new, clean, text-free hero/card art. No such complete History asset set was found in the current bundle. Existing `History_V1.png` contains infographic text and is already the source of the reported crop fragments. New artwork, asset licensing, or generated imagery therefore requires a separate decision; it must not be fabricated or silently substituted.
- Decision needed: whether the next implementation is a text-first History completion using the existing source-backed artwork where safe, or a larger History release slice that also waits for approved replacement artwork. The current surgical boundary supports the former more readily.

### Normal-page and release candidates from the second hand-off

These are candidates to rank together, not an instruction to implement every item:

- Account / More: rename the user-facing destination to “Your Progress” or “Progress & Data”; remove “Testing Progress,” “V1,” “Installed corpus,” “local-only learner profile,” and “Account features deferred”; show learned/review/favorite counts, offline library count, and local-device data scope in ordinary user language. Do not imply sign-in or cloud sync.
- Sources / About: keep the readable Sources page small and human-facing; show each actual research/font/art/audio source once; retain Apple Speech Synthesis attribution; move exhaustive URLs, licenses, notices, and rights details to a separate legal surface if needed. Remove source links and attribution inventory from About / Method, which should explain the teaching method, Shared Character model, representative forms, materials, and offline scope.
- Data correctness: current analysis found approximately 968 flattened source entries, 258 distinct source IDs, and repeated ZDIC/font/research references across the 126 runtime records. The display should deduplicate by canonical source identity while retaining per-character provenance in the data layer. Rights review for copied ZDIC assets remains a release gate for commercial distribution.
- Copy QA: fix Home’s `1 symbols learned` grammar and audit singular/plural, stage names, “Symbol” versus “Character,” capitalization, dates, truncation, long readings, and unfinished/internal wording. Do not blindly replace established terminology.
- Search: the current short placeholder and explicit Cancel callback are already present. Verify that Cancel is shown/behaves as an active-search control, dismisses focus appropriately, and does not remain permanently visible when the field is unfocused. Keep character, meaning, and four-track reading search without raw metadata.
- Browse/Home: the hand-off suggests latest-stage resume labels (`Start at Origin`, `Continue at Bronze`, `Learned`) and restrained collection progress lines. Existing local progress and Quick Review/resume work should be checked before changing anything; do not redesign accepted collection artwork or add dashboard widgets.
- Completion/accessibility: preserve the restrained Learned state and Next Symbol flow; verify Dynamic Type, VoiceOver labels/order, 44-point targets, contrast, Reduce Motion, image descriptions, audio labels, selected-state semantics, and the special visual case for 一. These require macOS/Xcode or device verification for claims about visual fidelity.
- Offline/release: core learning must continue if external links, ads, analytics, or StoreKit are unavailable. Testers should never be blocked by an unavailable ad or purchase service. The current app has no identified ads, StoreKit, or analytics implementation, so adding them is a separate dependency/credential/privacy-scope decision rather than a surgical cleanup.
- Monetization: the hand-off prefers free core learning with no banners and, if monetization launches immediately, a one-time Remove Ads / Script Roots Pass with restore. Ads may occur only at calm completion boundaries, never mid-Symbol, History, Search, Settings, legal, or first meaningful session. This is not approved by the notes and should not be introduced without an explicit product decision and external-service readiness.
- Optional growth/retention: Share Symbol, a one-time interaction hint, Quick Review expansion, review reminders, feedback, analytics, haptics, dark-mode polish, performance tuning, and App Store screenshot/review-prompt work are candidates. They are not prerequisites for a focused V1 test build unless separately agreed.
- Explicit no-add boundary: no XP, streaks, lives, coins, gems, leaderboards, forced sign-in, subscription paywall, locked History, banner or mid-journey ads, fake premium gates, aggressive prompts, mascots, or unrelated redesign.

### Proposed discussion order for the remaining V1 work

1. Agree whether the target is a free V1 test build or a monetized launch build. Treat ads, StoreKit, analytics, privacy copy, and legal surfaces as a separate scope if monetization is selected.
2. Lock the History slice: all five stage destinations and four modern destinations, the supplied editorial copy/guardrails, the native article layout, verified example links, safe-area/navigation behavior, and the artwork decision.
3. Apply only the highest-confidence normal-page cleanup: Account language/presentation, About-versus-Sources separation, canonical Sources rendering, Home grammar, and any confirmed Search focus behavior.
4. Run repository checks, then perform the required macOS/Xcode simulator and physical-device pass for navigation, safe areas, Dynamic Type, VoiceOver, Reduce Motion, fonts, artwork crops, and offline behavior. Windows checks alone cannot verify SwiftUI visual fidelity.
5. Reassess P1/P2 items after tester feedback. Keep picture/scan recognition as a later Browse feature: on-device recognition of present-day symbols, exact matching to the bundled dictionary, existing Symbol routing, explicit no-match, no historical OCR/cloud upload/photo storage without a new decision.

### Release-readiness facts to keep visible

- The 126-record corpus, language content, historical interpretation, copied ZDIC asset reuse, and native-speaker language review still have outstanding review/rights work documented elsewhere in this roadmap. “Ready for user testing” and “cleared for commercial release” are different gates.
- The approved patch remains surgical and reversible. It changes focused SwiftUI presentation/navigation and local polish only; it does not add History artwork, monetization, analytics, or content imports.

### Approved final polish implementation — 2026-09-08

- Implemented the agreed History article/content pass with all five stage destinations, the modern bridge, four modern-language destinations, native editorial copy, corpus-backed example links, next-page navigation, and full-row navigation hit areas.
- Implemented the agreed normal-page cleanup: production-language Your Progress presentation, Settings cleanup, About / Method separation, canonical Sources & Licenses presentation, legal-notice surface, Home pluralization/progress treatment, Browse resume labels, and focused Search Cancel behavior.
- Implemented the approved calm polish: five-prompt Quick Review when data supports it, one-time journey hint, restrained completion haptic, text-first system Share Symbol, user-initiated review reminders, feedback sharing, Reduce Motion handling, and accessibility labels/targets in the touched surfaces.
- Explicitly excluded: new History artwork, ads, StoreKit, monetization, analytics, picture/scan recognition, cloud sync, and gamification.
- The current bundle still uses the existing `History_V1.png` artwork and ZDIC-backed assets; artwork replacement and commercial rights clearance remain separate gates.

### Post-testing disposition record — 2026-09-08

This record preserves the remaining handoff suggestions without approving another implementation before the next testing round.

- Permanently out of scope: XP, points, streaks, lives, coins, gems, badges, leaderboards, competitive ranking, and other game mechanics. Script Roots is a museum app; retention must remain calm, educational, and recognition-oriented.
- Revisit after next testing: new History artwork and illustrated 2×2 modern-language cards, a compact article-specific History source surface, more complete legal/license/source presentation, a visual Share Symbol card, a fuller Quick Review session, richer feedback submission, notification-flow refinement, broader haptics, dark-mode polish, performance tuning, and a complete accessibility/offline/device QA pass.
- Revisit after next testing: full copy and editorial review across readings, translations, dates, terminology, truncation, native-speaker approval, historical interpretation, and source-rights clearance.
- Separate future feature: offline present-day picture/scan recognition with exact matching into the existing dictionary/Symbol route and an explicit no-match state. Historical-glyph recognition, cloud processing, image upload, and automatic photo storage remain out of scope unless separately approved.
- Launch collateral not yet produced: App Store screenshots, listing copy, positioning, and a later review-prompt decision.
- No item in this section is an approval to change the current V1 patch. Reassess all candidates together after tester feedback.

### Testing10_09 findings — discussion record — 2026-09-09

These observations come from testing the latest commit. They are recorded for the next planning discussion and do not authorize implementation yet.

- Symbol Origin copy is wrong at the content level: the repeated disclaimer about beginning with the real-world idea and not treating the illustration as a historical glyph appears throughout the corpus. That clarification belongs in the appropriate global teaching/method context, not as repeated copy on every Origin illustration.
- Symbol transition copy is broadly generic and should be rewritten as character-specific editorial content. Remove stock phrases such as “easy to see,” “clearly separated,” “very visible,” and generic curve/stroke observations. When a form changes little or there is no useful observation, the transition should be shorter or have no explanatory copy rather than describing an obvious visual fact.
- History navigation is not functionally complete in testing despite the NavigationLink declarations: Regular and A Living Tradition did not open, and the four modern-language rows only opened from the trailing chevron area. Treat full-row hit testing as a real bug requiring device verification, not as completed based on static code inspection.
- History article content has valuable structure, especially Look closely corpus links and next-page links. Preserve the useful information and section structure; the problem is that some copy is placed directly on the background while other sections are placed in white boxes without a clear editorial or visual reason. The article presentation needs a focused visual-hierarchy revision, not an assumed reduction in content.
- History overview and article image crops remain visibly poor in testing. The existing normalized crop rectangles require screenshot-led correction; the current reference artwork must not be considered visually fixed merely because a crop view exists.
- Browse, Home, and More were positively received in this testing round and should not be redesigned while the agreed problem areas are corrected.
- Sources & Licenses is still conceptually wrong for the intended product. Canonical ID deduplication is not enough: the user-facing page should contain only meaningful material/history references, normally one link per source at most. Generated origin artwork, OpenAI generation attribution, and font implementation details should not appear as ordinary educational sources. Font and system-attribution obligations should be reviewed separately in the legal-notices layer where required.
- About Script Roots should become an app/about page: a short app summary plus developer, version/build, and release information. The current teaching-method essay does not match this intended purpose; method content and source/legal information need a separate decision.
- Review reminders were positively received. Current behavior is documented below in the implementation notes and remains a candidate for refinement only after more testing.
- Send Feedback was positively received. Current behavior is a local text composer that hands the user’s message to the iOS share sheet; it does not send or store feedback automatically.
- Reminder behavior audit: the current implementation requests notification permission only after the user taps the setting, then schedules one repeating local notification for 19:00 in the device’s local time. It has no immediate test notification, no notification delegate for foreground presentation, and no recovery UI when system notification permission is later disabled. These are the first points to verify before changing the feature.
- Feedback routing decision: during testing, the useful version should route directly to the developer through a configured email address or support destination rather than relying on a generic share sheet. The exact destination must be supplied and approved; do not hard-code a guessed address. Reassess whether to keep the feature for release after testing.
- Home interaction hint: the current “Swipe, or tap the timeline, to follow the character through time. Got it” message appears on Home even though Home only offers entry actions and does not contain the interactive Symbol timeline. Remove or rewrite this hint so it describes the actual Home action; the Symbol Journey may have its own context-specific guidance if needed.
- Symbol tab icon: the current SF Symbol `character` renders as an unattractive large “A”-like mark in the navbar. Replace it later with a clearer museum/Symbol icon while preserving the `Symbol` label and five-area navigation.
- Feedback decision from Testing10_09: keep the current generic iOS share-sheet implementation for now. Revisit direct developer email/support routing later, especially for testing builds, and decide separately whether Feedback remains in the release build.
- Preserve the successful History Look closely links, next-page links, and the positive Browse/Home/More changes while revising only the failed content, navigation, crop, Sources, and About areas.

### Approved Testing10_09 implementation — 2026-09-09

The preceding Testing10_09 section records the pre-approval discussion. The following surgical changes are now implemented in the working tree:

- Home's misleading Symbol-timeline hint is removed, and the Symbol tab uses a clearer book/character icon.
- History stage rows, the A Living Tradition card, and all four modern-language rows use full-row hit areas; decorative artwork does not intercept navigation taps.
- History article sections now share one open editorial presentation, while the useful Look closely and next-page links remain.
- History overview and modern-article crops are tightened to avoid infographic labels and unrelated source text fragments.
- Sources & Licenses now shows one consolidated ZDIC reference plus meaningful research/history sources only; generated-origin, font, and speech implementation metadata remain outside the readable source inventory.
- About Script Roots now presents app, developer, version/build, release-year, and offline-library information.
- Review reminders now reconcile permission and pending-request state, recover after returning from Settings, and can present while the app is foregrounded.
- Regular's handout copy and transition to the dedicated A Living Tradition calligraphy page are implemented. The page includes the supplied prose, style descriptions, Four Treasures, Look closely, and modern-traditions CTA.
- The supplied History artwork placement board is bundled and cropped into the five ancient heroes, five-style calligraphy, four modern-language cards, and Four Treasures. Board captions remain excluded from runtime crops; all app labels stay native SwiftUI text. Symbol copy, Feedback behavior, monetization, and picture/scan recognition remain unchanged/deferred.

Windows layout, contract, corpus, and release-readiness checks pass. SwiftUI compilation, simulator screenshots, and device interaction still require macOS/Xcode verification.

## V1 to VNext Carryover Register

- Grammar and rule lessons
- Android pronunciation renderer: a future Android port replaces the iOS speech renderer with Android TextToSpeech while retaining the same verified platform-independent pronunciation data.
- Tracing/handwriting
- Android
- Sync and deep account systems
- Ads/monetization
- User-created collection folders
- richer historical animation
- Deeper onboarding language orientation covering all four target writing traditions; this applies only to the onboarding symbol experience.
- History artwork and richer visual treatment: the textual A Living Tradition page is implemented, while verified five-style calligraphy artwork and broader History visual redesign remain deferred.
- Future Home cleanup: replace the standalone “X symbols learned” footer with a deliberate destination such as History or the Learned library; do not change the current footer during this pass.
- Future language-orientation content: broader language-family/context explanation beyond the approved modern-language branches and their intentionally unfinished detail destinations remains deferred.

## Future considerations — undecided

- Consider future V2/V3 expansion packs beyond the current 126-character V1 design target, then evaluate optional online symbol/content packs so users can download additional symbols without requiring a full app update.
- Evaluate the trade-offs among initial app size, offline availability, pack versioning, storage management, content provenance, and whether future symbol additions should remain app-update based or become downloadable packs.

This is exploratory only and is not currently a product requirement or implementation decision.

## Launch targets

The first credible V1 target is about 100 high-quality Shared Characters. The longer-term product vision is 500–1000, after the pilot proves the content and design system.
