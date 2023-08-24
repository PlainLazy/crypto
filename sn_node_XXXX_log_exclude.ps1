$host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name
$exclude = @(
    "blockHandler\tnew block",
    "post\tinitialization: file already initialized",
    "post\tfound unrecognized file",
    "sync\tnode is too far behind",
    "atxHandler\tnew atx",
    "atxHandler\tatx failed contextual validation",
    "nipostValidator\tVerifying with PoW creator ID",
    "nipostValidator\tverifying POST with pow creator ID",
    "\tstarting post proof verifier worker",
    "proposalListener\tnew ballot",
    "proposalListener\tnew proposal",
    "atxHandler\tvalidating nipost",
    "mesh\tconsensus results",
    "executor\texecuted block",
    "executor\toptimistically executed block",
    "grpc\t",
    "grpc.Node\tGRPC NodeService.Status"
    "trtl\tcandidate layer is verified",
    "hare\tstatus round completed",
    "hare\tcommit round completed",
    "hare\tconsensus process started",
    "hare\tpreround ended",
    "hare\thare terminated with success",
    "hare\tconsensus process terminated",
    "hare\tnot voting on proposal from malicious identity",
    "hare\tencountered late preround message",
    "hare\tinvalid certificate",
    "hare\tlate message failed contextual validation",
    "hare\tmessage failed syntactic validation"
    "mesh\talready synced certificate",
    "hareOracle\t",
    "bootstrap\t",
    "beacon\t",
    "blockGenerator\tno feasible txs for block",
    "blockCert\tgenerating certificate",
    "trtl\tencoded votes",
    "conState\treceived mempool txs",
    "timesync\tfailed to read response from peer"
)
Get-Content log_XXXX.txt -Tail 30000 -Wait | Select-String ($exclude -Join '|') -NotMatch
Pause
