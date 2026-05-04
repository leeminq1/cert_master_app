Add-Type -AssemblyName System.Drawing

function Resize-Image($InputPath, $OutputPath, $Width, $Height) {
    $bmp = [System.Drawing.Image]::FromFile($InputPath)
    $newBmp = New-Object System.Drawing.Bitmap($Width, $Height)
    $g = [System.Drawing.Graphics]::FromImage($newBmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    
    $rect = New-Object System.Drawing.Rectangle(0, 0, $Width, $Height)
    $g.DrawImage($bmp, $rect)
    
    $newBmp.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    
    $g.Dispose()
    $newBmp.Dispose()
    $bmp.Dispose()
}

$workspace = "c:\Users\min21\Desktop\flutter_app_dev\cert_master"
$assetsDir = "$workspace\docs\playstore_assets"
if (!(Test-Path $assetsDir)) { New-Item -ItemType Directory -Path $assetsDir }

$iconInput = "$workspace\assets\images\app_icon.png"
$iconOutput = "$assetsDir\icon_512x512.png"
Resize-Image $iconInput $iconOutput 512 512

$featureInput = "C:\Users\min21\.gemini\antigravity\brain\e5a97299-4eb8-4c5a-a7f5-de8c3209d056\feature_graphic_info_style_1777864506075.png"
$featureOutput = "$assetsDir\feature_graphic_1024x500.png"
Resize-Image $featureInput $featureOutput 1024 500

Write-Output "Images successfully resized."
