#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; ^ means the control key, f10 is f10
; could be changed to another f key, ideally 8 9 or 10
; ^ is to ensure the user wants to enter the program
Loop
{
	Input, SingleKey, L1 V, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}
	Log .= SingleKey
}

^F9::
	reading := True
return

^Enter::
	if(reading){
		RegExMatch(Log, "(\S*)\s*$", Words)
		RunWait, logCheck.exe %Words1%
		Log := ""
		reading := False
	}
return