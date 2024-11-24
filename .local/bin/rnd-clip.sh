#!/bin/sh
#
# Generates a random alphanumeric string of a specified length
# and copies it to the clipboard.
#

if [ ! -z "$1" ]; then
	cat /dev/urandom | tr -dc 'a-zA-Z0-9!@#' | head -c "$1" | xsel -b -i
else
	>&2 echo "usage: $ $(basename $0) <number-of-symbols>"
	exit 1
fi
