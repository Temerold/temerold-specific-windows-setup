### Show empty drives

Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideDrivesWithNoMedia' -Value 0 -Force
Write-Output 'Enabled showing empty drives'
