#!/bin/sh

color="$1"
name="${2%.xbm}"

magick "$name.xbm" -fill "$color" -opaque black -transparent white "$name.xpm"
