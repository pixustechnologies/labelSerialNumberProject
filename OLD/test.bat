@echo off
set exePath=C:\Program Files (x86)\Visual CUT 11\Visual CUT.exe
set reportPath=\\WATNAS\Production\Manufacturing Instructions\Crystal Label Reports\
set printerName=\\waterp01\1.25x25-Citizen CLP-631
set orderNum=50004269
set format=Export_Format:Printer (Specified)
set reportName=01A000037-A01 INS LBL 1.25x0.25 Serial Number.RPT


"%exePath%" -e "%reportPath%%reportName%" "Parm1:%orderNum%" "Parm2:021440106" "%format%" "Export_File:%printerName%"

PAUSE