@echo off
:: takes in ORDNUM_10, Serial Number
set orderNum=%1
set serialNum=%2

:: QA sheet printing, and saving of file
set exePath="C:\Program Files (x86)\Visual CUT 11\Visual CUT.exe"
set reportName="\\WATDBS01\ExactShared\Exact\RMServer\Modified Reports\QAInspectionv22.rpt"
set printerName=\\waterp01\PXS-PRN-SHOP-BRTHR
%exePath% -e %reportName% "Parm1:%orderNum%" "Parm2:%serialNum%" "Export_Format:Printer (Specified)" "Export_File:%printerName%" "Use_Saved_Data_Recent:5"

