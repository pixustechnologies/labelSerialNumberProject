@echo off
:: takes in Serial Number
set serialNum=%1
:: removes the serial number's folder of saved files
set folderPath="\\WATNAS\Production\Saved_Labels\%serialNum%"
rmdir /s /q %folderPath%
rmdir %folderPath%
echo Program Finished
timeout 5