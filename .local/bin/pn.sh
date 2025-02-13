#!/bin/sh
#
# Push to notes:
# https://github.com/iikrllx/notes
# I'm not concerned about commit descriptions in this project.
#

gitstatus=$(git status -s)
git add .
git commit -m "$gitstatus"
git push
