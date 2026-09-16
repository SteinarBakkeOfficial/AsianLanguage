# Tools

Project-local scripts and wrappers. Shared cross-project tooling remains in `C:\Users\Stein\dev\personal\Tools`.

## Symbol preparation workflow

For the active V1 source, edit one folder under `content/release/symbols/<id>/`, then run the importer and checks:

```powershell
& .\Tools\Import-V1RuntimeCorpus.ps1
& .\Tools\Run-Checks.ps1
```

The older pilot preparation sequence is retained only for archived fixtures:

```powershell
& .\Tools\Prepare-SymbolWorkspace.ps1
& .\Tools\Validate-SymbolWorkspace.ps1
& .\Tools\Generate-SymbolReview.ps1
& .\Tools\Build-SymbolPackage.ps1
```

Each active release Symbol folder under `content/release/symbols/<id>/` contains the canonical `symbol.json` beside its research, provenance, and source artwork. `Import-V1RuntimeCorpus.ps1` creates the flat generated JSON output in `Resources/Corpus` and the generated app assets under `Resources/Assets/Symbols`. All records remain `needsReview`; no tool marks content approved.

`Prepare-SymbolWorkspace.ps1` and `Build-SymbolPackage.ps1` are retained for the legacy 11-record pilot only until that prototype workflow is retired. Their defaults read and write under `docs/archive/legacy-pilot/`; they must not be used as the V1 source pipeline and cannot overwrite active `Resources/` output.

When replacing active Symbol text or artwork, first copy the current file or package to `content/archive/symbols/<id>/revisions/<timestamp>/`, then replace it under `content/release/symbols/<id>/` and run the active importer. The archive is never bundled; `Resources/` is regenerated only from the release source.

`Import-V1RuntimeCorpus.ps1` is the current V1 source-to-runtime import. It reads the 126-record complete-evolution manifest, loads each canonical `content/release/symbols/<id>/symbol.json`, copies the selected normalized and original ZDIC SVGs and approved origin illustrations from that same Symbol folder, writes the 126 runtime JSON records, and emits `Resources/V1CorpusManifest.json` for inspection. It deliberately preserves review-required rights and editorial status; it does not approve or clear content for release.

`Import-CorrectedTargetLanguageCorpus.ps1` merges the corrected target-language handoff from `Reference Pictures/Chatgpt/Corpus_corrected_target_languages/Corpus` into the 126 existing runtime records. It replaces modern-language forms, readings, examples, speech text, and usage notes while preserving stable readable IDs, filenames, bundled asset references, and draft/review status. It intentionally leaves the excluded Fire pilot untouched.

## Final project handoff

The Xcode project bundles only the current runtime corpus and current approved asset roots. Research references, production candidates, rejected artwork, and prior revisions stay local and are excluded from a handoff. See `docs/packaging/FINAL_PROJECT_BOUNDARY.md` for the complete boundary.

Create a clean handoff with an empty destination outside the repository:

```powershell
& .\Tools\Export-FinalProject.ps1 -Destination "..\AsianLanguage-final-project"
```

The export uses an explicit allowlist, requires 126 active symbol folders, rejects Unicode-suffixed legacy folders, and refuses to overwrite an existing destination.

`Generate-MuseumTransitionNotes.ps1` compares the local selected museum SVG assets, generates one concise destination-stage `transitionNote` for every available stage in the 126-record runtime corpus, writes the reviewable source package to `content/research/v1-symbols/transition-notes-v1.json`, and updates the runtime records. Origin captions connect the concrete illustration to the first glyph; later captions compare neighboring forms without naming stages or repeating the modern character. It uses conservative visual language and records QA flags for uncertain comparisons; it never invents a missing stage or changes an image.

## ZDIC research intake

`Download-ZDIC-V1Research.ps1` reads the 148-character teaching-order assessment and downloads the first available ZDIC SVG for each Oracle Bone, Bronze, Small Seal, and Clerical stage. It stores intake originals and normalized research derivatives under `docs/archive/research-intake/v1-symbols/` and writes the 148-character audit manifest. The current V1 subset is the separate 126-character complete manifest; use `Import-V1RuntimeCorpus.ps1` to make that selected package available to the local runtime. ZDIC reuse permission must be confirmed before commercial publication.
