# waybar-like system stats for lxqt-panel, a platform-agonistic panel that isn't hard-to-configure

import psutil
import argparse
#import base64

# Human-readable Conversion
def hrconv(bytesnum):
    # Convert to GiB first
    newval = bytesnum / 1073741824
    unit = "GiB"
    # Check if less than 1
    if newval < 1:
        # Convert to MiB instead
        newval = bytesnum / 1048576
        unit = "MiB"
    # Also round the newval to 2 decimal places (not sigfigs)
    return [round(newval,2), unit]

# base64 encoder
def b64encoder(string):
    strbytes = string.encode("ascii")
    b64bytes = base64.b64encode(strbytes)
    return b64bytes.decode("ascii")

# Obj-to-print function
def objToPrint(obj):
        # Convert to dictionary
        objdict = obj._asdict()
        # Make printstring
        printstring = ""
        # Iterate over dictionary
        for key in objdict.keys():
            if key != "percent":
                unit = hrconv(objdict[key])
                printstring = printstring + key.capitalize() +  ": " + str(unit[0]) + unit[1] + "\n"
        # Return it
        return printstring

# Notify-sender function
def notifysender(title,text):
    return

# lxqt-panel structured format
# has to be in form: "text:(base64 title) icon:(base64 icon name) tooltip:(base64 tooltip)"
def lxqtStructure(percentage):
    lxqtstring = "text:"
    if type != 0:
        # Add base64 to lxqtstring (percentage)
        lxqtstring = lxqtstring + b64encoder(str(obj.percent) + "%") + " "
        # Add base64 to lxqtstring (tooltip)
        lxqtstring = lxqtstring + "tooltip:" + b64encoder(objToPrint(obj))
        # Return it
        return lxqtstring
    else:
        return "Unimplemented"
# CPU
def getCpu(simple=True,lxqt=False):
    if simple:
        print(psutil.cpu_percent(), "%")
    else:
        cpulist = psutil.cpu_percent(percpu=True)
        print("Per-CPU Usage:")
        for i in range(len(cpulist)):
            print("CPU ", i, ": ", cpulist[i], "%")
        print("User/Kernel Split:")

# RAM
def getRam(simple=True,lxqt=False):
    ramobj = psutil.virtual_memory()
    if simple:
        print(ramobj.percent, "%")
    else:
        print("All RAM Stats:")
        print(objToPrint(ramobj))
# Disk
def getDisk(mpoint="/", simple=True,lxqt=False):
    diskobj = psutil.disk_usage(mpoint)
    if simple:
        print(diskobj.percent, "%")
    else:
        print("All stats for mountpoint", mpoint)
        print(objToPrint(diskobj))

# Argument parsing
argparser = argparse.ArgumentParser()

# Define arguments
argparser.add_argument('--all', action='store_true', help='Print all stats')
argparser.add_argument('--lxqtpanel', action='store_true', help='lxqt-panel structured format')
argparser.add_argument('--cpu', action='store_true', help='Print CPU Info')
argparser.add_argument('--ram', action='store_true', help='Print RAM Info')
argparser.add_argument('--disk', action='store_true', help='Print Disk Info (needs mountpoint, default /)')
argparser.add_argument('--mountpoint', default='/', help='Print Disk Info (needs mountpoint, default /)')

# Get arguments (dict)
args = argparser.parse_args().__dict__

# simple
simple = not args['all']
# lxqt
lxqtpan = args['lxqtpanel']

# Display based on args
if args['cpu']:
    getCpu(simple=simple,lxqt=lxqtpan)
elif args['ram']:
    getRam(simple=simple,lxqt=lxqtpan)
elif args['disk']:
    getDisk(mpoint=args['mountpoint'],simple=simple,lxqt=lxqtpan)
else:
    print("You need to specify a stat!")
    argparser.print_help()
    exit(1)
