### Save desktop icon layout

Stop-Process -Name 'Explorer' | Out-Null
$desktopPath = [Environment]::GetFolderPath('Desktop')
Remove-Item (Join-Path $desktopPath 'desktop.ini')
$desktopIconLayout = (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\Shell\Bags\1\Desktop').IconLayouts
$base64 = [Convert]::ToBase64String($desktopIconLayout)
Set-Content -Value $base64 -Path '.\CustomIconLayout.b64'
Write-Output $base64
Write-Host '✅ Saved the above desktop icon layout to ''CustomIconLayout.b64''' -ForegroundColor 'green'
