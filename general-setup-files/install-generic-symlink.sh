#!/bin/sh

# Generic install script
# Installs stuff for things that are not tied to any specific display protocol
# YOU MUST BE IN THE SAME DIRECTORY AS THE GENERIC BRANCH FOR THIS SCRIPT TO WORK!

ln -sf $PWD/.zshrc $HOME/.zshrc
ln -sf $PWD/powerlevel10k $HOME/powerlevel10k
ln -sf $PWD/.p10k.zsh $HOME/.p10k.zsh
ln -sf $PWD/.p10k-basic.zsh $HOME/.p10k-basic.zsh
ln -sf $PWD/.vimrc $HOME/.vimrc
ln -sf $PWD/.nanorc $HOME/.nanorc
ln -sf $PWD/themes/openbox-theme $HOME/.themes/openbox-theme
ln -sf $PWD/Kvantum $HOME/.config/Kvantum
ln -sf $PWD/qterminal.org $HOME/.config/qterminal.org
ln -sf $PWD/alacritty $HOME/.config/alacritty
ln -sf $PWD/kitty $HOME/.config/kitty
ln -sf $PWD/i3status $HOME/.config/i3status
ln -sf $PWD/dunst $HOME/.config/dunst
ln -sf $PWD/openbox $HOME/.config/openbox
ln -sf $PWD/openbox $HOME/.config/labwc
ln -sf $PWD/lxqt $HOME/.config/lxqt
ln -sf $PWD/qt5ct $HOME/.config/qt5ct
ln -sf $PWD/qt6ct $HOME/.config/qt6ct
