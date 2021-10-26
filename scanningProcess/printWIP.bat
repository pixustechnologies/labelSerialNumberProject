@echo off
:: takes in ORDNUM_10, PRTNUM_10, DUEQTY_10, PRTNUM_11
set orderNum=%1
set prtnum=%2
set printNum=%3
set prtnumAbove=%4

set exePath=C:\Program Files (x86)\Visual CUT 11\Visual CUT.exe
set reportPath=\\WATDBS01\ExactShared\Shop Order Processing\
set printerName=\\waterp01\PXS - MXM363N PCL6

echo Printing the Serial Number Lists
:: the list of serial numbers
if /i "%prtnum:~0,3%" == "02A" goto :assy

:: this is for normal parts
"%exePath%" -e "%reportPath%SerialNumberList_v2.rpt" "Parm1:%orderNum%" "Export_Format:Printer (Specified)" "Export_File:%printerName%" "Print_Copies:%printNum%"
goto :bom

:assy &:: this is for parts that are assemblys, which dont have a assembly number
"%exePath%" -e "%reportPath%SerialNumberList_v3.rpt" "Parm1:%orderNum%" "Export_Format:Printer (Specified)" "Export_File:%printerName%" "Print_Copies:%printNum%"

:bom
echo Printing the BOM
:: the BOM
"%exePath%" -e "%reportPath%BOMRPTv2.rpt" "Parm1:%prtnumAbove%" "Export_Format:Printer (Specified)" "Export_File:%printerName%" "Use_Saved_Data_Recent:2"

:: the configuration sheets
:: searches for the correct file, then prints
set searchPath="\\WATNAS\Userdata\Projects"
set foundFilePath=
echo Searching for the Configuration Sheet...
FOR /R "%searchPath%" %%a  in (%prtnum%*.docx) DO (
    IF EXIST "%%~fa" (
        echo "%%~fa" 
        SET foundFilePath=%%~fa
    )
)
echo Printing "%foundFilePath%"
echo Finished Searching
if "%foundFilePath%" == "" (
    goto :skip
) 
call "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" /q /n "%foundFilePath%" /mFilePrintDefault /mFileCloseOrExit /mFileExit 
:skip
:: dialoge box to indicate it finished printing
echo.
echo Finished Printing
echo.
PAUSE
