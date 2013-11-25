#!/usr/bin/env bash
set -e

[ -d .dash.mk ] && (
    cd .dash.mk
    git fetch
    git checkout master
    git fetch
    git reset --hard origin/master
    cd -
    .dash.mk/install.sh
)
