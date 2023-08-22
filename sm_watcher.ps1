# basedOn: https://discord.com/channels/623195163510046732/691261331382337586/1142174063293370498
# thanksTo: --== S A K K I ==--
# get grpcurl here: https://github.com/fullstorydev/grpcurl/releases

$host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name

function main {

    $grpcurlLoc = ".\grpcurl.exe"
    $sleep = "60"

    $listOfNodes = @(
        @("localhost", "9092", "node1"),
        @("otherhost", "9092", "node2")
    )

    while (!$sunAndAllPlanetsLinedUp){

        cls
        $object=@()

        $nodes = foreach ($node in $listOfNodes) {

            $nodeHost = $node[0]
            $nodePort = $node[1]

            $node_highestATX  = "--plaintext", "$nodeHost`:$nodePort", "spacemesh.v1.ActivationService.Highest"
            $node_status = "--plaintext", "$nodeHost`:$nodePort", "spacemesh.v1.NodeService.Status"

            Write-Host "$node ..."
            
            $resultsNodeHighestATX = ((Invoke-Expression "$grpcurlLoc $node_highestATX") | ConvertFrom-Json).atx
            $resultsNodeStatus = ((Invoke-Expression "$grpcurlLoc $node_status") | ConvertFrom-Json).status

            $customObject = [PSCustomObject]@{
    
                name = $node[2]
                "host:port" = "$nodeHost`:$nodePort"
                peers = $resultsNodeStatus.connectedPeers
                isSynced = $resultsNodeStatus.isSynced
                syncedLayer = $resultsNodeStatus.syncedLayer.number
                topLayer = $resultsNodeStatus.topLayer.number
                verifiedLayer = $resultsNodeStatus.verifiedLayer.number
    
            }

            $object+=$customObject

        }

        cls
        $object | ft

        Write-Host "---- Highest ATX -----" -ForegroundColor Yellow
        Write-Host "   Address: " $($resultsNodeHighestATX.coinbase.address) -ForegroundColor Green
        Write-Host " Base64_ID: " $resultsNodeHighestATX.id.id -ForegroundColor Green
        Write-Host "    Hex_ID: " (B64_to_Hex -id2convert $resultsNodeHighestATX.id.id) -ForegroundColor Green
        Write-Host "     Layer: " $resultsNodeHighestATX.layer.number -ForegroundColor Green
        Write-Host "  NumUnits: " $resultsNodeHighestATX.numUnits -ForegroundColor Green
        Write-Host "   PrevATX: "$resultsNodeHighestATX.prevAtx.id -ForegroundColor Green
        Write-Host " SmesherID: " $resultsNodeHighestATX.smesherId.id -ForegroundColor Green
        Write-Host "SmeshIDHex: " (B64_to_Hex -id2convert $resultsNodeHighestATX.smesherId.id) -ForegroundColor Green
        Write-Host "----------------------" -ForegroundColor Yellow

        Start-Sleep -Seconds $sleep

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
