﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

^h:: Send,{BS}
#^Q:: Send,{Esc}
!^\:: Shutdown,2

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
    if Key=1
    {
        WinGetPos,X,Y,W,H,A
        WinMove,A,,60,0,1860,1070
    }
    else if Key=2
    {
        WinGetPos,X,Y,W,H,A
        WinMove,A,,60,1080,1860,1070
    }
    else if Key=3
    {
        WinGetPos,X,Y,W,H,A
        WinMove,A,,1920,0,1860,1070
    }
    else if Key=4
    {
        WinGetPos,X,Y,W,H,A
        WinMove,A,,1920,1080,1860,1070
    }
    else if Key=p
        WinSet, AlwaysOnTop, TOGGLE, A
    else if Key=c
        run,C:\tool\link\mintty.exe.lnk -i /Cygwin-Terminal.ico -
    else if Key=e
        run,"C:\Users\0000123820\OneDrive - Sony\tool\vim81-kaoriya-win64\gvim.exe" %A_ScriptFullPath%
    else if Key=v
        run,C:\tool\link\gvim.exe.lnk
    else if Key=w
        run,C:\Users\0000123820\AppData\Local\Microsoft\WindowsApps\ubuntu2004.exe
    else if Key=s
        run,C:\Users\0000123820\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk
    else if Key=r
        Reload
    return

!^e::
    Input Key, L1
    if Key=a
        Send,{Home}
    else if Key=e
        Send,{End}
    else if Key=b
        Send,{PgUp}
    else if Key=f
        Send,{PgDn}
    else if Key=j
        Send,{Down}
    else if Key=k
        Send,{Up}
    else if Key=h
        Send,{Left}
    else if Key=l
        Send,{Right}
    return

;
; Window focus
;
!^f::
    Input Key, L1
    if Key=c
        WinActivate,ahk_exe chrome.exe
    if Key=b
        WinActivate,ahk_exe msedge.exe
    if Key=f
        WinActivate,ahk_exe WinSCP.exe
    if Key=m
        WinActivate,ahk_class mintty
    if Key=t
        WinActivate,ahk_exe Teams.exe
    if Key=w
        WinActivate,Cygwin ahk_class mintty
    if Key=e
        WinActivate,ahk_exe explorer.exe
    if Key=s
        WinActivate,ahk_exe slack.exe
    if Key=x
        WinActivate,ahk_class XLMAIN
    if Key=u
        WinActivate,ahk_exe lync.exe
    if Key=o
        WinActivate,ahk_exe OUTLOOK.EXE
    if Key=v
        WinActivate,ahk_class Vim
    if Key=p
        WinActivate,ahk_class PPTFrameClass
    if Key=i
        WinActivate,ahk_exe iexplore.exe
    if Key=u
        WinActivate,ahk_exe lync.exe
    if Key=n
        WinActivate,ahk_class ApplicationFrameWindow
    if Key=d
        if WinExist("SuperPuTTY ahk_exe SuperPutty.exe") {
            WinActivate  ; Uses the last found window.
            Sleep 100
            WinActivate  ; Uses the last found window.
            MouseClick ,Left
        }
    return

!^m::
    WinActivate,ahk_exe WindowsTerminal.exe
    return

#IfWinActive ahk_class ApplicationFrameWindow

;^b:: SendInput, {Left}
;^f:: SendInput, {Right}
;^p:: SendInput, {Up}
;^n:: SendInput, {Down}

!^b:: SendInput, {Left 5}
!^s:: SendInput, {Left 5}
!^f:: SendInput, {Right 5}
!^p:: SendInput, {Up 5}
!^n:: SendInput, {Down 5}

^e:: SendInput, {End}
^^:: SendInput, {Home}

!f:: SendInput, {Right}
!e:: SendInput, {Up}
!l:: SendInput, {Right}
!k:: SendInput, {Up}
!j:: SendInput, {Down}
!+s:: SendInput, {Left 5}
!+f:: SendInput, {Right 5}
!+e:: SendInput, {Up 5}
!+d:: SendInput, {Down 5}
^k:: Send, {Shift down}{End}{Del}{Shift up}
^d:: SendInput, {Del}
#IfWinActive  

#IfWinNotActive ahk_class mintty
!d:: SendInput, {Ctrl down}{Del}{Ctrl up}
!h:: SendInput, {Ctrl down}{BS}{Ctrl up}
#IfWinNotActive

#m:: WinMinimize, A
#z:: WinMinimize, A
!^z:: WinMinimize, A

;
; Mouse
;
; Up
#+k::
    MouseMove 0,-20,0,R
    return
; Down
#+j::
    MouseMove 0,20,0,R
    return

; Left
#+h::
    MouseMove -20,0,0,R
    return

; Right
#+l::
    MouseMove 20,0,0,R
    return

; Up fast
#^k::
    MouseMove 0,-160,0,R
    return

; Down fast
#^j::
    MouseMove 0,160,0,R
    return

; Left fast
#^h::
    MouseMove -160,0,0,R
    return

; Right fast
#^l::
    MouseMove 160,0,0,R
    return

; Left click
#[::
    MouseClick,left,,,,,D
    return
#[ Up::
    MouseClick,left,,,,,U
    return
; Left click
#Enter::
    MouseClick,left,,,,,D
    return
#Enter Up::
    MouseClick,left,,,,,U
    return
; Right click
#]::
    MouseClick ,Right
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

Insert::Return

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
NumpadRight:: SendInput, {PgUp}
NumpadLeft:: SendInput, {PgDn}
NumpadHome:: SendInput, +^{Tab}
NumpadPgUp:: SendInput, ^{Tab}
NumpadUp:: SendInput, ^w
NumpadDiv:: SendInput, ^!s
