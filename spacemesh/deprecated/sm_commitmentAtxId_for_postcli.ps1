# get grpcurl here: https://github.com/fullstorydev/grpcurl/releases
# check port 9092

$idBase64 = (.\grpcurl.exe -plaintext -d "{}" localhost:9092 spacemesh.v1.ActivationService.Highest | ConvertFrom-Json).atx.id.id
$idHex = (([System.Convert]::FromBase64String($idBase64) | ForEach-Object {"{0:X}" -f $_}) -Join '').ToLower()
echo "-commitmentAtxId $idHex"
Pause
