#!/bin/sh
#
# Renames ALL files to random names in current directory.
# Need to specify the file format ("txt", "jpg", etc.).
#

generate_random_string()
{
	cat /dev/urandom | tr -dc 'a-z0-9' | head -c 12
}

if [ ! -z "$1" ]; then
	for file in *.$1; do
		s=$(generate_random_string)

		while [ -e "${s}.$1" ]; do
			s=$(generate_random_string)
		done

		mv "$file" "${s}.$1"
	done
else
	>&2 echo "usage: $ $(basename $0) '<file-format>'"
fi
