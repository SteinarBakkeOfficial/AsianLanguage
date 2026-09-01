param(
  [Parameter(Mandatory = $true)]
  [string]$InputPath,
  [Parameter(Mandatory = $true)]
  [string]$OutputPath
)

$ErrorActionPreference = "Stop"

# Windows CI images do not always include the Python/Pillow helper used by the
# image-generation skill. Keep this local fallback deterministic and limited
# to the flat green key used by generated educational illustrations.
Add-Type -AssemblyName System.Drawing

$source = [System.Drawing.Bitmap]::new($InputPath)
$target = [System.Drawing.Bitmap]::new($source.Width, $source.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$graphics = [System.Drawing.Graphics]::FromImage($target)
$graphics.DrawImageUnscaled($source, 0, 0)
$graphics.Dispose()

$rectangle = [System.Drawing.Rectangle]::new(0, 0, $target.Width, $target.Height)
$data = $target.LockBits($rectangle, [System.Drawing.Imaging.ImageLockMode]::ReadWrite, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$byteCount = [Math]::Abs($data.Stride) * $data.Height
$buffer = New-Object byte[] $byteCount
[System.Runtime.InteropServices.Marshal]::Copy($data.Scan0, $buffer, 0, $byteCount)

for ($index = 0; $index -lt $buffer.Length; $index += 4) {
  $blue = $buffer[$index]
  $green = $buffer[$index + 1]
  $red = $buffer[$index + 2]
  $greenExcess = [int]$green - [Math]::Max($red, $blue)

  if ($green -gt 150 -and $greenExcess -gt 55) {
    $buffer[$index + 3] = 0
  } elseif ($green -gt 120 -and $greenExcess -gt 28) {
    $buffer[$index + 3] = [byte][Math]::Max(0, [Math]::Min(255, 255 - (($greenExcess - 28) * 8)))
  }
}

[System.Runtime.InteropServices.Marshal]::Copy($buffer, 0, $data.Scan0, $byteCount)
$target.UnlockBits($data)
$target.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
$source.Dispose()
$target.Dispose()

Write-Output "OK: removed chroma key from $InputPath"
