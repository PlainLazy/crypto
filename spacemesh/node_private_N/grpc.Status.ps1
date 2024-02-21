$host.ui.RawUI.WindowTitle = Split-Path -Path $pwd -Leaf
[console]::WindowWidth  = 80;
[console]::WindowHeight = 40;

write-host 'spacemesh.v1.NodeService.Status:'
$pub = (gc _config.json | convertFrom-json).api.'grpc-public-listener'
../grpcurl -plaintext -d "{}" $pub spacemesh.v1.NodeService.Status

write-host 'spacemesh.v1.DebugService.NetworkInfo:'
$prv = (gc _config.json | convertFrom-json).api.'grpc-private-listener'
../grpcurl -plaintext -d "{}" $prv spacemesh.v1.DebugService.NetworkInfo

Pause