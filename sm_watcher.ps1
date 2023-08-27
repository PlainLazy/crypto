# basedOn: https://discord.com/channels/623195163510046732/691261331382337586/1142174063293370498
# thanksTo: --== S A K K I ==--
# get grpcurl here: https://github.com/fullstorydev/grpcurl/releases

$host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name

function main {

    $grpcurl = ".\grpcurl.exe"
    $cooldown = 300

    $list = @(
        @{ host = "127.0.0.1";  port = 9092; info = "Suppa Node 1" },
        @{ host = "localhost";  port = 9095; info = "Duppa Node 2" },
        @{ host = "farfaraway"; port = 9092; info = "ElonMaskIphone99ProMaxUltraHyperDogeWoffWoff" }
    )

    while (1) {

        cls
        $object=@()

        $node = $list[0]
        $resultsNodeHighestATX = ((Invoke-Expression (
            "$($grpcurl) --plaintext -max-time 3 $($node.host):$($node.port) spacemesh.v1.ActivationService.Highest"
        )) | ConvertFrom-Json).atx

        foreach ($node in $list) {
            Write-Host "$($node.host):$($node.port) ..."
            $status = ((Invoke-Expression (
                "$($grpcurl) --plaintext -max-time 3 $($node.host):$($node.port) spacemesh.v1.NodeService.Status"
            )) | ConvertFrom-Json).status
            $version = ((Invoke-Expression (
                "$($grpcurl) --plaintext -max-time 3 $($node.host):$($node.port) spacemesh.v1.NodeService.Version"
            )) | ConvertFrom-Json).versionString.value
            $o = [PSCustomObject]@{
                host = $node.host
                port = $node.port
                info = $node.info
                peers = $status.connectedPeers
                synced = $status.isSynced
                "layer top verified" = "$($status.syncedLayer.number) $($status.topLayer.number) $($status.verifiedLayer.number)"
                ver = $version
            }
            $object += $o
        }

        cls
        $object | ft

        #Write-Host "---- Highest ATX -----" -ForegroundColor Yellow
        #Write-Host "   Address: " $($resultsNodeHighestATX.coinbase.address) -ForegroundColor Green
        #Write-Host " Base64_ID: " $resultsNodeHighestATX.id.id -ForegroundColor Green
        Write-Host "Highest ATX Hex_ID: " (B64_to_Hex -id2convert $resultsNodeHighestATX.id.id) -ForegroundColor Green
        #Write-Host "     Layer: " $resultsNodeHighestATX.layer.number -ForegroundColor Green
        #Write-Host "  NumUnits: " $resultsNodeHighestATX.numUnits -ForegroundColor Green
        #Write-Host "   PrevATX: "$resultsNodeHighestATX.prevAtx.id -ForegroundColor Green
        #Write-Host " SmesherID: " $resultsNodeHighestATX.smesherId.id -ForegroundColor Green
        #Write-Host "SmeshIDHex: " (B64_to_Hex -id2convert $resultsNodeHighestATX.smesherId.id) -ForegroundColor Green
        #Write-Host "----------------------" -ForegroundColor Yellow

        Start-Sleep -Seconds $cooldown

    }

}

function B64_to_Hex{
    param (
        [Parameter(Position =0, Mandatory = $true)]
        [string]$id2convert
    )
    [System.BitConverter]::ToString([System.Convert]::FromBase64String($id2convert)).Replace("-","")
}
function Hex_to_B64{
    param (
        [Parameter(Position =0, Mandatory = $true)]
        [string]$id2convert
    )
    $NODE_ID_BYTES = for ($i = 0; $i -lt $id2convert.Length; $i += 2) { [Convert]::ToByte($id2convert.Substring($i, 2), 16) }
    [System.Convert]::ToBase64String($NODE_ID_BYTES)
}

main
