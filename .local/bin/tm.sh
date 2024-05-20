#!/bin/sh
#
# Simple timer with a signal.
#

if [ ! -z "$1" ]; then
    echo "aplay ~/.local/share/prompt.wav" | \
    at now + "$1" minute
else
    >&2 echo "usage: $ $(basename $0) <minutes>"
fi
