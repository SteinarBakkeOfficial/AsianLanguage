# Symbol content workspace

The content workspace is the human-editable source for Shared Character lessons.

## Ownership

- `symbols/<id>-u<codepoint>/` owns one complete Symbol and all character-specific editorial material.
- `components/` owns reusable concept/component assets that may be referenced by multiple Symbols.
- `manifests/` contains generated indexes and offline asset inventories.
- `shared-characters/` is the transitional flat source/export kept while the app bundle migrates to the folder model.

The app does not read web URLs at runtime. URLs in source and provenance files identify research sources only. Production lesson assets must be local and validated before packaging.

## Per-Symbol editing

Each Symbol folder should contain:

```text
symbol.json       structured lesson record consumed by tooling
lesson.md         learner-facing copy
research.md       editorial research, uncertainty, and source disagreements
review.md         human review status and actionable gaps
sources.json      source/provenance records
educational/      teaching aids, prompts, and visual notes
historical/       stage-specific evidence, originals, and app derivatives
components/       relationships to reusable component assets
```

Generated preparation keeps every record in `draft` or `needsReview`. Human approval is required before publication.
