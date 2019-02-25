#!/bin/bash

# set -ex

metrics.sh odroid 10.209.2.95 |& tee metrics.log

DATE=$(date +%Y-%m-%d\-%H-%M-%S)
mkdir $DATE-data
mv metrics.log $DATE-data/
mv PM-info-odroid-* $DATE-data/
zip -r $DATE-data.zip $DATE-data
rm -rf $DATE-data
echo -e "\e[32mFINISHED\e[0m"
