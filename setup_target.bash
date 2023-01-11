#!/bin/bash
set -eu -o pipefail

MISC_DIR=/share/misc_kato/

cp ${MISC_DIR}/.bash-preexec.sh ~/
cat ${MISC_DIR}/.bashrc >> ~/.bashrc

### vim
cat ${MISC_DIR}/.vimrc.min >> ~/.vimrc
