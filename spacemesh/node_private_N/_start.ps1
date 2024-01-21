$host.ui.RawUI.WindowTitle = Split-Path -Path $pwd -Leaf
[console]::WindowWidth=80;
[console]::WindowHeight=5;
$PSDefaultParameterValues = @{'Out-File:Encoding' = 'ascii'}

$logs_folder = 'logs'
if (!(Test-Path $logs_folder)) {
    $t = (New-Item -ItemType Directory -Force -Path $logs_folder)
}

while (1) {
    $logfile = "$((Get-Location).Path)\$logs_folder\$((Get-Date).ToLocalTime().ToString('yyyy-MM-dd HHmmss ffff')).txt"
    ../go-spacemesh --config _config.json 2>&1 | tee $logfile -Append
    Start-Sleep -Seconds 30
}

Pause