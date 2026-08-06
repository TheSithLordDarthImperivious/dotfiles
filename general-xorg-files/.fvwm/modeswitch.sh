#!/bin/sh

# Mode Switching script for FVWM (Desktop/Tablet/Phone)

# Default is desktop (like all other scripts)

# This script only calls other scripts via sourcing.

# Script gets called with the mode to switch to.
# FVWM's $[FWWM_CURRENTMODE] breaks (does not expand) even though setenv works, so we will directly use the env var
current="$FVWM_CURRENTMODE"
next="$1"

# Check if next is empty
if [ -z $next ]; then
    # Force set it to desktop
    next="desktop"
fi

# Check if next is init
if [ $next = "init" ]; then
    # Set next to currentmode
    next="$FVWM_CURRENTMODE"
    # Set init
    init="set"
fi

# Enable Phone Mode
enablePhone(){
# NOTE: ResizeMaximize actually cannot unset maximized state.
# State 2: Managed via phone mode
# State 1: Had no titlebar before phone mode
cat<<EOF
# Function that is run when any window is opened (auto-maximize and set states)
DestroyFunc TestMax
AddToFunc TestMax
+ I WindowStyle !Title, !Borders
+ I UpdateStyles
+ I Maximize 100 100
+ I State 2 True
+ I WindowStyle !Maximizable

# Make all maximizable windows have no titlebar or borders
All (Maximizable) WindowStyle !Title, !Borders
# Update styles so that the title and borders can take effect before maximizing
UpdateStyles
# Enable State 2 (maximized by phone mode flag) on maximizable, but not maximized windows
All (Maximizable, !Maximized) State 2 True
# Force re-maximization of previously maximized windows
All (Maximizable) Maximize True 100 100
# Make all current maximized windows (including State 2 ones) not be maximizable (restorable)
All (Maximized) WindowStyle !Maximizable
# Make it so that the function is run when any window is opened
Style * InitialMapCommand TestMax
EOF
}

# Disable Phone Mode
disablePhone(){
cat<<EOF
# Make all maximized windows (except state 1) maximizable and have titlebar and border
All (Maximized, !State 1) WindowStyle Maximizable, Title, Borders
# Update the styles so that maximize false (restore) can take effect
UpdateStyles
# Unmaximize ecery window that was maximized by phone mode.
All (State 2) Maximize False
# Still-maximized windows get maximized again so that it can update with ewmhbaemsestructs
All (Maximized) Maximize True 100 100
# Set all previously !Title windows to Maximizable and border (previousky we excluded)
All (State 1) WindowStyle Maximizable, Borders
# Disable all State 2
All State 2 False
# Disable the function that is run when every window is run.
Style * InitialMapCommand Nop
EOF
}

# Enable Touch-Mode Keyboard
enableTouchKBD(){
cat<<EOF
# Kill all existing keyboard instances
All (Keyboard) Close
# Run the keyboard
Exec exec matchbox-keyboard
# Wait for matchbox
Wait Keyboard
# Set the style of the keyboard
All (Keyboard) WindowStyle StaysOnTop, Sticky, BorderWidth 0, !Borders, !Closable, !Title
UpdateStyles
All (Keyboard) ResizeMove 100 35 0 -0
All (Keyboard) Move 0 -0
All (Keyboard) WindowStyle FixedPosition, FixedSize
All (Keyboard) Iconify
# We will add a InitialMapCommand Close to prevent any new keyboard windows from being opened
Style Keyboard InitialMapCommand Close
EOF
}

# Disable touch-mode keyboard
disableTouchKBD(){
cat<<EOF
# Disable initialmapcommand close
Style Keyboard InitialMapCommand Nop, Closable
# Needed for FVWM3
All (Keyboard) WindowStyle Closable
UpdateStyles
All (Keyboard) Close
EOF
}

# Check if currrent is equal to next and init is NOT set
if [ $current = $next ] && [ -z $init ] ; then
    # Exit with error code 0
    exit 0
# Check if current is phone and next is tablet
elif [ $current = "phone" ] && [ $next = "tablet" ]; then
    # Switch off the styles and then infostoreadd the tablet mode
    disablePhone
    disableTouchKBD
    echo "SetEnv FVWM_CURRENTMODE tablet"
# Check if current is tablet and next is phone
elif [ $current = "tablet" ] && [ $next = "phone" ]; then
    # Switch on the styles, infostoreadd phone
    enablePhone
    enableTouchKBD
    echo "SetEnv FVWM_CURRENTMODE phone"
elif [ $next = "phone" ]; then
    # Switch on the styles and do touch UI mode
    # Phobe mode styles have to be done last since maximize needs EwmhBaseStruts to not go under the panel
    # Enable touch UI and "panel modify" mode
    mode='touch'
    panel_modify='set'
    . $HOME/.fvwm/dpigen.sh
    . $HOME/.fvwm/panel-generator.sh
    enablePhone
    enableTouchKBD
    echo "SetEnv FVWM_CURRENTMODE phone"
elif [ $next = "tablet" ]; then
    # Do tablet mode only
    # It's just touch UI abnd setting panel modify though
    mode='touch'
    panel_modify='set'
    . $HOME/.fvwm/dpigen.sh
    . $HOME/.fvwm/panel-generator.sh
    echo "SetEnv FVWM_CURRENTMODE tablet"
else
    # Assume next is desktop, just run both scripts and set panel_modify
    panel_modify='set'
    . $HOME/.fvwm/dpigen.sh 'modify'
    . $HOME/.fvwm/panel-generator.sh 'modify'
    # Check if current was phone
    if [ $current = phone ]; then
        # Additionally disable phone
        disablePhone
        disableTouchKBD
    fi
    echo "SetEnv FVWM_CURRENTMODE desktop"
fi

