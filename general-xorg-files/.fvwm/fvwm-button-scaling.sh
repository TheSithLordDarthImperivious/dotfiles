# Allows scaling of fvwm pixmap with preserved padding in 96dpi using AdjustedPixmap
# Recommendation: Run this script using:
#
# $ find path/to/xpm/icons -type f -exec sh fvwm-button-scaling.sh "[size]" {} \;


size=$1
# If it has the.xpm extensuon, remove it
filename=`echo $2 | sed 's/.xpm//g'`

convert \
  -size "${size}x${size}" xc:none \
  ${filename}.xpm \
  -gravity center \
  -composite \
  ${filename}-scalable.xpm
