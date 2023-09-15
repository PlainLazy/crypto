# The program initializes files sequentially.
# Each file is initialized by one provider.
# When the provider finishes initializing the file, it is given the next one.
# In this way, all providers will be used until there are no files left in the initialization queue.
# Even if the providers are different in power, this will not lead to downtime for the more powerful ones.

# get postcli here: https://github.com/spacemeshos/post/releases

.\postcli.exe -printProviders

#### edit this section ####
$providers = 0,1,4  # in this case GPU0, GPU1 and GPU4 are used (also you can use CPU, its number is 4294967295)
$atx = "435FA442517E9C75087DE1B06D2A9D12C345505F3CAC93AC52B816171CE48308"
$nodeId = "9acc..."  # Your public nodeId (smehserId)
$fileSize = 2 * 1024 * 1024 * 1024  # 2 GiB  (For larger volumes, for convenience, you can increase to 4,8,16+ GiB)
$startFromFile = 0
$numUnits = 4  # 64 GiB each (mininum 4)
$dataDir = "post_data"
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
