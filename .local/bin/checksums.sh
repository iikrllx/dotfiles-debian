#!/bin/sh
#
# Wrapper script for 'md5sum' utility.
# Actual to use together with crontab.
# For example:
# ./script.sh -b (12:00)
# ./script.sh -a (00:00)
# Dotfiles with failed sums: /home/$SUDO_USER/.$(date +"%d-%m-%Y-%H:%M:%S")
#

if [ $(id -u) != 0 ]; then
        >&2 echo "Please, execute this script by sudo."
	exit 1
fi

# this variable may be empty in crontab environment
if [ -z "$SUDO_USER" ]; then
	>&2 echo "'\$SUDO_USER' variable empty."
	exit 1
fi

usage()
{
if [ $1 -eq 1 ]; then
        >&2 echo "Try '$(basename $0) --help' for more information."
        exit 1
else
cat << EOF
Usage: $(basename $0) [option]
Wrapper script for 'md5sum' utility.

  [option]
  -b            compute MD5 sums
  -a            check MD5 sums
  -h            show this help and exit

EOF

exit 0
fi
}

tmpf="/tmp/sums"
failed="/home/$SUDO_USER/.$(date +'%d-%m-%Y-%H:%M:%S')"

case "$1" in
# before
'-b')
	rm "$tmpf" >/dev/null 2>&1
	for p in /etc /usr/bin /usr/sbin /usr/lib /boot; do
		find "$p" -type f | while read -r f; do
			md5sum "$f" >> "$tmpf"
		done
	done
	;;
# after
'-a')
	if [ -s "$tmpf" ]; then
		md5sum -c --quiet "$tmpf" > "$failed" 2>/dev/null
		[ ! -s "$failed" ] && rm "$failed" || chown "$SUDO_USER:" "$failed"
		rm "$tmpf"
	else
		usage 1
	fi
	;;

'-h'|'--help')
	usage 0
	;;

*)
	usage 1
	;;
esac
