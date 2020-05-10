#!/bin/sh

set -e

printf "Deploying updates to Github."

HUGO_ENV=production hugo -t ananke
cd public
git add .

msg="$(date) REBUILD."
if [ -n "$*" ]; then
    msg="$*"
fi
git commit -m "$msg"

git push origin master
