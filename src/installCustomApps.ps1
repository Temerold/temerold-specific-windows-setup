### Install custom apps with WinGet

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

    if ($winGetArgs -contains '--nonadmin') {
        Write-Host "Running in non-admin mode for: $appId"
        $winGetArgs = $winGetArgs | Where-Object { $_ -ne '--nonadmin' }
        $winGetCommand = "winget $( $winGetArgs -join ' ' )"

        # Create a new PowerShell process with `runas` instead of `ShellExecute` to run in non-admin mode.
        # Running the script with PowerShell 7.5 (not the more commonly installed 5.1), `ShellExecute` inherits
        # elevation from the parent process, even when the child is 5.1. This works in both PowerShell 5.1 and 7.5.
        # https://www.reddit.com/r/sysadmin/comments/16kw85h/comment/k0ymmdo/
        runas /trustlevel:0x20000 "powershell `"${winGetCommand}`""

        continue
    }
    winget @winGetArgs

    # https://github.com/microsoft/winget-cli/blob/master/doc/windows/package-manager/winget/returnCodes.md
    # Exit code -1978335189 means that the app is already installed and has no available update.
    # Exit code -1978334956 means that the app is already installed but can't be upgraded by WinGet itself.
    # `Discord.Discord`, for example, exits with the message "The package cannot be upgraded using winget. Please
    # use the method provided by the publisher for upgrading this package."
    # Both exit codes imply that the app already is installed:
    if ( $LASTEXITCODE -in @(-1978335189, -1978334956) ) {
        Write-Host "✅ Already successfully installed: $appId" -ForegroundColor 'green'
    }
    elseif ( $LASTEXITCODE -eq 0 ) { Write-Host "✅ Successfully installed: $appId" -ForegroundColor 'green' }
    else { Write-Error "❌ Failed to install with exit code $( $LASTEXITCODE ): $appId" }
}
