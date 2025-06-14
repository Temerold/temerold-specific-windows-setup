### Enable developer mode

Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Value 1
Write-Output "Enabled Developer Mode"
