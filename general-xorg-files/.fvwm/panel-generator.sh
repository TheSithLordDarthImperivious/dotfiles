#!/bin/sh

# Panel generator for fvwm
# Needed because: DPI scaling, dynamic panel based on actual monitor dimensions (we want a PORTABLE setup)
# Use PipeRead in fvwm to actually use the generated config snippet
# NOTE: DOES NOT SUPPORT ARBITRARY LEFT/RIGHT/BOTTOM PANELS!
# This does not actually use X11 libraries, it's just a text processor

# Source dimensbase file
. $FVWM_USERDIR/dimensbase.sh

# Source font file
. $FVWM_USERDIR/font.sh

# Source fvwmcommand file
. $FVWM_USERDIR/fvwmcommand.sh

# Source xscreenstuff file
. $FVWM_USERDIR/xscreenstuff.sh

# Get the screen resolution
screenRes

# Firstly, scale the panel items
panel=`dpiScaler $bpanel`
panel_button=`dpiScaler $bpanel_button`
panel_cpuramdisk=`dpiScaler $bpanel_cpuramdisk`
panel_net=`dpiScaler $bpanel_net`
panel_clock=`dpiScaler $bpanel_clock`
panel_xclock_padding=`dpiScaler $bpanel_xclock_padding`
panel_wintitle_padding=`dpiScaler $bpanel_wintitle_padding`

# Also scale the norfont (via fontScaler)
norfontsize=`fontScaler $bnorfontsize`

# Create the font (same as normal font)
# But no xft: needed
norfont=`fontGen "$fontname" "$norfontsize" 'True' 'False'`

# "Class" for action button
# First Arg: Panel Name, Second arg: Length, Third Arg: Width, Fourth Arg: ID, Fifth Arg: Title, Sixth Arg: Normal Colorset, Seventh Arg: Active Colorset, Eighth Arg: Press Colorset, Ninth Arg: Action (FVWM)
actionButton() {
    # Check if horizontal padding arg is empty
    # If so, set it to 0, and if not, set it to the given value
    if [ -z ${10} ]; then
        hpad=0
    else
        hpad=${10}
    fi
    # Same with vertical padding
    if [ -z ${11} ]; then
        vpad=0
    else
        vpad=${11}
    fi
    # Use POSIX sh integer arithmetic to subtract the button width from the spacer width, and set it to the new value
    curspacerwidth=$(($curspacerwidth - $2))
    # Construct String, append to curpanelitems
    curpanelitems="$curpanelitems*$1: ($2x$3, Id '$4', Title '$5', Colorset $6, ActiveColorset $7, PressColorset $8, ActionOnPress, Action $9, Padding $hpad $vpad)\n"
}

# Second version of actionbutton
# This is meant for usage with the spacer
# Args are the same as normal actionbutton but without the panel name or dimensions
actionButtonSpacer(){
    # Check if horizontal padding arg is empty
    # If so, set it to 0, and if not, set it to the given value
    if [ -z $7 ]; then
        hpad=0
    else
        hpad=$7
    fi
    # Same with vertical padding
    if [ -z $8 ]; then
        vpad=0
    else
        vpad=$8
    fi
    # Just Echo
    echo ", Id '$1', Title (Left) '$2', Colorset $3, ActiveColorset $4, PressColorset $5, ActionOnPress, Action $6, Padding $hpad $vpad"
}


# "Class" for swallowed window
# First Arg: Panel Name, Second Arg: Length, Third Arg: Width, Fourth Arg: ID, Fifth Arg: Window Class to Swallow, Sixth Arg: Command, Seventh Arg: Horizontal Padding, Eighth Arg: Vertical Padding, Ninth Arg: Command to execute when clicked
swallowedWin() {
    # Check if horizontal padding arg is empty
    # If so, set it to 0, and if not, set it to the given value
    if [ -z $7 ]; then
        hpad=0
    else
        hpad=$7
    fi
    # Same with vertical padding
    if [ -z $8 ]; then
        vpad=0
    else
        vpad=$8
    fi
    # Check if ninth arg (command string) is non-empty
    if ! [ -z $9 ]; then
        # Set it to ", Action $9"
        extrastr=", Action $9"
    fi
    # Use POSIX sh integer arithmetic to subtract the button width from the sapcer width, and set it to the new value
    curspacerwidth=$(($curspacerwidth - $2))
    # Construct String, append to curpanelitems
    curpanelitems="$curpanelitems*$1: ($2x$3, Id '$4', Swallow '$5' '$6', Padding $hpad $vpad$extrastr)\n"
}

# Add spacer function
# Just adds insert_spacer into the string
addSpacer() {
    curpanelitems="${curpanelitems}insert_spacer\n"
}

# "Class" for Panel
# First Arg: Name, Second arg: Geometry x, Third arg: Geometry y, Fourth Arg: Top, Fifth Arg: Left, Sixth Arg: Base Colorset, Seventh Arg: Frame, Eighth Arg: Font, Ninth Arg: Rows, Tenth Arg: Columns, Eleventh Arg: Style
# Note: Columns should equal geometry x for horizontal, Rows should equal geometry y for vertical.
barGen() {
    # Check for top ($4)
    if [ "$4" = true ]; then
        geomxoff="+0"
    else
        geomxoff="-0"
    fi
    # Check for left ($5)
    if [ "$5" = true ]; then
        geomyoff="+0"
    else
        geomyoff="-0"
    fi

    # Set spacerwidth (exact same by default, we will subtract)
    curspacerwidth=${10}
    # Set spacerheight (exact same by default, we will subtract)
    curspacerheight=${9}

    # Global variable for panel items
    curpanelitems="\n"

    # Use heredoc
cat <<EOF
EwmhBaseStruts 0 0 $panel 0
Style $1 ${11}
DestroyModuleConfig $1: *
*$1: Geometry $2x$3$geomxoff$geomyoff
*$1: Colorset $6
*$1: Frame $7
*$1: Font $8
*$1: Rows $9
*$1: Columns ${10}
EOF
}

# The Panel Itself
# Add xft: prefix manually
#barGen FvwmBar "$width" $panel true true 0 0 "xft:$norfont" 1 "$width" '!Borders, !Title, WindowListSkip, StaysOnTop, Sticky, FixedPosition, FixedSize, !Maximizable, !Iconifiable, !Closable'
barGen FvwmBar "$width" $panel true true 0 0 "xft:$norfont" 1 "$width" 'Unmanaged'

# Spacer
# First Argument: Panel Name, Second Argument: Amount of Spacers, Third Argument: Special Options
spacerGen() {
    # Get the remaining space and divide it by the amount of spacers
    spaceremain=$(($curspacerwidth / $2))
    # Store into a variable called spacer
    spacer="*$1: (${spaceremain}x1$3)"
    # Use sed to replace insert_spacer with the real spacer
    curpanelitems=`echo $curpanelitems | sed "s/insert_spacer/${spacer}/g"`
}

# ELEMENTS

# Rofi
actionButton FvwmBar $panel_button 1 'launcher' '' 18 6 17 'Exec exec rofi -normal-window -dpi 0 -show drun'

# WindowSwitcher
actionButton FvwmBar $panel_button 1 'wswitcher' '' 0 6 17 'WindowList Root c c'

# File Browser
#actionButton FvwmBar $panel_button 1 'fileman' '' 0 6 17 'Exec exec rofi -normal-window -dpi 0 -show filebrowser'

# Virtual Desktop Switcher
actionButton FvwmBar $panel_button 1 'deskswitch' "$[FVWM_CURRENT_DESK]" 17 6 0 'Menu DeskMenu Root c c'

# Add Spacer
addSpacer

# Keyboard
actionButton FvwmBar $panel_button 1 'keyboard' '' 0 6 17 'PipeRead "sh $[FVWM_USERDIR]/matchbox-desktop.sh"'

# Mode Switcher
actionButton FvwmBar $panel_button 1 'modeswitch' '' 0 6 17 'Menu ModeSwitcher Delete'

# Only if fvwmcommandworks is true (fvwmcommandworks = 0), AND if psutil exists
if [ $fvwmcommandworks = 0 ] && python3 -c "import importlib.util; exit(importlib.util.find_spec('psutil') is None)" > /dev/null 2>&1; then
    # CPU
    actionButton FvwmBar $panel_cpuramdisk 1 'cpu' '  0.0 %' 19 19 19 'Exec exec python3 $[FVWM_USERDIR]/statslong.py --cpu --notifysend'

    # RAM
    actionButton FvwmBar $panel_cpuramdisk 1 'ram' '  0.0 %' 20 20 20 'Exec exec python3 $[FVWM_USERDIR]/statslong.py --ram --notifysend'

    # Disk
    actionButton FvwmBar $panel_cpuramdisk 1 'disk' '  0.0 %' 21 21 21 'Exec exec python3 $[FVWM_USERDIR]/statslong.py --disk --notifysend'

    # Battery
    actionButton FvwmBar $panel_cpuramdisk 1 'battery' '󰁺  None' 0 0 0 'Exec exec python3 $[FVWM_USERDIR]/statslong.py --battery --notifysend'
fi

# xclock swallow
swallowedWin FvwmBar $panel_clock 1 'FvwmBarClock' xclock "Exec exec xclock -d -face \"$norfont\" -fg \"#75B5AA\" -update 1 -strftime \" %H:%M:%S\" -padding $panel_xclock_padding -title 'FvwmBarClock'" 0 0 "Exec exec sh \$[FVWM_USERDIR]/date.sh"

# Power Button
actionButton FvwmBar $panel_button 1 'poweropts' '' 27 28 29 "Menu PowerOptions Root c c"

# Generate spacer
spacerGen FvwmBar 1 "`actionButtonSpacer 'wintitle' 'Desktop' 0 0 0 'Current Menu MenuWindowOps Delete' $panel_wintitle_padding 0`"

# "Echo" all elements
# Use printf as dash does not support echo -e (echo -e is just echo in dash) and normal echo does not support newline
# Use "%b" as format string so that printf doesn't treat the % as a format string and %b processes escapes like \n (newline)
printf '%b\n' "$curpanelitems"

# Only restart the panel if it's in "modify" mode (if panel_modify is set to a non-empty value)
if ! [ -z $panel_modify ]; then
    # Echo the killmodule command
    echo "KillModule FvwmButtons FvwmBar"
fi

# Echo the module start command
echo "Module FvwmButtons FvwmBar"
# Set some ENV vars
echo "SetEnv FVWM_PANHEIGHT $panel"
