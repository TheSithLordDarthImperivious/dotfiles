#!/bin/sh

# Rudimentary Wayland Setup Install Script
# Does not install themes and fonts yet!
# Untested, just taken from zsh history!
# YOU MUST BE IN THE BASE DIRECTORY OF THE REPO FOR THIS TO WORK!

cd general-setup-files
ln -sf $PWD/.zshrc ~/.zshrc
ln -sf $PWD/powerlevel10k ~/powerlevel10k
ln -sf $PWD/.p10k.zsh ~/.p10k.zsh
ln -sf $PWD/.vimrc ~/.vimrc
ln -sf $PWD/.nanorc ~/.nanorc
ln -sf $PWD/alacritty ~/.config/alacritty
cd ..
ln -sf $PWD/sway ~/.config/sway
ln -sf $PWD/dunst ~/.config/dunst
ln -sf $PWD/rofi ~/.config/rofi
ln -sf $PWD/waybar ~/.config/waybar
