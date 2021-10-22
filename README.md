# labelSerialNumberProject

setup TASK SCHEUDLAR
Need initScan to be called on computer bootup. 
LogCleaner need to be called once a year, will clear 20% of that year's barcodes, regardless of they are still being used
Weeks reset on Sunday 1am
Year resets on The 1st of january 1am

count up needs to be called every time something prints, include in loop.

TECH DEBT:
- Autohotkey needs to be installed on host computer
- If SQL isn’t used, we don’t need the compiler on each computer, otherwise might need Mingw compiler on host computer and MSSQL
- Scanner needs to preamble with F9
- User needs to type number of prints they want, defaulted to SQL
- Windows Task Scheduler will need to be setup on host computer, if it changes, the system will not work
    - Bat files cant execute on network computers thus needs to be local
- Percentage of barcodes removed every year is customizable
    - Easily found in code of scannerUsageCheck.cpp
    - Then compiled again
- Location of data and relevant files is hyper dependent on code
- Report extract is impossible to work with
- Crystal reports wont intake a text file easily, serial number is being imported as a parameter via visual cut
    - Tried ODBC text file
- Set paper printer to default to duplex
- INSTALL SQL SERVER 2019, download x86 and x64 and seperate installer? 
- update file paths with respective user
- DONT change any settings in Visual CUT, as the commandline only overrides a few of them and can cause unpredicted behaviour
- Silent PDF printing:
    - https://stackoverflow.com/questions/19124808/printing-pdfs-from-windows-command-line
    - http://www.columbia.edu/~em36/pdftoprinter.html
- https://github.com/pixustechnologies/labelSerialNumberProject
