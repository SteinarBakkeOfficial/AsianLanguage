$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

function Assert-True {
  param(
    [Parameter(Mandatory = $true)]
    [bool]$Condition,
    [Parameter(Mandatory = $true)]
    [string]$Message
  )

  if (-not $Condition) {
    throw $Message
  }
}

function Assert-Contains {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Text,
    [Parameter(Mandatory = $true)]
    [string]$ExpectedSubstring,
    [Parameter(Mandatory = $true)]
    [string]$Message
  )

  Assert-True -Condition $Text.Contains($ExpectedSubstring) -Message "$Message Expected '$ExpectedSubstring'."
}

function Get-Text {
  param(
    [Parameter(Mandatory = $true)]
    [string]$RelativePath
  )

  return Get-Content -Raw (Join-Path $repoRoot $RelativePath)
}

$historyViewText = Get-Text "Sources/App/Lesson/CharacterEvolutionView.swift"
Assert-Contains -Text $historyViewText -ExpectedSubstring "struct CharacterEvolutionView: View" -Message "Visual system should expose a history spine view."
Assert-Contains -Text $historyViewText -ExpectedSubstring "canonicalStages" -Message "History spine should preserve the agreed canonical evolution path."
Assert-Contains -Text $historyViewText -ExpectedSubstring "Source-backed historical drawing and explanation needed" -Message "History spine should visibly mark missing stage content."
Assert-Contains -Text $historyViewText -ExpectedSubstring "This draft gap keeps the agreed evolution path visible" -Message "History spine should avoid hiding missing final redraws."
Assert-Contains -Text $historyViewText -ExpectedSubstring "changeNoteFromPrevious" -Message "History spine should show stage-to-stage change notes."
Assert-Contains -Text $historyViewText -ExpectedSubstring "assetRef" -Message "History spine should preserve asset reference display points."

$formsViewText = Get-Text "Sources/App/Lesson/ModernFormsComparisonView.swift"
Assert-Contains -Text $formsViewText -ExpectedSubstring "struct ModernFormsComparisonView: View" -Message "Visual system should expose modern forms comparison."
Assert-Contains -Text $formsViewText -ExpectedSubstring "Simplified Chinese" -Message "Modern forms should include Simplified Chinese."
Assert-Contains -Text $formsViewText -ExpectedSubstring "Traditional Chinese" -Message "Modern forms should include Traditional Chinese."
Assert-Contains -Text $formsViewText -ExpectedSubstring "Japanese" -Message "Modern forms should include Japanese."
Assert-Contains -Text $formsViewText -ExpectedSubstring "Korean" -Message "Modern forms should include Korean."

$lessonText = Get-Text "Sources/App/Lesson/LessonView.swift"
Assert-Contains -Text $lessonText -ExpectedSubstring "EvolutionBoardView(record:" -Message "Origin step should use the reference-led evolution board."
Assert-Contains -Text $lessonText -ExpectedSubstring "ModernFormsComparisonView(record: record, focusSelection:" -Message "Modern Forms step should use the focus-filtered comparison visual."

$pictogramText = Get-Text "Sources/App/Lesson/SymbolPictogramView.swift"
Assert-Contains -Text $pictogramText -ExpectedSubstring "struct SymbolPictogramView: View" -Message "Visual system should include draft original-picture drawings."
Assert-Contains -Text $pictogramText -ExpectedSubstring 'case "tree"' -Message "Original-picture drawings should cover the tree reference path."

Write-Output "OK: visual content contract tests passed"
