#!/bin/sh

git fetch
git reset --hard origin/master
chown -R plus2:plus2 *
