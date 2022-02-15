$plotter_log = 'logs'  # original plotter log-file or logs-folder (last-modyfied *.log file will be used in case of folder)
$tracker_log = 'freespace_track.log'  # log file
$drive_letters = 'D,Z'  # disk drives for tracking free space
$cooldown = 10  # seconds

function Current-Timestamp {
    [int](Get-Date -UFormat '%s')
}

function Seconds-Passed {
    $(Current-Timestamp) - $i_stime
}

function Bytes-To-GiB {
    param($i_bytes)
    [math]::Round($i_bytes / [math]::Pow(1024,3), 2)
}

function Track-Log {
    param($t)
    Write-Host $t
    Add-Content -Path $tracker_log -Value $t
}

$i_stime = Current-Timestamp
$i_log_index = 0
$l_letters = $drive_letters -Split ','

if ((Get-Item $plotter_log) -is [System.IO.DirectoryInfo]) {
    # it is folder
    # getting last modyfied file
    Write-Host "* plotter_log ""$plotter_log"" is folder"
    $t_lm_file = (
        Get-ChildItem -Attributes !Directory "$plotter_log\*.log" |
        Sort-Object -Descending -Property LastWriteTime |
        Select -First 1 |
        Format-Table "Name" -HideTableHeaders |
        Out-String
    ) -replace '[\r\n]',''
    $plotter_log += "\$t_lm_file"
}

Write-Host "* tracking ""$plotter_log"" file"

if (!(Test-Path -Path $plotter_log)) {
    Write-Host "plotter_log ""$plotter_log"" does not exists"
    Exit
}

while (1) {
    
    [string[]]$l_log_actual = Get-Content -Path $plotter_log

    # handling newlines from plotter log
    $i_last_index = $l_log_actual.Count
    For ($i = [math]::Max($i_log_index, $i_last_index - 1); $i -lt $i_last_index; $i++) {
        Track-Log $l_log_actual[$i]
    }
    $i_log_index = $i_last_index

    # fetching free spaces
    $l_free_spaces = @()
    $l_letters.forEach({
        $l_free_spaces += Bytes-To-GiB(
            (Get-PSDrive $_ | Format-Table "used" -HideTableHeaders | Out-String) -replace '[^0-9]',''
        )
    })
    
    Track-Log "$(Seconds-Passed), $($l_free_spaces -join ', ')"
    Start-Sleep -seconds $cooldown

}