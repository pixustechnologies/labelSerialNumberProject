# labelSerialNumberProject

Need initScan to be called on computer bootup. 

LogCleaner need to be called once a year, will clear 20% of that year's barcodes, regardless of they are still being used


setup TASK SCHEUDLAR

Weeks reset on Sunday 1am
Year resets on The 1st of january 1am
count up needs to be called every time something prints, include in loop.

TODO on printer computer
- connect to printer
- connect to network files
- print config sheets

IBM SQL Info
http://www.cs.yorku.ca/~jarek/db2/embed-c.html
https://www.ibm.com/support/producthub/db2/docs/content/SSEPGG_11.5.0/com.ibm.db2.luw.apdv.embed.doc/doc/c0020948.html

TECH DEBT:
- Autohotkey needs to be installed on host computer
- If SQL isn’t used, we don’t need the compiler on each computer, otherwise might need Mingw compiler on host computer and MSSQL
- Scanner needs to preamble with F9
- User needs to type number of prints they want, defaulted to 1 pending SQL
- Windows Task Scheduler will need to be setup on host computer, if it changes, the system will not work
    - Bat files cant execute on network computers thus needs to be local
- Percentage of barcodes removed every year is customizable
    - Easily found in code of scannerUsageCheck.cpp
    - Then compiled again
- Location of data and relevant files is hyper dependent on code
- System will be hard to move between computers
- Report extract is impossible to work with
- Crystal reports wont intake a text file easily, serial number is being imported as a parameter via visual cut
    - Tried ODBC text file
- Set paper printer to default to duplex
- INSTALL SQL SERVER 2019, download x86 and x64 and seperate installer? 
- https://github.com/pixustechnologies/labelSerialNumberProject
