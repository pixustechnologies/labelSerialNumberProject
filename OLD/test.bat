@echo off
set exePath=C:\Program Files (x86)\Visual CUT 11\Visual CUT.exe
set reportPath=\\WATNAS\Production\Manufacturing Instructions\Crystal Label Reports\
set printerName=\\waterp01\ZDesigner 105SL 300DPI
set orderNum=50004365


"%exePath%" -e "%reportPath%01A000041-A02 INS LBL 3x2 Chassis.rpt" "Parm1:%orderNum%" "Parm2:021430101" "Parm3:Input: 100-240 VAC 10 AMPS MAX" "Export_Format:Printer (Specified)" "Export_File:%printerName%"


PAUSE