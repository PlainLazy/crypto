$host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name
$list = @(
    "proposal created",
    "proposal eligibility for an epoch",
    "generated block",
    "failed to process hare output",
    "not starting hare: node not synced at this layer",
    "waiting till poet round end",
    "post setup completed",
    "ERROR",
    "App version",
    "Loaded existing identity",
    "starting spacemesh",
    "post\tcalculating proof of work for nonces",
    "post\tFound proof for nonce",
    "post\tproving: generated proof"
)
Get-Content log_XXX.txt -Tail 20000 -Wait | Select-String ($list -Join '|')
Pause
