#!/bin/sh
#
# Encrypt/decrypt regular file with sensitive information (using a password).
#

usage()
{
if [ $1 -eq 1 ]; then
	>&2 echo "Try '$(basename $0) --help' for more information."
	exit 1
else
cat << EOF
Usage: $(basename $0) [option]
Use AES 256 (Advanced Encryption Standard) cipher
for symmetric file encrypt/decrypt.

  [option]
  -f, --file <name>        specify file (regular or openssl)
  -h, --help               show this help and exit

EOF

exit 0
fi
}

case "$1" in
'-f'|'--file')
	if [ ! -f "$2" ] || [ -z "$2" ]; then
		>&2 echo "\$2 incorrect."
		usage 1
	fi

	if [ "$USER" != "$(stat -c %U $2)" ]; then
		>&2 echo "'$USER' you have no perms."
		exit 1
	fi

	randf=".$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 8)"

	while true; do
		if file "$2" | grep -E "openssl|salted"; then
			# decrypt file
			if ! openssl enc -d -aes256 -pbkdf2 -in "$2" 2>/dev/null; then
				>&2 echo "Something went wrong, try again."
				exit 1
			fi
		else
			# encrypt new file
			if ! openssl enc -e -aes256 -pbkdf2 -in "$2" -out "$randf"; then
				continue
			fi

			shred -uzn 8 "$2" && echo "shred $2"
			chmod 600 "$randf"
			break
		fi

		break
	done
	;;

'-h'|'--help')
	usage 0
	;;

*)
	usage 1
	;;
esac
