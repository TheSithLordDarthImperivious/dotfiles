# Library to check whether fvwmcommand will work properly and if there is fvwm3
# We will check: /tmp and /var/tmp as well as $TMPDIR.
# /var/tmp and /tmp are for FVWM2, /tmp and $TMPDIR are for FVWM3.

# MUST BE IMPORTED! This does not do anything useful if run separately.

# Shell implementation also available, but this library is still needed for the psutil system stats.

import subprocess
import os

# This is a variable that will always be exposed (false by default)
fvwmcommandworks = False

fvwm2exists = subprocess.run(["which","fvwm2"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode == 0
fvwm3exists = subprocess.run(["which","fvwm3"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode == 0
fvwmexists = subprocess.run(["which","fvwm"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode == 0

# if both exist
if fvwm2exists and fvwm3exists:
    # Set both to false
    fvwm2exists = False
    fvwm3exists = False
    # Use ps -au, and find the name of fvwm
    psoutput = str(subprocess.run(["ps","-au"],capture_output=True).stdout)
    # if "fvwm" is in there:
    fvwmexists = "fvwm" in psoutput
    # if "fvwm2" is in there:
    fvwm2exists = "fvwm2" in psoutput
    # if "fvwm3" is in there:
    fvwm3exists = "fvwm3" in psoutput


# This is for if there is only a "fvwm" binary
if fvwmexists and not (fvwm2exists or fvwm3exists):
    # Check fvwm version, turn it into string
    fvwmoutput = subprocess.run(["fvwm","--version"],capture_output=True).stdout.decode()
    # if "fvwm 2" is in there, then it's fvwm2. Otherwise, it's fvwm3
    fvwm2exists = "fvwm 2" in fvwmoutput
    if not fvwm2exists:
        fvwm3exists = True

# Function to check if a directory is writable (we are not using subprocess on ls -la)
def is_writable(path):
       return os.access(path,os.W_OK)

# Always check /tmp
tmpwritable = is_writable("/tmp")

# Check /var/tmp if fvwm2exists
if fvwm2exists:
    vartmpwritable = is_writable("/var/tmp")

# Check TMPDIR if fvwm3exists
# NOTE: TMPDIR MAY NOT BE SET
if fvwm3exists:
    try:
        tmpdir = os.environ["TMPDIR"]
        tmpdirwritable = is_writable(tmpdir)
    except KeyError:
        tmpdirwritable = False


# Now, it's time
if fvwm2exists:
    fvwmcommandworks = tmpwritable or vartmpwritable
else:
    fvwmcommandworks = tmpwritable or tmpdirwritable

# FvwmCommand API
class FvwmCommandAPI():
    def __init__(self):
        # Start up FvwmCommand and have it listen on stdin
        self.proc = subprocess.Popen(["FvwmCommand","-c"],stdin=subprocess.PIPE,stderr=subprocess.PIPE, text=True,bufsize=1)
    def send(self,value):
        # First, check if process is gone, and if so, restart it
        # Anything other than none means process has exited
        if self.proc.poll() != None:
            # TEMP
            # Restart the process
            self.__init__()
        # Write it to stdin and flush (send) it
        self.proc.stdin.write(value + "\n")
        self.proc.stdin.flush()
    def sendMultiple(self,values):
        fullstr = ""
        # Use for loop to concatenate, then send using normal method
        for value in values:
            fullstr = fullstr + value + "\n"
        self.send(fullstr)
    def exit(self):
        self.proc.stdin.close()
        self.proc.wait()

