@echo off
set document="\\WATNAS\home\Jacob\Documents\ActionQ_User_Manual.pdf"

for %%a in (%document%) do (
    set file=%%~fa
    set filepath=%%~dpa
    set filename=%%~nxa
)    

FOR %%i IN ("%filename%") DO (
echo filename2=%%~ni
set fileextension=%%~xi
)
echo "%fileextension%"
if "%fileextension%" == ".pdf" (
    echo pdf
	"C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe" /t %document%
) else if "%fileextension%" == ".docx" (
    echo docx
	call "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" /q /n %document% /mFilePrintDefault /mFileCloseOrExit /mFileExit
)
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set prtnum="EUR19VPX-4415-022-0"
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
