#!/bin/bash

### sumire
### https://github.com/droidfivex/sumire
###
### Copyright (C) 2016 droidfivex
### Licensed under the MIT License.
### https://github.com/droidfivex/sumire/blob/master/LICENSE

# set paths
RUN=${0##*/}
tmp=$(readlink -f $0)
SUMIRE=${tmp%/*}
WORK=$(pwd)
unset tmp

# initialize
source "${SUMIRE}/variables.sh"
source "${SUMIRE}/functions.sh"

# parse mode
MODE=$1
shift 1
case $MODE in
    build)
        # parse arguments
        while getopts :d:s: argument; do
        case $argument in
            d) readonly DEVICE=$OPTARG ;;
            s) readonly SOURCE=$OPTARG ;;
            :) continue ;;
            \?) continue ;;
        esac; done
        unset argument
        [ -z $DEVICE ] && error "target device is unspecified."
        [ -z $SOURCE ] && error "source directory is unspecified."
        [ -d $SOURCE ] || error "source directory does not exist."

        # kick-start build
        init || error "device tree is unprepared."
        build ;;
    update) update ;;
    help) usage $1 ;;
    *) error "You must select right mode.\n    You want help, run '$RUN help'." ;;
esac