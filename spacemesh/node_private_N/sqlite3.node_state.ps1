$host.ui.RawUI.WindowTitle = Split-Path -Path $pwd -Leaf
[console]::WindowWidth  = 90;
[console]::WindowHeight = 20;

$init = @()
$nipost = @()

..\sqlite3.exe 'node_state.sql' "select hex(id), num_units, round(num_units*64.0/1024, 2) from initial_post;" | foreach-object {
  $d = ($_ -split "\|")
  $init += [PSCustomObject]@{
    'initial-node-id'  = $d[0]
    'num-units'        = $d[1]
    'size-TiB'         = $d[2]
  }
}

..\sqlite3.exe 'node_state.sql' "select hex(id), epoch, sequence from nipost;" | foreach-object {
  $d = ($_ -split "\|")
  $nipost += [PSCustomObject]@{
    'nipost-node-id' = $d[0]
    'epoch'          = $d[1]
    'sequence'       = $d[2]
  }
}

$init    | ft
$nipost  | ft

pause