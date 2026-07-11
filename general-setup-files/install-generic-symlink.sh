#!/bin/sh

# Generic install script
# Installs stuff for things that are not tied to any specific display protocol
# YOU MUST BE IN THE SAME DIRECTORY AS THE GENERIC BRANCH FOR THIS SCRIPT TO WORK!

ln -sfT $PWD/.zshrc $HOME/.zshrc
ln -sfT $PWD/powerlevel10k $HOME/powerlevel10k
ln -sfT $PWD/.p10k.zsh $HOME/.p10k.zsh
ln -sfT $PWD/.p10k-basic.zsh $HOME/.p10k-basic.zsh
ln -sfT $PWD/.vimrc $HOME/.vimrc
ln -sfT $PWD/.nanorc $HOME/.nanorc
ln -sfT $PWD/themes/openbox-theme-juno $HOME/.themes/openbox-theme-juno
ln -sfT $PWD/themes/openbox-theme-arc $HOME/.themes/openbox-theme-arc
ln -sfT $PWD/Kvantum $HOME/.config/Kvantum
ln -sfT $PWD/qterminal.org $HOME/.config/qterminal.org
ln -sfT $PWD/alacritty $HOME/.config/alacritty
ln -sfT $PWD/kitty $HOME/.config/kitty
ln -sfT $PWD/i3status $HOME/.config/i3status
ln -sfT $PWD/dunst $HOME/.config/dunst
ln -sfT $PWD/openbox $HOME/.config/openbox
ln -sfT $PWD/openbox $HOME/.config/labwc
ln -sfT $PWD/lxqt $HOME/.config/lxqt
ln -sfT $PWD/qt5ct $HOME/.config/qt5ct
ln -sfT $PWD/qt6ct $HOME/.config/qt6ct
ln -sfT $PWD/gtk-3.0 $HOME/.config/gtk-3.0
ln -sfT $PWD/dconf $HOME/.config/dconf
ln -sfT $PWD/glib-2.0 $HOME/.config/glib-2.0
mkdir -p $HOME/.local/share
ln -sfT $PWD/wallpapers $HOME/.local/share/wallpapers
