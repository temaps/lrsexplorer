rem Make new directory and copy files for publishing project LRS Explorer
set ProjFolder=LRS_Explorer_source
set PublicFolder=%ProjFolder%_public

cd ..\..\
md %PublicFolder%

xcopy %ProjFolder% %PublicFolder% /e /s /y

del %PublicFolder%\release\*.exe /q
del %PublicFolder%\release\*.dbg /q
rem del %PublicFolder%\Release\languages\*.* /q
del %PublicFolder%\release\Test.lrs /q
rd %PublicFolder%\backup /s /q
rd %PublicFolder%\sources\backup /s /q
rem del %PublicFolder%\LRS_Explorer.rc /q
rem del %PublicFolder%\manifest.rc /q
rd %PublicFolder%\units /s /q
rd %PublicFolder%\scripts /s /q
del %PublicFolder%\LRS_Explorer.lps /q

del %PublicFolder%.7z /q
rem Use a 7-zip compressor for PublicFolder
set Path7z=%ProgramFiles%\7-zip
rem -mx=9 sets level of compression to ultra
"%Path7z%\7z" a -t7z %PublicFolder%.7z %PublicFolder%\ -mx=9 -aoa

rd %PublicFolder% /s /q

pause 0
exit