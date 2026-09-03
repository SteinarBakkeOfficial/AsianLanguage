$ErrorActionPreference = "Stop"

<##
  Research-only asset intake for the 148-candidate V1 design reference.
  The runtime must not bundle these copied ZDIC assets until reuse permission
  is confirmed or the files are replaced with cleared/public-domain assets.
##>

$repoRoot = Split-Path -Parent $PSScriptRoot
$assessmentPath = Join-Path $repoRoot "docs/content/shared-cjk-v1-visual-story-oracle-assessment.md"
$manifestPath = Join-Path $repoRoot "content/research/zdic-v1-selection-manifest.json"
$doc = Get-Content -Raw -LiteralPath $assessmentPath
$blocks = [regex]::Matches($doc, '```text\r?\n(?<body>[\s\S]*?)\r?\n```')
$records = @()
foreach ($block in $blocks) {
    foreach ($match in [regex]::Matches($block.Groups['body'].Value, '(?<rank>\d+)\s+(?<character>[\u3400-\u9FFF])')) {
        $records += [pscustomobject]@{
            rank = [int]$match.Groups['rank'].Value
            character = $match.Groups['character'].Value
        }
    }
}
$records = @($records | Sort-Object rank -Unique)
if ($records.Count -ne 148) {
    throw "Expected the locked 148-character V1 sequence, found $($records.Count)."
}

$stageSpecs = @(
    [pscustomobject]@{ key = "oracleBone"; slug = "jiaguwen"; label = "Oracle Bone / 甲骨文" },
    [pscustomobject]@{ key = "bronze"; slug = "jinwen"; label = "Bronze / 金文" },
    [pscustomobject]@{ key = "smallSeal"; slug = "xiaozhuan"; label = "Small Seal / 小篆" },
    [pscustomobject]@{ key = "clerical"; slug = "lishu"; label = "Clerical / 隶书" }
)

function New-NormalizedSVG {
    param(
        [Parameter(Mandatory)] [string] $OriginalPath,
        [Parameter(Mandatory)] [string] $NormalizedPath
    )

    $svg = [System.IO.File]::ReadAllText($OriginalPath)
    $viewBoxMatch = [regex]::Match($svg, 'viewBox\s*=\s*"([^"]+)"')
    $viewBox = if ($viewBoxMatch.Success) { $viewBoxMatch.Groups[1].Value } else { "0 0 400 400" }
    $openMatch = [regex]::Match($svg, '<svg\b[^>]*>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $closeIndex = $svg.LastIndexOf("</svg>", [System.StringComparison]::OrdinalIgnoreCase)

    if ($openMatch.Success -and $closeIndex -gt $openMatch.Length) {
        $inner = $svg.Substring($openMatch.Length, $closeIndex - $openMatch.Length)
        $normalized = "<svg xmlns=`"http://www.w3.org/2000/svg`" width=`"1024`" height=`"1024`" viewBox=`"$viewBox`" preserveAspectRatio=`"xMidYMid meet`">`n$inner`n</svg>"
        [System.IO.File]::WriteAllText($NormalizedPath, $normalized, [System.Text.UTF8Encoding]::new($false))
    } else {
        Copy-Item -LiteralPath $OriginalPath -Destination $NormalizedPath -Force
    }
}

$results = @($records | ForEach-Object -Parallel {
    $record = $_
    $specs = $using:stageSpecs
    $root = $using:repoRoot
    $unicode = ("{0:X4}" -f [int][char]$record.character)
    $folder = Join-Path $root ("content/research/v1-symbols/rank-{0:D3}-{1}-u{2}" -f $record.rank, $record.character, $unicode)
    $targetRoot = Join-Path $folder "historical/zdic-selected"
    New-Item -ItemType Directory -Force -Path $targetRoot | Out-Null
    $encoded = [uri]::EscapeDataString($record.character)
    $pageURL = "https://zdic.net/hans/$encoded"
    $pageStatus = "available"
    $pageError = $null
    try {
        $page = Invoke-WebRequest -Uri $pageURL -UseBasicParsing -TimeoutSec 45
    } catch {
        $pageStatus = "pageUnavailable"
        $pageError = $_.Exception.Message
        $page = $null
    }

    $stages = @()
    foreach ($spec in $specs) {
        $stageDir = Join-Path $targetRoot $spec.key
        New-Item -ItemType Directory -Force -Path $stageDir | Out-Null
        $stagePageURL = "https://zdic.net/hans/$encoded/$($spec.slug)"
        $candidateURLs = @()
        if ($page) {
            $matches = [regex]::Matches($page.Content, '(?i)(?:https?:)?//img\.zdic\.net/[^"<> ]+\.svg')
            $candidateURLs = @($matches | ForEach-Object {
                $url = $_.Value
                if ($url.StartsWith("//")) { "https:$url" } else { $url }
            } | Where-Object { $_ -match "/zy/$($spec.slug)/" } | Select-Object -Unique)
        }

        $selectedURL = $null
        $selectedIndex = $null
        $assetStatus = if ($candidateURLs.Count -gt 0) { "available" } else { "missingOnOverview" }
        $originalPath = Join-Path $stageDir "original.svg"
        $normalizedPath = Join-Path $stageDir "museum-canvas.svg"
        for ($index = 0; $index -lt $candidateURLs.Count; $index++) {
            try {
                Invoke-WebRequest -Uri $candidateURLs[$index] -UseBasicParsing -TimeoutSec 45 -OutFile $originalPath
                if ((Get-Item -LiteralPath $originalPath).Length -lt 100) {
                    throw "Downloaded SVG is unexpectedly small."
                }
                $selectedURL = $candidateURLs[$index]
                $selectedIndex = $index + 1
                $assetStatus = "selected"
                break
            } catch {
                $assetStatus = "downloadFailed"
                if (Test-Path -LiteralPath $originalPath) {
                    Remove-Item -LiteralPath $originalPath -Force
                }
            }
        }

        if ($selectedURL) {
            $svg = [System.IO.File]::ReadAllText($originalPath)
            $viewBoxMatch = [regex]::Match($svg, 'viewBox\s*=\s*"([^"]+)"')
            $viewBox = if ($viewBoxMatch.Success) { $viewBoxMatch.Groups[1].Value } else { "0 0 400 400" }
            $openMatch = [regex]::Match($svg, '<svg\b[^>]*>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
            $closeIndex = $svg.LastIndexOf("</svg>", [System.StringComparison]::OrdinalIgnoreCase)
            if ($openMatch.Success -and $closeIndex -gt $openMatch.Length) {
                $inner = $svg.Substring($openMatch.Length, $closeIndex - $openMatch.Length)
                $normalized = "<svg xmlns=`"http://www.w3.org/2000/svg`" width=`"1024`" height=`"1024`" viewBox=`"$viewBox`" preserveAspectRatio=`"xMidYMid meet`">`n$inner`n</svg>"
                [System.IO.File]::WriteAllText($normalizedPath, $normalized, [System.Text.UTF8Encoding]::new($false))
            } else {
                Copy-Item -LiteralPath $originalPath -Destination $normalizedPath -Force
            }
        }

        $stages += [ordered]@{
            key = $spec.key
            label = $spec.label
            status = $assetStatus
            sourcePageURL = $stagePageURL
            sourceAssetURL = $selectedURL
            selectedVariant = $selectedIndex
            candidateCountOnOverview = $candidateURLs.Count
            originalPath = if ($selectedURL) { $originalPath.Substring($root.Length + 1).Replace("\", "/") } else { $null }
            normalizedPath = if ($selectedURL) { $normalizedPath.Substring($root.Length + 1).Replace("\", "/") } else { $null }
        }
    }

    [ordered]@{
        rank = $record.rank
        character = $record.character
        unicode = "U+$unicode"
        status = $pageStatus
        pageURL = $pageURL
        pageError = $pageError
        stages = $stages
    }
} -ThrottleLimit 8)

$manifest = [ordered]@{
    title = "ZDIC V1 Candidate Intake Audit (148)"
    generatedAt = (Get-Date).ToUniversalTime().ToString("o")
    status = "researchOnly"
    corpusCount = $records.Count
    workflow = "ZDIC overview page; first available SVG by stage in page order; advance only when retrieval fails or is empty."
    stages = @("oracleBone", "bronze", "smallSeal", "clerical")
    regularScript = "Generated from the approved Kai font; not copied from ZDIC."
    rightsWarning = "ZDIC is a reference source here. Commercial redistribution of copied images requires permission confirmation or replacement with cleared/public-domain assets."
    records = $results
}
$manifest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $manifestPath -Encoding UTF8

$results | ForEach-Object {
    [pscustomobject]@{
        rank = $_.rank
        character = $_.character
        selectedStages = @($_.stages | Where-Object status -eq "selected").Count
        missingStages = @($_.stages | Where-Object { $_.status -ne "selected" }).Count
    }
} | Group-Object selectedStages | Sort-Object Name | ForEach-Object {
    "selectedStages=$($_.Name): symbols=$($_.Count)"
}
"RECORDS=$($results.Count)"
"STAGE_SELECTIONS=$(@($results.stages | Where-Object status -eq 'selected').Count)"
"MANIFEST=$manifestPath"
