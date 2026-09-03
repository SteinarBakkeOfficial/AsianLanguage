# Tools

Project-local scripts and wrappers. Shared cross-project tooling remains in `C:\Users\Stein\dev\personal\Tools`.

## Symbol preparation workflow

Use the following sequence after editing a Symbol folder or adding local assets:

```powershell
& .\Tools\Prepare-SymbolWorkspace.ps1
& .\Tools\Validate-SymbolWorkspace.ps1
& .\Tools\Generate-SymbolReview.ps1
& .\Tools\Build-SymbolPackage.ps1
```

`Prepare-SymbolWorkspace.ps1` creates or refreshes the human-editable folder layer from the transitional draft corpus. `Build-SymbolPackage.ps1` validates it, synchronizes flat JSON into `Resources/Corpus`, and copies local app derivatives into `Resources/Assets/Symbols`. All prepared records remain `needsReview`; no tool marks content approved.

`Import-V1RuntimeCorpus.ps1` is the current V1 research-to-runtime import. It reads the 126-record complete-evolution manifest, copies the selected normalized and original ZDIC SVGs, copies the approved v2 origin illustrations, writes the 126 runtime JSON records, and emits `Resources/V1CorpusManifest.json` for inspection. It deliberately preserves review-required rights and editorial status; it does not approve or clear content for release.

`Generate-MuseumTransitionNotes.ps1` compares the local selected museum SVG assets, generates one destination-stage `transitionNote` for every available stage in the 126-record runtime corpus, writes the reviewable source package to `content/research/v1-symbols/transition-notes-v1.json`, and updates the runtime records. It uses conservative visual language and records QA flags for uncertain comparisons; it never invents a missing stage or changes an image.

## ZDIC research intake

`Download-ZDIC-V1Research.ps1` reads the 148-character teaching-order assessment and downloads the first available ZDIC SVG for each Oracle Bone, Bronze, Small Seal, and Clerical stage. It stores originals and normalized research derivatives under `content/research/v1-symbols/` and writes the 148-character audit manifest. The current V1 subset is the separate 126-character complete manifest; use `Import-V1RuntimeCorpus.ps1` to make that selected package available to the local runtime. ZDIC reuse permission must be confirmed before commercial publication.
