Add-Type -AssemblyName System.Drawing

function Get-ResizedBase64($path) {
    $img = [System.Drawing.Image]::FromFile($path)
    
    # Calculate crop to center (preserve aspect ratio, object-fit: cover)
    $ratio = $img.Width / $img.Height
    $targetWidth = 300
    $targetHeight = 300
    $srcRect = [System.Drawing.Rectangle]::new(0, 0, $img.Width, $img.Height)
    
    if ($ratio -gt 1) {
        # Wider than tall
        $newWidth = [int]($img.Height * 1) # target ratio 1:1
        $srcRect.X = [int](($img.Width - $newWidth) / 2)
        $srcRect.Width = $newWidth
    } elseif ($ratio -lt 1) {
        # Taller than wide
        $newHeight = [int]($img.Width / 1)
        $srcRect.Y = [int](($img.Height - $newHeight) / 2)
        $srcRect.Height = $newHeight
    }
    
    $bmp = [System.Drawing.Bitmap]::new($targetWidth, $targetHeight)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $destRect = [System.Drawing.Rectangle]::new(0, 0, $targetWidth, $targetHeight)
    $g.DrawImage($img, $destRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)
    
    $ms = [System.IO.MemoryStream]::new()
    $bmp.Save($ms, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    
    $bytes = $ms.ToArray()
    $base64 = [Convert]::ToBase64String($bytes)
    
    $g.Dispose()
    $bmp.Dispose()
    $img.Dispose()
    $ms.Dispose()
    
    return "data:image/jpeg;base64," + $base64
}

$b1 = Get-ResizedBase64("d:\Projects\Gokerwow\assets\001_260513_Hearts2Hearts_Instagram_Update_-_Carmen-1.jpg")
$b2 = Get-ResizedBase64("d:\Projects\Gokerwow\assets\001_260517_Ian_at_Asia_Star_Entertainer_Awards-1.png")
$b3 = Get-ResizedBase64("d:\Projects\Gokerwow\assets\WhatsApp Image 2025-12-21 at 9.57.53 AM (3).jpeg")

$svg = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 300 350" width="300" height="350" xmlns:xlink="http://www.w3.org/1999/xlink">
  <style>
    .slide {
      opacity: 0;
      animation: fade 12s infinite ease-in-out;
      transform-origin: 150px 140px;
    }
    .slide-1 {
      animation-delay: 0s;
    }
    .slide-2 {
      animation-delay: 4s;
    }
    .slide-3 {
      animation-delay: 8s;
    }
    
    @keyframes fade {
      0%, 100% {
        opacity: 0;
        transform: scale(0.95);
      }
      4%, 28% {
        opacity: 1;
        transform: scale(1);
      }
      33.3%, 96% {
        opacity: 0;
        transform: scale(0.95);
      }
    }
    .name-text {
      font-family: 'Outfit', 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      font-size: 20px;
      font-weight: 700;
      fill: #ffffff;
      text-shadow: 0 0 10px rgba(169, 112, 255, 0.5);
    }
    .group-text {
      font-family: 'Outfit', 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      font-size: 11px;
      font-weight: 600;
      letter-spacing: 2px;
      fill: #00D2FF;
      text-shadow: 0 0 5px rgba(0, 210, 255, 0.5);
    }
  </style>
  <defs>
    <linearGradient id="borderGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#A970FF" />
      <stop offset="100%" stop-color="#00D2FF" />
    </linearGradient>
    <clipPath id="circleView">
      <circle cx="150" cy="140" r="116" />
    </clipPath>
  </defs>
  
  <!-- Outer glowing border -->
  <circle cx="150" cy="140" r="118" fill="none" stroke="url(#borderGrad)" stroke-width="4" />
  
  <!-- Slide 1: Carmen -->
  <g class="slide slide-1">
    <g clip-path="url(#circleView)">
      <image xlink:href="$b1" x="30" y="20" width="240" height="240" />
    </g>
    <text class="name-text" x="150" y="300" text-anchor="middle">Carmen</text>
    <text class="group-text" x="150" y="322" text-anchor="middle">HEARTS2HEARTS</text>
  </g>
  
  <!-- Slide 2: Ian -->
  <g class="slide slide-2">
    <g clip-path="url(#circleView)">
      <image xlink:href="$b2" x="30" y="20" width="240" height="240" />
    </g>
    <text class="name-text" x="150" y="300" text-anchor="middle">Ian</text>
    <text class="group-text" x="150" y="322" text-anchor="middle">HEARTS2HEARTS</text>
  </g>
  
  <!-- Slide 3: Yuna -->
  <g class="slide slide-3">
    <g clip-path="url(#circleView)">
      <image xlink:href="$b3" x="30" y="20" width="240" height="240" />
    </g>
    <text class="name-text" x="150" y="300" text-anchor="middle">Yuna</text>
    <text class="group-text" x="150" y="322" text-anchor="middle">ITZY</text>
  </g>
</svg>
"@ 

[System.IO.File]::WriteAllText("d:\Projects\Gokerwow\biases_v2.svg", $svg, [System.Text.Encoding]::UTF8)

Write-Host "Success"
