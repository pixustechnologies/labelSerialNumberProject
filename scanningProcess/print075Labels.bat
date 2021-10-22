@echo off
:: takes in Serial Number
set serialNum=%1
set reportName=01A000199-A01 INS LBL 0.75x0.25 Serial Number Small by 4

set exePath=C:\Program Files (x86)\Visual CUT 11\Visual CUT.exe
:: searches for the file path where the report is stored
set searchPath=\\WATNAS\Production\Manufacturing Instructions\Crystal Label Reports
set foundFilePath=
FOR /R "%searchPath%" %%a  in (%reportName%*.rpt) DO (
    IF EXIST "%%~fa" (
        echo "%%~fa" 
        SET foundFilePath=%%~fa
    )
)

set printerName="\\waterp01\075x25-Citizen CLP-631"

:: prints file
if "%~2" == "" (
	"%exePath%" -e "%foundFilePath%" "Parm1:%1" "Export_Format:Printer (Specified)" "Export_File:%printerName%" "Use_Saved_Data_Recent:5"
) else ( 
	if "%~3" == "" (
		"%exePath%" -e "%foundFilePath%" "Parm1:%1" "Parm2:%2" "Export_Format:Printer (Specified)" "Export_File:%printerName%" "Use_Saved_Data_Recent:5"
	) else (
		if "%~4" == "" (
			"%exePath%" -e "%foundFilePath%" "Parm1:%1" "Parm2:%2" "Parm3:%3" "Export_Format:Printer (Specified)" "Export_File:%printerName%" "Use_Saved_Data_Recent:5"
		) else (
			"%exePath%" -e "%foundFilePath%" "Parm1:%1" "Parm2:%2" "Parm3:%3" "Parm4:%4" "Export_Format:Printer (Specified)" "Export_File:%printerName%" "Use_Saved_Data_Recent:5"
		)
	)
)
