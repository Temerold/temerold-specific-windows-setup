### Install custom apps

param (
    # Don't install apps silently
    [switch] $loud = $false
)

# Check if WinGet is installed
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error 'WinGet is not installed. Please install it first.'
    exit 1
}

$apps = @(
    '7zip.7zip',
    'AntibodySoftware.WizTree',
    'Audacity.Audacity',
    'AudioRangerIT.AudioRanger',
    @( 'Blizzard.BattleNet', '--location', 'C:\Program Files (x86)\Battle.net' ),
    'BoanAnbo.ZoteroCitationPicker',
    'calibre.calibre',
    'CharlesMilette.TranslucentTB',
    'CrystalDewWorld.CrystalDiskInfo',
    'CrystalDewWorld.CrystalDiskMark',
    'Discord.Discord',
    'dotPDN.PaintDotNet',
    'Duplicati.Duplicati',
    'EpicGames.EpicGamesLauncher',
    'Git.Git',
    'GNU.Wget2',
    'Google.Chrome',
    'Gyan.FFmpeg',
    'JanDeDobbeleer.OhMyPosh',
    'KDE.Kdenlive',
    'KeePassXCTeam.KeePassXC',
    'Klocman.BulkCrapUninstaller',
    'LibreWolf.LibreWolf',
    'Microsoft.PowerShell',
    'Microsoft.Sysinternals',
    @(  'Microsoft.VisualStudioCode',
        '--override',
        '/mergetasks=!runcode,addcontextmenufiles,addcontextmenufolders /verysilent'),
    'MiniTool.PartitionWizard.Free',
    'Modrinth.ModrinthApp',
    'Mojang.MinecraftLauncher',
    'Mozilla.Firefox',
    'MusicBrainz.Picard',
    'OBSProject.OBSStudio',
    'OpenJS.NodeJS',
    'Oracle.VirtualBox',
    'Python.Python.3.13',
    'qBittorrent.qBittorrent',
    'RARLab.WinRAR',
    @('Spotify.Spotify', '--nonadmin'),
    'undergroundwires.privacy.sexy',
    'Valve.Steam',
    'VideoLAN.VLC',
    'yt-dlp.yt-dlp'
)

foreach ($app in $apps) {
    if ($app -is [array]) {
        $appId = $app[0]
        $additionalWinGetArgs = $app[1..$app.Length]
    }
    else {
        $appId = $app
        $additionalWinGetArgs = @()
    }
    Write-Host "Installing: $appId..."

    $winGetArgs = @(
        'install',
        '--id', $appId,
        '--exact',
        '--accept-source-agreements',
        '--accept-package-agreements',
        '--verbose-logs'
    ) + $additionalWinGetArgs
    if (-not $loud) { $winGetArgs += '--silent' }

    $isElevated = "S-1-5-32-544" -in [System.Security.Principal.WindowsIdentity]::GetCurrent().Groups
    if ('--nonadmin' -in $winGetArgs -and $isElevated) {
        Write-Host "Running in non-admin mode for: $appId"
        $winGetArgs = $winGetArgs | Where-Object { $_ -ne '--nonadmin' }
        $winGetCommand = "winget $( $winGetArgs -join ' ' )"

        # Create, immediately run, and finally remove a scheduled task installing the app.
        # This method seems to work consistently, independent of elevation when running this script.
        #
        # Prior attempts to make this work included creating a new PowerShell process with `runas`, which had
        # inconsistent success across fresh installs of Windows 11, and therefore has been abandoned. The main issue
        # is the new process inheriting elevation from the parent process. Read more in the Git history.
        $taskName = "Install $appId"
        $taskDescription = "Installs $appId with WinGet"
        $action = New-ScheduledTaskAction -Execute "powershell" -Argument "-Command `"$winGetCommand`""
        $trigger = New-ScheduledTaskTrigger -AtLogOn
        $userId = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
        $principal = New-ScheduledTaskPrincipal -UserId $userId -LogonType Interactive

        if (Get-ScheduledTask | Where-Object { $_.TaskName -eq $taskName }) {
            Unregister-ScheduledTask -TaskName $taskName -Confirm 0
        }
        Register-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -TaskName $taskName -Description $taskDescription | Out-Null
        Start-ScheduledTask -TaskName $taskName
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
        $LASTEXITCODE = 0
    }
    else {
        $winGetArgs = $winGetArgs | Where-Object { $_ -ne '--nonadmin' }
        winget @winGetArgs
    }

    # https://github.com/microsoft/winget-cli/blob/master/doc/windows/package-manager/winget/returnCodes.md
    # Exit code -1978335189 means that the app is already installed and has no available update.
    # Exit code -1978334956 means that the app is already installed but can't be upgraded by WinGet itself.
    # `Discord.Discord`, for example, exits with the message "The package cannot be upgraded using winget. Please
    # use the method provided by the publisher for upgrading this package."
    # Both exit codes imply that the app already is installed:
    if ( $LASTEXITCODE -in @(-1978335189, -1978334956) ) {
        Write-Host "✅ Already successfully installed: $appId" -ForegroundColor Green
    }
    elseif ( $LASTEXITCODE -eq 0 ) { Write-Host "✅ Successfully installed: $appId" -ForegroundColor Green }
    else { Write-Error "❌ Failed to install with exit code $( $LASTEXITCODE ): $appId" }
}
