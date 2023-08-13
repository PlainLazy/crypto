$host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name
Get-Content log_NNNN.txt -Tail 10000 -Wait | Select-String 'proposal created|proposal eligibility for an epoch|generated block|failed to process hare output|ERROR|App version'
Pause
