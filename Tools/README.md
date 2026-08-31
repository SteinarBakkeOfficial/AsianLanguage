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
