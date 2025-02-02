#!/bin/sh

# Rudimentary Xorg 192dpi Setup Install Script
# YOU MUST BE IN THE BASE DIRECTORY OF THE REPO FOR THIS TO WORK!

cd ../general-setup-files
. $PWD/install-generic-symlink.sh
cd ../setup-192dpi
ln -sf $PWD/.fvwm $HOME/.fvwm
ln -sf $PWD/herbstluftwm $HOME/.config/herbstluftwm
ln -sf $PWD/dunst $HOME/.config/dunst
ln -sf $PWD/rofi $HOME/.config/rofi
ln -sf $PWD/polybar $HOME/.config/polybar
ln -sf $PWD/nitrogen $HOME/.config/nitrogen
ln -sf $PWD/picom $HOME/.config/picom
