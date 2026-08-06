#!/bin/sh

# DPI and Screen Resolution "library" for X11
# Meant to be sourced.
# Just gets DPI and screen resolution, and handles phone/tablet mode switching.

# Additional scaling based on mode (tablet, desktop, etc.)
# This script only handles the resizing, not the state changes.

if [ "$mode" = "touch" ]; then
    morescale=1.3
else
    morescale=1
fi

# Check if $FVWM_DPISCALE is set
if ! [ -z $FVWM_DPISCALE ]; then
    # Just set it to the values
    dpi=$FVWM_DPI
    dpiscale=$FVWM_DPISCALE
# Check if $DISPLAY is non-empty
elif [ -z $DISPLAY ]; then
    # Unset implies dpi=96
    dpi=96
    dpiscale=1
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

    # Get scale factor
    dpiscale=`echo $dpi | awk '{print $1 / 96}'`
    # Make FVWM export both
    echo "SetEnv FVWM_DPI $dpi"
    echo "SetEnv FVWM_DPISCALE $dpiscale"
fi

# Function for screen resolution
# This is separate for performance reasons
screenRes() {
    # Check if $FVWM_SCREENRES is set
    if ! [ -z $FVWM_SCREENRES ]; then
        # Just set it to the values
        wholeres=$FVWM_SCREENRES
        width=$FVWM_SCREENWIDTH
        height=$FVWM_SCREENHEIGHT
    # Check if $DISPLAY is non-empty
    elif [ -z $DISPLAY ]; then
        # Unset implies resolution is 1024x768
        wholeres="1024x768"
        width=1024
        height=768
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
        # Use x as separator: Format is WxH
        width=`echo $wholeres | awk -F 'x' '{print $1}'`
        height=`echo $wholeres | awk -F 'x' '{print $2}'`
        # Make FVWM export
        echo "SetEnv FVWM_SCREENRES $wholeres"
        echo "SetEnv FVWM_SCREENWIDTH $width"
        echo "SetEnv FVWM_SCREENHEIGHT $height"
    fi
}

# dpi scaler function using awk
# Takes only the value argument
dpiScaler() {
    # Multiply the three together using awk and round to integer
    echo "$1 $dpiscale $morescale" | awk '{val = $1 * $2 * $3; printf("%d\n", val + 0.5);}'
}

# dpi scaler function using awk
# Same as before but no touch mode stuff
dpiScalerNoTouch() {
    # Multiply the three together using awk and round to integer
    echo "$1 $dpiscale" | awk '{val = $1 * $2; printf("%d\n", val + 0.5);}'
}

# Font scaler
# Takes points (pt) and then awk does the math and rounds it
# Formula: pixels = points * dpi / 72, or: points * dpi scale factor * 96 / 72
fontScaler() {
    # Multiply the two together using awk and round to integer
    echo "$1 $dpi" | awk '{val = $1 * $2 / 72; printf("%d\n", val + 0.5);}'
}
