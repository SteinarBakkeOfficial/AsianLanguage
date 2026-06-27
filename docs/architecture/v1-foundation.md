# V1 App Foundation

## Goal

Define the first buildable shape for an offline-first SwiftUI iPhone app centered on guided `Shared Character` lessons.

## App Target

- Platform: iPhone first
- UI framework: SwiftUI
- Data posture: bundled read-only corpus plus local writable user state
- Network posture: no remote dependency for the core V1 study flow
- Visual mode: light and dark mode are first-class from the first app shell

## Module Shape

The initial app can stay in one SwiftUI target while keeping boundaries clear:

- `App`: app entry point, dependency setup, root scene
- `Navigation`: tab shell, route definitions, deep links within the app
- `Home`: resume state, next featured Shared Character, primary lesson entry
- `Lesson`: six-step guided lesson flow and lesson-specific view state
- `Discovery`: search, browse, filters, sorting, and collection entry points
- `Corpus`: bundled Shared Character models, loading, validation helpers
- `UserState`: local progress, favorites, review-later, focus track, preferences
- `SharedUI`: reusable typography, status indicators, focus-track chips, empty states

Start with explicit folders rather than package-level extraction. Promote modules into Swift packages only when tests or reuse pressure make that valuable.

## Navigation Shell

V1 uses a shallow tab structure:

- `Home`
- `Symbol` / `New Symbol`
- `History`
- `Browse`
- `More` / `Settings`

Names may still change during design, but the functional grouping is stable. `Symbol` / `New Symbol` owns the primary symbol-learning entry. `History` owns generic script-period explanations. `Browse` contains Search, Saved, Favorites, Review later, and collections. `More` / `Settings` contains Languages, Account, Settings, About / Method, reset, and utility pages.

## Home Routing

Home chooses its primary action from local state:

1. If any lesson is `inProgress`, show `Resume current lesson`.
2. Otherwise show `New Symbol` or `Next Symbol` for the next featured Shared Character.
3. Keep Symbol, History, Browse, and More / Settings available from the primary shell.

The first implementation should support only one active in-progress lesson. If multiple records exist after future migrations, choose the most recently updated one.

## Lesson Route

A lesson route needs two stable inputs:

- `sharedCharacterID`
- optional starting `lessonStep`

The route resolves the corpus record from read-only bundled data and overlays local user state. Learned lessons reopen at `Origin` by default. In-progress lessons resume at the saved step.

## Lesson Steps

The guided flow uses a closed enum:

1. `origin`
2. `character`
3. `modernForms`
4. `structure`
5. `usage`
6. `summary`

The progress bar is tappable only for steps that are current or already visited in the current lesson session. Future changes can loosen this after the lesson-state rules are proven.

## Symbol Evolution Experience

The `Origin` and `Character` lesson steps share the main reference-led evolution experience. The character-evolution reference images are product targets for layout, hierarchy, and stage navigation, adapted from one poster into iPhone-sized horizontal stage pages.

The stage sequence is:

1. origin picture
2. Oracle Bone
3. Bronze
4. Seal
5. Clerical
6. Regular
7. Modern Forms

Each stage owns a full-page horizontal swipe view. Stage content should normally fit in one screen; when text overflows, only the stage content scrolls vertically. The bottom evolution strip remains fixed or floating near the bottom and acts as pressable navigation between stages.

Every displayed Origin, Oracle Bone, Bronze, Seal, Clerical, and Regular stage needs its own image asset or an explicit missing-asset placeholder. Modern regular text must not be reused as a fake historical visual.

## Focus Tracks

The focus-track enum is:

- `all`
- `simplifiedChinese`
- `traditionalChinese`
- `japanese`
- `korean`

`traditionalChinese` is a modern written-form track. It includes separate Taiwan and Hong Kong usage examples when selected, and both are also visible when `all` is selected.

## Local State

Local writable state is separate from the corpus and keyed by corpus IDs:

- progress status
- last visited lesson step
- visited steps for the current session
- starred flag
- review-later flag
- focus-track preference
- display preferences
- installed corpus metadata

`learned` and `reviewLater` are mutually exclusive. `starred` is independent.

## Search and Discovery

Search lives inside Browse and should index:

- modern forms
- English glosses
- Mandarin readings
- Traditional Chinese readings when they differ
- Japanese readings
- Korean readings
- example text and translations only after the primary fields work well

Search can start with exact and case-insensitive partial matching over a normalized in-memory index. Ranking can stay simple in V1: exact form matches first, then readings, then glosses.

Browse also contains Saved, Favorites, Review later, and editorial/system collections.

## V1 to VNext Tracking

This foundation intentionally excludes grammar lessons, rule-based common-denominator lessons, audio, tracing, sync, accounts, ads, Android, and user-created collection folders. Those are valid later directions but should not alter the V1 app shell or schemas unless the roadmap is updated first.
