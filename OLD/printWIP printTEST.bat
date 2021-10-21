@echo off
echo front
set exe="C:\Program Files (x86)\Visual CUT 11\Visual CUT.exe"

set report="\\WATDBS01\ExactShared\Exact\RMServer\Modified Reports\01A000198-A01 INS LBL Shipping 4v6.RPT"
%exe% -e %report% "Parm1:50004321" "Parm2:021410107" "Export_Format:Printer (Specified)" "Export_File:\\waterp01\4x6 Shipping Label"
echo past2
PAUSE