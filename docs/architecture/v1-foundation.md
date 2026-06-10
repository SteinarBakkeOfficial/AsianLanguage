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
- `Search`
- `Browse`
- `Collections`
- `Settings`

`Home` remains the shell label. `New Symbol` and `Next Symbol` are primary actions inside Home, not page names.

## Home Routing

Home chooses its primary action from local state:

1. If any lesson is `inProgress`, show `Resume current lesson`.
2. Otherwise show `New Symbol` or `Next Symbol` for the next featured Shared Character.
3. Keep Search, Browse, and Collections secondary.

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

Search should index:

- modern forms
- English glosses
- Mandarin readings
- Traditional Chinese readings when they differ
- Japanese readings
- Korean readings
- example text and translations only after the primary fields work well

Search can start with exact and case-insensitive partial matching over a normalized in-memory index. Ranking can stay simple in V1: exact form matches first, then readings, then glosses.

## V1 to VNext Tracking

This foundation intentionally excludes grammar lessons, rule-based common-denominator lessons, audio, tracing, sync, accounts, ads, Android, and user-created collection folders. Those are valid later directions but should not alter the V1 app shell or schemas unless the roadmap is updated first.
