#!/bin/bash

# set -ex

./metrics.sh odroid 192.168.0.183 |& tee metrics.temp
grep -v "user\|sys\|^$" metrics.temp > metrics.log
rm metrics.temp
sed -ie "s/real/Elapsed time:/g" metrics.log

DATE=$(date +%Y-%m-%d\-%H-%M-%S)
mkdir $DATE-data
mv metrics.log $DATE-data/
mv PM-info-odroid-amp-data.csv $DATE-data/
mv PM-info-odroid-amp-date-data.csv $DATE-data/
mv PM-info-odroid-volt-data.csv $DATE-data/
mv PM-info-odroid-volt-date-data.csv $DATE-data/
mv PM-info-odroid-watt-data.csv $DATE-data/
mv PM-info-odroid-watt-date-data.csv $DATE-data/
zip -r $DATE-data.zip $DATE-data
rm -rf $DATE-data
echo -e "\e[32mFINISHED\e[0m"
