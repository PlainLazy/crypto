cd "c:\program files\mmx"

$global:uniqueAddrs = @()

function Fetch-Random-Addr {
	$currentHeight = ((./mmx node info | select-string "height:") -split ' ')[-1]
	$randomBlock = (Get-Random -Minimum ($currentHeight - 86400) -Maximum $currentHeight)
	$addr = ((./mmx node get block $randomBlock) | ConvertFrom-Json).tx_base.outputs[1].address
	if ($addr -and !($global:uniqueAddrs | Where-Object { $_ -eq $addr })) {
		$global:uniqueAddrs += $addr
		Write-Host "unique addr $addr has been found in block $randomBlock, total addrs " $global:uniqueAddrs.length
	}
}

for ($i = 0; $i -lt 100; $i++) {
	Fetch-Random-Addr
}

While (1) {
	Fetch-Random-Addr
	$addr = Get-Random -InputObject $global:uniqueAddrs
	if ($addr) {
		./mmx wallet send -t $addr -a (Get-Random -Minimum 0.001 -Maximum 0.002)
	}
	Start-Sleep -Seconds (Get-Random -Minimum 8 -Maximum 16)
}

Pause
