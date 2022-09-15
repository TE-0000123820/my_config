#!/bin/bash
set -eu -o pipefail

#
# vim
#
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

mkdir -p ~/vim_swap

#
# tmux
#
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

#
# python
#
sudo apt install python3-pip
pip3 install --user neovim python-lsp-server

#
# github
#
cat <<EOF >> ~/.ssh/config
Host github.com
    User git
    HostName ssh.github.com
    Port 443
EOF
