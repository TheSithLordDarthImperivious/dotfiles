#!/bin/sh

# Generic install script
# Installs stuff for things that are not tied to wm
# YOU MUST BE IN THE SAME DIRECTORY AS THE GENERIC BRANCH FOR THIS SCRIPT TO WORK!

ln -sf $PWD/.zshrc ~/.zshrc
ln -sf $PWD/powerlevel10k ~/powerlevel10k
ln -sf $PWD/.p10k.zsh ~/.p10k.zsh
ln -sf $PWD/.vimrc ~/.vimrc
ln -sf $PWD/.nanorc ~/.nanorc
ln -sf $PWD/alacritty ~/.config/alacritty
