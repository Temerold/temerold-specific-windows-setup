### Disable taskbar item combining for secondary taskbars

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarGlomLevel" -Value 2 -Force
Write-Host '✅ Disabled taskbar item combining for secondary taskbars' -ForegroundColor Green
