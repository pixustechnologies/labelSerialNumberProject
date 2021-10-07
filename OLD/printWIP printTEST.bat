@echo off
echo front
set exe="C:\Program Files (x86)\Visual CUT 11\Visual CUT.exe"

set report="\\WATDBS01\ExactShared\Exact\RMServer\Modified Reports\01A000037-A01 INS LBL 1.25x0.25 Serial Number.RPT"
%exe% -e %report% "Parm1:50004321" "Parm2:021400126" "Export_Format:Printer (Specified)" "Export_File:\\waterp01\1.25x25-Citizen CLP-631"
echo past2
PAUSE