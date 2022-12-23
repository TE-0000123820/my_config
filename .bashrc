export PS4='+${BASH_SOURCE}:${LINENO}+'

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
_tn_timestamp=`date +%s`
_tn_cmd=''
preexec() {
    _tn_timestamp=`date +%s`
    _tn_cmd=$1
}
precmd() {
    now=`date +%s`
    dur=$(( $now - $_tn_timestamp ))
    if [[ $_tn_cmd == "" ]]; then
        return
    fi
    if [[ $dur -gt 10 ]]; then
        echo elapsed time: $dur seconds
    fi
    _tn_cmd=''
}
