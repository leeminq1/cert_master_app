Add-Type -AssemblyName System.Drawing

$InputPath = "c:\Users\min21\Desktop\flutter_app_dev\cert_master\assets\images\app_icon.png"
$OutputPath1 = "c:\Users\min21\Desktop\flutter_app_dev\cert_master\assets\images\app_icon.png"
$OutputPath2 = "c:\Users\min21\Desktop\flutter_app_dev\cert_master\docs\playstore_assets\icon_512x512.png"

# Read image fully into memory so we can overwrite the same file
$fs = New-Object System.IO.FileStream($InputPath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
$bmp = [System.Drawing.Image]::FromStream($fs)
$fs.Close()

$cropX = 50
$cropY = 50
$cropWidth = $bmp.Width - ($cropX * 2)
$cropHeight = $bmp.Height - ($cropY * 2)

$newBmp = New-Object System.Drawing.Bitmap(512, 512)
$g = [System.Drawing.Graphics]::FromImage($newBmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

$destRect = New-Object System.Drawing.Rectangle(0, 0, 512, 512)
$srcRect = New-Object System.Drawing.Rectangle($cropX, $cropY, $cropWidth, $cropHeight)

$g.DrawImage($bmp, $destRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)

$newBmp.Save($OutputPath1, [System.Drawing.Imaging.ImageFormat]::Png)
$newBmp.Save($OutputPath2, [System.Drawing.Imaging.ImageFormat]::Png)

$bmp.Dispose()
$g.Dispose()
$newBmp.Dispose()

Write-Output "Icon cropped successfully."
