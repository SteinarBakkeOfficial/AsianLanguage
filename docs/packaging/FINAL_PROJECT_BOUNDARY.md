# Final project boundary

The distributable project is built from an explicit allowlist. It contains the
current app source, the approved 126-record runtime corpus, the current symbol
artwork, and the resources directly referenced by the Xcode project.

## Included

- `AsianLanguage.xcodeproj/`
- `Sources/`
- `Tests/`
- `Tools/`
- `content/release/` (current authoring source)
- `Resources/Corpus/`
- `Resources/Assets/Symbols/` (the 126 readable symbol folders only)
- `Resources/Assets/Collections/`
- `Resources/History/`
- `Resources/Assets.xcassets/`
- `Resources/Fonts/`

## Local-only and excluded

The following remain available for research, provenance, rollback, and future
editing, but are not part of the final project export:

- `Reference Pictures/` — visual references and handoff material
- `artwork_production/` — production candidates, rejected artwork, and approval state
- `content/archive/` — prior content and artwork revisions
- `docs/archive/` — legacy and research intake material
- any legacy `Resources/Assets/PrototypeVisuals/` or `Resources/Assets/HistoricalGlyphs/`
- any symbol folder not represented by a current `Resources/Corpus/*.json` record

The Xcode resource phase includes only the current runtime corpus and current
resource roots. It does not include the local-only folders above. Folder names
are validated against the runtime corpus, so a suffix in a current ID is kept
when it is part of the authoritative record and an unreferenced legacy alias is
excluded.

Use `Tools/Export-FinalProject.ps1` when creating a handoff. The script refuses
to overwrite an existing destination and checks that excluded folders are not
present in the result.
