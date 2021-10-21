@echo off
set u="report"
set ps=""
set serverName="WATDBS01"
set sqlPath="C:\Users\%USERNAME%\Documents\labelSerialNumberProject\scanningProcess\labelQuery.sql"
set outputPath="C:\Users\%USERNAME%\Documents\labelSerialNumberProject\scanningProcess\Labels.txt"
sqlcmd -U %u% -P %ps% -S %serverName% -i %sqlPath% -o %outputPath%

set sqlPath="C:\Users\%USERNAME%\Documents\labelSerialNumberProject\scanningProcess\documentQuery.sql"
set outputPath="C:\Users\%USERNAME%\Documents\labelSerialNumberProject\scanningProcess\Documents.txt"
sqlcmd -U %u% -P %ps% -S %serverName% -i %sqlPath% -o %outputPath%

set sqlPath="C:\Users\%USERNAME%\Documents\labelSerialNumberProject\scanningProcess\orderQuery.sql"
set outputPath="C:\Users\%USERNAME%\Documents\labelSerialNumberProject\scanningProcess\Orders.txt"
sqlcmd -U %u% -P %ps% -S %serverName% -i %sqlPath% -o %outputPath%

