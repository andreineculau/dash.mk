#!/usr/bin/env bash
set -e

[ -d .dash.mk ] || (
    git submodule add git://github.com/andreineculau/dash.mk .dash.mk
)

SYMLINK=(
    .npmignore
    feed.coffee
    Info.plist.coffee
    Makefile
    parseWrapper.coffee
)

for FILE in ${SYMLINK[*]}; do
    [ -e $FILE ] || [ -L $FILE ] || (
        DIR=`dirname $FILE`
        mkdir -p $DIR
        cd $DIR
        REL=`python -c "import os.path; print os.path.relpath('.dash.mk/$FILE', '$DIR')" `
        ln -s "$REL" "`basename $FILE`"
    )
done

COPY=(
    .gitignore
    AUTHORS
    custom.mk
    LICENSE
    NOTICE
    NOTICE2
    README.md
    parse.coffee
    package.json
)

for FILE in ${COPY[*]}; do
    [ -e $FILE ] || (
        mkdir -p `dirname $FILE`
        DIR=`dirname $FILE`
        cp -R .dash.mk/$FILE $DIR
    )
done

DOCSET_NAME=${DOCSET_NAME:-example}
cp -R placeholder.docset "$DOCSET_NAME.docset"
