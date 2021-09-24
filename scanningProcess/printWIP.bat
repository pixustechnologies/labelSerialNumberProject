@echo off
:: takes in ORDNUM_10, PRTNUM_10, and DUEQTY_10
set orderNum=%1
set prtnum=%2
set printNum=%3

set exePath="C:\Program Files\Visual CUT 11\Visual CUT.exe"
set reportPath="\\WATDBS01\ExactShared\Exact\RMServer\Modified Reports\"
:: the BOM
"%exePath%" -e "%reportPath%SHPPAPER.rpt" "Parm1:%orderNum%" "Printer:\\WATERP01.pixus-tech.local\PXS-MXM363N PCL6" "Use_Saved_Data_Recent:5"

:: the list of serial numbers
set /a "index = 1"
:while1
if %index% leq %printNum% (
	"%exePath%" -e "%reportPath%SerialNumberList_v2.rpt" "Parm1:%orderNum%" "Printer:\\WATERP01.pixus-tech.local\PXS-MXM363N PCL6" "Use_Saved_Data_Recent:5"
	echo Printing Number %index%
	set /a "index = index + 1"
	goto :while1
)
	
:: the configuration sheets
:: searches for the correct file, then prints
set searchPath="\\WATNAS\Userdata\Projects\Configuration Sheets"
set foundFilePath=
echo Searching for the Configuration Sheet...
FOR /R "%searchPath%" %%a  in (%prtnum%*.docx) DO (
    IF EXIST "%%~fa" (
        echo "%%~fa" 
        SET foundFilePath=%%~fa
    )
)
echo Printing -> "%foundFilePath%"
echo Finished Searching
call "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" /q /n "%foundFilePath%" /mFilePrintDefault /mFileCloseOrExit /mFileExit 

:: dialoge box to indicate it finished printing
echo.
echo Finished Printing
echo.
timeout 5
