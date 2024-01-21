title %cd%

@rem smasher: https://github.com/spacemeshos/go-spacemesh/releases
@rem config: https://configs.spacemesh.network/config.mainnet.json
  
:loop

go-spacemesh ^
 --listen /ip4/0.0.0.0/tcp/7514 ^
 --grpc-public-listener 0.0.0.0:9095 ^
 --grpc-private-listener 127.0.0.0:9096 ^
 --grpc-json-listener 0.0.0.0:9097 ^
 --config config.mainnet.json ^
 -d node ^
 --filelock lock ^
 --smeshing-coinbase _wallet_for_rewards_ ^
 --smeshing-start ^
 --smeshing-opts-datadir C:/_post_data_path_ ^
 --smeshing-opts-provider 4294967295 ^
 --smeshing-opts-numunits 4

timeout 30 > NUL
goto loop

@pause
