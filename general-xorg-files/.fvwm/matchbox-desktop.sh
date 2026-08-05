#!/bin/sh

if ! pkill matchbox; then
    matchbox-keyboard & disown
fi
