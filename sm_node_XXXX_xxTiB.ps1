$host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name

# get lastest go-spacemesh here: https://github.com/spacemeshos/go-spacemesh/releases
# get mainnet config here: https://configs.spacemesh.network/config.mainnet.json
# rename config.mainnet.json to config_NNNN.json (where NNNN is first 4 chars of your node_id)
# add this into config_NNNN.json:
<#
    "smeshing": {
        "smeshing-opts": {
            "smeshing-opts-datadir": "D:\\path_to_post_data",
            "smeshing-opts-maxfilesize": 17179869184,
            "smeshing-opts-numunits": 19,
            "smeshing-opts-provider": 4294967295,
            "smeshing-opts-throttle": false,
            "smeshing-opts-compute-batch-size": 1048576
        },
        "smeshing-coinbase": "your_wallet",
        "smeshing-proving-opts": {
            "smeshing-opts-proving-nonces": 288,
            "smeshing-opts-proving-threads": 6
        },
        "smeshing-start": true
    }
#>
# and check values of: datadir, maxfilesize, numunits, coinbase, nonces, threads
# for multiple instances, replace ports (7514,9095,9096,9097 from config and parameters) with ones that are not yet binded
# memo: provider 4294967295 <-- using CPU only

while (1) {

    ./go-spacemesh `
    --listen /ip4/0.0.0.0/tcp/7515 `
    --config config_NNNN.json `
    --data-folder node_NNNN `
    --filelock lock_NNNN `
    2>&1 | Tee log_NNNN.txt -Append

    Start-Sleep -Seconds 30

}

Pause
