#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SCREEN_WIDTH  := 3840
SCREEN_HEIGHT := 2160
TILE_WIDTH_LEFT := 2020
X_CENTER_MARGIN := 60
X_RIGHT_MARGIN := 30 
TILE_BORDER_X := TILE_WIDTH_LEFT + X_CENTER_MARGIN
TILE_WIDTH_RIGHT := SCREEN_WIDTH - TILE_BORDER_X - X_RIGHT_MARGIN

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

MoveCursorToFocusedWindow()
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

Insert:: Return
^h:: Send,{BS}
^M:: SendInput, {Enter}
+Esc:: SendInput, {``}
^1:: SendInput, {Up}
^2:: SendInput, {Down}

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

+^w::
    ; Switch focus among the same class window
    WinGetClass, className, A
    WinActivateBottom, ahk_class %className%
    return

!^g::
    Input Key, L1
    switch Key {
        case "1": {
            WinGetPos,X,Y,W,H,A
            WinMove,A,,60,0,TILE_WIDTH_LEFT,1070
        }
        case "2": {
            WinGetPos,X,Y,W,H,A
            WinMove,A,,60,1080,TILE_WIDTH_LEFT,1070
        }
        case "3": {
            WinGetPos,X,Y,W,H,A
            WinMove,A,,TILE_BORDER_X,0,TILE_WIDTH_RIGHT,1070
        }
        case "4": {
            WinGetPos,X,Y,W,H,A
            WinMove,A,,TILE_BORDER_X,1080,TILE_WIDTH_RIGHT,1070
        }
        case "5": {
            WinGetPos,X,Y,W,H,A
            WinMove,A,,60,0,TILE_WIDTH_LEFT,2100
        }
        case "6": {
            WinGetPos,X,Y,W,H,A
            WinMove,A,,TILE_BORDER_X,0,TILE_WIDTH_RIGHT,2100
        }
        case "p": WinSet, AlwaysOnTop, TOGGLE, A
        case "c": run,C:\tool\link\mintty.exe.lnk -i /Cygwin-Terminal.ico -
        case "e": run,"C:\Users\0000123820\OneDrive - Sony\tool\vim81-kaoriya-win64\gvim.exe" %A_ScriptFullPath%
        case "v": run,C:\tool\link\gvim.exe.lnk
        case "w": run,C:\Users\0000123820\AppData\Local\Microsoft\WindowsApps\ubuntu2004.exe
        case "s": run,C:\Users\0000123820\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk
        case "r": Reload
    }
    return

!^w::
    Input Key, L1
    switch Key {
        case "1": {
            WinGetPos,X,Y,W,H,A
            WinMove,A,,60,0,TILE_WIDTH_LEFT,1070
            MoveCursorToFocusedWindow()
        }
        case "q": {
            WinGetPos,X,Y,W,H,A
            WinMove,A,,60,1080,TILE_WIDTH_LEFT,1070
            MoveCursorToFocusedWindow()
        }
        case "2": {
            WinGetPos,X,Y,W,H,A
            WinMove,A,,TILE_BORDER_X,0,TILE_WIDTH_RIGHT,1070
            MoveCursorToFocusedWindow()
        }
        case "w": {
            WinGetPos,X,Y,W,H,A
            WinMove,A,,TILE_BORDER_X,1080,TILE_WIDTH_RIGHT,1070
            MoveCursorToFocusedWindow()
        }
        case "3": {
            WinGetPos,X,Y,W,H,A
            WinMove,A,,60,0,TILE_WIDTH_LEFT,2000
            MoveCursorToFocusedWindow()
        }
        case "4": {
            WinGetPos,X,Y,W,H,A
            WinMove,A,,TILE_BORDER_X,0,TILE_WIDTH_RIGHT,2000
            MoveCursorToFocusedWindow()
        }
    }
    return

;
; resize window
;
^!Down::
    WinGetPos,X,Y,W,H,A
    H := H + 200
    WinMove,A,,X,Y,W,H
    return
^!Up::
    WinGetPos,X,Y,W,H,A
    H := H - 200
    WinMove,A,,X,Y,W,H
    return
^!Right::
    WinGetPos,X,Y,W,H,A
    W := W + 200
    WinMove,A,,X,Y,W,H
    return
^!Left::
    WinGetPos,X,Y,W,H,A
    W := W - 200
    WinMove,A,,X,Y,W,H
    return

;
; Window focus
;
!^f::
    Input Key, L1
    switch Key {
        case "c": WinActivate,ahk_exe chrome.exe
        case "b": WinActivate,ahk_exe msedge.exe
        case "f": WinActivate,ahk_exe WinSCP.exe
        case "m": WinActivate,ahk_class mintty
        case "t": WinActivate,ahk_exe Teams.exe
        case "w": WinActivate,Cygwin ahk_class mintty
        case "e": WinActivate,ahk_exe explorer.exe
        case "s": WinActivate,ahk_exe slack.exe
        case "x": WinActivate,ahk_class XLMAIN
        case "o": WinActivate,ahk_exe OUTLOOK.EXE
        case "v": WinActivate,ahk_class Vim
        case "p": WinActivate,ahk_class PPTFrameClass
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
    MoveCursorToFocusedWindow() ;; move cursor
    return

!^m:: WinActivate,ahk_exe WindowsTerminal.exe

#IfWinActive ahk_class TablacusExplorer
+^a:: SendInput, {Alt down}{Left}{Alt Up}
+^s:: SendInput, {Alt down}{Right}{Alt Up}
#IfWinActive

#IfWinActive ahk_exe msedge.exe
+^n::
    SendInput, ^{l}
    Click, L, , 300, 200
    SendInput, {b}
    return
^n:: SendInput, {Down}
^p:: SendInput, {Up}
#IfWinNotActive

#m:: WinMinimize, A
#z:: WinMinimize, A
!^z:: WinMinimize, A

;
; Mouse
;
+#a::
    CoordMode, Mouse, Screen
    MouseMove 500,400,0,
    CoordMode, Mouse, Relative
    return
+#z::
    CoordMode, Mouse, Screen
    MouseMove 500,1600,0,
    CoordMode, Mouse, Relative
    return
+#s::
    CoordMode, Mouse, Screen
    MouseMove 3500,400,0,
    CoordMode, Mouse, Relative
    return
+#x::
    CoordMode, Mouse, Screen
    MouseMove 3500,1600,0,
    CoordMode, Mouse, Relative
    return

; PrintScreen
^!q::  SendInput, {LWin Down}{PrintScreen}{LWin Up}

vkac:: SendInput, {LWin Down}{PrintScreen}{LWin Up}

XButton2::
    IfWinActive ahk_exe msedge.exe
    {
        SendInput, {Alt down}{Space}
        Sleep 100
        SendInput, {m}{Alt up}
    }
    Else
    {
        WinGetPos, xpos, ypos, width, height, A
        pos := width - 300
        Click,%pos%,20,0
    }
    return
+WheelDown::WheelRight
+WheelUp::WheelLeft

;; select text
#+j::
    Send, {LButton Down}
    MouseMove 100,0,0,R
    Send, {LButton Up}
    return

;;;;;;;;;;;;;;;
;;;; RAlt
;;;;;;;;;;;;;;;
vka5 & s:: SendInput, {Down 5}
vka5 & w:: SendInput, {Up 5}
vka5 & a:: SendInput, {Left 5}
vka5 & d:: SendInput, {Right 5}

;;;;;;;;;;;;;;;
;;;; RCtrl
;;;;;;;;;;;;;;;
vka3 & c:: SendInput, {Esc}
vka3 & n:: SendInput, {Down}
vka3 & p:: SendInput, {Up}
vka3 & b:: SendInput, {Left}
vka3 & f:: SendInput, {Right}
vka3 & e:: SendInput, {End}
vka3 & a:: SendInput, {Home}
vka3 & w:: SendInput, {Up}
vka3 & s:: SendInput, {Down}
vka3 & v:: SendInput, {Shift Down}{Insert}{Shift Up}
vka3 & Down::   ExtendWindow(0, 200)
vka3 & Up::     ExtendWindow(0, -200)
vka3 & Right::  ExtendWindow(200, 0)
vka3 & Left::   ExtendWindow(-200, 0)
vka3 & Tab:: SendInput, {Alt Down}{Tab}
; num
vka3 & u:: SendInput, {1}
vka3 & i:: SendInput, {2}
vka3 & o:: SendInput, {3}
vka3 & j:: SendInput, {4}
vka3 & k:: SendInput, {5}
vka3 & l:: SendInput, {6}
vka3 & m:: SendInput, {7}
vka3 & ,:: SendInput, {8}
vka3 & .:: SendInput, {9}
vka3 & `;:: SendInput, {0}

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
!g:: SendInput, {Esc}
!x:: SendInput, {Del}
!h:: SendInput, {BS}
!z:: SendInput, {BS}
!v:: SendInput, {Shift Down}{Insert}{Shift Up}
!1:: SendInput, {PgUp}
!2:: SendInput, {PgDn}
; cursor
!s:: SendInput, {Down}
!d:: SendInput, {Right}
!w:: SendInput, {Up}
!q:: SendInput, {Home}
!a:: SendInput, {Home}
!e:: SendInput, {End}
!n:: SendInput, {Down}
!p:: SendInput, {Up}
!b:: SendInput, {Left}
!f:: SendInput, {Right}
!r:: MoveCursorToFocusedWindow()
+!a:: SendInput, {Shift Down}{Left}{Shift Up}
+!s:: SendInput, {Shift Down}{Down}{Shift Up}
+!d:: SendInput, {Shift Down}{Right}{Shift Up}
+!w:: SendInput, {Shift Down}{Up}{Shift Up}
+!q:: SendInput, {Shift Down}{Home}{Shift Up}
+!e:: SendInput, {Shift Down}{End}{Shift Up}
+!n:: SendInput, {Shift Down}{Down}{Shift Up}
+!p:: SendInput, {Shift Down}{Up}{Shift Up}
+!b:: SendInput, {Shift Down}{Left}{Shift Up}
+!f:: SendInput, {Shift Down}{Right}{Shift Up}
!Space:: IME_SET(1)
!4:: SendInput, {Alt Down}{F4}{Alt Up}
!5:: SendInput, {Alt Down}{F5}{Alt Up}
!Down::   ExtendWindow(0, 200)
!Up::     ExtendWindow(0, -200)
!Right::  ExtendWindow(200, 0)
!Left::   ExtendWindow(-200, 0)
!u:: SendInput, {_}
!y:: SendInput, {\}
!,:: SendInput, {~}
!/:: SendInput, {\}
!m:: SendInput, {_}
!j:: SendInput, {~}
~LAlt up::   ; 連打
    If (A_PriorHotKey == A_ThisHotKey && A_TimeSincePriorHotkey < 300)
    {
        IME_SET(1)
    }
    Return

;;;;;;;;;;;;;;;
;;; 変換
;;;;;;;;;;;;;;;
vk1c:: SendInput, {Enter}

;;;;;;;;;;;;;;;
;;; カタカナ/ひらがな(ChangeKeyでF13(vk7c(sc64))にマップ)
;;;;;;;;;;;;;;;
;vk7c:: IME_SET(1)         ;;; IME on
vk7c & Space:: IME_SET(0) ;;; IME off
vk7c & j:: SendInput, {vkf2} ;;; IME on
vk7c & k:: SendInput, {vk1d} ;;; IME off
vk7c & u:: SendInput, {F10}    ;;; hankaku
vk7c & o:: SendInput, {F10}    ;;; hankaku
vk7c & l:: SendInput, {F10}    ;;; hankaku
vk7c & i:: SendInput, {F7}     ;;; カタカナ
vk7c & q:: SendInput, {|}
vk7c & w:: SendInput, {~}
; symbols
vk7c & t:: SendInput, {~}
vk7c & b:: SendInput, {``}
vk7c & p:: SendInput, {|}
vk7c & a:: SendInput, {+}
vk7c & y:: SendInput, {\}
vk7c & m:: SendInput, {_}
vk7c & n:: SendInput, {&}
vk7c & ,:: SendInput, {~}
vk7c & e:: SendInput, {=}
vk7c & d:: SendInput, {+}
vk7c & h:: SendInput, {^}
vk7c & s:: SendInput, {_}
vk7c & f::
    IME_SET(0)
    SendInput, {-}
    Return
vk7c & 1:: SendInput, {[}
vk7c & 2:: SendInput, {]}
vk7c & 3:: SendInput, {{}
vk7c & 4:: SendInput, {}}
vk7c up::   ; 連打
    If (A_PriorHotKey == A_ThisHotKey && A_TimeSincePriorHotkey < 300)
    {
        ;IME_SET(0)
        SendInput, {Esc}
    }
    Return

;;;;;;;;;;;;;;;
;;; RAlt
;;;;;;;;;;;;;;;
vka5 & j:: SendInput, {vkf2} ;;; IME on
vka5 & k:: SendInput, {vk1d} ;;; IME off
vka5 & u:: SendInput, {F10}{Enter}    ;;; hankaku
vka5 & o:: SendInput, {F10}{Enter}    ;;; hankaku
vka5 & l:: SendInput, {F10}{Enter}    ;;; hankaku
vka5 & i:: SendInput, {F7}{Enter}     ;;; カタカナ
vka5 & q:: SendInput, {|}
; symbol
vka5 & t:: SendInput, {~}
vka5 & b:: SendInput, {``}
vka5 & p:: SendInput, {|}
vka5 & n:: SendInput, {&}
vka5 & Space:: SendInput, {vkf2}

AppsKey & z:: SendInput,{_}

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

;; for 60% keyboeard
^+/:: SendInput, {_}
^+Up:: SendInput, {\}
+BS:: SendInput, {|}
^+BS:: SendInput, {\}
