$host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name

# get lastest go-spacemesh here: https://github.com/spacemeshos/go-spacemesh/releases
# get mainnet config here: https://configs.spacemesh.network/config.mainnet.json

# change XXXX with yours
# check maxfilesize, numunits
# for multiple instances, replace ports (7514,9095,9096,9097) with ones that are not yet binded

while (1) {

    ./go-spacemesh `
    --listen /ip4/0.0.0.0/tcp/7514 `
    --grpc-public-listener 0.0.0.0:9095 `
    --grpc-private-listener 127.0.0.0:9096 `
    --grpc-json-listener 0.0.0.0:9097 `
    --config config.mainnet.json `
    -d node_XXXX `
    --filelock lock_XXXX `
    --smeshing-coinbase sm1qqqqqqqXXXX `
    --smeshing-start `
    --smeshing-opts-datadir H:/post_XXXX_xxTiB `
    --smeshing-opts-maxfilesize 4294967296 `
    --smeshing-opts-provider 4294967295 `
    --smeshing-opts-numunits 4 `
    2>&1 | Tee log_XXXX.txt -Appen

    Start-Sleep -Seconds 30

}

Pause
