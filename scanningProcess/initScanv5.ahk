#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#InstallKeybdHook

SetBatchLines, -1 
; waits for f9, then runs the program
F9::
    input, scan,,{Enter} ;start accepting input from barcode reader
	RunWait, updateSQL.bat
	RunWait, logCheck.exe %scan%
return