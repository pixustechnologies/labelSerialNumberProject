#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

scanMode := 0
hotkey, If, scanMode == 1 ; Turn on context-sensitive hotkeys
Loop 10 {
    key := A_Index - 1
    fn := Func("KeyEvent").Bind(key)
    Hotkey, % "~" key, % fn
}
hotkey, If ; Turn off context-sensitive hotkeys

PAUSE

KeyEvent(key){
    static BarCode := ""
    global scanMode
    BarCode .= key
    if (StrLen(BarCode) > 9){
        CodeScanned(BarCode)
        scanMode := 0
        BarCode := ""
    }
}

CodeScanned(BarCode){
    Run, %A_ProgramFiles%\Some_Program\Program.exe BarCode ; CHANGE TO THE C FILE OUTPUT
    msgbox % "You scanned " BarCode
}

^F10::
    scanMode := 1
    return
