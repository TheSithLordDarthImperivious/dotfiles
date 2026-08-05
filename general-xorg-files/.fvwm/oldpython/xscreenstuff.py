# DPI and Screen Resolution "library" for X11
# Meant to be imported.
# Just gets DPI and screen resolution.

# ABANDONED IN FAVOUR OF SH VERSION

import subprocess

def getDPI():
    # Get DPI
    rawoutput = ""
    # Counter for dpi timeout, until it's 10
    # TODO: xrdb import here instead? I don't like running xrdb every few milliseconds
    counter = 0
    while rawoutput == "" or counter < 10:
        # Get the result of xrdb -q, but loop it until we get a value
        rawoutput = subprocess.run(["xrdb", "-q"],capture_output=True).stdout.decode()
        # Increment counter
        counter = counter + 1
    # Check if rawoutput is no longer empty
    if rawoutput != "":
        # Process the output into DPI
        # Replace tabs with spaces, split according to "\\n"
        splitoutput = rawoutput.replace("\t"," ").split("\n")
        # Search for xft.dpi
        for item in splitoutput:
            if "Xft.dpi" in item:
                # Set dpi to the item.split(), and the index is ALWAYS the second
                dpi = int(item.split()[1])
    else:
        # If still empty, assume dpi is 96 (standard DPI)
        dpi = 96
    return dpi

def getScrRes():
    # In addition, get the screen resolution
    xdpyraw = subprocess.run(["xdpyinfo"],capture_output=True).stdout.decode()
    # Process the output to get dimensions
    xdpysplit = xdpyraw.split("\n")
    # Loop over until there's a "dimension" item.
    nores = True
    rescount = 0
    dimenraw = ""
    while nores:
        # Check if "dimensions" is in one of the entries (this will always get the first one!)
        if "dimensions" in xdpysplit[rescount]:
            nores = False
            dimenraw = xdpysplit[rescount]
        # Prevent infinite loop.
        if rescount >= len(xdpysplit):
            # Force set nores to False
            nores = False
        rescount = rescount + 1

    # If there is no valid resolution, just exit
    if dimenraw == "":
        exit(1)

    # Split dimenraw, and the resolution, LxW, will always be in the second index.
    # Then split it with "x".
    screenres = dimenraw.split()[1].split("x")
    return screenres
