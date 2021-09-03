scanMode := 0
hotkey, If, scanMode == 1 ; Turn on context-sensitive hotkeys
echo found you
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
    ; your code here
    call doublePrint.bat
    msgbox % "You scanned " BarCode
}

F12::
    scanMode := 1
    return
