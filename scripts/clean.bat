@echo off

set ProjName=LRS_Explorer

rem ������� ��� "������" ����� �������

rem �������� ���������� ����������
rem - ������� ���� ���������� ��������
del ..\release\%ProjName%.dbg

rem - ���������� ���������� �������
rem strip release/Kub.exe
rem - ���������� ������� ������������ �����
rem upx release/Kub.exe

rem �������� ��������� ����� ������
del /s /q ..\backup
del /s /q ..\sources\backup

rem �������� ��������� ������
del /s /q ..\units

pause 0

rem �������� �������� ������ � ������� ������� ��������� ������ delp