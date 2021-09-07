@echo off
set orderNum=%1
set printNum=%2
echo.

:: simple loop, x times
set /a "index = 1"
:while1
if %index% leq %printNum% (
	::C:\Program Files\Millet Software\DataLink Viewer 2011\DataLink_Viewer_2011.exe" -v "C:\temp\Report.rpt" "user_id:dba" "password:sql" "Parm1:%orderNum%" "Printer:\\Srv1\Small2"
	::C:\Program Files\Millet Software\DataLink Viewer 2011\DataLink_Viewer_2011.exe" -v "C:\temp\Report.rpt" "user_id:dba" "password:sql" "Parm1:%orderNum%" "Printer:\\Srv1\Large1"
	:: PRINTER NAMES UNTESTED
	"C:\Program Files\Visual CUT 11\Visual CUT.exe" -e "\\WATDBS01\ExactShared\Exact\RMServer\Modified Reports\boxLabel.rpt" "Parm1:%orderNum%" "Printer_Only:ZDesigner LP 2844"
	"C:\Program Files\Visual CUT 11\Visual CUT.exe" -e "\\WATDBS01\ExactShared\Exact\RMServer\Modified Reports\productLabel.rpt" "Parm1:%orderNum%" "Printer_Only:ZDesigner 105SL"
	:: calls the counting bat to ensure the serial number changes per label
	call serialNumberCountUp.bat
	echo Printing Number %index%
	set /a "index = index + 1"
	goto :while1
)
echo.
echo Finished Printing
echo.
PAUSE
