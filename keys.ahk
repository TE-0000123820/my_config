#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SCREEN_WIDTH  := A_ScreenWidth
SCREEN_HEIGHT := A_ScreenHeight
TILE_WIDTH_LEFT := A_ScreenWidth/2
X_CENTER_MARGIN := 60
X_RIGHT_MARGIN := 30 
TILE_HEIGHT_FULL := A_ScreenHeight * 0.95
TILE_BORDER_X := TILE_WIDTH_LEFT + X_CENTER_MARGIN
TILE_WIDTH_RIGHT := SCREEN_WIDTH - TILE_BORDER_X - X_RIGHT_MARGIN
AltTabMenu := false

IME_SET(SetSts, WinTitle="A")    {
	ControlGet,hwnd,HWND,,,%WinTitle%
	if	(WinActive(WinTitle))	{
		ptrSize := !A_PtrSize ? 4 : A_PtrSize
	    VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
	    NumPut(cbSize, stGTI,  0, "UInt")   ;	DWORD   cbSize;
		hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
	             ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
	}

    return DllCall("SendMessage"
          , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
          , UInt, 0x0283  ;Message : WM_IME_CONTROL
          ,  Int, 0x006   ;wParam  : IMC_SETOPENSTATUS
          ,  Int, SetSts) ;lParam  : 0 or 1
}

MoveMouseCursorToFocusedWindow()
{
    WinGetPos, _xpos, _ypos, _width, _height, A
    _xpos_r := _width/2
    _ypos_r := _height/2
    _xpos_a := _xpos + _width/2
    _ypos_a := _ypos + _height/2
    MouseMove _xpos_r,_ypos_r,0,
    WinGetTitle, win_title, A
	SplashImage,,B1 FM14 W400 X%_xpos_a% Y%_ypos_a%,, %win_title%
    SetTimer, RemoveSplash, 2000
    Return
}

RemoveSplash:
    SetTimer, RemoveSplash, Off
	SplashImage,off
    Return

ExtendWindow(diff_w, diff_h)
{
    WinGetPos,_X,_Y,_W,_H,A
    _W := _W + diff_w
    _H := _H + diff_h
    WinMove,A,,_X,_Y,_W,_H
    return
}

MoveKeyCursor(direction)
{
    switch direction {
        case "u": {
            If GetKeyState("Shift", "P") {
                SendInput {Blind}+{Up}
            }
            else {
                SendInput {Up}
            }
        }
        case "d": {
            If GetKeyState("Shift", "P") {
                SendInput {Blind}+{Down}
            }
            else {
                SendInput {Down}
            }
        }
        case "l": {
            If GetKeyState("Shift", "P") {
                SendInput {Blind}+{Left}
            }
            else {
                SendInput {Left}
            }
        }
        case "r": {
            If GetKeyState("Shift", "P") {
                SendInput {Blind}+{Right}
            }
            else {
                SendInput {Right}
            }
        }
        case "e": {
            If GetKeyState("Shift", "P") {
                SendInput {Blind}+{End}
            }
            else {
                SendInput {End}
            }
        }
        case "h": {
            If GetKeyState("Shift", "P") {
                SendInput {Blind}+{Home}
            }
            else {
                SendInput {Home}
            }
        }
    }
}

GetNextKeyAndRunCmd()
{
    global TILE_WIDTH_LEFT
    global TILE_WIDTH_RIGHT
    global TILE_BORDER_X
    Input _Key, L1
    switch _Key {
        case "p": WinSet, AlwaysOnTop, TOGGLE, A
        case "c": run,C:\tool\link\mintty.exe.lnk -i /Cygwin-Terminal.ico -
        case "e": run,"C:\Users\0000123820\OneDrive - Sony\tool\vim81-kaoriya-win64\gvim.exe" %A_ScriptFullPath%
        case "v": run,C:\tool\link\gvim.exe.lnk
        case "w": run,C:\Users\0000123820\AppData\Local\Microsoft\WindowsApps\ubuntu2004.exe
        ;case "s": run,C:\Users\0000123820\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk
        case "s": SendInput, ^!{s}
        case "r": Reload
    }
    return
}

GetNextKeyAndResizeWindow()
{
    global TILE_WIDTH_LEFT
    global TILE_WIDTH_RIGHT
    global TILE_HEIGHT_FULL
    global TILE_BORDER_X
    Input _Key, L1
    switch _Key {
        case "1": {
            WinGetPos,_X,_Y,_W,_H,A
            WinMove,A,,60,0,TILE_WIDTH_LEFT,1070
            MoveMouseCursorToFocusedWindow()
        }
        case "q": {
            WinGetPos,_X,_Y,_W,_H,A
            WinMove,A,,60,1080,TILE_WIDTH_LEFT,1070
            MoveMouseCursorToFocusedWindow()
        }
        case "2": {
            WinGetPos,_X,_Y,_W,_H,A
            WinMove,A,,TILE_BORDER_X,0,TILE_WIDTH_RIGHT,1070
            MoveMouseCursorToFocusedWindow()
        }
        case "w": {
            WinGetPos,_X,_Y,_W,_H,A
            WinMove,A,,TILE_BORDER_X,1080,TILE_WIDTH_RIGHT,1070
            MoveMouseCursorToFocusedWindow()
        }
        case "3": {
            WinGetPos,_X,_Y,_W,_H,A
            WinMove,A,,60,0,TILE_WIDTH_LEFT,TILE_HEIGHT_FULL
            MoveMouseCursorToFocusedWindow()
        }
        case "4": {
            WinGetPos,_X,_Y,_W,_H,A
            WinMove,A,,TILE_BORDER_X,0,TILE_WIDTH_RIGHT,TILE_HEIGHT_FULL
            MoveMouseCursorToFocusedWindow()
        }
    }
    return
}

Insert:: Return
^h:: Send,{BS}
^M:: SendInput, {Enter}
+Esc:: SendInput, {``}

;;;
;;; date
;;;
::;d;::
FormatTime,TimeString,,yyyyMMdd
Send,%TimeString%
Return

::;d/;::
FormatTime,TimeString,,yyyy/MM/dd
Send,%TimeString%
Return

::;d-;::
FormatTime,TimeString,,yyyy-MM-dd
Send,%TimeString%
Return

::;ts;::
FormatTime,TimeString,,M/d HHmm
Send,%TimeString% テレワーク開始します
Return

::;te;::
FormatTime,TimeString,,M/d HHmm
Send,%TimeString% テレワーク終了します
Return

::;m;::
Send, norito.kato@sony.com
Return

<^q::
<^g::
+!g::
    GetNextKeyAndRunCmd()
    return

<^w::
+!w::
    GetNextKeyAndResizeWindow()
    return

;
; Window focus
;
FocusWindow()
{
    Input Key, CL1
    switch Key {
        case "c": WinActivate,ahk_exe chrome.exe
        case "b": WinActivate,ahk_exe msedge.exe
        case "f": WinActivate,ahk_exe WinSCP.exe
        case "m": WinActivate,ahk_class mintty
        case "t": WinActivate,ahk_exe Teams.exe
        case "w": WinActivate,Cygwin ahk_class mintty
        case "E": WinActivate,ahk_class TablacusExplorer
        case "e": WinActivate,ahk_exe explorer.exe
        case "s": WinActivate,ahk_exe slack.exe
        case "x": WinActivate,ahk_class XLMAIN
        case "o": WinActivate,ahk_exe OUTLOOK.EXE
        case "v": WinActivate,ahk_class Vim
        case "p": WinActivate,ahk_class PPTFrameClass
        case "r": WinActivate,ahk_exe mstsc.exe
        case "i": WinActivate,ahk_exe iexplore.exe
        case "n": WinActivate,ahk_class ApplicationFrameWindow
        case "d": {
            if WinExist("SuperPuTTY ahk_exe SuperPutty.exe") {
                WinActivate  ; Uses the last found window.
                Sleep 100
                WinActivate  ; Uses the last found window.
                MouseClick ,Left
            }
        }
        default:
            ;; do nothing
            return
    }
    MoveMouseCursorToFocusedWindow() ;; move cursor
    return
}
!^f::
<^f::
    FocusWindow()
    return

#m:: WinMinimize, A
#z:: WinMinimize, A
!^z:: WinMinimize, A

; PrintScreen
^!q::  SendInput, {LWin Down}{PrintScreen}{LWin Up}
vkac:: SendInput, {LWin Down}{PrintScreen}{LWin Up}

;;;;;;;;;;;;;;;
;;;; 無変換
;;;;;;;;;;;;;;;
vk1d & g:: SendInput, {Esc}
vk1d & x:: SendInput, {Del}
vk1d & h:: SendInput, {BS}
vk1d & z:: SendInput, {BS}
vk1d & v:: SendInput, {Shift Down}{Insert}{Shift Up}
vk1d & 1:: SendInput, {Home}
vk1d & 2:: SendInput, {End}
vk1d & f:: SendInput, {PgDn}
vk1d & b:: SendInput, {PgUp}
vk1d & p:: SendInput, {|}
vk1d & Down::
    WinGetPos,X,Y,W,H,A
    Y := Y + 200
    WinMove,A,,X,Y,W,H
    return
vk1d & Up::
    WinGetPos,X,Y,W,H,A
    Y := Y - 200
    WinMove,A,,X,Y,W,H
    return
vk1d & Right::
    WinGetPos,X,Y,W,H,A
    X := X + 200
    WinMove,A,,X,Y,W,H
    return
vk1d & Left::
    WinGetPos,X,Y,W,H,A
    X := X - 200
    WinMove,A,,X,Y,W,H
    return
; num
vk1d & u:: SendInput, {1}
vk1d & i:: SendInput, {2}
vk1d & o:: SendInput, {3}
vk1d & j:: SendInput, {4}
vk1d & k:: SendInput, {5}
vk1d & l:: SendInput, {6}
vk1d & m:: SendInput, {7}
vk1d & ,:: SendInput, {8}
vk1d & .:: SendInput, {9}
vk1d & `;:: SendInput, {0}
; cursor
vk1d & a:: SendInput, {Left}
vk1d & s:: SendInput, {Down}
vk1d & d:: SendInput, {Right}
vk1d & w:: SendInput, {Up}
vk1d & q:: SendInput, {PgUp}
vk1d & e:: SendInput, {PgDn}

;;;;;;;;;;;;;;;
;;;; LAlt
;;;;;;;;;;;;;;;
*~LAlt::Send {Blind}{vkFF} ; map to "no mapping"
<!n:: MoveKeyCursor("d")
<!p:: MoveKeyCursor("u")
;<!b:: MoveKeyCursor("l")
;<!f:: MoveKeyCursor("r")
<!e:: MoveKeyCursor("e")
<!q:: MoveKeyCursor("h")

<!w:: MoveKeyCursor("u")
<!s:: MoveKeyCursor("d")
<!a:: MoveKeyCursor("l")
<!d:: MoveKeyCursor("r")

<!c:: SendInput, {Esc}
<!x:: SendInput, {Del}
<!h:: SendInput, {BS}
<!v:: SendInput, {Shift Down}{Insert}{Shift Up}
<!k:: SendInput, {Shift down}{End}{Del}{Shift up}

<!Down::   ExtendWindow(0, 200)
<!Up::     ExtendWindow(0, -200)
<!Right::  ExtendWindow(200, 0)
<!Left::   ExtendWindow(-200, 0)

#IfWinNotActive,ahk_exe mstsc.exe
;;;;;;;;;;;;;;;
;;; F13
;;; カタカナ/ひらがな or RAlt にマップ
;;;;;;;;;;;;;;;
F13 & Space:: IME_SET(0) ;;; IME off
F13 & j:: SendInput, {vkf2} ;;; IME on
F13 & k:: SendInput, {vk1d} ;;; IME off
F13 & q:: SendInput, {|}
F13 & w:: SendInput, {~}
; symbols
F13 & t:: SendInput, {~}
F13 & b:: SendInput, {\}
F13 & p:: SendInput, {|}
F13 & a:: SendInput, {+}
F13 & y:: SendInput, {\}
F13 & m:: SendInput, {_}
F13 & n:: SendInput, {&}
F13 & s:: SendInput, {_}

#IfWinNotActive

;;;;;;;;;;;;;;;
;;; RAlt
;;;;;;;;;;;;;;;
>!j:: SendInput, {vkf2} ;;; IME on
>!k:: SendInput, {vk1d} ;;; IME off
>!q:: SendInput, {|}
; symbol
>!t:: SendInput, {~}
>!b:: SendInput, {``}
>!p:: SendInput, {|}
>!n:: SendInput, {&}
>!Space:: SendInput, {vkf2}

!>s:: SendInput, {Down 5}
!>w:: SendInput, {Up 5}
!>a:: SendInput, {Left 5}
!>d:: SendInput, {Right 5}

*~RAlt::Send {Blind}{vkFF} ; map to "no mapping"

;;
;; Numpad
;;
NumpadEnter:: SendInput, {Esc}
NumpadSub:: SendInput, {Home}
NumpadAdd:: SendInput, {End}
NumpadDel:: SendInput, {F5}

NumpadPgDn:: SendInput, {Right}
NumpadEnd:: SendInput, {Left}
NumpadDown:: SendInput, {Down}
NumpadClear:: SendInput, {Up}
NumpadRight:: SendInput, {PgDn}
NumpadLeft:: SendInput, {PgUp}

NumpadHome:: SendInput, +^{Tab}
NumpadPgUp:: SendInput, ^{Tab}
NumpadUp:: SendInput, ^w
NumpadDiv:: SendInput, ^!s

;;
;; Numpad(NumLocked)
;;
Numpad3:: SendInput, {Right}
Numpad1:: SendInput, {Left}
Numpad2:: SendInput, {Down}
Numpad5:: SendInput, {Up}
Numpad6:: SendInput, {PgDn}
Numpad4:: SendInput, {PgUp}

;
; Application Specific
;
#IfWinActive ahk_class TablacusExplorer
+^a:: SendInput, {Alt down}{Left}{Alt Up}
+^s:: SendInput, {Alt down}{Right}{Alt Up}
#IfWinActive

; Horizontal Scroll
#IfWinActive, ahk_exe POWERPNT.EXE
~Lshift & WheelUp::ComObjActive("PowerPoint.Application").ActiveWindow.SmallScroll(0,0,0,10)
~Lshift & WheelDown::ComObjActive("PowerPoint.Application").ActiveWindow.SmallScroll(0,0,10,0)
#IfWinActive

#IfWinActive, ahk_exe EXCEL.EXE
~LShift & WheelUp:: ; Scroll left.
    SetScrollLockState, On
    SendInput {Left}
    SetScrollLockState, Off
    Return
~LShift & WheelDown:: ; Scroll right.
    SetScrollLockState, On
    SendInput {Right}
    SetScrollLockState, Off
#IfWinActive

; 同じアプリ内の次のウィンドウに切り替える
WIN_SameAppNext() {
    WinGetClass, className, A
    WinActivateBottom, ahk_class %className%
}
!Esc::WIN_SameAppNext()

WIN_SameAppPrev() {
    WinGet, thisWindowId, ID, A
    WinGetClass, thisWindowClass, ahk_id %thisWindowId%
    WinGet, allWindowIds, List, , , Program Manager
    Loop, %allWindowIds% {
        StringTrimRight, targetWindowId, allWindowIds%A_index%, 0
        WinGetClass, targetWindowClass, ahk_id %targetWindowId%
        if (thisWindowClass = targetWindowClass) {
            if (thisWindowId <> targetWindowId) {
                WinSet, Bottom, , ahk_id %thisWindowId%
                WinActivate, ahk_id %targetWindowId%
                break
            }
        }
    }
}
!+Esc::WIN_SameAppPrev()
