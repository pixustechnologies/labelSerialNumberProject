@echo off
:: takes in ORDNUM_10, and NOTES_61
set orderNum=%1
set reportName=%2

set printerName="\\WATERP01.pixus-tech.local\PXS-MXM363N PCL6"
set exePath="C:\Program Files\Visual CUT 11\Visual CUT.exe"
set reportPath="\\WATDBS01\ExactShared\Exact\RMServer\Modified Reports\"

if "%~3" == "" (
	"%exePath%" -e "%reportPath%%reportName%.rpt" "Parm1:%orderNum%" "Printer_Only:%printerName%" "Use_Saved_Data_Recent:5"
) else if "%~4" == "" (
	"%exePath%" -e "%reportPath%%reportName%.rpt" "Parm1:%orderNum%" "Parm2:%3" "Printer_Only:%printerName%" "Use_Saved_Data_Recent:5"
) else if "%~5" == "" (
	"%exePath%" -e "%reportPath%%reportName%.rpt" "Parm1:%orderNum%" "Parm2:%3" "Parm3:%4" "Printer_Only:%printerName%" "Use_Saved_Data_Recent:5"
) else (
	"%exePath%" -e "%reportPath%%reportName%.rpt" "Parm1:%orderNum%" "Parm2:%3" "Parm3:%4" "Parm4:%5" "Printer_Only:%printerName%" "Use_Saved_Data_Recent:5"
)