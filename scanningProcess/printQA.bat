@echo off
:: takes in ORDNUM_10, Serial Number
set orderNum=%1
set serialNum=%2

set folderPath=
:: need full path of where to put the files 
mkdir C:\PrintedReports\%serialNum%

:: PRINTER NAMES UNTESTED
:: QA sheet
set exePath="C:\Program Files\Visual CUT 11\Visual CUT.exe"
set reportName="\\WATDBS01\ExactShared\Exact\RMServer\Modified Reports\QAInspection2.2.rpt"
"%exePath%" -e "%reportName%" "Parm1:%orderNum%" "Parm2:%serialNum%" "Printer_Only:\\WATERP01.pixus-tech.local\PXS-MXM363N PCL6"
:: output second to a file in 
"%exePath%" -e "%reportName%" "Parm1:%orderNum%" "Parm2:%serialNum%" "Export_Format:" "Export_File:%folderPath%QA%serialNum%.file"
