#!/usr/bin/env bash
#
# Remove 'rc' (removed but not purged) packages
# plus debs autoremove and autoclean.
#

rc_packs=$(dpkg -l | grep '^rc' | awk '{print $2}')
for p in ${rc_packs[*]}; do sudo apt-get purge -y $p; done
sudo apt-get autoremove -y
sudo apt-get autoclean
