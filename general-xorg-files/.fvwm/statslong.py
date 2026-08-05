# Long stats via psutil

# Argument parsing
import argparse

from time import sleep

# Custom library
import statslib

# Notify-send
from notifysender import notifySenderTuple

# Simple print function
def printer(tuple):
    print(tuple[0])
    print(tuple[1])

# Argument parsing
argparser = argparse.ArgumentParser()

# Define arguments
argparser.add_argument('--cpu', action='store_true', help='Print CPU Info')
argparser.add_argument('--ram', action='store_true', help='Print RAM Info')
argparser.add_argument('--disk', action='store_true', help='Print Disk Info (needs mountpoint, default /)')
argparser.add_argument('--battery', action='store_true', help='Print Battery Info')
argparser.add_argument('--mountpoint', default='/', help='Print Disk Info (needs mountpoint, default /)')
argparser.add_argument('--notifysend', action='store_true', help='Use notify-send to send the stuff')
# Get arguments (dict)
args = argparser.parse_args().__dict__

# This is cursed. Set a variable to a function
if args['notifysend']:
    printchoice = notifySenderTuple
else:
    printchoice = printer

# Display based on args
if args['cpu']:
    printchoice(statslib.getCPU(simple=False))
elif args['ram']:
    printchoice(statslib.getRAM(simple=False))
elif args['disk']:
    printchoice(statslib.getDisk(mpoint=args['mountpoint'],simple=False))
elif args['battery']:
    printchoice(statslib.getBattery(simple=False))
else:
    print("You need to specify a stat!")
    argparser.print_help()
    exit(1)
