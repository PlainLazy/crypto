cd ~\AppData\Local\chia-blockchain\app-*\resources\app.asar.unpacked\daemon
.\chia configure --set-log-level INFO
.\chia start farmer
while (1) {
    Get-Content ~\.chia\mainnet\log\debug.log -tail 100 -wait | Select-String 'error|warning|harvester|partial'
    Start-Sleep -seconds 5
}
Pause