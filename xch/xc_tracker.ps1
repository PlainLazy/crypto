$plotter_log = 'logs'  # original plotter log-file or logs-folder (last-modyfied *.log file will be used in case of folder)
$tracker_log = 'track.log'  # log file
$drive_letters = 'Z,D'  # space separated listof disk-letters for tracking
$cooldown = 20  # seconds

function Current-Timestamp {
    [int](Get-Date -UFormat '%s')
}

function Seconds-Passed {
    $(Current-Timestamp) - $i_stime
}

function Track-Log {
    param($t)
    Write-Host $t
    Add-Content -Path $tracker_log -Value $t
}

function Get-Disk-ReadWriteBytes {
    param($letter)
    $d = Get-WmiObject -class Win32_PerfRawData_PerfDisk_LogicalDisk -filter ("name='$letter" + ":'")
    return ([Double]$d.DiskReadBytesPersec, [Double]$d.DiskWriteBytesPersec)
}

$i_stime = Current-Timestamp

if ((Get-Item $plotter_log) -is [System.IO.DirectoryInfo]) {
    # it is folder
    # getting last modyfied file
    Write-Host "* plotter_log ""$plotter_log"" is folder"
    $t_lm_file = (
        Get-ChildItem -Attributes !Directory "$plotter_log\*.log" |
        Sort-Object -Descending -Property LastWriteTime |
        Select -First 1
    ).Name
    $plotter_log += "\$t_lm_file"
}

Write-Host "* tracking ""$plotter_log"" file"

if (!(Test-Path -Path $plotter_log)) {
    Write-Host "plotter_log ""$plotter_log"" does not exists"
    Exit
}

$i_log_index = 0
$l_letters = $drive_letters -Split ','
$h_disk_rw = @{}

# init disks statistics
$l_letters.forEach({
    $h_disk_rw[$_] = Get-Disk-ReadWriteBytes($_)
})

while (1) {
    
    [string[]]$l_log_actual = Get-Content -Path $plotter_log

    # handling plotter log newlines
    $i_last_index = $l_log_actual.Count
    For ($i = [math]::Max($i_log_index, $i_last_index - 1); $i -lt $i_last_index; $i++) {
        Track-Log $l_log_actual[$i]
    }
    $i_log_index = $i_last_index

    $l_data = @()

    # cpu usage [0..100]
    $l_data += [math]::Round((Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue)

    # free ram (MiB)
    $l_data += [math]::Round((Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue)

    # disks
    $l_letters.forEach({

        # disk used (MiB)
        $l_data += [math]::Round((Get-PSDrive $_).Used / [math]::Pow(1024,2))

        # disk readed/wited (MiB)
        ($f_read, $f_write) = Get-Disk-ReadWriteBytes($_)
        $l_data += [math]::Round(($f_read - $h_disk_rw[$_][0]) / [math]::Pow(1024,2))
        $l_data += [math]::Round(($f_write - $h_disk_rw[$_][1]) / [math]::Pow(1024,2))
        $h_disk_rw[$_] = ($f_read, $f_write)

    })
    
    Track-Log "$(Seconds-Passed)`t$($l_data -join "`t")"
    Start-Sleep -seconds $cooldown

}