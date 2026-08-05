# Panel generator for fvwm
# Needed because: DPI scaling, dynamic panel based on actual monitor dimensions (we want a PORTABLE setup)
# Use PipeRead in fvwm to actually use the generated config snippet
# NOTE: DOES NOT SUPPORT ARBITRARY LEFT/RIGHT/BOTTOM PANELS!
# This does not actually use X11 libraries, it's just a text processor

# TODO: Font Library, Tablet/Desktop Mode, Sidebar Generation (vertical panel widget!)

# ABANDONED IN FAVOUR OF SHELL VERSION! See the .sh file for complete implementation!

# Custom Libraries
import fvwmcommand
import xscreenstuff
import dimensbase
import fvwmcolorset

# class for Label
class Label:
    def __init__(self, id: str, pixsize: int, title: str, normalcolset: int, activecolset: int, presscolset: int, fore="", back="", panname=""):
        self.id = id
        self.panname = panname
        self.pixsize = pixsize
        self.title = title
        self.normalcolset = normalcolset
        self.activecolset = activecolset
        self.presscolset = presscolset
        self.forecol = fore
        self.backcol = back
    def setPanName(self,name):
        self.panname = name
    def toFvwm(self):
        fullstr = "*" + self.panname + ": (" + str(self.pixsize) + "x1, Id '" + self.id + "', Title '" + self.title + "', Colorset " + str(self.normalcolset) + ", ActiveColorset " + str(self.activecolset) + ", PressColorset " + str(self.presscolset)
        if self.forecol != "":
            fullstr = fullstr + ", Fore " + self.forecol
        if self.backcol != "":
            fullstr = fullstr + ", Back " + self.backcol
        fullstr = fullstr + ")"
        return fullstr

# class for buttons with actions
class ActionButton(Label):
    def __init__(self, id: str, pixsize: int, title: str, normalcolset: int, activecolset: int, presscolset: int, leftcommand: str, rightcommand="Nop", fore="", back="", panname=""):
        super().__init__(id, pixsize, title, normalcolset, activecolset, presscolset, fore, back, panname)
        self.leftcommand = leftcommand
        self.rightcommand = rightcommand
    def toFvwm(self):
        # Call parent's
        fullstr = super().toFvwm()
        # Remove the ")" (it's always the last character)
        fullstr = fullstr[:-1]
        if self.leftcommand != "Nop":
            fullstr = fullstr + ", Action(Mouse 1) " + self.leftcommand
        if self.rightcommand != "Nop":
            fullstr = fullstr + ", Action(Mouse 3) " + self.rightcommand
        fullstr = fullstr + ")"
        return fullstr

# class for swallowed
class SwallowedWin:
    def __init__(self, id: str, pixsize: int, wintoswallow: str, commandtoswallow: str, leftcommand="Nop", rightcommand="Nop", panname=""):
        self.id = id
        self.panname = panname
        self.pixsize = pixsize
        self.wintoswallow = wintoswallow
        self.commandtoswallow = commandtoswallow
        self.leftcommand = leftcommand
        self.rightcommand = rightcommand
    def setPanName(self,name):
       	self.panname = name
    def toFvwm(self):
        fullstr =  "*" + self.panname + ": (" + str(self.pixsize) + "x1, Id '" + self.id + "', Swallow " + self.wintoswallow + " " + self.commandtoswallow
       	if self.leftcommand != "Nop":
            fullstr = fullstr + ", Action(Mouse 1) " + self.leftcommand
       	if self.rightcommand != "Nop":
            fullstr = fullstr + ", Action(Mouse 3) " + self.rightcommand
        fullstr = fullstr + ")"
        return fullstr

# Class for spacer
class Spacer:
    def __init__(self, pixsize: int, panname=""):
        self.panname = panname
        self.pixsize = pixsize
    def setPanName(self,name):
        self.panname = name
    def toFvwm(self):
        return "*" + self.panname + ": (" + str(self.pixsize) + "x1)"

# class for panel
# This cannot create arbitrary panels
class Panel:
    def __init__(self, name: str, screenwidth: int, barheight: int, colset: int, frame: int, font: str, panelitems: list, top=True, style="Unmanaged"):
        self.name = name
        # Generate the geometry
        if top:
            y = "+0" # top
        else:
            y = "-0" # bottom
        # x position is always from +0 (left)
        x = "+0"
        self.geom = str(screenwidth) + "x" + str(barheight) + x + y
        self.colset = colset
        self.frame = frame
        self.font = font # TODO: Complex processing of font (dpi-awareness). Will be via object, so this code does not need to change.
        self.screenwidth = screenwidth
        self.panelitems = panelitems
        self.style = style
        self.barheight = barheight
        self.top = top
    # Generate spacer (Can support multiple of SAME WIDTH)
    def generateSpacers(self):
        # Number of spacers
        num = 0
        # Get all widths of the components and add them
        comwidth = 0
        for item in self.panelitems:
            if item != "spacer":
                comwidth = comwidth + item.pixsize
            else:
                # Add number of spacers
                num = num + 1
        # Subtract comwidth from the screen resolution, and divide it by the number of spacers, rounded
        spacerwidth = round((self.screenwidth - comwidth) / num)
        # Create spacers
        spacerlist = []
        # Make num number of spacers
        for i in range(num):
            spacerlist.append(Spacer(spacerwidth))
        # Replace "spacer" with the real thing
        panelind = 0
        spacerind = 0
        while "spacer" in self.panelitems:
            # Check if the item is spacer
            if self.panelitems[panelind] == "spacer":
                # Replace it if it is
                self.panelitems[panelind] = spacerlist[spacerind]
                # Iterate spacer index
                spacerind = spacerind + 1
            # Iterate panel index (always)
            panelind = panelind + 1
    def toFvwm(self):
        # Check if spacer is in panelitems
        if "spacer" in self.panelitems:
            # Generate spacers
            self.generateSpacers()
        # Create a string list
        stringlist = [
            "Style " + self.name + " " + self.style,
            "DestroyModuleConfig " + self.name + ": *",
            "*" + self.name + ": Geometry " + self.geom,
            "*" + self.name + ": Colorset " + str(self.colset),
            "*" + self.name + ": Frame " + str(self.frame),
            "*" + self.name + ": Font " + str(self.font),
            "*" + self.name + ": Rows 1",
            "*" + self.name + ": Columns " + str(self.screenwidth)
         ]
        # Also add items from each item in the panel
        for item in self.panelitems:
            # Don't forget to make the panel name match
            item.setPanName(self.name)
            stringlist.append(item.toFvwm())
        # Loop over and print
        for item in stringlist:
            print(item)
        # Also print this to use FvwmButtons
        print("Module FvwmButtons " + self.name)
        # Check if Top is true
        if self.top:
            # print the ewmhbasestructs for top
            print("EwmhBaseStruts 0 0 " + str(self.barheight) + " 0")
        else:
            # print the wemhbasestructs for bottom
            print("EwmhBaseStruts 0 0 0 " + str(self.barheight))

# Get DPI from custom library
dpi = xscreenstuff.getDPI()

# Scale it by dpi/96, if dpi is not 96
if dpi != 96:
    dimensions.dimenScaler(dpi / 96)

# The panel itself

# Launcher button
launcher = ActionButton(
    "launcher",
    dimensbase.dimensions['panel_button'],
    "",
    18,
    6,
    17,
    "Exec exec rofi -normal-window -dpi 0 -show drun",
    )

# Window switcher button
windowswitcher = ActionButton(
    "wswitcher",
    dimensbase.dimensions['panel_button'],
    "",
    0,
    6,
    17,
    "Exec exec rofi -normal-window -dpi 0 -show window",
    )

# File Manager (rofi)
fileman = ActionButton(
    "fileman",
    dimensbase.dimensions['panel_button'],
    "",
    0,
    6,
    17,
    "Exec exec rofi -normal-window -dpi 0 -show filebrowser",
    )

# FvwmPager Swallow
fvwmpager = SwallowedWin(
    "fvwmbarpager",
    300,
    "FvwmPager",
    "'Module FvwmPager FvwmBarPager 0 10'"
    )

# Keyboard
keyboard = ActionButton(
    "keyboard",
    dimensbase.dimensions['panel_button'],
    "",
    0,
    6,
    17,
    "Exec sh $[FVWM_USERDIR]/matchbox-desktop.sh"
    )


# Mode Switcher
modeswitch = ActionButton(
    "modeswitch",
    dimensbase.dimensions['panel_button'],
    "",
    0,
    6,
    17,
    "Menu ModeSwitcher Delete"
    )


# Check if fvwmcommandworks
if fvwmcommand.fvwmcommandworks:
    # Add all of the stats stuff

    # CPU
    cpu = ActionButton(
        "cpu",
        dimensbase.dimensions['panel_cpuramdisk'],
        "  0.0%",
        19,
        19,
        19,
        "Exec exec python3 $[FVWM_USERDIR]/statslong.py --cpu --notifysend"
        )

    # RAM
    ram = ActionButton(
        "ram",
        dimensbase.dimensions['panel_cpuramdisk'],
        "  0.0%",
        20,
        20,
        20,
        "Exec exec python3 $[FVWM_USERDIR]/statslong.py --ram --notifysend"
        )
    # Disk
    disk = ActionButton(
        "disk",
        dimensbase.dimensions['panel_cpuramdisk'],
        "  0.0%",
        21,
        21,
        21,
        "Exec exec python3 $[FVWM_USERDIR]/statslong.py --disk --notifysend"
        )
    # Battery
    battery = ActionButton(
        "battery",
        dimensbase.dimensions['panel_cpuramdisk'],
        "󰁺  None",
        0,
        0,
        0,
        "Exec exec python3 $[FVWM_USERDIR]/statslong.py --battery --notifysend"
        )


# xclock swallow
xclock = SwallowedWin(
    "xclock",
    dimensbase.dimensions['panel_clock'],
    "xclock",
    "'Exec exec xclock -d -fg \"#75B5AA\" -update 1 -strftime \" %H:%M:%S\"'",
    )
# Power Options
poweropts = ActionButton(
    "poweropts",
    dimensbase.dimensions['panel_button'],
    "",
    27,
    28,
    29,
    "Exec exec rofi -normal-window -dpi 0 -show power-menu -modi power-menu:'~/.config/rofi/rofi-power-menu' -no-show-icons"
    )

# Front part of panel
panelcom = [launcher, windowswitcher, fileman, "spacer", keyboard, modeswitch]

# Check if fvwmcommand works (this is needed for stats to work, which will be an optional addon)
if fvwmcommand.fvwmcommandworks:
    panelcom.append(cpu)
    panelcom.append(ram)
    panelcom.append(disk)
    panelcom.append(battery)

# Add the last
panelcom = panelcom + [xclock, poweropts]

# Create the panel
# Screen resolution and dpi both come from the xscreenstuff library
fvwmbar = Panel(
    "FvwmBar",
    int(xscreenstuff.getScrRes()[0]),
    dimensbase.dimensions['panel'],
    0,
    0,
    "xft:Ubuntu Nerd Font:size=12:antialias=True", # Replace with a "font object", controlled by DPI
    panelcom,
    style="!Borders, !Title, WindowListSkip, StaysOnTop, Sticky, FixedPosition, FixedSize, !Maximizable, !Iconifiable, !Closable" # No borders, No titlebar, Skip from windowlist, Always On Top, Sticks across all desktops, Cannot be moved, Cannot be resized, Cannot be maximized or minimized, Cannot be closed.
    )

# Emit fvwm syntax
fvwmbar.toFvwm()
