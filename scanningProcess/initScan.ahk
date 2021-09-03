#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; ^ means the control key, f10 is f10
; could be changed to another f key, ideally 8 9 or 10
; ^ is to ensure the user wants to enter the program
^F9::
    	Run, logCheck.exe
		; WinGetClass, class, A
		; MsgBox, The active window's class is "%class%".
		WinWait ahk_class ConsoleWindowClass
		WinActivate
    	return
