#!/bin/sh

# Mode Switching script for FVWM (Desktop/Tablet/Phone)

# Default is desktop (like all other scripts)

# This script only calls other scripts via sourcing.

# Script gets called with TWO arguments: The current mode and the next mode.
current="$1"
next="$2"

# TODO: Phone Styles Function

# Check if next is empty
if [ -z $next ];
    # Force set it to desktop
    next="desktop"
fi


# Check if currrent is equal to next
if [ $current = $next ]; then
    # Exit with error code 0
    exit 0
# Check if current is phone and next is tablet
elif [ $current = "phone" ] && [ $next = "tablet" ]; then
    # Switch off the styles and then infostoreadd the tablet mode
# Check if current is tablet and next is phone
elif [ $current = "tablet" ] && [ $next = "phone" ]; then
    # Switch on the styles, infostoreadd phone
elif [ $next = "phone" ]; then
    # Switch on the styles and do tablet mode
elif [ $next = "tablet" ]; then
    # Do tablet mode only
else
    # Assume next is desktop, just run both scripts without args
fi

