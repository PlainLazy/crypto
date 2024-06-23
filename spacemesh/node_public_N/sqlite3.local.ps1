$host.ui.RawUI.WindowTitle = Split-Path -Path $pwd -Leaf
[console]::WindowWidth  = 142;
[console]::WindowHeight = 32;

if (!(test-path local.sql)) {
  write-host 'local.sql not found'
  pause
  exit
}

$atx_sync_state = @()
$initial_post = @()
$challenge = @()
$poet_registration = @()

..\sqlite3.exe 'local.sql' "select count(*), round(sum(length(id))/pow(1024,3),3) from atx_sync_state;" | foreach-object {
  $d = ($_ -split "\|")
  $atx_sync_state += [PSCustomObject]@{
    'atx_sync_states' = $d[0]
    'GiB' = $d[1]
  }
}

..\sqlite3.exe 'local.sql' "select row_number() over(order by id) num, hex(id), num_units, round(num_units*64.0/1024, 2) from post;" | foreach-object {
  $d = ($_ -split "\|")
  $initial_post += [PSCustomObject]@{
    'num' = $d[0]
    'initial_post_id' = $d[1]
    'su' = $d[2]
    'TiB' = $d[3]
  }
}

..\sqlite3.exe 'local.sql' "select row_number() over(order by id) num, hex(id), epoch, sequence from challenge;" | foreach-object {
  $d = ($_ -split "\|")
  $challenge += [PSCustomObject]@{
    'num' = $d[0]
    'challenge_id' = $d[1]
    'epoch' = $d[2]
    'sequence' = $d[3]
  }
}

..\sqlite3.exe 'local.sql' "select row_number() over(order by id) num, hex(id), hex(hash), address, round_id, datetime(round_end, 'unixepoch', 'localtime') from poet_registration;" | foreach-object {
  $d = ($_ -split "\|")
  $poet_registration += [PSCustomObject]@{
    'num' = $d[0]
    'poet_registration_id' = $d[1]
    'hash' = $d[2].tostring().substring(1, 4) + '...'
    'address' = $d[3]
    'round' = $d[4]
    'end' = $d[5]
  }
}

$atx_sync_state | ft
$initial_post | ft
$challenge | ft
$poet_registration | ft

pause
