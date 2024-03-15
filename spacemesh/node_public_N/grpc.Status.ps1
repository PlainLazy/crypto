$host.ui.RawUI.WindowTitle = Split-Path -Path $pwd -Leaf
[console]::WindowWidth  = 80;
[console]::WindowHeight = 60;

write-host 'spacemesh.v1.NodeService.Status:'
$pub = (gc _config.json | convertFrom-json).api.'grpc-public-listener'
../grpcurl -plaintext -d "{}" $pub spacemesh.v1.NodeService.Status

write-host 'spacemesh.v1.DebugService.NetworkInfo:'
$prv = (gc _config.json | convertFrom-json).api.'grpc-private-listener'
../grpcurl -plaintext -d "{}" $prv spacemesh.v1.DebugService.NetworkInfo

write-host 'spacemesh.v1.PostInfoService.PostStates:'
$post = (gc _config.json | convertFrom-json).api.'grpc-post-listener'
if (!$post) {
  $post = '127.0.0.1:9094'
}
../grpcurl -plaintext -d "{}" $post spacemesh.v1.PostInfoService.PostStates

Pause