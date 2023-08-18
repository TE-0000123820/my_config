#!/bin/bash
set -eu -o pipefail

MISC_DIR=/share/misc_kato/

cd $HOME

cat ${MISC_DIR}/.profile >> ~/.profile
source ~/.profile

ln -sf ${MISC_DIR} ./
ln -sf ${MISC_DIR}/.tmux.conf .
ln -sf ${MISC_DIR}/.gitconfig .
ln -sf ${MISC_DIR}/.vimrc .

vim -c ":PlugInstall|:qa"

cat << EOF > ~/.zshrc
export MISC_DIR=~/misc_kato
source $MISC_DIR/.zshrc
EOF

mkdir -p ~/.ssh
