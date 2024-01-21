# basedOn: https://discord.com/channels/623195163510046732/691261331382337586/1142174063293370498
# thanksTo: --== S A K K I ==--
# get grpcurl here: https://github.com/fullstorydev/grpcurl/releases

$host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name
[console]::WindowWidth=80;
[console]::WindowHeight=50;

function main {

    $grpcurl = ".\grpcurl.exe"
    $cooldown = 300

    $list = @(
        @{ host = "127.0.0.1";  port = 9092; info = "Suppa Node 1" }
        @{ host = "localhost";  port = 9095; info = "Duppa Node 2" }
        @{ host = "farfaraway"; port = 9092; info = "SpaceMesh25UsdPerCoin" }
    )

    while (1) {

        $object=@()
        $node = $list[0]

        #log("$($node.host):$($node.port) ... atx")
        #$resultsNodeHighestATX = ((Invoke-Expression (
        #    "$($grpcurl) --plaintext -max-time 20 $($node.host):$($node.port) spacemesh.v1.ActivationService.Highest"
        #)) | ConvertFrom-Json).atx 2>$null

        foreach ($node in $list) {

            log("$($node.host):$($node.port) ... status")
            $status = ((Invoke-Expression (
                "$($grpcurl) --plaintext -max-time 3 $($node.host):$($node.port) spacemesh.v1.NodeService.Status"
            )) | ConvertFrom-Json).status 2>$null

            if ($status -ne $null) {
                
                log("$($node.host):$($node.port) ... ver")
                $version = ((Invoke-Expression (
                    "$($grpcurl) --plaintext -max-time 5 $($node.host):$($node.port) spacemesh.v1.NodeService.Version"
                )) | ConvertFrom-Json).versionString.value 2>$null

                #log("$($node.host):$($node.port) ... p2p")
                #$p2p = ((Invoke-Expression (
                #    "$($grpcurl) --plaintext -max-time 5 $($node.host):$($node.port) spacemesh.v1.DebugService.NetworkInfo"
                #)) | ConvertFrom-Json).id

            } else {
                $version = $null
            }

            #log("$($node.host):$($node.port) ... p2p")
            #$p2p = ((Invoke-Expression (
            #    "$($grpcurl) --plaintext -max-time 3 $($node.host):$($node.port) spacemesh.v1.DebugService.NetworkInfo"
            #)) | ConvertFrom-Json).id

            $o = [PSCustomObject]@{
                host = $node.host
                port = $node.port
                info = $node.info
                peers = $status.connectedPeers
                synced = $status.isSynced
                "layer top verified" = "$($status.syncedLayer.number) $($status.topLayer.number) $($status.verifiedLayer.number)"
                ver = $version
                #p2p = $p2p
            }
            $object += $o
        }

        cls
        $object | ft

        try {
            #Write-Host "---- Highest ATX -----" -ForegroundColor Yellow
            #Write-Host "   Address: " $($resultsNodeHighestATX.coinbase.address) -ForegroundColor Green
            #Write-Host " Base64_ID: " $resultsNodeHighestATX.id.id -ForegroundColor Green
            #Write-Host "Highest ATX: " (B64_to_Hex -id2convert $resultsNodeHighestATX.id.id) -ForegroundColor Green
            #Write-Host "     Layer: " $resultsNodeHighestATX.layer.number -ForegroundColor Green
            #Write-Host "  NumUnits: " $resultsNodeHighestATX.numUnits -ForegroundColor Green
            #Write-Host "   PrevATX: "$resultsNodeHighestATX.prevAtx.id -ForegroundColor Green
            #Write-Host " SmesherID: " $resultsNodeHighestATX.smesherId.id -ForegroundColor Green
            #Write-Host "SmeshIDHex: " (B64_to_Hex -id2convert $resultsNodeHighestATX.smesherId.id) -ForegroundColor Green
            #Write-Host "----------------------" -ForegroundColor Yellow
        } catch {
            Write-Host "ATX not found"
        }

        Start-Sleep -Seconds $cooldown

    }

}

function log {
    param ($t)
    $pos = $host.ui.RawUI.get_cursorPosition()
    Write-Host (" "*64)
    $host.UI.RawUI.set_cursorPosition($Pos)
    Write-Host "$t"
    $host.UI.RawUI.set_cursorPosition($Pos)
}

function B64_to_Hex{
    param ($id2convert)
    [System.BitConverter]::ToString([System.Convert]::FromBase64String($id2convert)).Replace("-","")
}
function Hex_to_B64{
    param ($id2convert)
    $NODE_ID_BYTES = for ($i = 0; $i -lt $id2convert.Length; $i += 2) { [Convert]::ToByte($id2convert.Substring($i, 2), 16) }
    [System.Convert]::ToBase64String($NODE_ID_BYTES)
}

main
