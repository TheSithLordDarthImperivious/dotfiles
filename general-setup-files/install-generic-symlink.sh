#!/bin/sh

# Generic install script
# Installs stuff for things that are not tied to wm
# YOU MUST BE IN THE SAME DIRECTORY AS THE GENERIC BRANCH FOR THIS SCRIPT TO WORK!

ln -sf $PWD/.zshrc $HOME/.zshrc
ln -sf $PWD/powerlevel10k $HOME/powerlevel10k
ln -sf $PWD/.p10k.zsh $HOME/.p10k.zsh
ln -sf $PWD/.vimrc $HOME/.vimrc
ln -sf $PWD/.nanorc $HOME/.nanorc
ln -sf $PWD/alacritty $HOME/.config/alacritty
ln -sf $PWD/kitty $HOME/.config/kitty
ln -sf $PWD/i3status $HOME/.config/i3status
