PROMPT_STR=$'(`basename \"$VIRTUAL_ENV\"`) %{\e[31m%}%n%{\e[m%}@%{\e[32m%}%m%{\e[m%}:${vcs_info_msg_0_}:(%1v, $$) %D{%Y/%m/%d %H:%M} %{\e[1;33m%}%~%{\e[m%}\n%{%(?.$bg[black].$bg[red])%}%#%#%#%{$reset_color%} '
PROMPT=${PROMPT_STR}

export EDITOR='vim'
export PATH=~/bin:~/utils/:${PATH}
export TERM=xterm-256color
export LANG=C
export http_proxy="http://proxy.osk.sony.co.jp:10080/"
export https_proxy="https://proxy.osk.sony.co.jp:10080/"
export no_proxy=localhost,127.0.0.0/8,::1,gitlabce.misty.sdna.sony.co.jp,kc.misty.sdna.sony.co.jp
export PERL5LIB=${MISC_DIR}

# fzf
source ${MISC_DIR}/.fzf.zsh

# dir color
eval `dircolors ${MISC_DIR}/.colorrc`

#
# cdr
#
# cdr, add-zsh-hook を有効にする
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
# cdr の設定
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/shell/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-pushd true


#
# key binds
#
bindkey -e
#bindkey "^G"
bindkey "^X^B" backward-word
bindkey "^X^F" forward-word
bindkey "^X^D" kill-word
#bindkey "^R" history-incremental-search-backward
zle     -N   fh
bindkey "^x^r" fh
#bindkey "^T" history-incremental-search-forward
zle     -N   fr
bindkey "^x^e" fr
zle -C _complete_files complete-word complete-files
complete-files () { compadd - $PREFIX* }
bindkey "^Xl" _complete_files
function cd-up { zle push-line && LBUFFER='builtin cd ..' && zle accept-line }
zle -N cd-up
bindkey "^O" cd-up


#
# history settings {{{
#
HISTFILE="$HOME/.zhistory"
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt share_history
bindkey "${key[Up]}" up-line-or-local-history
bindkey "${key[Down]}" down-line-or-local-history
bindkey "^P" up-line-or-local-history
bindkey "^N" down-line-or-local-history
up-line-or-local-history() {
    zle set-local-history 1
    zle up-line-or-history
    zle set-local-history 0
}
zle -N up-line-or-local-history
down-line-or-local-history() {
    zle set-local-history 1
    zle down-line-or-history
    zle set-local-history 0
}
zle -N down-line-or-local-history

# }}}

autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " _-./;@"
zstyle ':zle:*' word-style unspecified

autoload -U compinit
compinit

autoload -U colors
colors

setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt auto_pushd
setopt noautoremoveslash
setopt auto_param_slash
setopt magic_equal_subst
setopt auto_cd

zstyle ':completion:*:default' menu select=1

ulimit -c 100000000
ulimit -s 1000000

#
# aliases {{{
#
alias C="source ~/.vimrc.cwd"
alias K="kill -9 %"
alias Kill='kill -9'
alias b="bg"
alias bp="echo $'\a'"
alias btar="tar --use-compress-program=pbzip2"
alias btarc="tar --use-compress-program=pbzip2 -cf"
alias c="cd"
alias cmake="cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1"
alias df="df -h"
alias e="export"
function myfg() { fg %$1 }
alias f="myfg"
alias g="git"
alias gr="grep --color=always"
#function myglobal() { global --color=always --result grep -g -o $1 -S $2 $argv[3,-1] }
function myglobal() { global --result=grep -g $1 }
alias gg="myglobal"
alias gpom="git push origin master"
alias gu="global -uv"
alias ip="ipython3"
alias j="jobs"
alias java='java -Dfile.encoding=UTF-8'
alias javac='javac -J-Dfile.encoding=UTF-8'
alias k="kill -9"
alias l="ls -F --color=auto"
alias ll="ls -F --color=auto -l"
alias llh="ls -F --color=auto -l -h"
alias ls="ls -F --color=auto"
alias lv='lv -c'
alias m="make"
alias man='(){ man $1 | col -b | view -}'
alias md='md5sum'
alias nv="nvim"
alias p2="python2"
alias p3="python3"
alias p="python"
alias perl="perl -W"
alias po="perl -W -MOneLinerLib"
alias pon="perl -MOneLinerLib -W -nE"
alias parallel='parallel --gnu'
alias pd="popd"
alias r="anyframe-widget-cdr"
alias s="source"
alias ssh='ssh -Y'
alias tp="top"
alias t="tmux -u"
alias ta="tmux -u a"
alias tig="env LANG=ja_JP.UTF-8 tig status"
less_with_unbuffer () {
    unbuffer "$@" |& less -SR
}
alias ub=less_with_unbuffer
alias ul="ulimit -c 1000000000"
alias ulimc="ulimit -c 1000000000"
alias ust="stty stop undef"
VIM=nvim
v () {
    if [ "$#" = "0" ] ; then
        ${VIM} -c ":FZFMru"
        echo MRU
    else
        ${VIM} $*
    fi
}
alias vd="${VIM} -d"
alias vg="vimgit"
alias vimbin='${VIM} -c ":BinEdit'
alias vimgit="${VIM} -c \":Gstatus\""
alias vimps="${VIM} -c \":new | :wincmd o | :PsThisBuffer\""
alias xtar="tar --use-compress-prog=pxz"
alias xtarc="tar --use-compress-prog=pxz -cf"
alias xxd='xxd -g 1'
alias ztar="tar --use-compress-prog=pigz"
alias ztarc="tar --use-compress-prog=pigz -cf"
# }}}

#
# g aliases {{{
#
LOG_FILE_NAME='log'
alias -g L='2>&1 |less -R'
alias -g G='2>&1 |grep '
alias -g RL='> ${LOG_FILE_NAME} 2>&1'
alias -g TL='2>&1 |tee ${LOG_FILE_NAME}'
alias -g TLA='2>&1 |tee -a ${LOG_FILE_NAME}'
alias -g TLH='2>&1 |tee ~/${LOG_FILE_NAME}'
alias -g BP='; bp'
# }}}

if [ "`uname|grep CYGWIN`" != "" ]; then
    chcp.com 65001
    alias st="cygstart"
fi

stty stop undef
stty -ixon -ixoff

# vcs_infoロード    
autoload -Uz vcs_info    
# PROMPT変数内で変数参照する    
setopt prompt_subst    

# vcsの表示    
zstyle ':vcs_info:*' formats '%s|%F{green}%b%f'    
zstyle ':vcs_info:*' actionformats '%s|%F{green}%b%f(%F{red}%a%f)'    
# プロンプト表示直前にvcs_info呼び出し    
precmd() {
    vcs_info

    psvar=()
    psvar[1]=$(jobs | wc -l);
    PROMPT=${PROMPT_STR}
}

# keychain
#keychain $HOME/.ssh/id_rsa
#source $HOME/.keychain/`uname -n`-sh

# syntax highlighting
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

#
# recompile zsh scripts {{{
#
if [ ! -f ${MISC_DIR}/.zshrc.zwc -o ${MISC_DIR}/.zshrc -nt ${MISC_DIR}/.zshrc.zwc ]; then
   zcompile ${MISC_DIR}/.zshrc
fi
if [ ! -f ${MISC_DIR}/.fzf.zsh.zwc -o ${MISC_DIR}/.fzf.zsh -nt ${MISC_DIR}/.fzf.zsh.zwc ]; then
   zcompile ${MISC_DIR}/.fzf.zsh
fi
if [ ! -f ~/.zshrc.zwc -o ~/.zshrc -nt ~/.zshrc.zwc ]; then
   zcompile ~/.zshrc
fi
# }}}
