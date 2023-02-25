cd "c:\program files\mmx"

# Will spam only the unique addresses.
# Take the addresses starting from the last block, jump back through $blocks_delta blocks and so $scan_blocks times.
# Ignore repeating addresses.

$scan_blocks = 1000
$blocks_delta = 30

$height = ((./mmx node info | select-string "height:") -split ' ')[-1]
write-host "current height $height"

$addrs = @()

for (($i = $scan_blocks), ($block = $height-1); $i -gt 0; ($block -= $blocks_delta), $i--) {
	$a = ((./mmx node get block $block) | convertfrom-json).tx_base.outputs[1].address
	$pc = [math]::floor(100-$i/$scan_blocks*100)
	write-host "`rgetting addr $a from block $block ... $pc % " -NoNewline
	if ($a -and !($addrs | where-object { $_ -eq $a })) {
		$addrs += $a
	}
}

write-host ""
$u = $addrs.length
write-host "collected $u unique addresses in $scan_blocks blocks, let's go:"

while (1) {
	$to = Get-Random -InputObject $addrs
	./mmx wallet send -t $to -a (Get-Random -Minimum 0.001 -Maximum 0.002)
	start-sleep -seconds (Get-Random -Minimum 9 -Maximum 18)
}

pause