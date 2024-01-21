# create symlink of chia app
# makes possible to use "~\chia\chia" instead of full path

# version <= 1.6.0
#cd ~\AppData\Local\chia-blockchain\app-*\resources\app.asar.unpacked\daemon

# version >= 1.6.1
cd ~\AppData\Local\Programs\Chia\resources\app.asar.unpacked\daemon

New-Item -Path ~\chia -ItemType SymbolicLink -Value (Get-Location).Path -Force
Pause
