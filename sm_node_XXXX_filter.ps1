$host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name
Get-Content log_NNNN.txt -Tail 10000 -Wait | Select-String 'proposal created|proposal eligibility for an epoch|generated block|failed to process hare output|not starting hare: node not synced at this layer|waiting till poet round end|ERROR|App version'
Pause
