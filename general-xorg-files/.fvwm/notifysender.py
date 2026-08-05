# Notify-sender via notify-send
# DOES NOT interface with dbus

# Has fallback if notify-send does not exist (xterm)

import subprocess

secstosleep = 3

def notifySender(title, message):
    try:
        subprocess.run(["notify-send","-t",str(secstosleep*1000),title,message])
    except FileNotFoundError:
        # Use xterm
        commandstr = "echo -e '\033[1m" + title + "\033[0m\n'; echo -e '" + message + "'; echo 'Exiting in " + str(secstosleep) + " seconds...'; sleep " + str(secstosleep)
        subprocess.run(["xterm","-T","Notification","-e",commandstr])
def notifySenderTuple(tuple):
    notifySender(tuple[0],tuple[1])
