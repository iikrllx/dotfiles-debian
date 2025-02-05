#!/bin/sh
#
# A script that automates the process of writing a message, signing it with GPG.
#

usage()
{
if [ $1 -eq 1 ]; then
        >&2 echo "Try '$(basename $0) --help' for more information."
        exit 1
else
cat << EOF
Usage: $(basename $0) [option]
Automates message writing and GPG signing.

  [option]
  -c, --clearsign     clear-sign and copy
  -d, --detachsign    detach-sign and copy
  -h                  show this help and exit

EOF

exit 0
fi
}

message_template()
{
text=$(mktemp)
cat << EOF > $text


---
Regards, Kirill Rekhov

GPG Fingerprint:
2640 769D FDA1 AAA0 F863  D1AE 5F2C 5905 519C E0A0
EOF
vim $text
}

case "$1" in

'-c'|'--clearsign')
	message_template
	gpg --clearsign $text
	shred -uzn 8 $text
	cat $text.asc | xsel -b -i
	shred -uzn 8 $text.asc
	echo "> paste signed text from clipboard"
	;;

'-d'|'--detachsign')
	message_template
	gpg --detach-sign --armor -o ~/signature.asc $text
	cat $text | xsel -b -i
	shred -uzn 8 $text
	echo "> paste signed text from clipboard"
	echo "> attach signature.asc"
	;;

'-h'|'--help')
	usage 0
	;;

*)
	usage 1
	;;

esac
