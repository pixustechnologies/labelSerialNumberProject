@echo off
:: takes in ORDNUM_10, PRTNUM_10, DUEQTY_10, PRTNUM_11
set orderNum=%1
set prtnum=%2
set printNum=%3
set prtnumAbove=%4

set exePath=C:\Program Files (x86)\Visual CUT 11\Visual CUT.exe
set reportPath=\\WATDBS01\ExactShared\Shop Order Processing\
set printerName=\\waterp01\PXS-PRN-SHOP-BRTHR

echo Printing the BOM
:: the BOM
"%exePath%" -e "%reportPath%BOMRPTv2.rpt" "Parm1:%prtnumAbove%" "Export_Format:Printer (Specified)" "Export_File:%printerName%" "Use_Saved_Data_Recent:2"

echo Printing the Serial Number Lists
:: the list of serial numbers
if /i "%prtnum:~0,3%" == "02A" goto :assy
if /i "%prtnum:~0,4%" == "K02A" goto :assy

:: this is for normal parts
"%exePath%" -e "%reportPath%SerialNumberList_v2.rpt" "Parm1:%orderNum%" "Export_Format:Printer (Specified)" "Export_File:%printerName%" "Print_Copies:%printNum%"
goto :config

:assy &:: this is for parts that are assemblys, which dont have a assembly number
"%exePath%" -e "%reportPath%SerialNumberList_v3.rpt" "Parm1:%orderNum%" "Export_Format:Printer (Specified)" "Export_File:%printerName%" "Print_Copies:%printNum%"

:config
:: the configuration sheets
:: searches for the correct file, then prints
set searchPath="\\WATNAS\Userdata\Projects"
echo Searching for the Configuration Sheet...

setlocal enableDelayedExpansion
set foundCnt=0
FOR /R "%searchPath%" %%a  in (%prtnum%*.docx) DO (
    IF EXIST "%%~fa" (
        echo "%%~fa" 
        set /a foundCnt +=1
        SET "foundFilePath!foundCnt!=%%~fa"
    )
)
echo Finished Searching
if %foundCnt% == 0 (
    goto :skip
) 
if %foundCnt% == 1 (
    echo Printing "%foundFilePath1%"
    call "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" /q /n "%foundFilePath1%" /mFilePrintDefault /mFileCloseOrExit /mFileExit 
) else (
    ::print menu
    for /l %%N in (1 1 %foundCnt%) do echo %%N - !foundFilePath%%N!
    set /p selection="Enter a folder number: "
    for /l %%N in (1 1 %foundCnt%) do if !selection! == %%N (call "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" /q /n "!foundFilePath%%N!" /mFilePrintDefault /mFileCloseOrExit /mFileExit )
)

:skip
:: dialoge box to indicate it finished printing
echo.
echo Finished Printing
echo.
PAUSE
