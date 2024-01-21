$forkname = 'chia'  # chia, chives, etc...
$zombie_tolerance = 8*60  # seconds before zombie will be kicked
$iter_delay = 10  # delay in seconds between check interation
$zombie_gap = 5  # minimum height gap for zombie detection

$host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name
cd $env:UserProfile\appdata\local\$forkname-blockchain\app-*\resources\app.asar.unpacked\daemon

$h_nodes = @{}
$i_height_max = 0

class Node {
    [string]$id
    [int]$height
    [datetime]$action
}

while (1) {

    # fetch
    $t = (Invoke-Expression "./$forkname show -c") -join ';'
    $matches = ([regex]'FULL_NODE((?!\.\.\.).)*.{8}\.\.\.((?!Height:).)*Height:\s*\d+').matches($t)
    $h_actual_nodes = @{}
    $matches.Foreach({
        #Write-Host ("match: {0}" -f $t)
        $n = [Node]::new()
        $n.id = ([regex]'\w{8}\.\.\.').Matches($_.value).value.substring(0, 8)
        $n.height = [int]([regex]'\d+$').Matches($_.value).value
        $h_actual_nodes[$n.id] = $n
    })

    # cleanup
    $l_lost = @()
    foreach ($n in $h_nodes.Values) {
        if (!$h_actual_nodes[$n.id]) {
            $l_lost += $n.id
        }
    }
    $l_lost.Foreach({
        Write-Host "[-] $_"
        $h_nodes.Remove($_)
    })

    # merging
    foreach ($n in $h_actual_nodes.Values) {
        $i_height_max = [math]::max($i_height_max, $n.height)
        $n1 = $h_nodes[$n.id]
        if (!$n1) {  # new node
            $n.action = Get-Date
            $h_nodes[$n.id] = $n
            Write-Host "[+] $($n.id) at $($n.height)"
        } else {  # exists node
            if ($n1.height -ne $n.height) {  # height changed
                $n1.height = $n.height
                $n1.action = Get-Date
            }
        }
    }

    # processing
    $i_full_nodes = 0
    $i_leechers = 0
    $l_zombies = @()
    foreach ($n in $h_nodes.Values) {
        $i_behind = $i_height_max - $n.height
        if ($i_behind -le 0) {
            $i_full_nodes++
        } else {
            $i_leechers++
            if ($i_behind -gt $zombie_gap) {
                # zombie candidate
                $f_seconds = [int](NEW-TIMESPAN -Start $n.action -End (get-date)).totalseconds
                Write-Host "[l] leecher $($n.id) is behind by $i_behind heights for $f_seconds sec"
                if ($f_seconds -ge $zombie_tolerance) {  # leeching too long time
                    $l_zombies += $n.id
                }
            }
        }
    }
    $l_zombies.Foreach({
        Write-Host "[z] zombie kicking $_"
        Invoke-Expression "./$forkname show -r $_"
        $h_nodes.Remove($_)
    })

    Write-Host "height: $($i_height_max) nodes: $i_full_nodes full + $($i_leechers) leeches"
    Start-Sleep -seconds $iter_delay

 }