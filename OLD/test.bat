@echo off
set exePath=C:\Program Files (x86)\Visual CUT 11\Visual CUT.exe
set reportPath=\\WATDBS01\ExactShared\Exact\RMServer\Modified Reports\
set printerName=\\waterp01\1.25x25-Citizen CLP-631
set orderNum=50004321
set printNum=1


"%exePath%" -e "%reportPath%01A000037-A01 INS LBL 1.25x0.25 Serial Number.RPT.rpt" "Parm1:%orderNum%" "Parm2:021430101" "Export_Format:Printer (Specified)" "Export_File:%printerName%" "Print_Copies:%printNum%"


PAUSE