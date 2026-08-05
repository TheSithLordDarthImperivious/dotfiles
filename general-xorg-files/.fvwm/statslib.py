# General stats library
import psutil

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

# Seconds to hours/minutes
# Almost exact from psutil docs
def sectotime(secs):
    # divmod gets both value and remainder
    # Get amount of minutes, the remainder is seconds
    mm, ss = divmod(secs, 60)
    # Get amount of hours, the remainder is minutes
    hh, mm = divmod(mm, 60)
    # Use time format, but round too
    return str(round(hh)) + ":" + str(round(mm)) + ":" + str(round(ss))

# CPU
def getCPU(simple=True):
    if simple:
        return str(psutil.cpu_percent()) + "%"
    else:
        cpulist = psutil.cpu_percent(percpu=True)
        cpustr = "Per-CPU Usage:\n"
        for i in range(len(cpulist)):
            cpustr = cpustr + "    CPU " + str(i) + " : " + str(cpulist[i]) + " %\n"
        cputime = psutil.cpu_times()
        cpustr = cpustr + "User/Kernel Split Time:\n"
        cpustr = cpustr + "    User: " + sectotime(cputime.user) + "\n"
        cpustr = cpustr + "    Kernel: " + sectotime(cputime.system) + "\n"
        cpustr = cpustr + "    Idle: " + sectotime(cputime.idle) + "\n"
        cpufreq = psutil.cpu_freq()
        cpustr = cpustr + "CPU Frequency stats:\n"
        cpustr = cpustr + "    Current: " + str(round(cpufreq.current,2)) + " Hz\n"
        cpustr = cpustr + "    Minimum: " + str(round(cpufreq.min,2)) + " Hz\n"
        cpustr = cpustr + "    Maximum: " + str(round(cpufreq.max,2)) + " Hz\n"
        return ("All CPU Stats:", cpustr)
# RAM
def getRAM(simple=True):
    ramobj = psutil.virtual_memory()
    if simple:
        return str(ramobj.percent) + "%"
    else:
        return ("All RAM Stats:", objToPrint(ramobj))
# Disk
def getDisk(mpoint="/", simple=True):
    diskobj = psutil.disk_usage(mpoint)
    if simple:
        return str(diskobj.percent) + "%"
    else:
        return ("All stats for mountpoint " + mpoint + ":", objToPrint(diskobj))

# Battery
def getBattery(simple=True):
    batobj = psutil.sensors_battery()
    # If batobj is None then there is no battery
    if batobj == None:
        return -1
    if simple:
        return batobj.percent
    else:
        batstr = "Amount: " + str(round(batobj.percent)) + "%\n"
        if batobj.power_plugged:
            batstr = batstr + "Status: Charging\n"
        else:
            batstr = batstr + "Status: Discharging\n" + "Time Left: " + sectotime(batobj.secsleft) + "\n"
        return ("All Battery Stats:", batstr)
