@echo off
:: takes in ORDNUM_10, Serial Number, Report Name, and Input Specification
set orderNum=%1
set serialNum=%2
set reportName=%3
set inputSpec=%4

set folderPath=
set searchPath="\\WATDBS01\ExactShared\Exact\RMServer\Modified Reports\"
set foundFilePath=
FOR /R "%searchPath%" %%a  in (%prtnum%*.docx) DO (
    IF EXIST "%%~fa" (
        echo "%%~fa" 
        SET foundFilePath=%%~fa
    )
)
echo "%foundFilePath%"
set printerName=
set exePath="C:\Program Files\Visual CUT 11\Visual CUT.exe"
:: PRINTER NAMES UNTESTED
if %reportName% == "01A000037-A01" (
	set printerName=""
) else if %reportName% == "01A000038-A01" (
	set printerName=""
) else if %reportName% == "01A000039-A01" (
	set printerName=""
) else if %reportName% == "01A000040-A01" (
	set printerName=""
) else if %reportName% == "01A000041-A02" (
	set printerName="ZDesigner 105SL"
) else if %reportName% == "01A000042-A01" (
	set printerName=""
) else if %reportName% == "01A000052-A01" (
	set printerName=""
) else if %reportName% == "01A000077-A01" (
	set printerName=""
) else if %reportName% == "01A000163-A01" (
	set printerName=""
)
:: missing the box label still

"%exePath%" -e "%foundFilePath%" "Parm1:%orderNum%" "Parm2:%serialNum%" "Parm3:%inputSpec%" "Printer_Only:%printerName%"
"%exePath%" -e "%foundFilePath%" "Parm1:%orderNum%" "Parm2:%serialNum%" "Parm3:%inputSpec%" "Export_Format:" "Export_File:%folderPath%Label%reportName%.file"
:: REPRINT THE VISUAL CUT FILES INTO FOLDER
:: "Adobe Acrobat (pdf)" 
:: (see valid export format options in the Visual CUT drop-down list for export formats). 
:: PAGE 103