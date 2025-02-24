#!/usr/bin/env bash
#
# https://www.debian.org/devel/wnpp/requested_byage
# Processes Debian's WNPP (Work-Needing and Prospective Packages) RFP (Request
# for Package) bug reports. It extracts links to GitHub projects mentioned in
# these bug reports.
#

a=$(mktemp)
b=$(mktemp)

cleanup() {
	rm -f /tmp/rev "$a" "$b"
}

curl -s "https://www.debian.org/devel/wnpp/requested_byage" > "$a"

grep 'href="https://bugs.debian.org/*' "$a" | \
sed -n 's/.*href="https:\/\/bugs\.debian\.org\/\([0-9]*\)".*/\1/p' > "$b"
tac "$b" > /tmp/rev

trap 'cleanup; exit' SIGINT ERR
trap 'cleanup' EXIT

counter=0
for n in $(cat /tmp/rev); do
	if (( counter == 1000 )); then
		break
	fi

	github=$(curl -s "https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=${n};msg=5" \
	| grep -A 1 -E '\*? URL[^:]*:' | grep -Eo 'href="[^"]+"' | grep 'https://github.com' \
	| awk -F'"' '{print $2}')

	if [ ! -z "$github" ]; then
		echo "https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=${n}"
		echo -e "$github\n"
	fi

	counter=$((counter + 1))
done
