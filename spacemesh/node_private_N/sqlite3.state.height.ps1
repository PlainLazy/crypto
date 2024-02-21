$host.ui.RawUI.WindowTitle = Split-Path -Path $pwd -Leaf
[console]::WindowWidth  = 90;
[console]::WindowHeight = 10;
write-host "get height ..."
$tStart = Get-Date
..\sqlite3.exe 'state.sql' "select max(id) from layers;"
write-host "done in $(((Get-Date) - $tStart).TotalMinutes) minutes"
pause