@echo off
cd /d "%~dp0"

powershell -Command "Write-Host 'Starting Temerold-specific Windows setup' -ForegroundColor 'cyan'"

echo Installing Microsoft.PowerShell...
winget install --id Microsoft.PowerShell --exact --accept-source-agreements --accept-package-agreements --verbose-logs

set "powershell=pwsh"
: set "powershell=powershell" : Uncomment this line if you want to use the built-in PowerShell where possible
:: 1. App installation and uninstallation
%powershell% -File src\installCustomApps.ps1
: pwsh -File src\installMicrosoftOffice.ps1
%powershell% -File src\uninstallCustomApps.ps1


:: 1. Non-interfering
%powershell% -File src\applyCustomDpiScaling.ps1
: %powershell% -File src\addCustomDirectoryToPath.ps1
: %powershell% -File src\applyCustomVolumeLettersAndLabels.ps1
%powershell% -File src\disableHibernation.ps1
%powershell% -File src\disableTaskbarItemCombiningForMainTaskbar.ps1
%powershell% -File src\disableTaskbarItemCombiningForSecondaryTaskbars.ps1
%powershell% -File src\disableTaskbarTaskView.ps1
%powershell% -File src\enableDeveloperMode.ps1
%powershell% -File src\enableSecondsInSystemClock.ps1
%powershell% -File src\enableTaskbarEndTask.ps1
%powershell% -File src\enableWindowsSandbox.ps1
%powershell% -File src\leftAlignTaskbar.ps1
%powershell% -File src\removeTaskbarSearchBar.ps1
%powershell% -File src\setVisualStudioCodeAsDefaultGitEditor.ps1
%powershell% -File src\showEmptyDrives.ps1


:: 2. Requiring Explorer restart
%powershell% -File src\colorEncryptedAndCompressedNtfsFiles.ps1
%powershell% -File src\enableCheckBoxes.ps1
%powershell% -File src\showFileExtensions.ps1
%powershell% -File src\showHiddenFiles.ps1
: %powershell% -File src\showSuperHiddenFiles.ps1

taskkill /f /im explorer
explorer


:: 3. Desktop-related
: pwsh -File src\addCustomShortcutsToDesktop.ps1
: %powershell% -File src\createCustomShellFolders.ps1
: %powershell% -File src\applyCustomDesktopIconLayout.ps1


:: 4. Requiring app install
%powershell% -File src\addCustomGitIdentity.ps1
%powershell% -File src\disableGitSafeDirectories.ps1
%powershell% -File src\disableStartupProcesses.ps1

pause
shutdown /r /t 0
