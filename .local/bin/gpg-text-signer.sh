#!/bin/sh
#
# Automates the process of writing a message, signing it with GPG, and copying
# the signed message to the clipboard.
#

set -e

cat << EOF > text


---
Regargs, Kirill Rekhov

GPG Fingerprint:
2640 769D FDA1 AAA0 F863  D1AE 5F2C 5905 519C E0A0

EOF

vim text
gpg --clearsign text
shred -uzn 8 text
cat text.asc | xsel -b -i
shred -uzn 8 text.asc
echo "paste signed text from clipboard"
