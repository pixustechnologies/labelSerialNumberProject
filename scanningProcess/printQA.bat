@echo off
:: takes in ORDNUM_10, Serial Number
set orderNum=%1
set serialNum=%2

:: makes a new folder for the current set of documents
set folderPath="\\WATNAS\Production\Saved Labels\%serialNum%"
mkdir %folderPath%

:: PRINTER NAMES TBD
:: QA sheet printing, and saving of file
set exePath="C:\Program Files\Visual CUT 11\Visual CUT.exe"
set reportName="\\WATDBS01\ExactShared\Exact\RMServer\Modified Reports\QAInspection2.2.rpt"
::"%exePath%" -e "%reportName%" "Parm1:%orderNum%" "Parm2:%serialNum%" "Printer_Only:\\WATERP01.pixus-tech.local\PXS-MXM363N PCL6" "Use_Saved_Data_Recent:5"
::"%exePath%" -e "%reportName%" "Parm1:%orderNum%" "Parm2:%serialNum%" "Export_Format:Adobe Acrobat (pdf)" "Export_File:%folderPath%\QA.pdf" "Use_Saved_Data_Recent:5"
