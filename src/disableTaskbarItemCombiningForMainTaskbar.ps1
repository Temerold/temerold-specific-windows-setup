### Disable taskbar item combining for main taskbar

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Value 2 -Force
Write-Host '✅ Disabled taskbar item combining for main taskbar' -ForegroundColor 'green'
