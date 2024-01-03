export FZF_DEFAULT_OPTS="-e --bind 'btab:toggle-down,tab:toggle-up,alt-n:down+down+down+down,alt-p:up+up+up+up,ctrl-k:kill-line,ctrl-j:accept'"

# ffd - select items from fd result
ffd() {
  local path
  path=$(fd | fzf -m) || return
  print -z $path
}

# ff: generic filter
ff() {
    local -A opthash
    local field_id
    zparseopts -D -A opthash -- n:

    if [[ -n "${opthash[(i)-n]}" ]]; then
        field_id="${opthash[-n]}"
    fi

    local item
    if [ -p /dev/stdin ]; then
        if [ $@ ]; then
            __str=$@
        else
            __str=`cat -`
        fi
    else
        __str=$@
    fi
    item=$(echo $__str | fzf --tac -m --ansi) || return
    if [[ -n "${field_id}" ]]; then
        item=$(echo $item | perl -aF'\s+' -ne 'print $F'"[$field_id] . ' '")
    else
        item=$(echo $item | perl -pne "s/\n/ /g")
    fi
    print -z $item
}

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() {
  local out file key
  IFS=$'\n' out=($(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e))
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}

# fr
fr() {
  local dir
  dir=$(cdr -l 2> /dev/null | awk '{ print $2 }' | fzf +m) &&
  cd `eval echo $dir`
}

# fh - repeat history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]*\*\?//' | sed 's/\\/\\\\/')
}

# fk - kill process
fK() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}
fk() {
  local pid
  pid=$(ps -f | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# fbr - checkout git branch (including remote branches)
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fco - checkout git branch/tag
fco() {
  local tags branches target
  tags=$(
    git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
    git branch --all | grep -v HEAD             |
    sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
    sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
    (echo "$tags"; echo "$branches") |
    fzf-tmux -l30 -- --no-hscroll --ansi +m -d "\t" -n 2) || return
  git checkout $(echo "$target" | awk '{print $2}')
}

# fco_preview - checkout git branch/tag, with a preview showing the commits between the tag/branch and HEAD
fco_preview() {
  local tags branches target
  tags=$(
git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
git branch --all | grep -v HEAD |
sed "s/.* //" | sed "s#remotes/[^/]*/##" |
sort -u | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
(echo "$tags"; echo "$branches") |
    fzf --no-hscroll --no-multi --delimiter="\t" -n 2 \
        --ansi --preview="git log -200 --pretty=format:%s $(echo {+2..} |  sed 's/$/../' )" ) || return
  git checkout $(echo "$target" | awk '{print $2}')
}

# rg
frg() {
  local target args
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  target=$(rg --smart-case --color always -n $1 $2 | fzf --ansi --preview "sh ${MISC_DIR}/fzf_preview.sh {}") || return
  args=$(echo $target | perl -ne 'if(/(\S+):(\d+):/) { print qq{+$2 $1 -c "normal zz"}; }')
  eval "${EDITOR} ${args}"
}

# git status fiter
fga() {
	local selected
	selected=$(git status -s | bat -l "Git Attributes" --color=always -p | fzf -m --ansi --bind "\
ctrl-d:execute(${VIM} -c \":Gdiff\" {2..} < /dev/tty > /dev/tty 2>&1)") || return
    selected=$(echo ${selected} | cut -c3- | perl -pne 's/\n/ /g')
    print -z $selected
}

# fs - snippets
fs() {
  print -z $(cat ${MISC_DIR}/fzf_snippets | fzf +s --tac | sed 's/ ##### .*$//g')
}
