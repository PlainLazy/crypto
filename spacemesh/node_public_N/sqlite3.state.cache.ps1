$host.ui.RawUI.WindowTitle = Split-Path -Path $pwd -Leaf
[console]::WindowWidth  = 90;
[console]::WindowHeight = 10;
write-host "read state.sql ..."
$tStart = Get-Date
$b = [System.IO.File]::ReadAllBytes("state.sql")
write-host "readed $($b.count) bytes in $(((Get-Date) - $tStart).TotalSeconds) seconds"
pause