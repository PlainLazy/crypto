# The program initializes files sequentially.
# Each file is initialized by one provider.
# When the provider finishes initializing the file, it is given the next one.
# In this way, all providers will be used until there are no files left in the initialization queue.
# Even if the providers are different in power, this will not lead to downtime for the more powerful ones.

# Get postcli: https://github.com/spacemeshos/post/releases
# RTM https://github.com/spacemeshos/post/blob/develop/cmd/postcli/README.md
# After completing the initialization of the subsets, you will need to combine the files into same direcory and merge postmeta_data.json as described in the README.md

# linux version: https://github.com/Stizerg/sm-multi-gpu-init/blob/main/sm-multi-gpu-init.sh

.\postcli.exe -printProviders

#### edit this section ####
$providers = 0,1,4  # in this case GPU0, GPU1 and GPU4 are used (also you can use CPU, its number is 4294967295)
$atx = "ECA2BBC8D4E65916576E1D64FDCE95455265E82B9953BFD7AAD15BA3921D33FB"
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
                        "-datadir $dataDir\data$p",
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
