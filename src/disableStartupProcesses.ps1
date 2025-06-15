### Disable startup processes

$runKeys = @(
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run',
    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run',
    'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run'
)

foreach ($key in $runKeys) {
    try {
        $processes = Get-ItemProperty -Path $key
        foreach ($property in $processes.PSObject.Properties) {
            if ($property.Name -in @('PSPath', 'PSParentPath', 'PSChildName', 'PSDrive', 'PSProvider')) { continue }
            try {
                Remove-ItemProperty -Path $key -Name $property.Name
                Write-Host "✅ Disabled startup process: $( $property.Name )" -ForegroundColor "green"
            }
            catch {
                Write-Error "Could not disable startup process: $( $property.Name )"
            }
        }
    }
    catch {
        Write-Error "Could not access registry key: $key"
    }
}

$startupDirs = @(
    "$env:AppData\Microsoft\Windows\Start Menu\Programs\Startup",
    "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
)

$removalAttempts = 0
$maxRemovalAttempts = 5
$delayMilliseconds = 100
foreach ($dir in $startupDirs) {
    if (Test-Path -Path $dir) {
        Get-ChildItem -Path $dir | ForEach-Object {
            do {
                Remove-Item -Path $_.FullName -Force
                $removalAttempts++
                Start-Sleep -Milliseconds $delayMilliseconds
            } while ((Test-Path -Path $_.FullName) -and ($removalAttempts -lt $maxRemovalAttempts))
            if (Test-Path -Path $_.FullName) {
                Write-Error "Could not disable startup process: $( $_.Name )"
                continue
            }
            Write-Host "✅ Disabled startup process: $( $_.Name )" -ForegroundColor "green"
        }
    }
}
