#!/bin/sh

# DPI and Screen Resolution "library" for X11
# Meant to be sourced.
# Just gets DPI and screen resolution, and handles phone/tablet mode switching.

# Additional scaling based on mode (tablet, desktop, etc.)
# This script only checks if $1 is either tablet or phone. Phone will also have some additional echo commands to set "always maximize".# It is "desktop" by default and if the argument is invalid.

if [ "$1" = "tablet" ]; then
    morescale=1.5
    setmode="tablet"
elif [ "$1" = "phone" ]; then
    morescale=1.5
    setmode="phone"
else
    morescale=1
    setmode="desktop"
fi

# Check if $DISPLAY is non-empty
if [ -z $DISPLAY ]; then
    # Unset implies dpi=96
    dpi=96
else
    # It is of format 'Xft.dpi: X', so we use awk to get X
    dpi=`xrdb -q | grep Xft.dpi | awk '{print $2}'`
    # We have to loop until "dpi" is defined or "non-empty", or else scripts will break
    # We have a countdown of 10 tries
    count=0
    while [ -z $dpi ] && [ $count -lt 10 ]; do
        # Run the command
        dpi=`xrdb -q | grep Xft.dpi | awk '{print $2}'`
        # Use $(()) to add
        count=$(($count+1))
    done
    if [ -z $dpi ]; then
        # Just set it to 96
        dpi=96
    fi
fi

# Get scale factor
dpiscale=`echo $dpi | awk '{print $1 / 96}'`

# Function for screen resolution
# This is separate for performance reasons
screenRes() {
    # Check if $DISPLAY is non-empty
    if [ -z $DISPLAY ]; then
        # Unset implies resolution is 1024x768
        wholeres="1024x768"
    else
        # Basically we use xdpyinfo, get the dimension, but only the first one, and then the second is the WxH we need.
        wholeres=`xdpyinfo | grep -i dimension | head -n 1 | awk '{print $2}'`
        # We have to loop until "wholeres" is defined or "non-empty", or else scripts will break
        # We have a countdown of 10 tries
        count=0
        while [ -z $wholeres ] && [ $count -lt 10 ]; do
            # Get whole res string again
            wholeres=`xdpyinfo | grep -i dimension | head -n 1 | awk '{print $2}'`
            # Use $(()) to add
            count=$(($count+1))
        done
        if [ -z $wholeres ]; then
            # Just set it to 1024x768
            wholeres="1024x768"
        fi
    fi

    # Use x as separator: Format is WxH
    width=`echo $wholeres | awk -F 'x' '{print $1}'`
    height=`echo $wholeres | awk -F 'x' '{print $2}'`
}

# dpi scaler function using awk
# Takes only the value argument
dpiScaler() {
    # Multiply the three together using awk and round to integer
    echo "$1 $dpiscale $morescale" | awk '{val = $1 * $2 * $3; printf("%d\n", val + 0.5);}'
}

# Font scaler
# Takes points (pt) and then awk does the math and rounds it
# Formula: pixels = points * dpi / 72, or: points * dpi scale factor * 96 / 72
fontScaler() {
    # Multiply the two together using awk and round to integer
    echo "$1 $dpi" | awk '{val = $1 * $2 / 72; printf("%d\n", val + 0.5);}'
}
