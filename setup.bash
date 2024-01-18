#!/bin/bash
set -u -o pipefail

config_dir=$(pwd)

#
# vim
#
function setup_vim() {
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
mkdir -p ~/vim_swap
(
cd ~/
ln -sf $config_dir/.vimrc .
)
env MISC_DIR=$config_dir vim -c ":PlugInstall|:qa"
}

#
# tmux
#
function setup_tmux() {
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
(
cd ~/
ln -sf $config_dir/.tmux.conf .
)
}

#
# python
#
function setup_python() {
sudo apt update
sudo apt install -y python3-pip
pip3 install --user neovim python-lsp-server
}

#
# github
#
function setup_github() {
cat <<EOF >> ~/.ssh/config
Host github.com
    User git
    HostName ssh.github.com
    Port 443
EOF

(
cd ~
ln -sf $config_dir/.gitconfig ./
mkdir -p ~/.ssh
cat $config_dir/.ssh_config >> ./.ssh/config
)
}

#
# misc
#
function setup_misc() {
mkdir -p ~/.cache/shell/

sudo apt update
sudo apt install -y zsh libevent-dev bison flex vim keychain less wget unzip jq golang-go global
(
cd ~/
ln -sf ${config_dir} ./my_config
)

# zsh
cat << EOF >> ~/.zshrc
export MISC_DIR=~/my_config
source \$MISC_DIR/.zshrc
EOF
}

setup_tmux
setup_python
setup_github
setup_misc
setup_vim
