#!/bin/bash -e

mkdir -p reqfiles
wget -O reqfiles/SARS-CoV-2.insert.V4.txt https://raw.githubusercontent.com/cbg-ethz/cojac/master/SARS-CoV-2.insert.V4.txt


mkdir -p reqfiles/voc
cd reqfiles/voc
wget -O - https://github.com/cbg-ethz/cojac/archive/master.tar.gz | tar -xz --strip=2 "cojac-master/voc/"
