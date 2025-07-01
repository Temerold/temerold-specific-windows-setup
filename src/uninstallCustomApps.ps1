### Uninstall custom apps

$appxApps = @(
    'Microsoft.BingNews',
    'Microsoft.BingSearch'
    'Microsoft.Copilot',
    'Microsoft.GetHelp',
    'Microsoft.MicrosoftOfficeHub',
    'Microsoft.MicrosoftSolitaireCollection',
    'Microsoft.MicrosoftStickyNotes',
    'Microsoft.OutlookForWindows',
    'Microsoft.Paint',
    'Microsoft.QuickAssist',
    'Microsoft.StartExperiencesApp'
    'Microsoft.WindowsCamera',
    'Microsoft.WindowsFeedbackHub',
    'MicrosoftWindows.Client.WebExperience'
)

foreach ($app in $appxApps) {
    Write-Host "Uninstalling: $app..."

    try {
        Get-AppxPackage -Name $app | Remove-AppxPackage -ErrorAction Stop
        Write-Host "✅ Successfully uninstalled: $app" -ForegroundColor Green
    }
    catch {
        Write-Error "❌ Failed to uninstall: $app. Error: $_"
    }
}
