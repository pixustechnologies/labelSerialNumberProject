@echo off
:: takes in ORDNUM_10, Serial Number, Report Name, and Input Specification
set orderNum=%1
set serialNum=%2
set reportName=%3
set Parm3=%4
set prtnum=%5

set folderPath="\\WATNAS\Production\Saved Labels\%serialNum%"
set exePath="C:\Program Files\Visual CUT 11\Visual CUT.exe"
:: searches for the file path where the report is stored
set searchPath="\\WATDBS01\ExactShared\Exact\RMServer\Modified Reports\"
set foundFilePath=
FOR /R "%searchPath%" %%a  in (%reportName%*.rpt) DO (
    IF EXIST "%%~fa" (
        echo "%%~fa" 
        SET foundFilePath=%%~fa
    )
)
echo "%foundFilePath%"

:: checks which printer to print to
set printerName=
:: PRINTER NAMES UNTESTED
if %prtnum% == "94A000003-A01" (
	set printerName="2.0x0.25 - Citizen CLP-631"
) else if %prtnum% == "94A000004-A01" (
	set printerName="075x25-Citizen CLP-631"
) else if %prtnum% == "94A000005-A01" (
	set printerName="ZDesigner 105SL 300DPI"
) else if %prtnum% == "94A000006-A01" (
	set printerName="1.25x25-Citizen CLP-631"
) else if %prtnum% == "94A000007-A01" (
	set printerName=""
) else if %prtnum% == "94A000009-A01" (
	set printerName=""
) else if %prtnum% == "94A000039-A01" (
	set printerName=""
) else if %prtnum% == "94A000040-A01" (
	set printerName=""
) else if %prtnum% == "94A000041-A01" (
	set printerName=""
) else if %prtnum% == "94A000042-A01" (
	set printerName=""
) else if %prtnum% == "94A000043-A01" (
	set printerName=""
) else if %prtnum% == "94A000044-A01" (
	set printerName=""
) else if %prtnum% == "94A000045-A01" (
	set printerName=""
) else if %prtnum% == "94A000046-A01" (
	set printerName=""
) else if %prtnum% == "94A000047-A01" (
	set printerName="PXS-LP2844-02"
) else {
	goto :noMatch
}

:: prints file, and saves file to folder
:: need to test if parm3 ruins or not !
"%exePath%" -e "%foundFilePath%" "Parm1:%orderNum%" "Parm2:%serialNum%" "Parm3:%Parm3%" "Printer_Only:%printerName%" "Use_Saved_Data_Recent:5"
"%exePath%" -e "%foundFilePath%" "Parm1:%orderNum%" "Parm2:%serialNum%" "Parm3:%Parm3%" "Export_Format:Image" "Export_File:%folderPath%\Label_%reportName%.jpg" "Use_Saved_Data_Recent:5"
:: PAGE 270

:noMatch