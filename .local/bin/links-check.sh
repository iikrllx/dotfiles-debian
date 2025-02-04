#!/usr/bin/env bash
#
# Checks the availability of URLs extracted from a specified file, reporting the
# status of each link. Checks response http|https links from file.
#

if [ -s "$1" ] ; then
	list=$(grep -o 'https\?://[^ ]*' "$1" | sed 's/[)*.,:;(]*$//')
	if [ ! -z "$list" ]; then
		for l in ${list[*]}; do
			#wget -O/dev/null -q "$l"
			curl -IsSf "$l" >/dev/null
			echo "$l - $?"
		done
	else
		>&2 echo "The file '$1' has no links."
		exit 1
	fi
else
	>&2 echo "usage: $ $(basename $0) '<file>'"
	exit 1
fi
