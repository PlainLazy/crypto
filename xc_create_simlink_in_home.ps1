# create symlink of chia app
# makes possible to use "~\chia\chia" instead of full path

cd ~\AppData\Local\chia-blockchain\app-*\resources\app.asar.unpacked\daemon
New-Item -Path ~\chia -ItemType SymbolicLink -Value (Get-Location).Path -Force
Pause