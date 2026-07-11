#!/bin/sh

# Generic xorg install script
# Installs stuff for xorg things that are not tied to dpi
# YOU MUST BE IN THE SAME DIRECTORY AS THE GENERIC BRANCH FOR THIS SCRIPT TO WORK!

ln -sfT $PWD/herbstluftwm $HOME/.config/herbstluftwm
ln -sfT $PWD/polybar $HOME/.config/polybar
ln -sfT $PWD/nitrogen $HOME/.config/nitrogen
ln -sfT $PWD/.fvwm $HOME/.fvwm
