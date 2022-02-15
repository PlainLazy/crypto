@echo off
title %~nx0
:loop
set cooldown=120
echo %date% %time:~0,-3%
for %%s in (E F G H) do (
  if exist %%s: (
    echo poke %%s:\
    echo %random% > %%s:\poke.txt
    timeout 5 > NUL
    set /A cooldown=cooldown-5
  )
)
if %cooldown% gtr 0 echo cooldown %cooldown%s & timeout %cooldown% > NUL
goto loop
pause