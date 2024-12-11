#!/bin/bash
set -e
cd "$(dirname "$0")"
ln -rsfv init.lua ~/.config/nvim/init.lua
ln -rsfv .tmux.conf ~/.tmux.conf
ln -rsfv .bashrc ~/.bashrc
