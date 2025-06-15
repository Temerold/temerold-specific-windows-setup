### Create custom shell folders

$registryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel'
$registryProperties = Get-ItemProperty -Path $registryPath

# Remove all shell folders
foreach ($property in $registryProperties.PSObject.Properties) {
    if ($property.Name -in @('PSChildName', 'PSDrive', 'PSParentPath', 'PSPath', 'PSProvider')) { continue }
    Set-ItemProperty -Path $registryPath -Name $property.Name -Value 1 -Force
}

$desktopIcons = @(
    '{20D04FE0-3AEA-1069-A2D8-08002B30309D}', # Computer/This PC
    '{645FF040-5081-101B-9F08-00AA002F954E}'  # Recycle bin
)

foreach ($propertyName in $desktopIcons) {
    Set-ItemProperty -Path $registryPath -Name $propertyName -Value 0 -Force
}

Stop-Process -Name 'Explorer'

Write-Host '✅ Created custom shell folders on desktop' -Foregroundcolor Green
