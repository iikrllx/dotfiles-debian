#!/bin/sh
#
# Create a compressed tar archive (.tar.gz) of a specified directory.
#

if [ ! -z "$1" ]; then
	dir="$1"
	archive_name="${dir%/}.tar.gz"
	tar -cvzf "$archive_name" "$dir"
else
	>&2 echo "usage: $ $(basename $0) <directory>"
	exit 1
fi
