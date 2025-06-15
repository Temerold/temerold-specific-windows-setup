### Apply custom volume letters and labels

$volumes = @(
    @{  Letter   = 'C';
        Label    = 'Local Disk';
        DeviceId = '\\?\Volume{2c4ae0c4-4f69-4737-81b7-c0bb138500cb}\'
    },
    @{  Letter   = 'D';
        Label    = 'Back-up HDD';
        DeviceId = '\\?\Volume{bd291e51-0000-0000-0000-100000000000}\'
    },
    @{  Letter   = 'E';
        Label    = 'Back-up SSD';
        DeviceId = '\\?\Volume{34833919-0000-0000-0000-000000000000}\'
    },
    @{  Letter   = 'S';
        Label    = 'Lagring';
        DeviceId = '\\?\Volume{d37a7990-6079-01db-c83c-bde93cb0ed00}\'
    }
)

ForEach ($volume in $volumes) {
    $volumeInstance = Get-CimInstance -ClassName 'Win32_Volume' | Where-Object {
        $_.DeviceID -eq $volume['DeviceId']
    }
    $currentLetter = $volumeInstance.DriveLetter.TrimEnd(':')
    $currentLabel = $volumeInstance.Label

    if ($currentLetter -ne $volume['Letter']) {
        Set-Partition -DriveLetter $currentLetter -NewDriveLetter $volume['Letter']
        Write-Host "✅ Changed volume $( $volume['DeviceId'] ) letter from $currentLetter to $( $volume['Letter'] )" -Foregroundcolor Green
    }

    if ($currentLabel -ne $volume['Label']) {
        Set-Volume -UniqueId $volumeInstance.DeviceID -NewFileSystemLabel $volume['Label']
        Write-Host "✅ Changed volume $( $volume['DeviceId'] ) label from $currentLabel to $( $volume['Label'] )" -Foregroundcolor Green
    }
}
