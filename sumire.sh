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
source "${SUMIRE}/variable.sh"
source "${SUMIRE}/function.sh"

# parse mode
MODE=$1
shift 1
case $MODE in
    build)
        # parse arguments
        while getopts :d:s: argument; do
        case $argument in
            d) DEVICE=$OPTARG ;;
            s) SOURCE=$OPTARG ;;
            r) SYNC=ON ;;
            j) JOBS=$OPTARG ;;
            :) continue ;;
            \?) continue ;;
        esac; done
        unset argument
        [ -z $DEVICE ] && error "target device is unspecified."
        [ -z $SOURCE ] && error "source directory is unspecified."
        [ -d $SOURCE ] || error "source directory does not exist."

        # kick-start build
        cd "$SOURCE" >& /dev/null
        source build/envsetup.sh >& /dev/null
        breakfast $DEVICE >& /dev/null #|| error "device tree is unprepared."
        MODEL=$(get_build_var PRODUCT_MODEL)
        VARIANT=$(get_build_var TARGET_BUILD_VARIANT)
        LOGDIR=$(readlink -f "$WORK/log")
        mkdir -p "$LOGDIR/logging"
        mkdir -p "$LOGDIR/failed"
        mkdir -p "$LOGDIR/successful"
        LOGNAME="$SOURCE_$DEVICE-$VARIANT_$(date '+%Y%m%d%-H%M%S')"
        LOGFILE="$LOGDIR/logging/$LOGNAME.log"
        LANG=C
        brunch $DEVICE 2>&1 | tee "$LOGFILE"
        echo $LOGFILE
        RESULT=${PIPESTATUS[0]}
        mv $LOGFILE $(echo $LOGFILE | sed s/logging/$(test $RESULT -eq 0 && echo "successful" || echo "failed")/g)
        exit $RESULT ;;
    setup) setup ;;
    update) update ;;
    help) usage $1 ;;
    *) error "You must select right mode.\nYou want help, run '$RUN help'." ;;
esac