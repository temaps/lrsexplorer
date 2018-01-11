@echo off

set ProjName=LRS_Explorer

rem Удаляем все "лишние" файлы проекта

rem Удаление отладочной информации
rem - внешний файл отладочных символов
del ..\release\%ProjName%.dbg

rem - внутренние отладочные символы
rem strip release/Kub.exe
rem - уменьшение размера исполняемого файла
rem upx release/Kub.exe

rem Удаление резервных копий файлов
del /s /q ..\backup
del /s /q ..\sources\backup

rem Удаление объектных файлов
del /s /q ..\units

pause 0

rem Возможно удаление файлов с помощью утилиты командной строки delp