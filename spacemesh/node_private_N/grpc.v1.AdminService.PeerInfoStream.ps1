$host.ui.RawUI.WindowTitle = Split-Path -Path $pwd -Leaf
[console]::WindowWidth=80;
[console]::WindowHeight=50;
$addr = (gc _config.json | convertFrom-json).api.'grpc-private-listener'
../grpcurl -plaintext $addr spacemesh.v1.AdminService.PeerInfoStream
pause