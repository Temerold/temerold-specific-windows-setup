### Enable seconds in system clock

Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSecondsInSystemClock' -Value 1 -Force
Write-Host 'Enabled seconds in system clock'
