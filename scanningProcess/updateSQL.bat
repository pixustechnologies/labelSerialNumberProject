::@echo off
set u="report"
set ps=""
set serverName="WATDBS01"
set sqlPath="C:\Users\jwScott\Documents\workspace\labelSerialNumberProject\scanningProcess\labelQuery.sql"
set outputPath="C:\Users\jwScott\Documents\workspace\labelSerialNumberProject\scanningProcess\Labels.txt"
sqlcmd -U %u% -P %ps% -S %serverName% -i %sqlPath% -o %outputPath%

