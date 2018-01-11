rem @echo off
rem Backup of LRS Explorer
set ProjFolder=LRS_Explorer_source
set PublicFolder=%ProjFolder%_backup

cd ..\..\
md %PublicFolder%

xcopy %ProjFolder% %PublicFolder% /e /s /y

rd %PublicFolder%\units /s /q
del %PublicFolder%\release\*.exe /q
del %PublicFolder%\release\*.dbg /q

rem Use a 7-zip compressor for PublicFolder //rem -mx=9 sets level of compression to ultra
set Path7z=%ProgramFiles%\7-zip

"%Path7z%\7z" a -t7z %PublicFolder%.7z %PublicFolder%\ -mx=9 -aoa

rd %PublicFolder% /s /q

pause 0
exit

