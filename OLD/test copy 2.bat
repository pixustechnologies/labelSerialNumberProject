@echo off
:: takes in a search path, and the document number 
set searchPath=\\WATNAS\Production\Serial No Tracking
set documentName=Serial_No_Tracking

:: searchs for the document
set foundFilePath=
echo Searching for the Document...
FOR /R "%searchPath%" %%a  in (*%documentName%*) DO (
    IF EXIST "%%~fa" (
        echo "%%~fa" 
        SET foundFilePath=%%~fa
    )
)
echo Finished Searching

:: gets the file extension
FOR %%i IN ("%foundFilePath%") DO (
set filename=%%~ni
set fileextension=%%~xi
)

:: checks which print type to do
:: might need to get rid of quotes around document
if "%fileextension%" == ".pdf" GOTO :pdf
if "%fileextension%" == ".PDF" GOTO :pdf
if "%fileextension%" == ".docx" GOTO :docx
if "%fileextension%" == ".DOCX" GOTO :docx
if "%fileextension%" == ".xlsx" GOTO :xlsx
if "%fileextension%" == ".XLSX" GOTO :xlsx
GOTO :end
:pdf
"C:\Users\%USERNAME%\Documents\labelSerialNumberProject\install\PDFtoPrinter.exe" /s "%foundFilePath%"
GOTO :end
:docx
call "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" /q /n "%foundFilePath%" /mFilePrintDefault /mFileCloseOrExit /mFileExit
GOTO :end
:xlsx
powershell -command "start-process -filepath '%foundFilePath%' -verb print"
:end
PAUSE