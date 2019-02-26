#!/bin/bash

echo "./unpack-deb.sh <deb directory> <unpack directory>"
echo "Where"
echo "<deb directory> - is a directory with .deb packages."
echo "<unpack directory> - is a directory where previous .deb packages"
echo "                     will be unpacked. This directory MUST exist."
echo "ex: ./unpack-deb.sh deb-packages/ deb-unpacked/"
echo "===================================================================="
echo

set -ex

DEBFILESDIR=$1
EXTRACTDIR=$2

for f in $(ls -1 $DEBFILESDIR | grep .deb)
do
    dpkg-deb -x $DEBFILESDIR$f $EXTRACTDIR
    dpkg-deb -e $DEBFILESDIR$f $EXTRACTDIR
done

