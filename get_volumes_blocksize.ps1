Get-CimInstance -ClassName Win32_Volume |
    Where-Object -FilterScript {$_.Label -match '[A-Z]'} |
    Select-Object DriveLetter, Label, BlockSize |
    Format-Table -AutoSize

Pause