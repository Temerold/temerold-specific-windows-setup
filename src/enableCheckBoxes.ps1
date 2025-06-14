### Enable check boxes

Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'AutoCheckSelect' -Value 1 -Force
Write-Host 'Enabled check boxes'
