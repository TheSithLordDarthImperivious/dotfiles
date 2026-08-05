# Dimensions database for python programs used in this fvwm setup
# Also contains a scaler (used for DPI and touchs

dimensions = {
    'panel': 37,
    'panel_button': 44,
    'panel_cpuramdisk': 84,
    'panel_net': 0,
    'panel_clock': 96,
}

# Note: This scaler is LIVE. There is no saving.
def dimenScaler(scale):
    # Loop through keys
    for key in dimensions.keys():
        # Scale the dpi
        dimensions[key] = round(dimensions[key] * scale)

