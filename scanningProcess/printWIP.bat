@echo off
:: takes in ORDNUM_10, PRTNUM_10, and DUEQTY_10
set orderNum=%1
set prtnum=%2
set printNum=%3

set exePath="C:\Program Files\Visual CUT 11\Visual CUT.exe"
set reportPath="\\WATDBS01\ExactShared\Exact\RMServer\Modified Reports\"
:: the BOM
"%exePath%" -e "%reportPath%SHPPAPER.rpt" "Parm1:%orderNum%" "Printer:\\Srv1\Small2"

:: the list of serial numbers
set /a "index = 1"
:while1
if %index% leq %printNum% (
	"%exePath%" -e "%reportPath%SerialNumberList_v2.rpt" "Parm1:%orderNum%" "Printer:\\Srv1\Large1"
	echo Printing Number %index%
	set /a "index = index + 1"
	goto :while1
)
	
:: the configuration sheets
set searchPath=\\WATNAS\Userdata\Projects\
set foundFilePath=
echo Searching for the Configuration Sheet...
FOR /R "%searchPath%" %%a  in (%prtnum%*.docx) DO (
    IF EXIST "%%~fa" (
        echo "%%~fa" 
        SET foundFilePath=%%~fa
    )
)
echo "%foundFilePath%"
echo Finished Searching
call "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" "%foundFilePath%" /q /n /mFilePrintDefault /mFileExit

:: dialoge box to indicate it finished printing
echo.
echo Finished Printing
echo.
PAUSE
