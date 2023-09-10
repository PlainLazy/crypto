# get postcli here: https://github.com/spacemeshos/post/releases

.\postcli.exe -printProviders

###########################
#### edit this section ####
#gpus=[0,1,2,3,...] (any of, in any order) cpu=4294967295 (for details .\postcli.exe -printProviders)
$providers = 4,3,0,4294967295  # in this case: gpu4,gpu3,gpu0,cpu (cpu is very weak provider, dont use it ;))
$atx = "435FA442517E9C75087DE1B06D2A9D12C345505F3CAC93AC52B816171CE48308"
$nodeId = "9acc..."
$fileSize = 2 * 1024 * 1024 * 1024  # 2 GiB
$startFromFile = 0
$numUnits = 4  # 64 GiB each (mininum 4)
$dataDir = "post_data"
###########################
###########################

$filesTotal = $numUnits * 64 * 1024 * 1024 * 1024 / $fileSize
write-host "filesTotal $filesTotal" -ForegroundColor Yellow
$processes = @{}
$fileCounter = $startFromFile

while ($fileCounter -le $filesTotal) {
    foreach ($p in $providers) {
        if ($fileCounter -le $filesTotal) {
            $pp = $processes[$p]
            if (!$pp -or $pp.HasExited) {
                write-host " provider $p starts file $fileCounter" -ForegroundColor Yellow
                $processes[$p] = start-process `
                    -NoNewWindow `
                    -filepath postcli.exe `
                    -PassThru `
                    -ArgumentList `
                        "-provider $p",
                        "-commitmentAtxId $atx",
                        "-id $nodeId",
                        "-labelsPerUnit 4294967296",
                        "-maxFileSize $fileSize",
                        "-numUnits $numUnits",
                        "-datadir $dataDir",
                        "-fromFile $fileCounter",
                        "-toFile $fileCounter"
                $fileCounter++
            }
        }
    }
    start-sleep -seconds 1
}

write-host "done" -ForegroundColor Green
pause
