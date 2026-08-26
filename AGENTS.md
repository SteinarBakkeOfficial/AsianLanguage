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
