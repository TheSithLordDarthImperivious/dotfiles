#!/bin/sh

if [ "$FVWM_CURRENTMODE" = 'desktop' ]; then
    if ! pkill matchbox; then
        echo "Exec exec matchbox-keyboard"
    fi
else
    echo "All (Keyboard) Iconify"
fi
