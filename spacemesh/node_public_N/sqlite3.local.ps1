$host.ui.RawUI.WindowTitle = Split-Path -Path $pwd -Leaf
[console]::WindowWidth  = 142;
[console]::WindowHeight = 32;

if (!(test-path local.sql)) {
  write-host 'local.sql not found'
  pause
  exit
}

$initial_post = @()
$challenge = @()
$poet_registration = @()

..\sqlite3.exe 'local.sql' "select hex(id), num_units, round(num_units*64.0/1024, 2) from initial_post;" | foreach-object {
  $d = ($_ -split "\|")
  $initial_post += [PSCustomObject]@{
    'initial_post_id' = $d[0]
    'num_units' = $d[1]
    'size_TiB' = $d[2]
  }
}

..\sqlite3.exe 'local.sql' "select hex(id), epoch, sequence from challenge;" | foreach-object {
  $d = ($_ -split "\|")
  $challenge += [PSCustomObject]@{
    'challenge_id' = $d[0]
    'epoch' = $d[1]
    'sequence' = $d[2]
  }
}

..\sqlite3.exe 'local.sql' "select hex(id), hex(hash), address, round_id, datetime(round_end, 'unixepoch', 'localtime') from poet_registration;" | foreach-object {
  $d = ($_ -split "\|")
  $poet_registration += [PSCustomObject]@{
    'poet_registration_id' = $d[0]
    'hash' = $d[1].tostring().substring(1, 4) + '...'
    'address' = $d[2]
    'round' = $d[3]
    'end' = $d[4]
  }
}

$initial_post | ft
$challenge | ft
$poet_registration | ft

pause