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
    'Microsoft.Powershell',
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
    'PeterPawlowski.foobar2000',
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
        runas /trustlevel:0x20000 "PowerShell `"${winGetCommand}`""

        continue
    }
    else { winget @winGetArgs }

    if ($LASTEXITCODE -ne 0) { Write-Error "Failed to install: $appId" }
    else { Write-Host "✅ Successfully installed: $appId"  -ForegroundColor 'green' }
}
