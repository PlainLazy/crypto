$size = 34  # 32 or 33 or 34
$threads = 4
$buckets = 256
$temp_dir_2 = 'Z:\'  # tmpdir2 (fast drive, ramdisk/nvme, requirements: k33 ~232GiB, k34 ~458GiB)
$temp_dir_t = 'D:\temp\'  # tmpdir (slow drive, ssd/hdd, requirements: k33 ~402GiB, k34 ~820GiB)
$finaldir = 'H:\chia\'
$contract = '...'  # 62 chars ("chia plotnft show" -> "Pool contract address")
$farmerkey = '...'  # 48 bytes ("chia keys show" -> "Farmer public key")
$logs_folder = 'logs'
$repeat_file = '__loop__'  # if this file exists, the plotting will be repeated. delete or rename the file to prevent repeats
$cooldown = 30  # seconds

$host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name

if (!(Test-Path $logs_folder)) {
    $t = (New-Item -ItemType Directory -Force -Path $logs_folder)
}
$base_path = (Get-Location).Path
$logs_path = $base_path + '\' + $logs_folder

function Write-Log ($t) {
    Write-Host ((Get-Date).ToLocalTime().ToString('yyyy-MM-dd HH:mm:ss') + ' ' + $t)
}

function Get-Drive-Info ($path) {
    $drive_letter = $path.Substring(0, 2)
    $volume = (
        Get-CimInstance -ClassName Win32_Volume |
        Where-Object -filter {$_.DriveLetter -eq $drive_letter}
    )
    $freeGiB = [math]::Round($volume.FreeSpace / [math]::Pow(1024, 3), 2)
    return "$path freeSpace $freeGiB GiB, blockSize $($volume.BlockSize)"
}

function Rename-Log ($log_file_path) {
    
    # log content
    $content = (Get-Content $log_file_path) -join ';'

    # plot full name
    $m = ([Regex]'Plot Name: (((?!;).)+)').Matches($content)
    $plot_name = if ($m.Success) { $m.Groups[1].Value }

    # plot creation time
    $m = ([Regex]'Total plot creation time was ([0-9\.]+) sec').Matches($content)
    [double] $creation_time = if ($m.Success) { try { $m.Groups[1].Value } catch { 0 } }

    # plot copy time
    $m = ([Regex]'Copy to .+ finished, took ([0-9\.]+) sec').Matches($content)
    [double] $copy_time = if ($m.Success) { try { $m.Groups[1].Value } catch { 0 } }

    # rename log file
    if ($plot_name) {
        $new_name = $plot_name
        if ($creation_time -gt 0) {
            $new_name += '_' + [Math]::Round($creation_time / 3600, 2) + 'h'
        }
        if ($copy_time -gt 0) {
            $new_name += '_' + [Math]::Round($copy_time / 3600, 2) + 'h'
        }
        Rename-Item -Path $log_file_path -NewName ($new_name + '.log')
    }

}

cd ~\appdata\local\chia-blockchain\app-*\resources\app.asar.unpacked\daemon\madmax

while (1) {
    
    Write-Log "clearing *.tmp"
    Remove-Item ($temp_dir_2 + '*.tmp')
    Remove-Item ($temp_dir_t + '*.tmp')
    Start-Sleep -Seconds 2

    # may be useful for SSD
    #Write-Host "optimizing"
    #Optimize-Volume -DriveLetter $temp_dir_2 -ReTrim -Verbose
    #Start-Sleep -Seconds 2

    $log_file = $logs_path + '\' + ((Get-Date).ToLocalTime().ToString('yyyy-MM-dd HHmmss')) + '.log'

    Get-Drive-Info $temp_dir_2 | tee $log_file -Append
    Get-Drive-Info $temp_dir_t | tee $log_file -Append

    Write-Log 'start plotting'
    .\chia_plot_k34.exe `
        -k $size `
        -n 1 `
        -r $threads `
        -u $buckets `
        -v $buckets `
        -t $temp_dir_t `
        -2 $temp_dir_2 `
        -d $finaldir `
        -c $contract `
        -f $farmerkey `
    | tee $log_file -Append

    Rename-Log $log_file

    Write-Log 'plotting done'
    
    if (![System.IO.File]::Exists($base_path + '\' + $repeat_file)) {
        Break
    }

    Write-Log "cooldonw $cooldown sec ..."
    Start-Sleep -Seconds $cooldown

}

Write-Log 'finish'
Pause