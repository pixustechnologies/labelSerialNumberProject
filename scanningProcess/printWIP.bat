@echo off
set orderNum=%1
set prtnum=%2
set printNum=%3

:: the BOM
"C:\Program Files\Visual CUT 11\Visual CUT.exe" -e "\\WATDBS01\ExactShared\Exact\RMServer\Modified Reports\SHPPAPER.rpt" "user_id:dba" "password:sql" "Parm1:%orderNum%" "Printer:\\Srv1\Small2"


:: the configuration report
:: \\WATNAS\Userdata\Projects\Configuration Sheets
::for /f tokens^=* %%i in ('where .:*')do %%~nxi
::for /f "delims=" %%F in ('where java') do set var=%%F
for /f tokens^=* %%i in ('where \\\\WATNAS\Userdata\\Projects\\Configuration Sheets\\%prtnum%*.docx')do set var=%%~nxi 
::printer name?
:: also maybe just print from te \\watnas?
print %var% /c /d:lpt1


:: the list of serial numbers
set /a "index = 1"
:while1
if %index% leq %printNum% (
	"C:\Program Files\Visual CUT 11\Visual CUT.exe" -e "\\WATDBS01\ExactShared\Exact\RMServer\Modified Reports\SerialNumberList_V2.rpt" "user_id:dba" "password:sql" "Parm1:%orderNum%" "Parm2:%prtnum%" "Printer:\\Srv1\Large1"
	echo Printing Number %index%
	set /a "index = index + 1"
	goto :while1
)

echo.
echo Finished Printing
echo.
PAUSE
