@echo off
:: takes in ORDNUM_10, Serial Number, Document Path, Document Name
set orderNum=%1
set serialNum=%2
set searchPath=%3
set documentName=%4

:: searchs for the document
set foundFilePath=
echo Searching for the Document...
FOR /R "%searchPath%" %%a  in (*%documentName%*) DO (
    IF EXIST "%%~fa" (
        echo "%%~fa" 
        SET foundFilePath=%%~fa
    )
)

:: prints out the crystal report
set exePath="C:\Program Files (x86)\Visual CUT 11\Visual CUT.exe"
set reportName="\\WATDBS01\ExactShared\Exact\RMServer\Modified Reports\QAInspectionv22.rpt"
set printerName=\\waterp01\PXS-PRN-SHOP-BRTHR
%exePath% -e %foundFilePath% "Parm1:%orderNum%" "Parm2:%serialNum%" "Export_Format:Printer (Specified)" "Export_File:%printerName%" "Use_Saved_Data_Recent:5"
