### Save desktop icon layout

Stop-Process -Name "Explorer"
$desktopIconLayout = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\Shell\Bags\1\Desktop").IconLayouts
$b64 = [Convert]::ToBase64String($desktopIconLayout)
Set-Content -Value $b64 -Path ".\CustomIconLayout.b64"
Write-Output $b64
