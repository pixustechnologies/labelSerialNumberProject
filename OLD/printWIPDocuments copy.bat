@echo off
set searchPath="\\WATNAS\Userdata\Projects"
set documentName="04A000132-B01U01 - Stackup + Impedance"

set foundFilePath=
echo Searching for the Configuration Sheet...
FOR /R "%searchPath%" %%a  in (*%documentName%*) DO (
    IF EXIST "%%~fa" (
        echo "%%~fa" 
        SET foundFilePath=%%~fa
    )
)
echo Finished Searching

FOR %%i IN ("%foundFilePath%") DO (
set filename=%%~ni
set fileextension=%%~xi
)
:: might need to get rid of quotes around document
if "%fileextension%" == ".pdf" GOTO :pdf
if "%fileextension%" == ".PDF" GOTO :pdf
if "%fileextension%" == ".docx" GOTO :docx
if "%fileextension%" == ".DOCX" GOTO :docx
GOTO :end
:pdf
"C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe" /t "%foundFilePath%"
GOTO :end
:docx
call "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" /q /n "%foundFilePath%" /mFilePrintDefault /mFileCloseOrExit /mFileExit

:end
PAUSE