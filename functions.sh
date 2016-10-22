#!/bin/bash

### sumire
### https://github.com/droidfivex/sumire
###
### Copyright (C) 2016 droidfivex
### Licensed under the MIT License.
### https://github.com/droidfivex/sumire/blob/master/LICENSE

function init () {
    cd "$SOURCE" >& /dev/null
    source build/envsetup.sh >& /dev/null
    breakfast $DEVICE >& /dev/null
    local result=$?
    cd "$WORK"
    [ $result -ne 0 ] && return 1
}

function build () {
    cd "$SOURCE"
    brunch $DEVICE | tee "$LOG"
    local result=${PIPESTATUS[0]}
    cd "$WORK"
    return $result
}

function error () {
    color red "*E: ${1}" 1>&2
    exit 1
}

function color () {
    local red=31
    local green=32
    local yello=33
    local blue=34
    local color=$1
    echo -e "\033[${!color}m${2}\033[m" ${3}
}

function help () {
    local REVISION=unknown
    [ -d "$SUMIRE/.git" ] && local REF=$(sed "s/.*: //g" "$SUMIRE/.git/HEAD") && REVISION=$(cat "$SUMIRE/.git/$REF" 2>/dev/null)
    echo "the sumire, revision $REVISION"
    case $1 in
        *)
            color green "Usage: add later" ;;
    esac
}