$host.ui.RawUI.WindowTitle = Split-Path -Path $pwd -Leaf
[console]::WindowWidth=80;
[console]::WindowHeight=50;
$addr = (gc _config.json | convertFrom-json).api.'grpc-public-listener'
Write-Host "getting Highest ATX ... "
$atx = ((Invoke-Expression (
  "../grpcurl --plaintext $addr spacemesh.v1.ActivationService.Highest"
)) | ConvertFrom-Json).atx 2>$null
function B64_to_Hex {
    param ($id2convert)
    [System.BitConverter]::ToString([System.Convert]::FromBase64String($id2convert)).Replace("-","")
}
Write-Host (B64_to_Hex -id2convert $atx.id.id)
pause