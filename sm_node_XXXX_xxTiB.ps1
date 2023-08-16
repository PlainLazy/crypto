$host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name

# get lastest go-spacemesh here: https://github.com/spacemeshos/go-spacemesh/releases
# get mainnet config here: https://configs.spacemesh.network/config.mainnet.json

# change NNNN with yours (for example: use first 4 chars of your node_id)
# smeshing-opts-provider 4294967295 <-- using CPU only
# check datadir, maxfilesize, numunits
# for multiple instances, replace ports (7514,9095,9096,9097) with ones that are not yet binded

while (1) {

    ./go-spacemesh `
    --listen /ip4/0.0.0.0/tcp/7514 `
    --grpc-public-listener 0.0.0.0:9095 `
    --grpc-private-listener 127.0.0.0:9096 `
    --grpc-json-listener 0.0.0.0:9097 `
    --config config.mainnet.json `
    --data-folder node_NNNN `
    --filelock lock_NNNN `
    --smeshing-coinbase sm1qqq... `
    --smeshing-start `
    --smeshing-opts-provider 4294967295 `
    --smeshing-opts-datadir C:\PATH_TO_POST_DATA `
    --smeshing-opts-maxfilesize 4294967296 `
    --smeshing-opts-numunits 4 `
    2>&1 | Tee log_NNNN.txt -Append

    Start-Sleep -Seconds 30

}

Pause
