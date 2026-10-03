$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$sourcePath = Join-Path $repoRoot "content/release/symbols"
$runtimePath = Join-Path $repoRoot "Resources/Corpus"

function Get-Array($Value) {
  if ($null -eq $Value) { return @() }
  return @($Value)
}

function Normalize-Meaning([string]$Value) {
  if ([string]::IsNullOrWhiteSpace($Value)) { return "" }
  return (($Value.ToLowerInvariant() -replace "\s+", " ").Trim())
}

function Assert-NonEmpty([string]$Value, [string]$Message) {
  if ([string]::IsNullOrWhiteSpace($Value)) { throw $Message }
}

$sourceFiles = @(Get-ChildItem -LiteralPath $sourcePath -Directory | ForEach-Object { Join-Path $_.FullName "symbol.json" })
if ($sourceFiles.Count -ne 126) { throw "Example quality audit expected 126 source Symbols, found $($sourceFiles.Count)." }

foreach ($sourceFile in $sourceFiles) {
  $record = Get-Content -LiteralPath $sourceFile -Raw | ConvertFrom-Json -Depth 100
  $id = [string]$record.id
  $coverage = $record.focusCoverage

  $equivalentCollections = @(
    ,$coverage.simplifiedChinese.semanticEquivalents
    ,$coverage.traditionalChinese.taiwanSemanticEquivalents
    ,$coverage.traditionalChinese.hongKongSemanticEquivalents
    ,$coverage.japanese.semanticEquivalents
    ,$coverage.korean.semanticEquivalents
  )
  foreach ($collection in $equivalentCollections) {
    if ($null -ne $collection -and -not ($collection -is [System.Array])) {
      throw "$id contains an equivalent/native collection encoded as a JSON object instead of an array."
    }
  }

  $lanes = @(
    [pscustomobject]@{ name = "S"; examples = Get-Array $coverage.simplifiedChinese.examples; readings = Get-Array $coverage.simplifiedChinese.readings; equivalents = Get-Array $coverage.simplifiedChinese.semanticEquivalents; language = "mandarin" },
    [pscustomobject]@{ name = "TW"; examples = Get-Array $coverage.traditionalChinese.taiwanExamples; readings = Get-Array $coverage.traditionalChinese.taiwanReadings; equivalents = Get-Array $coverage.traditionalChinese.taiwanSemanticEquivalents; language = "mandarin" },
    [pscustomobject]@{ name = "HK"; examples = Get-Array $coverage.traditionalChinese.hongKongExamples; readings = Get-Array $coverage.traditionalChinese.hongKongReadings; equivalents = Get-Array $coverage.traditionalChinese.hongKongSemanticEquivalents; language = "cantonese" },
    [pscustomobject]@{ name = "J"; examples = Get-Array $coverage.japanese.examples; readings = Get-Array $coverage.japanese.readings; equivalents = Get-Array $coverage.japanese.semanticEquivalents; language = "japanese" },
    [pscustomobject]@{ name = "K"; examples = Get-Array $coverage.korean.examples; readings = Get-Array $coverage.korean.readings; equivalents = Get-Array $coverage.korean.semanticEquivalents; language = "korean" }
  )

  foreach ($lane in $lanes) {
    if ($lane.examples.Count -lt 4 -or $lane.examples.Count -gt 5) {
      throw "$id [$($lane.name)] must have 4–5 examples; found $($lane.examples.Count)."
    }

    $meanings = @($lane.examples | ForEach-Object { Normalize-Meaning $_.translation })
    if (($meanings | Where-Object { [string]::IsNullOrWhiteSpace($_) }).Count -gt 0) {
      throw "$id [$($lane.name)] has an example without an English translation."
    }
    $duplicateMeanings = @($meanings | Group-Object | Where-Object { $_.Count -gt 1 })
    if ($duplicateMeanings.Count -gt 0) {
      throw "$id [$($lane.name)] repeats an example meaning: $($duplicateMeanings.Name -join ', ')."
    }

    foreach ($example in $lane.examples) {
      Assert-NonEmpty ([string]$example.text) "$id [$($lane.name)] example text is empty."
      Assert-NonEmpty ([string]$example.reading) "$id [$($lane.name)] example reading is empty for '$($example.text)'."
      Assert-NonEmpty ([string]$example.translation) "$id [$($lane.name)] example translation is empty for '$($example.text)'."
      Assert-NonEmpty ([string]$example.speechText) "$id [$($lane.name)] speech text is empty for '$($example.text)'."
      if ([string]$example.speechLanguage -ne $lane.language) {
        throw "$id [$($lane.name)] '$($example.text)' has speech language '$($example.speechLanguage)', expected '$($lane.language)'."
      }
    }

    foreach ($equivalent in $lane.equivalents) {
      foreach ($field in @("value", "nativeReading", "romanization", "gloss", "speechText", "speechLanguage")) {
        Assert-NonEmpty ([string]$equivalent.$field) "$id [$($lane.name)] equivalent is missing '$field'."
      }
      if ([string]$equivalent.speechLanguage -ne $lane.language) {
        throw "$id [$($lane.name)] equivalent '$($equivalent.nativeReading)' has speech language '$($equivalent.speechLanguage)', expected '$($lane.language)'."
      }
    }

    $equivalentKeys = @{}
    foreach ($equivalent in $lane.equivalents) {
      $key = ("$($equivalent.speechLanguage)|$($equivalent.speechText)|$($equivalent.romanization)|$($equivalent.gloss)").ToLowerInvariant()
      if ($equivalentKeys.ContainsKey($key)) {
        throw "$id [$($lane.name)] contains a duplicate equivalent/native row '$($equivalent.nativeReading)'."
      }
      $equivalentKeys[$key] = $true
    }

    if ($lane.name -eq "J") {
      foreach ($example in $lane.examples) {
        foreach ($reading in $lane.readings) {
          if ((Get-Array $example.coversReadings) -contains [string]$reading.nativeReading -and (Normalize-Meaning $example.translation) -eq (Normalize-Meaning $reading.gloss)) {
            throw "$id [J] example '$($example.text)' repeats the gloss of reading '$($reading.nativeReading)'."
          }
        }
      }
    }
  }

  $sMeanings = ((Get-Array $coverage.simplifiedChinese.examples) | ForEach-Object { Normalize-Meaning $_.translation }) -join " || "
  $twMeanings = ((Get-Array $coverage.traditionalChinese.taiwanExamples) | ForEach-Object { Normalize-Meaning $_.translation }) -join " || "
  $hkMeanings = ((Get-Array $coverage.traditionalChinese.hongKongExamples) | ForEach-Object { Normalize-Meaning $_.translation }) -join " || "
  if ($sMeanings -eq $twMeanings -and $sMeanings -eq $hkMeanings) {
    throw "$id clones the complete Simplified/Taiwan/Hong Kong example-meaning sequence."
  }
}

$usagePath = Join-Path $repoRoot "Sources/App/Lesson/UsageExamplesView.swift"
$usageText = Get-Content -LiteralPath $usagePath -Raw
if ($usageText.Contains("if (!readings.isEmpty || !equivalents.isEmpty) && !examples.isEmpty")) {
  throw "Traditional Chinese divider logic still renders before and after equivalents."
}
if (-not $usageText.Contains("} else if !readings.isEmpty && !examples.isEmpty {")) {
  throw "Traditional Chinese divider logic must have a single reading-only branch when no equivalents exist."
}

Write-Output "OK: example quality audit passed for 126 Symbols and the Traditional Chinese divider branch."
