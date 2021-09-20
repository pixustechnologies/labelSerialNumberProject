@echo off
set prtnum=VPX
set address=
:: the configuration report
::for /f tokens^=* %%i in ('where .:*')do %%~nxi
::for /f "delims=" %%F in ('where java') do set var=%%F
::net use q: \\WATNAS\Userdata\Projects\Configuration_Sheets  /user:JacobS COop2021!
for /f tokens^=* %%i in ('where %prtnum%*')do set var=%%~nxi 
::printer name?
:: also maybe just print from te \\watnas?
where *%address%*%prtnum%*
echo %var%
::print %var% /c /d:lpt1


SET PrinterName =10.10.1.95
SET file=%TEMP%\bLog.txt
RUNDLL32.EXE PRINTUI.DLL,PrintUIEntry /Xg /n "%PrinterName%" /f "%file%" /q

IF EXIST "%file%" (
   ECHO %PrinterName% printer exists
) ELSE (
   ECHO %PrinterName% printer does NOT exists
)



:: the configuration report
:: \\WATNAS\Userdata\Projects\Configuration Sheets
::for /f tokens^=* %%i in ('where .:*')do %%~nxi
::for /f "delims=" %%F in ('where java') do set var=%%F
for /f tokens^=* %%i in ('where \\\\WATNAS\Userdata\\Projects\\Configuration Sheets\\%prtnum%*.docx')do set var=%%~nxi 
::printer name?
:: also maybe just print from te \\watnas?
print %var% /c /d:lpt1





echo.
echo Finished Printing
echo.
PAUSE
