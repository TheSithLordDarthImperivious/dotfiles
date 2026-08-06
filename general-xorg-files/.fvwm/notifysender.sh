#!/bin/sh
# Notify sender script
# Has a fallback for xterm

if command -v notify-send > /dev/null 2>&1; then
    # Use notify-send
    notify-send "$1" "$2"
else
    # Use xterm
    secstosleep=3
    # The command string just prints out thebtitle, message, and has a timeout before exiting (secstosleep)
    # Use printf '%b\n' "string" because echo -e is not portable
    commandstr="printf '%b\n' '\033[1m$1\033[0m\n'; printf '%b\n' \"$2\n\"; echo 'Exiting in $secstosleep seconds...'; sleep $secstosleep"
    # Ezecute xterm with title "Notification" amd execute the command string
    xterm -T Notification -e "$commandstr"
fi
