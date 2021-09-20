
@echo off
set prtnum="bL"
for /f tokens^=* %%i in ('where C:\Users\jwScott\Documents\workspace\labelSerialNumberProject\scanningProcess\%prtnum%*')do set var=%%~nxi 
::for /f tokens^=* %%i in ('where .:*')do %%~nxi
for /f "delims=" %%F in ('where %prtnum%*.txt') do set var=%%F

::printer name?
echo %var%
PAUSE