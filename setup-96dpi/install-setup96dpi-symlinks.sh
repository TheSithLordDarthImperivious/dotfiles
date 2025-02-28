#!/bin/sh

# Rudimentary Xorg 96dpi Setup Install Script
# YOU MUST BE IN THE BASE DIRECTORY OF THE REPO FOR THIS TO WORK!

cd ../general-setup-files
. $PWD/install-generic-symlink.sh
cd ../general-xorg-files
. $PWD/install-general-xorg-symlink.sh
cd ../setup-96dpi
ln -sf $PWD/.fvwm $HOME/.fvwm
ln -sf $PWD/rofi $HOME/.config/rofi
ln -sf $PWD/picom $HOME/.config/picom
