
@echo off
echo ȷ��Ҫɾ����ǰĿ¼������.bak��.exe���͵��ļ���libĿ¼��
pause


for /r %%f in (*.bak) do (
del %%f
echo ɾ����"%%f"
)


for /r %%a in (*.exe) do (
echo ɾ��exe��"%%a"
DEL /F /A /Q "%%~a"
)

for /r %%a in (*.log) do (
echo ɾ��log��"%%a"
DEL /F /A /Q "%%~a"
)


if exist lib (
echo "ɾ��lib"
rd /s/q lib
)


for /f "delims=" %%b in ('dir /s/b/ad lib') do (
echo ɾ����"%%b"
rd /s/q "%%b" 
)



set a=2
:dao
set /a a=a-1
ping -n 2 -w 500 127.1>nul
cls
echo ����ɹ���
echo %a%����Զ��ر�...
if %a%==0 (exit) else (goto dao)


rem BY CM,2016.06.02AM
rem update 20160614 by CM