#!/bin/sh
#
# Launch QEMU with specified options.
#

usage()
{
if [ $1 -eq 1 ]; then
        >&2 echo "Try '$(basename $0) --help' for more information."
        exit 1
else
cat << EOF
Usage: $(basename $0) [option]
Launch QEMU with specified options.

  [option]
  -qc, --qemu-cdrom      launch QEMU using a specified CD-ROM ISO
  -qd, --qemu-tempdisk   create a temporary disk and launch QEMU with it
  -h                     show this help and exit

EOF

exit 0
fi
}

case "$1" in
'-qc'|'--qemu-cdrom')
	qemu-system-x86_64 -boot d -cdrom "$1" -m 2048
	;;

'-qd'|'--qemu-tempdisk')
	f=$(mktemp)
	qemu-img create -f qcow2 "/tmp/$f.img" 12G
	qemu-system-x86_64 -boot d -cdrom "$1" -m 2048 -hda "/tmp/$f.img"
	;;

'-h'|'--help')
	usage 0
	;;

*)
	usage 1
	;;
esac
