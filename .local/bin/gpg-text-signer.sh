#!/bin/sh
#
# Automates the process of writing a message, signing it with GPG, copying the
# signed message to the clipboard, and securely deleting the temporary file.
# The detached signature is saved as 'signature.asc' in the /tmp directory.
#

set -e

text=$(mktemp)
cat << EOF > $text


---
Regards, Kirill Rekhov

GPG Fingerprint:
2640 769D FDA1 AAA0 F863  D1AE 5F2C 5905 519C E0A0
EOF

vim $text
gpg --detach-sign --armor -o ~/signature.asc $text
cat $text | xsel -b -i
shred -uzn 8 $text
echo "> paste signed text from clipboard"
echo "> attach signature.asc"
