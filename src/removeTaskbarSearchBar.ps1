### Remove taskbar search bar

Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Name 'SearchboxTaskbarMode' -Type 'DWord' -Value 0
Write-Host '✅ Removed taskbar search bar' -ForegroundColor 'green'
