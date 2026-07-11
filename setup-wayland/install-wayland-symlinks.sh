#!/bin/sh

# Rudimentary Wayland Setup Install Script
# YOU MUST BE IN THE BASE DIRECTORY OF THE REPO FOR THIS TO WORK!

cd ../general-setup-files
. $PWD/install-generic-symlink.sh
cd ../setup-wayland
ln -sfT $PWD/sway $HOME/.config/sway
ln -sfT $PWD/rofi $HOME/.config/rofi
ln -sfT $PWD/waybar $HOME/.config/waybar
