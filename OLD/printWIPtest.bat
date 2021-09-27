@echo off
set prtnum="VVVVV12"
	
:: the configuration sheets
:: searches for the correct file, then prints

set searchPath="\\WATNAS\Userdata\Projects"
set foundFilePath=
echo Searching for the Configuration Sheet...
FOR /R "%searchPath%" %%a  in (%prtnum%*.docx) DO (
    IF EXIST "%%~fa" (
        echo "%%~fa" 
        SET foundFilePath=%%~fa
    )
)
echo Finished Searching
::call "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" /q /n "%foundFilePath%" /mFilePrintDefault /mFileCloseOrExit /mFileExit 

:: dialoge box to indicate it finished printing
echo.
echo Finished Printing
echo.
PAUSE
