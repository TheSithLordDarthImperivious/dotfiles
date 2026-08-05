#!/bin/sh

# DPI-aware config fragment generator for fvwm
# This will not include the panel stuff

# Source the dimensions base and xscreenstuff, and fonts
. $HOME/.fvwm/dimensbase.sh
. $HOME/.fvwm/xscreenstuff.sh
. $HOME/.fvwm/font.sh

# Check if mode is empty
if [ -z $mode ]; then
    # Assume desktop
    mode='desktop'
fi

# Use the dpiScaler function on all non-panel items
# Font (uses fontScaler)
norfontsize=`fontScaler $bnorfontsize`
tbarfontsize=`fontScaler $btbarfontsize`
bigfontsize=`fontScaler $bbigfontsize`
menfontsize=`fontScaler $bmenfontsize`
bigtitlefontsize=`fontScaler $bbigtitlefontsize`

# Titlebar
titleheight=`dpiScaler $btitleheight`
borderwidth=`dpiScaler $bborderwidth`

# Menu Stuff
normalspacing=`dpiScaler $bnormalspacing`
normaltitlespacing=`dpiScaler $bnormaltitlespacing`
normalmarginspacing=`dpiScaler $bnormalmarginspacing`
bigspacing=`dpiScaler $bbigspacing`
bigmargin=`dpiScaler $bbigmargin`
titlespacing1=`dpiScaler $btitlespacing1`
titlespacing2=`dpiScaler $btitlespacing2`

# Firstly, generate fonts
norfont=`fontGen "$fontname" $norfontsize 'True' 'False' 'True'`
tbarfont=`fontGen "$fontname" $tbarfontsize 'True' 'True' 'True'`
bigfont=`fontGen "$fontname" $bigfontsize 'True' 'False' 'True'`
menfont=`fontGen "$fontname" $menfontsize 'True' 'False' 'True'`
mentfont=`fontGen "$fontname" $menfontsize 'True' 'True' 'True'` # Menu Title font
bigtitlefont=`fontGen "$fontname" $bigtitlefontsize 'True' 'True' 'True'`

# We will now define a menu generator function
# First Arg: Menu Name, Second Arg: Item Spacing 1, Third Arg: Item Spacing 2, Fourth Arg: Title Spacing 1, Fifth Arg: Title Spacing 2, Sixth Arg: Margins 1, Seventh Arg: Margins 2, Eighth Arg: Normal Font, Ninth Arg: Title Font, Tenth Arg: Border Width
menuGen(){
    # Use a heredoc
cat<<EOF
MenuStyle $1 VerticalMargins $6 $7, BorderWidth ${10}
MenuStyle $1 Font "$8", VerticalItemSpacing $2 $3
MenuStyle $1 TitleFont "$9", VerticalTitleSpacing $4 $5
EOF
}

# Define default font (titlebar font)
echo "DefaultFont \"$tbarfont\""

# Define Border Width Style
echo "Style * BorderWidth $borderwidth, HandleWidth $borderwidth"

# Define TitleStyle
echo "TitleStyle Centered Height $titleheight -- Flat"

# Now, we will generate the two menus: The normal one and the "big" (WindowList) menu
menuGen \* "$normalspacing" "$normalspacing" "$normaltitlespacing" "$normaltitlespacing" "$normalmarginspacing" "$normalmarginspacing" "$menfont" "$mentfont" "1"
menuGen WindowList "$bigspacing" "$bigspacing" "$titlespacing1" "$titlespacing2" "$bigmargin" "$bigmargin" "$bigfont" "$bigtitlefont" "$borderwidth"
