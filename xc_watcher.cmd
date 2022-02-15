@title %~nx0
powershell "get-content %userprofile%\.chia\mainnet\log\debug.log -tail 100 -wait | select-string 'error|warning|partial|harvester|Farmed unfinished_block'"
@pause