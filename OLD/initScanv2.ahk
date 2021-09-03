#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; ^ means the control key, f10 is f10
; could be changed to another f key, ideally 8 9 or 10
; ^ is to ensure the user wants to enter the program
loop, 26
	Transform, M%A_Index%, Chr, % A_Index

^F9::
Input, Singlekey, L1 M
Loop, 26
	{
	if (Singlekey = M%A_Index%)
		{
		MyVar:=("^" . Chr(A_Index+96))	; or MyVar:=("{Ctrl}" . Chr(A_Index+96))
			Break
		}
	}
MsgBox, %MyVar%
Run, logCheck.exe %MyVar%
return

esc::ExitApp