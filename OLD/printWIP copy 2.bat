@echo off
set prtnum=VPX6VR180-211
:: the configuration report
::for /f tokens^=* %%i in ('where .:*')do %%~nxi
::for /f "delims=" %%F in ('where java') do set var=%%F
::net use q: \\WATNAS\Userdata\Projects\Configuration_Sheets  /user:JacobS COop2021!
::for /f tokens^=* %%i in ('where %address%%prtnum%*.docx')do set var=%%~nxi 
::printer name?
:: also maybe just print from te \\watnas?
::where %address%%prtnum%*
::where r/ C:\Users\jwScott\Documents\ConfigReports\
::where r/ C:\Users\jwScott\Documents\ *
::where %prtnum%*
::echo %var%
::print %var% /c /d:lpt1




:: the drive or path to search. (In this case searching current drive)
::set searchPath=\\WATNAS\Userdata\Projects\Configuration Sheets\
set searchPath=C:\Users\jwScott\Documents\ConfigReports\
:: If the file is found. This variable will be set
set foundFilePath=
echo Loading...
:: echos all found paths and returns the last occurrance of the file path
FOR /R "%searchPath%" %%a  in (%prtnum%*.docx) DO (
    IF EXIST "%%~fa" (
        echo "%%~fa" 
        SET foundFilePath=%%~fa
    )
)
echo Finished Searching
::PRINTER NAME IS SERVER NAME AFTER wmic printer list full
::AND GO TO PROPERTIES THEN SHARING NAME FOR THE PRINTER NAME
print /d:"\\WATERP01.pixus-tech.local\PXS-MXM363N PCL6" "%foundFilePath%"

call "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" "%foundFilePath%" /q /n /mFilePrintDefault /mFileExit

::set foundFilePath=%foundFilePath: =_%

echo.
echo Finished Printing
echo.
PAUSE
