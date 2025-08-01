### Disable taskbar task view

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0 -Force
Write-Host '✅ Disabled taskbar task view' -ForegroundColor Green
