# DECISIONS

## Product Definition

- The app is an English-first `guided educational reference`.
- The subject is `shared Chinese-character heritage across Mandarin, Traditional Chinese usage communities, Japanese, and Korean`.
- V1 focuses only on `shared characters and their modern usage`.
- Grammar comparison is out of scope for V1.
- Rule-based common-denominator lessons are out of scope for V1.
- `Structure` in V1 means character/component structure, not grammar or sentence structure.

## Platform and Delivery

- V1 is iPhone first.
- V1 should be built in `SwiftUI`.
- Android is a later expansion, not a launch target.
- V1 supports both light mode and dark mode.

## Lesson Model

- The user-facing content object is `Shared Character`.
- Each lesson is centered on one underlying character record.
- Every V1 lesson requires Mandarin, Traditional Chinese, Japanese, and Korean coverage.
- Traditional Chinese is a modern written-form focus track, not the historical ancestor of Kanji or Hanja.
- Traditional Chinese focus requires separate Taiwan/Hong Kong usage examples when selected, and those examples are also shown when the user selects all focus tracks.
- The primary V1 learning outcome is `cross-language recognition`.
- The app uses an `evolution framework`:
  - historical origin anchor
  - optional intermediate script stages
  - characterized or regular-script form
  - modern focus-track forms
- The canonical history spine is Oracle Bone, Bronze, Seal, Clerical, Regular, then modern focus-track forms.
- V1 does not require every lesson to show every historical script stage.
- Missing, disputed, or pedagogically noisy stages should be omitted or summarized with explicit certainty notes.

## Lesson Flow

- Guided flow has six labeled steps:
  1. `Origin`
  2. `Character`
  3. `Modern Forms`
  4. `Structure`
  5. `Usage`
  6. `Summary`
- `Origin` and `Character` share a continuous visual area.
- `Modern Forms` transitions into a comparison-oriented layout.
- `Usage` is organized by core shared meaning first, then focus-track examples.
- `Summary` includes an editorially written recognition takeaway.

## Editorial Rules

- V1 lessons must have one teachable core shared meaning across all required focus tracks.
- Pronunciation and exact modern form may differ.
- Historical evolution can be limited-certainty when uncertainty is explicit.
- Intermediate historical script stages are included only when they improve recognition or clarify the lineage.
- Displayed Origin, Oracle Bone, Bronze, Seal, Clerical, and Regular stages require dedicated image assets or explicit missing-asset placeholders; the modern regular character must not be reused as a false substitute for older stages.
- Every displayed historical stage after the first requires a short change note from the previous shown stage.
- Richer side-by-side stage comparison is optional and used only when the visual change is important or confusing.
- Historical sound information is included only when accurate enough to source and label responsibly.
- Historical sound information is not required for every stage and is not a publication blocker when unavailable or too uncertain.
- Character/component structure can be limited-certainty when uncertainty is explicit.
- Components should be shown at the stage where they first appear or become meaningful in the symbol evolution.
- One-component symbols still identify that single component; multi-component symbols explain each component with role, depiction, and source support.
- Unsupported mnemonic folklore must not be presented as fact.
- Phonetic resemblance is optional editorial enrichment, not a required lesson pillar.

## Publication Gate

A V1 lesson is publishable only if it has:

- one underlying character record
- one core shared meaning
- complete Mandarin, Traditional Chinese, Japanese, and Korean coverage
- separate Taiwan/Hong Kong usage examples for Traditional Chinese focus
- at least one historical origin anchor
- characterized or regular-script form
- modern focus-track forms
- stage-to-stage change notes for every displayed historical stage after the first
- required sections completed responsibly
- at least two examples per language
- at least one direct core-meaning example per language
- section-appropriate source support
- app-ready assets and metadata

## Search and Discovery

- Search, Browse, Saved/Favorites/Review later, and Collections are all in scope for V1.
- `Browse` is the primary discovery hub and includes Search, Saved, Favorites, Review later, and collections.
- Search supports character, English gloss, and language readings.
- Search uses exact and partial matching with practical normalization.
- Browse stays shallow and curated.
- Collections are grouped into:
  - `Your Collections`
  - `Explore Collections`
- `Review later` and `Favorites` are system/user-state-driven collections.
- Thematic and pedagogical collections are editorially curated.

## Progress and User State

- Core states:
  - `unseen`
  - `in progress`
  - `learned`
  - `review later`
  - `starred`
- `learned` and `review later` are mutually exclusive.
- `Favorites` is separate from retention state.
- `Resume` is reserved for in-progress lessons only.
- Learned lessons reopen from the beginning by default.
- In-progress lessons resume at the exact saved step.
- Step-jumping is allowed only through the tappable progress bar.

## Home and Navigation

- The target primary shell is `Home`, `Symbol` / `New Symbol`, `History`, `Browse`, and `More` / `Settings`.
- Names may still change during design, but the functional grouping is stable.
- `New Symbol` / `Next Symbol` is represented by the `Symbol` shell area and may also appear as the primary Home action.
- `History` is a primary shell area for generic script-period explanations.
- `More` / `Settings` contains Languages, Account, Settings, About / Method, reset, and other utility pages.
- Home prioritizes:
  - `Resume current lesson` when applicable
  - otherwise the `next featured Shared Character`
- Browse and More / Settings are secondary to the Home/Symbol learning flow.
- Home reflects the evolution framework rather than behaving like a generic catalog.
- `Why this now` may appear on the featured lesson card.

## Data and Offline Behavior

- Shared Character corpus is bundled with the app and read-only.
- User state is local-only and writable on-device.
- No sync or account system in V1.
- No remote content dependency for the core experience.
- Progress is measured against the currently installed corpus.
- Symbol source strategy, the first-50 proof set, and the broader candidate pool live in `docs/content/symbol-source-plan.md`.
- The next approach is design first, preferably in Figma, captured in `docs/content/symbol-evolution-design-handoff.md`.

## Visual Content

- The character-evolution reference pictures are product targets for the evolution experience, not loose design inspiration.
- The app adapts the reference from one poster into horizontal full-page stage views on iPhone.
- The bottom evolution strip is the pressable stage navigation for each symbol: origin picture, Oracle Bone, Bronze, Seal, Clerical, Regular, and Modern Forms.
- Bottom stage navigation remains fixed or floating near the bottom while stage content may scroll vertically if needed.
- Production visuals should be app-native, licensed, or source-backed content assets.
- Prefer source-backed image assets or specialist redraws for historical forms; vector assets are welcome when they preserve the required visual target.
- Stroke order is view-only in V1.
- Stroke order applies to modern focus-track forms where authoritative data is available.
- Historical transformation drawing and modern stroke order are separate concepts.
- Step-controlled viewing is primary; auto-play is secondary.
- Evolution visuals should show editorially chosen key stages only, but every displayed stage must be visually represented by its own asset or a clearly labeled gap.
- Prefer Wikimedia Commons Ancient Chinese Characters SVGs for bundled historical glyphs when available, with Dong Chinese used for origin/component analysis, stage discovery, and source cross-checking.
- Generic explanations of Oracle Bone, Bronze, Seal, Clerical, and Regular periods belong in the primary-shell `History` area, not repeated inside each symbol page.

## Utility and Reset

- `About / Method` exists in `More` / `Settings`.
- It should explain scope, method, and corpus size.
- `Account` is an agreed app concept, but it can remain shallow/deferred while the core symbol-recognition experience is being tested.
- `Saved/Archive` is an agreed app concept; V1 may implement it inside `Browse` through lightweight saved collections until the public-testing account/storage model is needed.
- `Languages` is an agreed app concept; V1 may implement it inside `More` / `Settings` through focus-language controls until a separate public-facing language page is needed.
- Deferred app concepts should keep a visible or documented place in the product model; they should not be silently removed or replaced with unrelated pages.
- `Settings` handles local preferences, focus language, offline/app information, and reset.
- `Reset app progress` is app-wide, not per lesson.
- Reset uses a normal explicit confirmation flow.

## Monetization and Expansion

- V1 excludes ads.
- V1 excludes deep implementation of voice, tracing, grammar comparison, rule-based common-denominator lessons, Android, account systems, sync, ads, and roadmap teasers in-product.
- Deferred agreed features remain part of the product direction and should be preserved as carryover or shallow placeholders when they affect navigation or public-testing readiness.
