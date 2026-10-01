$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$backgroundDirectory = Join-Path $repoRoot "Resources/Assets/Symbols/_StageBackgrounds"
$sourceCanvasSize = 512
$stageIDs = @("origin", "oracleBone", "bronze", "seal", "clerical", "regular")

foreach ($stageID in $stageIDs) {
  $sourcePath = Join-Path $backgroundDirectory "$stageID.png"
  $temporaryPath = Join-Path $backgroundDirectory "$stageID.normalized.png"
  $source = [System.Drawing.Bitmap]::new($sourcePath)
  $target = [System.Drawing.Bitmap]::new($sourceCanvasSize, $sourceCanvasSize, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $graphics = [System.Drawing.Graphics]::FromImage($target)

  try {
    $graphics.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
    $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graphics.Clear([System.Drawing.Color]::Transparent)

    # Measure the current visible panel so the tool remains safe to rerun after normalization.
    $minX = $source.Width
    $minY = $source.Height
    $maxX = -1
    $maxY = -1
    for ($y = 0; $y -lt $source.Height; $y++) {
      for ($x = 0; $x -lt $source.Width; $x++) {
        if ($source.GetPixel($x, $y).A -gt 8) {
          if ($x -lt $minX) { $minX = $x }
          if ($x -gt $maxX) { $maxX = $x }
          if ($y -lt $minY) { $minY = $y }
          if ($y -gt $maxY) { $maxY = $y }
        }
      }
    }
    if ($maxX -lt 0 -or $maxY -lt 0) { throw "No visible panel found in $stageID.png" }

    $visibleWidth = $maxX - $minX + 1
    $visibleHeight = $maxY - $minY + 1
    $scaleX = $sourceCanvasSize / [double]$visibleWidth
    $scaleY = $sourceCanvasSize / [double]$visibleHeight
    $destinationX = -$minX * $scaleX
    $destinationY = -$minY * $scaleY
    $destinationWidth = $sourceCanvasSize * $scaleX
    $destinationHeight = $sourceCanvasSize * $scaleY
    $destination = [System.Drawing.RectangleF]::new($destinationX, $destinationY, $destinationWidth, $destinationHeight)
    $sourceRectangle = [System.Drawing.Rectangle]::new(0, 0, $source.Width, $source.Height)

    $graphics.DrawImage($source, $destination, $sourceRectangle, [System.Drawing.GraphicsUnit]::Pixel)
    $target.Save($temporaryPath, [System.Drawing.Imaging.ImageFormat]::Png)
  }
  finally {
    $graphics.Dispose()
    $target.Dispose()
    $source.Dispose()
  }

  Move-Item -LiteralPath $temporaryPath -Destination $sourcePath -Force
  Write-Output "Normalized $stageID.png"
}
