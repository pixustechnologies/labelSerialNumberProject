@echo off
:: takes in Serial Number
set serialNum=%1
:: removes the serial number's folder of saved files
set folderPath="\\WATNAS\Production\Saved Labels\%serialNum%"
rmdir /s /q %folderPath%