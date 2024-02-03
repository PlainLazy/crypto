$host.ui.RawUI.WindowTitle = Split-Path -Path $pwd -Leaf
[console]::WindowWidth  = 80;
[console]::WindowHeight = 50;
$addr = (gc _config.json | convertFrom-json).api.'grpc-private-listener'
$table = @()
$buff = ''
../grpcurl -plaintext $addr spacemesh.v1.AdminService.PeerInfoStream | foreach-object {
  $buff += $_
  if ($_ -eq '}') {
    $peer = $buff | ConvertFrom-Json
    $address = ''
    $uptime = ''
    $tag = ''
    #write-host $peer.id
    if ($peer.connections.count -gt 0) {
        $address = $peer.connections[0].address
        $uptime = [math]::round($peer.connections[0].uptime.split('.')[0] / 60 / 60, 2)
    }
    if ($peer.tags.count -gt 0) {
        $tag = $peer.tags[0]
    }
    $table += [PSCustomObject]@{
        'id'       = $peer.id
        'address'  = $address
        'uptime'   = $uptime
        'tag'      = $tag
    }
    $buff = ''
  }
}
$table | ft
pause