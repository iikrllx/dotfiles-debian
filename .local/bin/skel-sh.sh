#!/bin/sh
#
# Prepare the skeleton of the Shell script.
#

uniq_name=$(echo $(cat /dev/urandom | tr -dc 'a-z0-9' | head -c 8).sh)

if [ ! -e "$uniq_name" ]; then
cat << 'EOF' > "$uniq_name"
#!/bin/sh
#
# Comments here...
#

if [ $(id -u) != 0 ]; then
	>&2 echo "Please, execute this script by sudo."
	exit 1
fi

usage()
{
if [ $1 -eq 1 ]; then
	>&2 echo "Try '$(basename $0) --help' for more information"
	exit 1
else
	echo "Usage: $(basename $0) [option]"
	echo "Description here..."
	echo ""
	echo "  [option]"
	echo "  -a            description of option"
	echo "  -b            description of option"
	echo "  -h            show this help and exit"
	echo ""
	exit 0
fi
}

case "$1" in
'-b')
	echo "code here..."
	;;

'-a')
	echo "code here..."
	;;

'-h'|'--help')
	usage 0
	;;

*)
	usage 1
	;;
esac
EOF
fi

chmod +x "$uniq_name"
ls "$uniq_name"
