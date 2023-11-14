# IO stage performance test

$jobs = @(
    @{ file = 'D:\node1\postdata_3.bin'; threads = 4; nonces = 288 }
    @{ file = 'E:\node2\postdata_3.bin'; threads = 3; nonces = 288 }
    #@{ file = 'F:\node3\postdata_2.bin'; threads = 3; nonces = 288 }
    #@{ file = 'G:\node4\postdata_2.bin'; threads = 3; nonces = 288 }
    #@{ file = 'H:\node5\postdata_4.bin'; threads = 2; nonces = 288 }
    #@{ file = 'I:\node6\postdata_2.bin'; threads = 1; nonces = 288 }
)
$duration = 60  # seconds
$rockets = $jobs | ForEach-Object -Begin { $i = 0 } {
    write-host "proving $($_.file) ..."
    $logFile = 'proving_log_{0:000}.txt' -f ++$i
    [pscustomobject] @{
    Job = $_
    LogFile = $logFile
    Process = Start-Process -PassThru -WindowStyle Hidden `
        -FilePath 'profiler.exe' `
        -ArgumentList "proving --data-file $($_.file) -t $($_.threads) -n $($_.nonces) --duration $duration" `
        -RedirectStandardOutput $logFile
    }
}
$rockets.Process | Wait-Process
write-host 'resilts:'
$summ = 0
$count = 0
foreach ($r in $rockets) {
    $result = Get-Content -LiteralPath $r.LogFile -raw | convertfrom-json
    write-host "file $($r.Job.file) has $([math]::Round($result.speed_gib_s,3)) gib_s"
    $summ += $result.speed_gib_s
    $count++
}
write-host "average: $([math]::Round($summ/$count,3)) gib_s"
remove-item -LiteralPath $rockets.LogFile
pause
