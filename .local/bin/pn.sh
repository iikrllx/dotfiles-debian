#!/bin/sh
#
# Push to notes:
# https://github.com/iikrllx/notes
# I'm not concerned about commit descriptions in this project.
#

git add .
git commit -m "$(date -R)"
git push
