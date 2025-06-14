### Add custom shortcuts to desktop

# Check if PowerShell version 7 or higher is being used
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Error 'This script requires PowerShell version 7 or higher'
    exit 1
}

$desktopPath = [System.Environment]::GetFolderPath('Desktop')
$lagringPath = 'S:\'
$lagringShortcuts = @(
    @{  Name   = 'Lagring'
        Target = $lagringPath 
    },
    @{  Name   = 'Program'
        Target = Join-Path -Path $lagringPath -ChildPath 'Program'
    },
    @{  Name   = 'Dokument'
        Target = Join-Path -Path $lagringPath -ChildPath 'Dokument'
    },
    @{  Name   = 'Böcker'
        Target = Join-Path -Path $lagringPath -ChildPath 'Böcker'
    },
    @{  Name   = 'Musik'
        Target = Join-Path -Path $lagringPath -ChildPath 'Musik'
    },
    @{  Name   = 'Film'
        Target = Join-Path -Path $lagringPath -ChildPath 'Film'
    },
    @{  Name   = 'Memes'
        Target = Join-Path -Path $lagringPath -ChildPath 'Memes'
    },
    @{  Name   = 'Bilder'
        Target = Join-Path -Path $lagringPath -ChildPath 'Bilder'
    },
    @{  Name   = 'Övrigt'
        Target = Join-Path -Path $lagringPath -ChildPath 'Övrigt'
    }
)

foreach ($shortcut in $lagringShortcuts) {
    $WshShell = New-Object -ComObject 'WScript.Shell'
    $shortcutPath = Join-Path -Path $desktopPath -ChildPath "$($shortcut.Name).lnk"
    $shortcutObject = $WshShell.CreateShortcut($shortcutPath)

    # Continue if the shortcut already exists with the same target
    if ((Test-Path -Path $shortcutPath) -and ($shortcutObject.TargetPath -eq $shortcut.Target)) {
        Write-Host "Shortcut already exists: $( $shortcut.Name ) -> $( $shortcut.Target )"
        continue
    }

    # Create or overwrite the shortcut
    $shortcutObject.TargetPath = $shortcut.Target
    $shortcutObject.Save()

    Write-Host "Created shortcut: $( $shortcut.Name ) -> $( $shortcut.Target )"
}
