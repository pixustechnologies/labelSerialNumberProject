@echo off
set exePath=C:\Program Files (x86)\Visual CUT 11\Visual CUT.exe
set reportPath=\\WATDBS01\ExactShared\Shop Order Processing\
set printerName=\\waterp01\PXS - MXM363N PCL6
set printerName=\\waterp01\PXS-PRN-SHOP-BRTHR
set prtnumAbove=02A000666-A01
:: the BOM
"%exePath%" -e "%reportPath%BOMRPTv2.rpt" "Parm1:%prtnumAbove%" "Export_Format:Printer (Specified)" "Export_File:%printerName%"


PAUSE