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

function update () {
    getrev
    local before=$REVISION
    [ -d "$SUMIRE/.git" ] || error "not Git repository."
    cd "$SUMIRE"
    git pull >& /dev/null
    [ $? -ne 0 ] && error "failed to update."
    getrev
    [ $before = $REVISION ] && color blue "try update, but no commits found after ${before:0:7}." || color blue "updated ${before:0:7} to ${REVISION:0:7}."
}

function error () {
    cd "$WORK"
    color red "*E: ${1}" 1>&2
    exit 1
}

function color () {
    local red=31
    local green=32
    local yello=33
    local blue=34
    local color=$1
    echo -e "\e[${!color}m${2}\e[m" ${3}
}

function getrev () {
    [ -d "$SUMIRE/.git" ] && tmp=$(sed "s/.*: //g" "$SUMIRE/.git/HEAD") && REVISION=$(cat "$SUMIRE/.git/$tmp" 2>/dev/null)
    [ -z $REVISION ] && REVISION=unknown
}

function usage () {
    getrev
    echo -e "SUMIRE - a helper for android builders"
    echo -e "Rev: $REVISION\n"
    case $1 in
        update)
            color blue "Usage: $RUN update"
            echo -e "update own. has no argument." ;;
        help)
            color blue "Usage: $RUN help \e[3mMODE\e[m"
            echo -e "show help of given MODE, show generic help if no given or MODE not found." ;;
        build)
            color blue "Usage: $RUN build \e[3mOPTIONS\e[m"
            echo -e "OPTIONS: "
            echo -e "\t-d: target device \e[32m(required)\e[m"
            echo -e "\t-s: target directory \e[32m(required)\e[m" ;;
        *)
            color blue "Usage: $RUN \e[3mMODE\e[m ..."
            echo -e "MODE:"
            echo -e "\tbuild: run build."
            echo -e "\thelp: show help."
            echo -e "\tupdate: update own."
            echo -e "more information, please run '$RUN help MODE'." ;;
    esac
}