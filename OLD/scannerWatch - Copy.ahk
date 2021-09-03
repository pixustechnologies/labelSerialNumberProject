#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

scanMode := 0
#If, scanMode == 1 ; Turn on context-sensitive hotkeys
	1::
		BarCode := BarCode 1
		Check()
		return
	2::
		BarCode := BarCode 2
		Check()
		return
	3::
		BarCode := BarCode 3
		Check()
		return
	4::
		BarCode := BarCode 4
		Check()
		return
	5::
		BarCode := BarCode 5
		Check()
		return
	6::
		BarCode := BarCode 6
		Check()
		return
	7::
		BarCode := BarCode 7
		Check()
		return
	8::
		BarCode := BarCode . "8"
		Check()
		return
	9::
		BarCode := BarCode 9
		Check()
		return
	0::
		BarCode := BarCode 0
		Check()
		return
	
#If ; Turn off context-sensitive hotkeys

Check(){
	Len++
	MsgBox % "The length of the string is " BarCode
	if (StrLen(BarCode) > 9){
    		Run, notepad
        	CodeScanned(BarCode)
	        scanMode := 0
        	BarCode := ""
		Exit
	}
}

CodeScanned(BarCode){
    	Run, notepad
    	msgbox % "You scanned " BarCode
}

^F10::
    	scanMode := 1
    	return
