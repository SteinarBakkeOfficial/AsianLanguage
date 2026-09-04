$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
function Assert-True { param([bool]$Condition,[string]$Message); if (-not $Condition) { throw $Message } }

$manifest = Get-Content -Raw (Join-Path $repoRoot "Resources/V1CorpusManifest.json") | ConvertFrom-Json
$records = @(Get-ChildItem (Join-Path $repoRoot "Resources/Corpus") -Filter "*.json" -File | ForEach-Object {
  Get-Content -Raw $_.FullName | ConvertFrom-Json
})
$runtimeIDs = @($manifest | Sort-Object teachingSequence | ForEach-Object id)
$allowedFormationTypes = @("pictograph", "simpleIdeograph", "compoundIdeograph", "phonoSemantic", "phoneticLoan", "laterFormation", "uncertain")
$expectedCharacters = @('一','日','月','夕','山','水','川','木','竹','土','石','雨','云','田','井','泉','生','人','大','女','子','母','目','耳','口','舌','自','首','身','心','老','长','天','牛','羊','犬','虎','角','刀','弓','衣','豆','工','册','玉','王','示','力','二','三','十','上','下','中','小','少','多','高','入','出','立','央','南','北','西','林','休','从','好','男','明','美','兄','品','告','合','取','采','止','步','走','行','正','先','及','交','反','友','向','分','利','武','得','後','集','言','公','民','典','兵','令','各','同','妻','古','吉','旅','族','守','官','申','光','白','黑','赤','年','夏','冬','望','甘','香','益','祭','宗','宿','祝')
$actualCharacters = @($manifest | Sort-Object teachingSequence | ForEach-Object coreCharacter)

Assert-True ($runtimeIDs.Count -eq 126) "Runtime corpus must contain exactly 126 records."
Assert-True (($actualCharacters -join '') -eq ($expectedCharacters -join '')) "Runtime corpus must follow the approved 126-symbol teaching order."
foreach ($record in $records | Where-Object { $runtimeIDs -contains $_.id }) {
  Assert-True ($allowedFormationTypes -contains $record.formationType) "Runtime record '$($record.id)' has a Swift-incompatible formationType '$($record.formationType)'."
  Assert-True ($null -ne $record.history.origin.asset) "Runtime record '$($record.id)' must retain its origin asset metadata."
  foreach ($track in @("simplifiedChinese", "japanese", "korean")) {
    Assert-True ($record.focusCoverage.$track.readings -is [array]) "Runtime record '$($record.id)' track '$track' readings must be an array."
    foreach ($reading in @($record.focusCoverage.$track.readings)) {
      Assert-True (-not [string]::IsNullOrWhiteSpace([string]$reading.system)) "Runtime record '$($record.id)' track '$track' reading system must be present."
      Assert-True (-not [string]::IsNullOrWhiteSpace([string]$reading.value)) "Runtime record '$($record.id)' track '$track' reading value must be present."
    }
  }
  foreach ($field in @("readings", "taiwanReadings", "hongKongReadings")) {
    Assert-True ($record.focusCoverage.traditionalChinese.$field -is [array]) "Runtime record '$($record.id)' traditional '$field' must be an array."
  }
}

$firstSymbol = Get-Content -Raw (Join-Path $repoRoot "Resources/Corpus/one.json") | ConvertFrom-Json
Assert-True ($firstSymbol.coreCharacter -eq "一") "The first runtime symbol must be 一."
Assert-True ($firstSymbol.history.origin.asset.assetRef -eq "Assets/Symbols/one/educational/origin.png") "The onboarding symbol must retain its local origin illustration reference."
Assert-True (Test-Path (Join-Path $repoRoot "Resources/Assets/Symbols/one/educational/origin.png")) "The onboarding symbol origin illustration must exist locally."
Assert-True ($firstSymbol.focusCoverage.simplifiedChinese.readings -is [array]) "The onboarding symbol readings must remain a decodable array."

Write-Output "OK: runtime corpus decode contract passed"
