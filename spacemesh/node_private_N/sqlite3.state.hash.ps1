$host.ui.RawUI.WindowTitle = Split-Path -Path $pwd -Leaf
[console]::WindowWidth  = 90;
[console]::WindowHeight = 10;
write-host "get hash of state.sql ..."
$tStart = Get-Date
Get-FileHash state.sql | Format-List
write-host "done in $(((Get-Date) - $tStart).TotalSeconds) seconds"
pause