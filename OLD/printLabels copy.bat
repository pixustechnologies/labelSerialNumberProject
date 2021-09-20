@echo off
set orderNum=50004218
set serialNum=019010102
::echo %orderNum%
	::C:\Program Files\Millet Software\DataLink Viewer 2011\DataLink_Viewer_2011.exe" -v "C:\temp\Report.rpt" "user_id:dba" "password:sql" "Parm1:%orderNum%" "Printer:\\Srv1\Small2"
	::C:\Program Files\Millet Software\DataLink Viewer 2011\DataLink_Viewer_2011.exe" -v "C:\temp\Report.rpt" "user_id:dba" "password:sql" "Parm1:%orderNum%" "Printer:\\Srv1\Large1"
	:: PRINTER NAMES UNTESTED
	:: can move reports to local 
::"C:\Program Files\Visual CUT 11\Visual CUT.exe" -e "\\WATDBS01\ExactShared\Exact\RMServer\Modified Reports\boxLabel.rpt" "Parm1:%orderNum%" "Parm2:%serialNum%" "Printer_Only:ZDesigner LP 2844"
::"C:\Program Files\Visual CUT 11\Visual CUT.exe" -e "\\WATDBS01\ExactShared\Exact\RMServer\Modified Reports\productLabel.rpt" "Parm1:%orderNum%" "Parm2:%serialNum%" "Printer_Only:ZDesigner 105SL"

md \PrintedReports\%serialNum%
md \PrintedReports\hello
md test
md %serialNum%

echo.
echo Finished Printing
echo.
PAUSE


