#!/bin/sh
#
# Automates the process of writing a message, signing it with GPG,
# and copying the signed message to the clipboard.
#

set -e

echo >> text
echo >> text
echo "---" >> text
echo "Kirill Rekhov" >> text
echo >> text
vim text
gpg --clearsign text
shred -uzn 8 text
cat text.asc | xsel -b -i
shred -uzn 8 text.asc
