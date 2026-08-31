param(
  [string]$SymbolsPath = "content/symbols"
)

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$symbolsRoot = Join-Path $repoRoot $SymbolsPath

# These are draft word-level display variants, not sentence lessons. They make the
# writing-system relationship visible while the native-speaker review queue remains open.
$variants = @{
  fire = @{ japanese = @{ form = "ひ"; reading = "hi"; meaning = "fire" }; korean = @{ form = "불"; reading = "bul"; meaning = "fire" } }
  water = @{ japanese = @{ form = "みず"; reading = "mizu"; meaning = "water" }; korean = @{ form = "물"; reading = "mul"; meaning = "water" } }
  mountain = @{ japanese = @{ form = "やま"; reading = "yama"; meaning = "mountain" }; korean = @{ form = "산"; reading = "san"; meaning = "mountain" } }
  tree = @{ japanese = @{ form = "き"; reading = "ki"; meaning = "tree" }; korean = @{ form = "나무"; reading = "namu"; meaning = "tree" } }
  day = @{ japanese = @{ form = "ひ"; reading = "hi"; meaning = "day / sun" }; korean = @{ form = "날"; reading = "nal"; meaning = "day" } }
  moon = @{ japanese = @{ form = "つき"; reading = "tsuki"; meaning = "moon" }; korean = @{ form = "달"; reading = "dal"; meaning = "moon" } }
  eye = @{ japanese = @{ form = "め"; reading = "me"; meaning = "eye" }; korean = @{ form = "눈"; reading = "nun"; meaning = "eye" } }
  mouth = @{ japanese = @{ form = "くち"; reading = "kuchi"; meaning = "mouth" }; korean = @{ form = "입"; reading = "ip"; meaning = "mouth" } }
  person = @{ japanese = @{ form = "ひと"; reading = "hito"; meaning = "person" }; korean = @{ form = "사람"; reading = "saram"; meaning = "person" } }
  big = @{ japanese = @{ form = "おおきい"; reading = "ookii"; meaning = "big" }; korean = @{ form = "크다"; reading = "keuda"; meaning = "big" } }
  small = @{ japanese = @{ form = "ちいさい"; reading = "chiisai"; meaning = "small" }; korean = @{ form = "작다"; reading = "jakda"; meaning = "small" } }
}

foreach ($entry in $variants.GetEnumerator()) {
  $symbolFolder = Get-ChildItem -LiteralPath $symbolsRoot -Directory | Where-Object { $_.Name -like "$($entry.Key)-*" } | Select-Object -First 1
  if ($null -eq $symbolFolder) { continue }
  $symbolPath = Join-Path $symbolFolder.FullName "symbol.json"
  $symbol = Get-Content -LiteralPath $symbolPath -Raw | ConvertFrom-Json

  foreach ($track in @("japanese", "korean")) {
    $coverage = $symbol.focusCoverage.$track
    $draft = $entry.Value[$track]
    $variantID = "native-$track"
    $variant = [pscustomobject]@{
      id = $variantID
      form = $draft.form
      writingSystem = if ($track -eq "japanese") { "Japanese kana" } else { "Hangul" }
      readings = @([pscustomobject]@{ system = if ($track -eq "japanese") { "kana" } else { "native Korean" }; value = $draft.reading })
      notes = @("Draft native-language equivalent shown alongside the shared character; native-speaker review remains required.")
      examples = @([pscustomobject]@{
        text = $draft.form
        reading = $draft.reading
        translation = $draft.meaning
        showsCoreMeaning = $true
        exampleLevel = "word"
        parallelExampleGroupID = $null
        reusesKnownSymbols = @()
        introducedSymbols = @($symbol.coreCharacter)
      })
    }
    if ($null -eq $coverage.PSObject.Properties["variants"]) {
      $coverage | Add-Member -MemberType NoteProperty -Name variants -Value @($variant)
    } else {
      $coverage.variants = @($variant)
    }
  }

  $symbol | ConvertTo-Json -Depth 30 | Set-Content -LiteralPath $symbolPath -Encoding utf8
}

Write-Output "OK: added draft Japanese kana and Korean Hangul variants to the 11-symbol workspace."
