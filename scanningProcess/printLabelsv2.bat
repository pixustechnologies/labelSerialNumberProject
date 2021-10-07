@echo off
:: takes in ORDNUM_10, Serial Number, Report Name, and Input Specification
set orderNum=%1
set serialNum=%2
set reportName=%3
set prtnum=%4

set folderPath=\\WATNAS\Production\Saved_Labels\%serialNum%
set exePath=C:\Program Files (x86)\Visual CUT 11\Visual CUT.exe
:: searches for the file path where the report is stored
set searchPath=\\WATDBS01\ExactShared\Exact\RMServer\Modified Reports\
set foundFilePath=
FOR /R "%searchPath%" %%a  in (%reportName%*.rpt) DO (
    IF EXIST "%%~fa" (
        echo "%%~fa" 
        SET foundFilePath=%%~fa
    )
)

:: checks which printer to print to
set printerName=
:: PRINTER NAMES UNTESTED
if %prtnum% == "94A000003-A01" (
	set printerName="\\waterp01\2.0x0.25 - Citizen CLP-631"
) else if %prtnum% == "94A000004-A01" (
	set printerName="\\waterp01\075x25-Citizen CLP-631"
) else if %prtnum% == "94A000005-A01" (
	set printerName="\\waterp01\ZDesigner 105SL 300DPI"
) else if %prtnum% == "94A000006-A01" (
	set printerName="\\waterp01\1.25x25-Citizen CLP-631"
) else if %prtnum% == "94A000047-A01" (
	set printerName="\\waterp01\PXS-LP2844-02"
	set printerName="\\waterp01\4x6 Shipping Label"
) else (
	goto :noMatch
)

:: prints file, and saves file to folder
if "%~5" == "" (
	"%exePath%" -e "%foundFilePath%" "Parm1:%orderNum%" "Parm2:%serialNum%" "Printer:%printerName%" "Export_Format:Printer (Specified)" "Export_File:\\waterp01\PXS-PRN-SHOP-BRTHR" "Use_Saved_Data_Recent:5"
	"%exePath%" -e "%foundFilePath%" "Parm1:%orderNum%" "Parm2:%serialNum%" "Printer:%printerName%" "Export_Format:Image" "Export_File:%folderPath%\Label_%reportName%.jpg" "Use_Saved_Data_Recent:5"
) else ( 
	if "%~6" == "" (
		"%exePath%" -e "%foundFilePath%" "Parm1:%orderNum%" "Parm2:%serialNum%" "Parm3:%5" "Printer_Only:%printerName%" "Export_Format:Printer (Specified)" "Export_File:\\waterp01\PXS-PRN-SHOP-BRTHR" "Use_Saved_Data_Recent:5"
		"%exePath%" -e "%foundFilePath%" "Parm1:%orderNum%" "Parm2:%serialNum%" "Parm3:%5" "Printer_Only:%printerName%" "Export_Format:Image" "Export_File:%folderPath%\Label_%reportName%.jpg" "Use_Saved_Data_Recent:5"
	) else (
		if "%~7" == "" (
			"%exePath%" -e "%foundFilePath%" "Parm1:%orderNum%" "Parm2:%serialNum%" "Parm3:%5" "Parm4:%6" "Printer_Only:%printerName%" "Export_Format:Printer (Specified)" "Export_File:\\waterp01\PXS-PRN-SHOP-BRTHR" "Use_Saved_Data_Recent:5"
			"%exePath%" -e "%foundFilePath%" "Parm1:%orderNum%" "Parm2:%serialNum%" "Parm3:%5" "Parm4:%6" "Printer_Only:%printerName%" "Export_Format:Image" "Export_File:%folderPath%\Label_%reportName%.jpg" "Use_Saved_Data_Recent:5"
		) else (
			"%exePath%" -e "%foundFilePath%" "Parm1:%orderNum%" "Parm2:%serialNum%" "Parm3:%5" "Parm4:%6" "Parm5:%7" "Printer_Only:%printerName%" "Export_Format:Printer (Specified)" "Export_File:\\waterp01\PXS-PRN-SHOP-BRTHR" "Use_Saved_Data_Recent:5"
			"%exePath%" -e "%foundFilePath%" "Parm1:%orderNum%" "Parm2:%serialNum%" "Parm3:%5" "Parm4:%6" "Parm5:%7" "Printer_Only:%printerName%" "Export_Format:Image" "Export_File:%folderPath%\Label_%reportName%.jpg" "Use_Saved_Data_Recent:5"
		)
	)
)

:noMatch