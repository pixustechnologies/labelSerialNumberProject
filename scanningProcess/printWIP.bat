@echo off
set orderNum=%1

:: simple loop
set /a "index = 1"
:while1
if %index% leq %printNum% (
	C:\Program Files\Millet Software\DataLink Viewer 2011\DataLink_Viewer_2011.exe" -v "C:\temp\Report.rpt" "user_id:dba" "password:sql" "Parm1:%orderNum%" "Printer:\\Srv1\Small2"
	C:\Program Files\Millet Software\DataLink Viewer 2011\DataLink_Viewer_2011.exe" -v "C:\temp\Report.rpt" "user_id:dba" "password:sql" "Parm1:%orderNum%" "Printer:\\Srv1\Large1"
	echo Printing Number %index%
	set /a "index = index + 1"
	goto :while1
)
echo.
echo Finished Printing
echo.
PAUSE
