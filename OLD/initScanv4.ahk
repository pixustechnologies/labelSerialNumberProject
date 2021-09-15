#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#MaxThreadsPerHotkey 2

#F9:: ; WINDOWS KEY + A
{
	Loop ; INFINITE LOOP, UNTILL YOU WRITE "EXIT" AND PRESS ENTER
	{
		scannedcharacters = ; CLEAR VARIABLE
		scannedcharacters_UPPER =
		inputbox, scannedcharacters, SCAN NOW, TYPE "EXIT" TO QUIT ; OPEN INPUTBOX AND CLOSES IT WHEN ENTER KEY IS SENT OR WHEN A BARCODESCANNER SENDS IT LAST CHARACTER THAT IS USUALLY AN ENTER.
		StringUpper, scannedcharacters_UPPER, scannedcharacters  ; verify if you want to exit script
		My_Routine(scannedcharacters)
        reload
	}
	return
}
return

#z:: ; WINDOWS KEY + Z ; TEST
{
	scannedcharacters := "50004218"
	My_Routine(scannedcharacters)
	
}
return

My_Routine(scannedcharacters)
{
	RunWait, logCheck.exe %scannedcharacters%
}
return

ins:: ; PRESS INSERT TO RELOAD THE SCRIPT 
{
	reload
}
return