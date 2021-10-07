@echo off
:: takes in ORDNUM_10, Serial Number
set orderNum=%1
set serialNum=%2

:: makes a new folder for the current set of documents
set folderPath=\\WATNAS\Production\Saved_Labels\%serialNum%
mkdir %folderPath%

:: PRINTER NAMES TBD
:: QA sheet printing, and saving of file
set exePath="C:\Program Files (x86)\Visual CUT 11\Visual CUT.exe"
set reportName="\\WATDBS01\ExactShared\Exact\RMServer\Modified Reports\QAInspectionv22.rpt"
set printerName=\\waterp01\PXS-PRN-SHOP-BRTHR
%exePath% -e %reportName% "Parm1:%orderNum%" "Parm2:%serialNum%" "Export_Format:Image" "Export_File:%folderPath%\QA.jpg" "Use_Saved_Data_Recent:5"
%exePath% -e %reportName% "Parm1:%orderNum%" "Parm2:%serialNum%" "Export_Format:Printer (Specified)" "Export_File:%printerName%" "Use_Saved_Data_Recent:5"

