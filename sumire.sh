#!/bin/bash

### sumire
### https://github.com/droidfivex/sumire
###
### Copyright (C) 2016 droidfivex
### Licensed under the MIT License.
### https://github.com/droidfivex/sumire/blob/master/LICENSE

# set paths
tmp=$(readlink -f $0)
readonly SUMIRE=${tmp%/*}
readonly WORK=$(pwd)
unset tmp

# initialize
source "${SUMIRE}/variables.sh"
source "${SUMIRE}/functions.sh"

# parse mode
readonly MODE=$1
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
    help) help $1 ;;
    *) error "You must select right mode.\n    want help, run 'sumire help'." ;;
esac