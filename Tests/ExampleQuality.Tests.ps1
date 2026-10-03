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
      foreach ($reading in $lane.readings) {
        foreach ($field in @("writtenForm", "furigana", "speechText")) {
          Assert-NonEmpty ([string]$reading.$field) "$id [J] reading '$($reading.nativeReading)' is missing '$field'."
        }
        if ([string]$reading.speechText -ne [string]$reading.furigana) {
          throw "$id [J] reading '$($reading.nativeReading)' speech text must use furigana, not the written form."
        }
      }
      foreach ($equivalent in $lane.equivalents) {
        foreach ($field in @("writtenForm", "furigana")) {
          Assert-NonEmpty ([string]$equivalent.$field) "$id [J] equivalent '$($equivalent.nativeReading)' is missing '$field'."
        }
        if ([string]$equivalent.speechText -ne [string]$equivalent.furigana) {
          throw "$id [J] equivalent '$($equivalent.nativeReading)' speech text must use furigana."
        }
      }
      foreach ($example in $lane.examples) {
        Assert-NonEmpty ([string]$example.kanaReading) "$id [J] example '$($example.text)' is missing kanaReading."
        if ([string]$example.speechText -ne [string]$example.kanaReading) {
          throw "$id [J] example '$($example.text)' speech text must use kanaReading."
        }
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

  # Chinese lanes may share useful meanings, but no pair may reuse four
  # meanings in one Symbol. This keeps the fourth teaching slot regional
  # without forcing artificial differences into otherwise natural examples.
  $chineseLanes = @(
    [pscustomobject]@{ name = "S"; meanings = @($coverage.simplifiedChinese.examples | ForEach-Object { Normalize-Meaning $_.translation }) },
    [pscustomobject]@{ name = "TW"; meanings = @($coverage.traditionalChinese.taiwanExamples | ForEach-Object { Normalize-Meaning $_.translation }) },
    [pscustomobject]@{ name = "HK"; meanings = @($coverage.traditionalChinese.hongKongExamples | ForEach-Object { Normalize-Meaning $_.translation }) }
  )
  for ($leftIndex = 0; $leftIndex -lt $chineseLanes.Count; $leftIndex++) {
    for ($rightIndex = $leftIndex + 1; $rightIndex -lt $chineseLanes.Count; $rightIndex++) {
      $sharedMeanings = @($chineseLanes[$leftIndex].meanings | Where-Object { $chineseLanes[$rightIndex].meanings -contains $_ } | Sort-Object -Unique)
      if ($sharedMeanings.Count -ge 4) {
        throw "$id [$($chineseLanes[$leftIndex].name)/$($chineseLanes[$rightIndex].name)] reuses four or more Chinese example meanings: $($sharedMeanings -join ', ')."
      }
    }
  }
}

$semanticAuditExpectations = @{
  "below|おりる" = "go down / descend"
  "ear|ジ" = "ear"
  "follow|したがえる" = "make someone follow / command"
  "life|いける" = "arrange flowers"
  "old|ふける" = "look / grow older"
  "turn-back|そらす" = "bend backward / arch"
  "white|しら" = "white (in compounds)"
}
$requiredJapaneseReplacementExamples = @{
  "big" = "大声"
  "field" = "田舎"
  "middle" = "中身"
  "reach" = "及第"
  "things-goods" = "食品"
}

$followExpectedExamples = @{
  "simplifiedChinese" = @("从前", "从属", "我从家里来。", "跟随")
  "taiwanExamples" = @("從前", "從事", "我從家裡來。", "從不")
  "hongKongExamples" = @("從前", "從來", "我從屋企嚟。", "從未")
}

foreach ($sourceFile in $sourceFiles) {
  $record = Get-Content -LiteralPath $sourceFile -Raw | ConvertFrom-Json -Depth 100
  $japanese = $record.focusCoverage.japanese
  foreach ($expectation in $semanticAuditExpectations.GetEnumerator()) {
    $parts = $expectation.Key.Split('|', 2)
    if ($parts[0] -ne [string]$record.id) { continue }
    $reading = @($japanese.readings | Where-Object { [string]$_.nativeReading -eq $parts[1] }) | Select-Object -First 1
    if ($null -eq $reading -or [string]$reading.gloss -ne [string]$expectation.Value) {
      throw "$($record.id) [J] semantic gloss audit mismatch for '$($parts[1])'."
    }
  }

  if ([string]$record.id -eq "stretch" -and @($japanese.semanticEquivalents | Where-Object { [string]$_.nativeReading -eq "申す" }).Count -gt 0) {
    throw "stretch [J] must not duplicate 申す as both a reading and semantic equivalent."
  }

  if ($requiredJapaneseReplacementExamples.ContainsKey([string]$record.id)) {
    $replacement = [string]$requiredJapaneseReplacementExamples[[string]$record.id]
    if (@($japanese.examples | Where-Object { [string]$_.text -eq $replacement }).Count -eq 0) {
      throw "$($record.id) [J] is missing the reviewed replacement example '$replacement'."
    }
  }

  if ([string]$record.id -eq "follow") {
    foreach ($laneName in $followExpectedExamples.Keys) {
      $laneExamples = switch ($laneName) {
        "simplifiedChinese" { @($record.focusCoverage.simplifiedChinese.examples) }
        "taiwanExamples" { @($record.focusCoverage.traditionalChinese.taiwanExamples) }
        "hongKongExamples" { @($record.focusCoverage.traditionalChinese.hongKongExamples) }
      }
      $expected = $followExpectedExamples[$laneName]
      if ((@($laneExamples | ForEach-Object { [string]$_.text }) -join "|") -ne ($expected -join "|")) {
        throw "follow [$laneName] does not contain the approved distinct regional example set."
      }
    }
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
if (-not $usageText.Contains("private func japaneseExampleRow(_ example: UsageExample) -> some View") -or
    -not $usageText.Contains("HStack(alignment: .bottom, spacing: AppSpacing.spaceSm)")) {
  throw "Japanese example glosses must align with the bottom of the written-word block, below furigana."
}
if (-not $usageText.Contains("private func japaneseReadingRow(") -or
    -not $usageText.Contains("reading.writtenForm") -or
    -not $usageText.Contains("reading.furigana")) {
  throw "Japanese reading rows must render actual written forms with furigana."
}
if (-not $usageText.Contains("HStack(alignment: .firstTextBaseline, spacing: AppSpacing.spaceSm)")) {
  throw "Japanese header glosses must share the written-form baseline rather than the romanization line."
}

Write-Output "OK: example quality audit passed for 126 Symbols and the Traditional Chinese divider branch."
