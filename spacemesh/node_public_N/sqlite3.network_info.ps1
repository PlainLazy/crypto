$host.ui.RawUI.WindowTitle = Split-Path -Path $pwd -Leaf
[console]::WindowWidth  = 100;
[console]::WindowHeight = 40;

Write-Host 'getting newtork info ...'

$network = @()

..\sqlite3.exe 'state.sql' "select
    *,
    round(rewards/progress/(networkPiB*1024)/14,4) coinsPerTiB24hAvg
from (
select
    epoch+1 epoch,
    count(distinct(coinbase)) coinbases,
    count(*) smeshers,
    round(max(effective_num_units)*64.0/1024,2) biggestTiB,
    round(sum(effective_num_units)*64.0/1024/1024,2) networkPiB,
    ( select round(sum(total_reward/1000000000.0))
			from rewards
			where layer between (epoch+1)*4032 and (epoch+2)*4032
		) rewards,
	  ( select round((max(layer)-(epoch+1)*4032)/4032.0,4)
			from rewards
			where layer between (epoch+1)*4032 and (epoch+2)*4032
		) progress
   from atxs
   group by epoch limit 99
 )" | foreach-object {
  $d = ($_ -split "\|")
  $prev = $null
  if ($network.count -gt 0) {
    $prev = $network[$network.count-1]
  }
  $coinbases   = [math]::Round($d[1], 2)
  $smeshers    = [math]::Round($d[2], 2)
  $networkPiB  = [math]::Round($d[4], 2)
  $network += [PSCustomObject]@{
    'epoch'              = [math]::Round($d[0])
    'coinbases'          = $coinbases
    'smeshers'           = $smeshers
    'networkPiB'         = $networkPiB
    'growth'             = if ($prev -ne $null) { [math]::Round($networkPiB / $prev.'networkPiB', 2) } else { 0 }
    'biggestTiB'         = [math]::Round($d[3], 1)
    'rewards'            = [math]::Round($d[5])
    'progress'           = [math]::Round($d[6], 4)
    'coinsPerTiB24hAvg'  = [math]::Round($d[7], 4)
  }
}

$network | ft

pause