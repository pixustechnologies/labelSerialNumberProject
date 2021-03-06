@echo off
:: takes in ORDNUM_10, the serial number, boolean if last copy, and input specification
set orderNum=%1
set serialNum=%2
set printNum=%3
set inputSpec=%4

::the printing
	::C:\Program Files\Millet Software\DataLink Viewer 2011\DataLink_Viewer_2011.exe" -v "C:\temp\Report.rpt" "user_id:dba" "password:sql" "Parm1:%orderNum%" "Printer:\\Srv1\Small2"
	::C:\Program Files\Millet Software\DataLink Viewer 2011\DataLink_Viewer_2011.exe" -v "C:\temp\Report.rpt" "user_id:dba" "password:sql" "Parm1:%orderNum%" "Printer:\\Srv1\Large1"
	:: PRINTER NAMES UNTESTED
	:: can move reports to local 
"C:\Program Files\Visual CUT 11\Visual CUT.exe" -e "\\WATDBS01\ExactShared\Exact\RMServer\Modified Reports\boxLabel.rpt" "Parm1:%orderNum%" "Parm2:%serialNum%" "Printer_Only:ZDesigner LP 2844"
"C:\Program Files\Visual CUT 11\Visual CUT.exe" -e "\\WATDBS01\ExactShared\Exact\RMServer\Modified Reports\productLabel.rpt" "Parm1:%orderNum%" "Parm2:%serialNum%" "Parm3:%inputSpec%" "Printer_Only:ZDesigner 105SL"

:: QA sheet
"C:\Program Files\Visual CUT 11\Visual CUT.exe" -e "\\WATDBS01\ExactShared\Exact\RMServer\Modified Reports\QAInspection2.2.rpt" "Parm1:%orderNum%" "Parm2:%serialNum%" "Printer_Only:\\WATERP01.pixus-tech.local\PXS-MXM363N PCL6"

:: need full path of where to put the files 
::mkdir C:\PrintedReports\%serialNum%
:: REPRINT ALL OF THE VISUAL CUT FILES INTO THIS FOLDER

:: dialoge box to indicate the printing is finished
if %printNum% == 1 (
	echo.
	echo Finished Printing
	echo.
	PAUSE
)

