### Add custom shortcuts to desktop

# Check if PowerShell version 7 or higher is being used
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Error 'This script requires PowerShell version 7 or higher'
    exit 1
}

$desktopPath = [System.Environment]::GetFolderPath('Desktop')
$lagringPath = 'S:'
$lagringShortcuts = @(
    @{ Name = 'Lagring'; Target = $lagringPath },
    @{ Name = 'Program'; Target = "$lagringPath\Program" },
    @{ Name = 'Dokument'; Target = "$lagringPath\Dokument" },
    @{ Name = 'Böcker'; Target = "$lagringPath\Böcker" },
    @{ Name = 'Musik'; Target = "$lagringPath\Musik" },
    @{ Name = 'Film'; Target = "$lagringPath\Film" },
    @{ Name = 'Memes'; Target = "$lagringPath\Memes" },
    @{ Name = 'Bilder'; Target = "$lagringPath\Bilder" },
    @{ Name = 'Övrigt'; Target = "$lagringPath\Övrigt" }
)

foreach ($shortcut in $lagringShortcuts) {
    $shortcutPath = Join-Path -Path $desktopPath -ChildPath "$( $shortcut.Name ).lnk"
    Write-Output "Processing shortcut: $( $shortcut.Name ) -> $( $shortcut.Target )"
    if (-not (Test-Path -Path $shortcutPath)) {
        $WshShell = New-Object -ComObject WScript.Shell
        $shortcutObject = $WshShell.CreateShortcut($shortcutPath)
        $shortcutObject.TargetPath = $shortcut.Target
        $shortcutObject.Save()
        Write-Output "Created shortcut: $( $shortcut.Name ) -> $( $shortcut.Target )"
    }
    else { Write-Output "Shortcut already exists: $( $shortcut.Name )" }
}
