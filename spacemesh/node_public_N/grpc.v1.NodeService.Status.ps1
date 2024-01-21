$host.ui.RawUI.WindowTitle = Split-Path -Path $pwd -Leaf
[console]::WindowWidth=40;
[console]::WindowHeight=20;
$addr = (gc _config.json | convertFrom-json).api.'grpc-public-listener'
../grpcurl -plaintext -d "{}" $addr spacemesh.v1.NodeService.Status
Pause