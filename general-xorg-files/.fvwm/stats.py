# General stats library consumer for FvwmButtons
# NEEDS FVWMCOMMAND OR THIS WILL NOT WORK!

from time import sleep
import importlib.util

# Custom
import statslib
import fvwmcommand

# Check if the module "psutil" does NOT exist
if importlib.util.find_spec('psutil') is None:
    # Exit immediately
    exit(0)

# Battery with Logo
# This will also include the logo
def getBatteryLogo():
    # Get the battery percentage
    batpercent = statslib.getBattery(True)
    if batpercent >= 0:
        # Define symbols as an array
        batarray = ['󰁺', '󰁻', '󰁼', '󰁽', '󰁾', '󰂀', '󰂁', '󰂂', '󰁹']
        # Divide by length of batarray so that we can get "how much change in percent before change in symbol".
        # Basically: "percent per symbol".
        deltasymbol = 100 / len(batarray)
        # We will divide the battery percentage by deltasymbol.
        # This is because every multiple "deltasymbol" percent corresponds exactly to one symbol (percent per symbol).
        # So by dividing the percentage by deltasymbol, we will get the whole number, which corresponds to the lower symbol index, plus a remainder (which is essentially the amount right "between symbols").
        # We will use floor (int divide) as we want the lesser symbol.
        ind = round(batpercent // deltasymbol)
        # If the index is >= the length of the array, we will just subtract it by 1
        if ind >= len(batarray):
            ind = ind - 1
        # Select via index
        return batarray[ind] + "  " + str(round(batpercent)) + "%"
    else:
        return "󰁺  None"


# Check if fvwmcommand works
if not fvwmcommand.fvwmcommandworks:
    # Exit, we need fvwmcommand
    exit(1)

# Create an object first
fcom = fvwmcommand.FvwmCommandAPI()

# ToFVWM Function
def toFvwm(id,value):
    header = "SendToModule FvwmButtons ChangeButton "
    middle = " Title '"
    end = "'"
    # Return it
    return header + id + middle + value + end

# Main loop
while True:
    updatevals = []
    updatevals.append(toFvwm('cpu','  ' + statslib.getCPU()))
    updatevals.append(toFvwm('ram','  ' + statslib.getRAM()))
    updatevals.append(toFvwm('disk','  ' + statslib.getDisk()))
    batstr = getBatteryLogo()
    if batstr != None:
        updatevals.append(toFvwm('battery', batstr))
    # Send it to fvwmcommand
    fcom.sendMultiple(updatevals)
    sleep(3)
