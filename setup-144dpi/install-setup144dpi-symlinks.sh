#!/bin/sh

# Rudimentary Xorg 144dpi Setup Install Script
# YOU MUST BE IN THE BASE DIRECTORY OF THE REPO FOR THIS TO WORK!

cd ../general-setup-files
. $PWD/install-generic-symlink.sh
cd ../general-xorg-files
. $PWD/install-general-xorg-symlink.sh
cd ../setup-144dpi
ln -sfT $PWD/.Xresources $HOME/.Xresources
ln -sfT $PWD/rofi $HOME/.config/rofi
ln -sfT $PWD/picom $HOME/.config/picom
