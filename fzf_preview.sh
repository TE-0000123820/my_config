FILE_NAME=`echo $1 | perl -ne 'if (/^(\S+):(\d+):/) { print $1; }'`
LINE_NO=`echo $1 | perl -ne 'if (/^(\S+):(\d+):/) { print $2; }'`
bash ~/.vim/bundle/fzf.vim/bin/preview.sh ${FILE_NAME}:${LINE_NO}
