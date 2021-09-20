@echo off
:: takes in ORDNUM_10, Serial Number, Report Name, and Input Specification
set orderNum=%1
set serialNum=%2
set reportName=%3
set inputSpec=%4

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
if %reportName% == "01A000037-A01" (
	set printerName="1.25x25-Citizen CLP-631"
) else if %reportName% == "01A000038-A01" (
	set printerName="1.25x25-Citizen CLP-631"
) else if %reportName% == "01A000039-A01" (
	set printerName="2.0x0.25 - Citizen CLP-631"
) else if %reportName% == "01A000040-A01" (
	set printerName="1.25x25-Citizen CLP-631"
) else if %reportName% == "01A000041-A02" (
	set printerName="ZDesigner 105SL 300DPI"
) else if %reportName% == "01A000042-A01" (
	set printerName="075x25-Citizen CLP-631"
) else if %reportName% == "01A000052-A01" (
	set printerName="2.0x0.25 - Citizen CLP-631"
) else if %reportName% == "01A000077-A01" (
	set printerName="2.0x0.25 - Citizen CLP-631"
) else if %reportName% == "01A000163-A01" (
	set printerName="1.25x25-Citizen CLP-631"
) else if %reportName% == "01A0001XX-A01" (
	:: fix XX here when label is created
	set printerName="PXS-LP2844-02"
) else {
	goto :noMatch
}

:: prints file, and saves file to folder
"%exePath%" -e "%foundFilePath%" "Parm1:%orderNum%" "Parm2:%serialNum%" "Parm3:%inputSpec%" "Printer_Only:%printerName%" "Use_Saved_Data_Recent:5"
"%exePath%" -e "%foundFilePath%" "Parm1:%orderNum%" "Parm2:%serialNum%" "Parm3:%inputSpec%" "Export_Format:Adobe Acrobat (pdf)" "Export_File:%folderPath%\Label_%reportName%.pdf" "Use_Saved_Data_Recent:5"
:: change file output format still
:: "Adobe Acrobat (pdf)" 
:: (see valid export format options in the Visual CUT drop-down list for export formats). 
:: PAGE 103

:noMatch