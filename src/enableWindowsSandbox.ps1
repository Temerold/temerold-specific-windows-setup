### Enable Windows Sandbox

# Check Windows edition
$edition = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').EditionID
if ($edition -notin @('Professional', 'Enterprise', 'Education')) {
    Write-Error "Windows Sandbox is only supported on Pro, Enterprise, and Education editions. Current edition: $edition"
    exit 1
}

# Check if virtualization is enabled
if (-not (Get-CimInstance 'Win32_ComputerSystem' | Select-Object -ExpandProperty 'HypervisorPresent')) {
    Write-Warning 'Virtualization is not enabled. Please enable virtualization (VT-x / AMD-V) in your BIOS/UEFI settings.'
}

# Check if Containers-DisposableClientVM is available
$feature = Get-WindowsOptionalFeature -Online -FeatureName 'Containers-DisposableClientVM'
if (-not $feature) {
    Write-Error 'Windows Sandbox feature option not found: Containers-DisposableClientVM'
    exit 1
}

# Enable if not already enabled
if ($feature.State -eq 'Enabled') {
    Write-Host '✅ Windows Sandbox is already enabled.' -ForegroundColor 'green'
}
else {
    Write-Host 'Enabling Windows Sandbox...'
    Enable-WindowsOptionalFeature -Online -FeatureName 'Containers-DisposableClientVM' -All -NoRestart
    Write-Host '✅ Successfully enabled Windows Sandbox. Please restart the system to complete the process.' -ForegroundColor 'green'
}
