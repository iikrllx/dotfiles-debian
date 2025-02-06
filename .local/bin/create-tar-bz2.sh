#!/bin/sh
#
# Create a compressed tar archive (.tar.bz2) of a specified directory.
#

if [ ! -z "$1" ]; then
	dir="$1"
	archive_name="${dir%/}.tar.bz2"
	tar -cvjf "$archive_name" "$dir"
else
	>&2 echo "usage: $ $(basename $0) <directory>"
	exit 1
fi
