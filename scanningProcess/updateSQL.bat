@echo off
set u="report"
set ps=""
set serverName="WATDBS01"
set sqlPath="C:\Custom Programs\labelSerialNumberProject\scanningProcess\labelQuery.sql"
set outputPath="C:\Custom Programs\labelSerialNumberProject\scanningProcess\Labels.txt"
sqlcmd -U %u% -P %ps% -S %serverName% -i %sqlPath% -o %outputPath%

set sqlPath="C:\Custom Programs\labelSerialNumberProject\scanningProcess\documentQuery.sql"
set outputPath="C:\Custom Programs\labelSerialNumberProject\scanningProcess\Documents.txt"
sqlcmd -U %u% -P %ps% -S %serverName% -i %sqlPath% -o %outputPath%

set sqlPath="C:\Custom Programs\labelSerialNumberProject\scanningProcess\orderQuery.sql"
set outputPath="C:\Custom Programs\labelSerialNumberProject\scanningProcess\Orders.txt"
sqlcmd -U %u% -P %ps% -S %serverName% -i %sqlPath% -o %outputPath%

