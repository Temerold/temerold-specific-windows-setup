### Left align taskbar

Set-ItemProperty -Path HKCU:\software\microsoft\windows\currentversion\explorer\advanced -Name 'TaskbarAl' -Type 'DWord' -Value 0
Write-Host '✅ Left-aligned taskbar' -ForegroundColor Green
