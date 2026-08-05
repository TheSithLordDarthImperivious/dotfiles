#!/bin/sh

# Fonts handling for FVWM Shell Scripts

# Font Generator (Xft)
# First Argument: Name, Second Argument: Size (PIXELS, Third Argument: Antialias, Fourth Argument: Bold, Fifth Argument: FVWM (add xft: prefix)
# Third and Fourth use 'True'/'False' literals
fontGen() {
    # We use fc-match so that we can do fallback fonts
    # fc-match always prints the font name in the second column
    realfont=`fc-match "$1" | awk -F '"' '{print $2}'`
    fontdesc="$1:pixelsize=$2:antialias=$3"
    if [ "$4" = "True" ]; then
        # Append :Bold
        fontdesc="$fontdesc:Bold"
    fi
    if [ "$5" = "True" ]; then
        # Prepend (Add) xft: prefix
        fontdesc="xft:$fontdesc"
    fi
    echo $fontdesc
}
