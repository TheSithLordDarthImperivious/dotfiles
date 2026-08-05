# Library for Fvwm Colorset
# Format like this: Colorset [NUM]  fg #[COL], bg [COL], hi, sh, Plain, NoShape
# NOTE: Would prefer to set colorsets in fvwm's own config file, but this is for transient colorsets primarily

# This maybe works, but had already been abandoned in favour of shell and inbuilt fvwm colorsets in config.

# Counter for one-off colorsets
tempcolorsetcounter = 100

# Includes reserved colorset range 100+ to use for "one-off colorsets"
class FvwmColorset:
    def __init__(self, num: int, fg: str, bg: str, hi="",sh="",plain=True,noshape=True):
        # Check if we have a non-negative colorset number
        if num >= 0:
            self.num = num
        else:
            # It's transient, use the colorset counter and then increment
            self.num = tempcolorsetcounter
            tempcolorsetcounter = tempcolorsetcounter + 1
        self.fgcol = fg
        self.bgcol = bg
        self.hi = hi
        self.sh = sh
        self.plain = plain
        self.noshape = noshape
    # Convert to fvwm
    def toFvwm(self):
        basestr = "Colorset " + str(self.num) + " " + " fg " + self.fg + ", bg " + self.bg + ", hi"
        # If hi is not empty string
        if self.hi != "":
            # Add the color
            basestr = basestr + " " + self.hi
        # Add the comma and sh
        basestr = basestr + ", sh"
        # If sh is not empty string
        if self.sh != "":
            # Add the color
            basestr = basestr + " " + self.hi
        # Check if plain
        if self.plain:
            # Add the Plain option
            basestr = basestr + ", Plain"
        # Check if noshape
        if self.noshape:
            # Add the NoShape option
            basestr = basestr + ", NoShape"

