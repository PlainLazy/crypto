$host.ui.RawUI.WindowTitle = Split-Path -Path $pwd -Leaf
$fileFrom = 'state.sql'
$fileTo = "state_$((Get-Date).ToLocalTime().ToString('yyyyMMdd_HHmmss')).sql"
write-host "vacuum sqlite DB: $fileFrom -> $fileTo"
$tStart = Get-Date
..\sqlite3.exe $fileFrom "VACUUM into '$fileTo';"
write-host "done in $(((Get-Date) - $tStart).TotalMinutes) minutes"
pause