#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

^h:: Send,{BS}
#^Q:: Send,{Esc}
!^\:: Shutdown,2

::d//::
FormatTime,TimeString,,yyyyMMdd
Send,%TimeString%
Return

::d??::
FormatTime,TimeString,,yyyy/MM/dd
Send,%TimeString%
Return

::ts//::
FormatTime,TimeString,,M/dd HHmm
Send,%TimeString% テレワーク開始します
Return

::te//::
FormatTime,TimeString,,M/dd HHmm
Send,%TimeString% テレワーク終了します
Return

+^w::
    ; Switch focus among the same class window
    WinGetClass, className, A
    WinActivateBottom, ahk_class %className%
    return

!^g::
    Input Key, L1
    if Key=p
        WinSet, AlwaysOnTop, TOGGLE, A
    else if Key=i
        Send,+{Insert}
    else if Key=c
        run,C:\tool\link\mintty.exe.lnk -i /Cygwin-Terminal.ico -
    else if Key=v
        run,C:\tool\link\gvim.exe.lnk
    else if Key=e
        run,C:\tool\link\gvim.exe.lnk %A_ScriptFullPath%
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
    if Key=f
        WinActivate,ahk_exe WinSCP.exe
    if Key=m
        WinActivate,ahk_class mintty
    if Key=d
        WinActivate,ahk_class mintty
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
    if Key=t
        WinActivate,ahk_exe thunderbird.exe
    if Key=p
        WinActivate,ahk_class PPTFrameClass
    if Key=i
        WinActivate,ahk_exe iexplore.exe
    if Key=u
        WinActivate,ahk_exe lync.exe
    if Key=n
        WinActivate,ahk_class ApplicationFrameWindow
    return

#IfWinActive ahk_class ApplicationFrameWindow

^b:: SendInput, {Left}
^f:: SendInput, {Right}
^p:: SendInput, {Up}
^n:: SendInput, {Down}

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
^Space:: Send, {PgDn}
^+Space:: Send, {PgUp}
!d:: SendInput, {Ctrl down}{Del}{Ctrl up}
!h:: SendInput, {Ctrl down}{BS}{Ctrl up}
#IfWinNotActive

;
; Mouse
;
; Up
;#Up::
;    MouseMove 0,-20,0,R
;    return
;
;; Down
;#Down::
;    MouseMove 0,20,0,R
;    return
;
;; Left
;#Left::
;    MouseMove -20,0,0,R
;    return
;
;; Right
;#Right::
;    MouseMove 20,0,0,R
;    return

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
; Wheel
;+^p::
;    Send,{WheelUp 3}
;    return
;+^n::
;    Send,{WheelDown 3}
;    return
