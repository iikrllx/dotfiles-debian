#!/bin/sh
#
# Generate a random alphanumeric string of a specified length
# and echo it to the stdout.
#

if [ ! -z "$1" ]; then
	cat /dev/urandom | tr -dc 'a-zA-Z0-9!@#' | head -c "$1" && echo
else
	>&2 echo "usage: $ $(basename $0) <number-of-symbols>"
	exit 1
fi
