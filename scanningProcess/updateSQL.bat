::@echo off
set u="report"
set ps=""
set serverName="WATDBS01"
set sqlPath="C:\Users\%USERNAME%\Documents\workspace\labelSerialNumberProject\scanningProcess\labelQuery.sql"
set outputPath="C:\Users\%USERNAME%\Documents\workspace\labelSerialNumberProject\scanningProcess\Labels.txt"
sqlcmd -U %u% -P %ps% -S %serverName% -i %sqlPath% -o %outputPath%

set sqlPath="C:\Users\%USERNAME%\Documents\workspace\labelSerialNumberProject\scanningProcess\documentQuery.sql"
set outputPath="C:\Users\%USERNAME%\Documents\workspace\labelSerialNumberProject\scanningProcess\Documents.txt"
sqlcmd -U %u% -P %ps% -S %serverName% -i %sqlPath% -o %outputPath%


