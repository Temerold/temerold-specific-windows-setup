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
    #'7zip.7zip',
    #'AntibodySoftware.WizTree',
    #'Audacity.Audacity',
    #'AudioRangerIT.AudioRanger',
    #@( 'Blizzard.BattleNet', '--location', 'C:\Program Files (x86)\Battle.net' ),
    #'BoanAnbo.ZoteroCitationPicker',
    #'calibre.calibre',
    #'CrystalDewWorld.CrystalDiskInfo',
    #'CrystalDewWorld.CrystalDiskMark',
    #'Discord.Discord',
    #'dotPDN.PaintDotNet',
    #'Duplicati.Duplicati',
    #'EpicGames.EpicGamesLauncher',
    #'Git.Git',
    #'GNU.Wget2',
    #'Google.Chrome',
    #'Gyan.FFmpeg',
    #'KDE.Kdenlive',
    #'KeePassXCTeam.KeePassXC',
    #'Klocman.BulkCrapUninstaller',
    #'LibreWolf.LibreWolf',
    #'Microsoft.PowerShell',
    #'Microsoft.Sysinternals',
    #@(  'Microsoft.VisualStudioCode',
    #    '--override',
    #    '/mergetasks=!runcode,addcontextmenufiles,addcontextmenufolders /verysilent'),
    #'MiniTool.PartitionWizard.Free',
    #'Modrinth.ModrinthApp',
    #'Mojang.MinecraftLauncher',
    #'Mozilla.Firefox',
    #'MusicBrainz.Picard',
    #'OBSProject.OBSStudio',
    #'OpenJS.NodeJS',
    #'Oracle.VirtualBox',
    #'Python.Python.3.13',
    #'qBittorrent.qBittorrent',
    #'RARLab.WinRAR',
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
        # When ran with PowerShell 7.5 (not the more commonly installed 5.1), `ShellExecute` inherits elevation
        # from the parent process, even when the child is 5.1, thus the use of `runas`, which works in
        # both versions. https://www.reddit.com/r/sysadmin/comments/16kw85h/comment/k0ymmdo/
        #
        # FURTHERMORE, due to a known bug not fixed until PowerShell 7.3.0 when passing embedded quotes in
        # arguments passed to external programs, double quotes (") can't be escaped using double quotes (" -> "").
        # Instead, we have to use backslashes (\) AND double quotes. However, this hotfix doesn't work in versions
        # >= 7.3.0, and so we have to use `$PSNativeCommandArgumentPassing = 'Legacy'` to make sure that all
        # versions handles it as the old, incorrect ones would.
        # https://stackoverflow.com/questions/24745868/powershell-passing-json-string-to-curl/66837948#66837948
        # https://stackoverflow.com/questions/74440303/powershell-7-3-0-breaking-command-invocation/74440425#74440425
        # https://stackoverflow.com/questions/59036580/pwsh-command-is-removing-quotation-marks/59036879#59036879
        # https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-7.5#psnativecommandargumentpassing
        $PSNativeCommandArgumentPassing = 'Legacy'
        runas /trustlevel:0x20000 "powershell -Command \""$winGetCommand\"""


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
