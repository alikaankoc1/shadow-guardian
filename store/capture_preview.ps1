# Capture Play Store landscape previews (Chrome).
# Usage:
#   powershell -ExecutionPolicy Bypass -File store/capture_preview.ps1 phone
#   powershell -ExecutionPolicy Bypass -File store/capture_preview.ps1 tablet

param(
  [ValidateSet('phone', 'tablet')]
  [string]$Device = 'phone'
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

$size = if ($Device -eq 'phone') { '1920,1080' } else { '1920,1200' }
$outDir = Join-Path $root "store\screenshots\$Device"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

Write-Host ""
Write-Host "Sevimli Golgeler - $Device preview ($size)" -ForegroundColor Cyan
Write-Host "Chrome acilacak. Sahneleri gez."
Write-Host ""
Write-Host "Yakalama: Win+Shift+S ile pencereyi kirp," -ForegroundColor Yellow
Write-Host "sonra kaydet:" -ForegroundColor Yellow
Write-Host "  store/screenshots/$Device/01_start.png"
Write-Host "  store/screenshots/$Device/02_worlds.png"
Write-Host "  store/screenshots/$Device/03_play.png"
Write-Host "  store/screenshots/$Device/04_complete.png"
Write-Host ""
Write-Host "(flutter screenshot Chrome'da calismaz.)" -ForegroundColor DarkYellow
Write-Host "Cikti klasoru: $outDir"
Write-Host ""

flutter run -d chrome --web-browser-flag "--window-size=$size"
