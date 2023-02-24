cd "c:\program files\mmx"
while (1) {
	$height = ((./mmx node info | select-string "height:") -split ' ')[-1]
	$h = (get-random -minimum ($height-8640) -maximum $height)
	$to = ((./mmx node get block $h) | convertfrom-json).tx_base.outputs[1].address
	./mmx wallet send -t $to -a (Get-Random -Minimum 0.001 -Maximum 0.002)
	start-sleep -seconds 9
}
pause