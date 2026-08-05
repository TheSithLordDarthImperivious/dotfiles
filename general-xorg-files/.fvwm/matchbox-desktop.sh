#!/bin/sh

if [ "$FVWM_CURRENTMODE" = 'desktop' ]; then
    if ! pkill matchbox; then
        echo "Exec exec matchbox-keyboard"
    fi
else
    KBDHEIGHT=`echo $FVWM_SCREENHEIGHT 0.35 | awk '{val = $1 * $2; printf("%d\n", val + 0.5);}'`
    # Use heredoc
    # The command is "resizemaximize" as we do not want the window to become unmaximized.
cat<<EOF
DestroyFunc KbdHide
AddToFunc KbdHide
+ I EwmhBaseStruts 0 0 $FVWM_PANHEIGHT 0
+ I All (Maximized) ResizeMaximize keep 100da

DestroyFunc KbdShow
AddToFunc KbdShow
+ I EwmhBaseStruts 0 0 $FVWM_PANHEIGHT $KBDHEIGHT
+ I All (Maximized) ResizeMaximize keep w-35
EOF
    echo "All (Keyboard) Iconify"
    echo "All (Keyboard, Iconic) KbdHide"
    echo "All (Keyboard, !Iconic) KbdShow"
fi
