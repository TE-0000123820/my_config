PS4_STR='[%D{%Y/%m/%d %H:%M:%S.%6.} ]+++ '
PS4=${PS4_STR}
precmd() {
    PS4=${PS4_STR}
}
