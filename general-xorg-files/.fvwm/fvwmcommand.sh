#!/bin/sh

# Library to check whether fvwmcommand will work properly and if there is fvwm3
# We will check: /tmp and /var/tmp as well as $TMPDIR.
# /var/tmp and /tmp are for FVWM2, /tmp and $TMPDIR are for FVWM3.

# MUST BE SOURCED! This does not do anything useful if run standalone.

# Check for fvwm2
command -v fvwm2 > /dev/null
fvwm2exists=$?
# Same thing for fvwm3
command -v fvwm3 > /dev/null
fvwm3exists=$?
# Same thing for fvwm
command -v fvwm > /dev/null
fvwmexists=$?

# If both exist
if [ $fvwm2exists = 0 ] && [ $fvwm3exists = 0 ]; then
    # Use ps -au and find running fvwm
    psoutput=`ps -au`
    # If "fvwm" is in there:
    grep fvwm "$psoutput"
    fvwmexists=$?
    # If "fvwm2" is in there:
    grep fvwm2 "$psoutput"
    fvwm2exists=$?
    # If "fvwm3" is in there:
    grep fvwm3 "$psoutput"
    fvwm3exists=$?
fi

# If there is only a "fvwm" binary (fvwm2 does not exist and fvwm3 does not exist, but fvwm does)
if [ $fvwmexists = 0 ] && ! [ $fvwm2exists = 0 ] && ! [ $fvwm3exists = 0 ]; then
    # Get fvwm's version and check if "fvwm 2" is in there.
    # If so, then it's fvwm2.
    if fvwm --version | grep "fvwm 2" > /dev/null 2>&1; then
        fvwm2exists=0
        fvwm3exists=1
    else
        fvwm2exists=1
        fvwm3ezists=0
    fi
fi

# Check /var/tmp and /tmp if fvwm2exists
if [ $fvwm2exists = 0 ]; then
    #Check if /var/tmp is writable or if /tmp is writable
    if [ -w '/var/tmp' ] || [ -w '/tmp' ]; then
        # Set fvwmcommandworks to 0
        fvwmcommandworks=0
    else
        # Set it to 1
        fvwmcommandworks=1
    fi
fi

# Check $TMPDIR and /tmp if fvwm3exists
if [ $fvwm3exists = 0 ]; then
    #Check if $TMPDIR is writable or if /tmp is writable
    if [ -w '$TMPDIR' ] || [ -w '/tmp' ]; then
        # Set fvwmcommandworks to 0
        fvwmcommandworks=0
    else
        # Set it to 1
        fvwmcommandworks=1
    fi
fi
