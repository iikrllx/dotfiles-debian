#!/usr/bin/env bash
#
# Stupid script for fetching source codes.
#

# my favorite debian packages here
packages=(bash tmux vim mousepad xfce4 xfce4-terminal \
strace xterm tig tree aptitude cowsay oneko ncurses mc)

for pkg in ${packages[*]}; do
	[ ! -d ~/sources/sid-$pkg ] && mkdir ~/sources/sid-$pkg || continue
	cd ~/sources/sid-$pkg
	apt-get source $pkg
done

cd ~
