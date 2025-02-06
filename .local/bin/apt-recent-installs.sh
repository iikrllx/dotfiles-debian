#!/bin/sh
#
# Parse the /var/log/apt/history.log file to extract and display
# installation dates and package lists for each install command executed.
#

if [ ! -f /var/log/apt/history.log ]; then
	echo "File /var/log/apt/history.log not found"
	exit 1
fi

awk '
	/Start-Date:/ {
		date = $0
	}

	/Commandline:.*install/ {
		sub(/Commandline:.*install /, "Commandline: ")
		print date
		print $0
		print "--"
	}
' /var/log/apt/history.log
