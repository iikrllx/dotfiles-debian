#!/bin/sh
#
# Delete all time jobs.
#

atq | awk '{print $1}' | xargs atrm
