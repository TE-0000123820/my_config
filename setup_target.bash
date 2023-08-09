#!/bin/bash
set -eu -o pipefail

MISC_DIR=/share/misc_kato/

cp ${MISC_DIR}/.bash-preexec.sh ~/
cat ${MISC_DIR}/.bashrc >> ~/.bashrc
cat ${MISC_DIR}/.profile >> ~/.profile

### vim
cat ${MISC_DIR}/.vimrc.min >> ~/.vimrc

### docker
mkdir -p ~/.docker/
cp ${MISC_DIR}/docker_config.json ~/.docker/config.json
