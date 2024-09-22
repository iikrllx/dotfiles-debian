#!/bin/sh
#
# Stores any given command in the clipboard for easy reuse and quick execution.
#

echo "$1" | xsel -b -i
