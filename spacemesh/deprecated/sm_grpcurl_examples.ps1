# get grpcurl here: https://github.com/fullstorydev/grpcurl/releases

.\grpcurl.exe -plaintext -d "{}" localhost:9092 spacemesh.v1.NodeService.Status
.\grpcurl.exe -plaintext -d "{}" localhost:9092 spacemesh.v1.ActivationService.Highest
.\grpcurl.exe -plaintext -d "{}" localhost:9093 spacemesh.v1.SmesherService.IsSmeshing
.\grpcurl.exe -plaintext -d "{}" localhost:9093 spacemesh.v1.SmesherService.PostSetupStatus
.\grpcurl.exe -plaintext -d "{}" localhost:9093 spacemesh.v1.AdminService.EventsStream
.\grpcurl.exe -plaintext -d "{}" localhost:9093 spacemesh.v1.SmesherService.SmesherID

Pause
