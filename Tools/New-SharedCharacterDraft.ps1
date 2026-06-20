param(
  [Parameter(Mandatory = $true)]
  [string]$Id,

  [Parameter(Mandatory = $true)]
  [string]$CoreCharacter,

  [Parameter(Mandatory = $true)]
  [string]$CoreSharedMeaning,

  [Parameter(Mandatory = $true)]
  [string]$OutputPath
)

$ErrorActionPreference = "Stop"

if (Test-Path $OutputPath) {
  Write-Error "Output path already exists: $OutputPath"
  exit 2
}

$outputDirectory = Split-Path -Parent $OutputPath
if ($outputDirectory -and -not (Test-Path $outputDirectory)) {
  New-Item -ItemType Directory -Path $outputDirectory | Out-Null
}

# This draft is intentionally complete enough for the editor to see every required
# V1 field, while placeholder copy still forces source-backed editorial review.
$record = [ordered]@{
  id = $Id
  version = 1
  teachingSequence = 999
  coreCharacter = $CoreCharacter
  coreSharedMeaning = $CoreSharedMeaning
  recognitionTakeaway = "Draft recognition takeaway for $CoreCharacter. Replace with source-backed editorial copy before publication."
  publicationStatus = "draft"
  visuals = [ordered]@{
    evolutionAssetRefs = [ordered]@{}
    assetStatus = "prototype-draft"
    note = "Add source-backed or app-native visual assets before prototype review."
  }
  focusCoverage = [ordered]@{
    simplifiedChinese = [ordered]@{
      form = $CoreCharacter
      readings = @([ordered]@{ system = "pinyin"; value = "TODO" })
      glosses = @($CoreSharedMeaning)
      examples = @(
        [ordered]@{ text = "TODO"; reading = "TODO"; translation = $CoreSharedMeaning; showsCoreMeaning = $true; exampleLevel = "word"; parallelExampleGroupID = $null; reusesKnownSymbols = @(); introducedSymbols = @($CoreCharacter) },
        [ordered]@{ text = "TODO"; reading = "TODO"; translation = "TODO"; showsCoreMeaning = $false; exampleLevel = "sentence"; parallelExampleGroupID = "TODO"; reusesKnownSymbols = @(); introducedSymbols = @($CoreCharacter) }
      )
    }
    traditionalChinese = [ordered]@{
      form = $CoreCharacter
      readings = @([ordered]@{ system = "pinyin"; value = "TODO" })
      glosses = @($CoreSharedMeaning)
      taiwanExamples = @(
        [ordered]@{ text = "TODO"; reading = "TODO"; translation = $CoreSharedMeaning; showsCoreMeaning = $true; exampleLevel = "word"; parallelExampleGroupID = $null; reusesKnownSymbols = @(); introducedSymbols = @($CoreCharacter) },
        [ordered]@{ text = "TODO"; reading = "TODO"; translation = "TODO"; showsCoreMeaning = $false; exampleLevel = "sentence"; parallelExampleGroupID = "TODO"; reusesKnownSymbols = @(); introducedSymbols = @($CoreCharacter) }
      )
      hongKongExamples = @(
        [ordered]@{ text = "TODO"; reading = "TODO"; translation = $CoreSharedMeaning; showsCoreMeaning = $true; exampleLevel = "word"; parallelExampleGroupID = $null; reusesKnownSymbols = @(); introducedSymbols = @($CoreCharacter) },
        [ordered]@{ text = "TODO"; reading = "TODO"; translation = "TODO"; showsCoreMeaning = $false; exampleLevel = "sentence"; parallelExampleGroupID = "TODO"; reusesKnownSymbols = @(); introducedSymbols = @($CoreCharacter) }
      )
    }
    japanese = [ordered]@{
      form = $CoreCharacter
      readings = @([ordered]@{ system = "on"; value = "TODO" })
      glosses = @($CoreSharedMeaning)
      examples = @(
        [ordered]@{ text = "TODO"; reading = "TODO"; translation = $CoreSharedMeaning; showsCoreMeaning = $true; exampleLevel = "word"; parallelExampleGroupID = $null; reusesKnownSymbols = @(); introducedSymbols = @($CoreCharacter) },
        [ordered]@{ text = "TODO"; reading = "TODO"; translation = "TODO"; showsCoreMeaning = $false; exampleLevel = "sentence"; parallelExampleGroupID = "TODO"; reusesKnownSymbols = @(); introducedSymbols = @($CoreCharacter) }
      )
    }
    korean = [ordered]@{
      form = $CoreCharacter
      readings = @([ordered]@{ system = "hangul"; value = "TODO" })
      glosses = @($CoreSharedMeaning)
      examples = @(
        [ordered]@{ text = "TODO"; reading = "TODO"; translation = $CoreSharedMeaning; showsCoreMeaning = $true; exampleLevel = "word"; parallelExampleGroupID = $null; reusesKnownSymbols = @(); introducedSymbols = @($CoreCharacter) },
        [ordered]@{ text = "TODO"; reading = "TODO"; translation = "TODO"; showsCoreMeaning = $false; exampleLevel = "sentence"; parallelExampleGroupID = "TODO"; reusesKnownSymbols = @(); introducedSymbols = @($CoreCharacter) }
      )
    }
  }
  history = [ordered]@{
    originAnchor = "TODO: source-backed origin anchor."
    stages = @(
      [ordered]@{
        stage = "regular"
        label = "Regular Script"
        form = $CoreCharacter
        assetRef = $null
        changeNoteFromPrevious = $null
        certainty = "limited"
        sourceIds = @("source-editorial-placeholder")
        historicalSound = $null
      }
    )
  }
  structure = [ordered]@{
    summary = "TODO: source-backed character/component structure."
    components = @(
      [ordered]@{ label = $CoreCharacter; role = "TODO"; meaningHint = $CoreSharedMeaning }
    )
    certainty = "limited"
    caveat = "Draft placeholder; replace with source-backed certainty note before publication."
    sourceIds = @("source-editorial-placeholder")
  }
  usage = [ordered]@{
    coreMeaningFirst = "TODO: explain how the core shared meaning appears across focus tracks."
    notes = @("Draft record generated for editorial completion.")
  }
  sources = @(
    [ordered]@{
      id = "source-editorial-placeholder"
      label = "Editorial source placeholder"
      type = "placeholder"
      citation = "Replace with source-backed references before publication."
    }
  )
  notes = @("Generated draft. Do not publish until TODO placeholders are replaced and sources are reviewed.")
}

$record |
  ConvertTo-Json -Depth 20 |
  Set-Content -Path $OutputPath -Encoding utf8

Write-Output "OK: created draft Shared Character record at $OutputPath"
exit 0
