#!/bin/bash

set -ex

DEBFILESDIR=$1
EXTRACTDIR=$2


for f in $(ls -1 $DEBFILESDIR | grep .deb)
do
    dpkg-deb -x $DEBFILESDIR$f $EXTRACTDIR
    dpkg-deb -e $DEBFILESDIR$f $EXTRACTDIR
done
