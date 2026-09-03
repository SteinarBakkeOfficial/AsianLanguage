# AGENTS.md

## Agent skills

### Issue tracker

Issues and PRDs are tracked in GitHub Issues. See `docs/agents/issue-tracker.md`.

### Triage labels

Use the default mattpocock/skills triage labels. See `docs/agents/triage-labels.md`.

### Domain docs

This is a single-context repo using root project docs. See `docs/agents/domain.md`.

## AsianLanguage product guardrails

- Shared Character is the core object; the historical Symbol Journey is the core experience.
- The five root areas are Home, Symbol, History, Browse, and More.
- Search, Saved, Learned, Review later, Favorites, and Collections belong in Browse.
- Languages, Settings, Account, About / Method, reset, and offline information belong in More.
- Historical Assets must be source-backed or licensed, bundled, or shown as explicit Missing Historical Assets. Never fabricate historical glyphs or use a modern form as a historical fallback.
- Character structure is stage-aware; components appear where they are historically introduced or become meaningful.
- The corpus is bundled/read-only and user state is separate/local.
- Schema changes require validator, runtime model, migration, and test alignment.
- Approved design references and behavioral specifications outrank transitional views or brittle prototype tests.

## Design-freeze and scope-control protocol

- Treat the newest direct user instruction as authoritative over older roadmap notes, transitional implementation comments, and inferred improvements.
- Begin every implementation task with a written scope contract: requested changes, allowed files/components, and explicit no-change areas.
- For a surgical request, preserve layout, wording, hierarchy, navigation, data shape, and interaction behavior unless that specific item is explicitly included.
- Never add fallback copy, placeholder examples, generated content, labels, or new navigation as a way to make a screen feel complete when content quality or review is on hold.
- Before changing an existing view or method, state the exact behavior being changed and why it is required by the current request.
- Keep visual changes in focused commits. Do not combine content imports, typography changes, navigation changes, and unrelated screen redesigns.
- Before commit, review `git diff --stat` and the complete changed-file list against the scope contract; stop if an unrequested screen or component changed.
- Windows contract checks do not validate visual fidelity. Any SwiftUI visual change requires macOS/Xcode simulator comparison before it is described as verified.
- Preserve the last known-good commit as the comparison baseline. If a requested change causes unrelated visual drift, restore the affected component to that baseline and reapply only the requested delta.
