$host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name
cd ~\AppData\Roaming\Spacemesh
Get-Content spacemesh-log-7c8cef2b.txt -Tail 500 -Wait | Select-String 'grpc.GlobalState|finished unary call' -NotMatch
