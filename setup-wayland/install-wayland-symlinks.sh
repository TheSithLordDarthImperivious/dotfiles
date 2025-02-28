#!/bin/sh

# Rudimentary Wayland Setup Install Script
# YOU MUST BE IN THE BASE DIRECTORY OF THE REPO FOR THIS TO WORK!

cd ../general-setup-files
. $PWD/install-generic-symlink.sh
cd ../setup-wayland
ln -sf $PWD/sway $HOME/.config/sway
ln -sf $PWD/rofi $HOME/.config/rofi
ln -sf $PWD/waybar $HOME/.config/waybar
