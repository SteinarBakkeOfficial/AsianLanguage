# Symbol content workspace

The content workspace is the human-editable source for Shared Character lessons.

## Ownership

- `release/symbols/<id>/` owns one active V1 release Symbol and all character-specific editorial material, including its canonical `symbol.json`, research, source references, and source artwork.
- `components/` owns reusable concept/component assets that may be referenced by multiple Symbols.
- `manifests/` from the former pilot is archived under `docs/archive/legacy-pilot/manifests/`; active V1 runtime manifests live under `Resources/`.
- `research/v1-symbols/` now contains only research-intake indexes and transition-note source material; the old 148 per-candidate intake folders are archived under `docs/archive/research-intake/v1-symbols/`.
- The former flat `shared-characters/` and suffixed pilot folders are archived under `docs/archive/legacy-pilot/`. Superseded assets from active release packages are archived under `archive/symbols/<id>/`.

The app does not read web URLs at runtime. URLs in source and provenance files identify research sources only. Production lesson assets must be local and validated before packaging.

## Per-Symbol editing

Each active release Symbol folder should contain:

```text
symbol.json       structured lesson record consumed by tooling
research.md       editorial research, uncertainty, and source disagreements
sources.json      source/provenance records
historical-references.json  stage research and source-selection metadata when available
educational/      teaching aids, prompts, and visual notes
historical/       stage-specific source evidence and selected originals
components/       relationships to reusable component assets when needed
```

The runtime copies are generated separately under `Resources/Corpus` and `Resources/Assets/Symbols`; they are not editable source. `Reference Pictures/` is external design/reference material and is never part of the runtime source package.

Only the currently selected Origin image and ZDIC stage source files remain in each active Symbol folder. Earlier or alternate asset files are retained separately under `docs/archive/superseded-symbol-assets/`.

Generated preparation keeps every record in `draft` or `needsReview`. Human approval is required before publication.
