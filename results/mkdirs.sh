#!/bin/bash

DECAYS="2.0 1.4 1.0 0.7"
INCIDENTS="50 100 200 500 1000"

for D in $DECAYS; do
  for I in $INCIDENTS; do
    dstr="p${D}_${I}_1_1h"
    [ -d $dstr ] && continue;
    echo "making directory $dstr"
    cp -a template $dstr
    sed -e "s/sigma1=2.0/sigma1=${D}/" -e "s/sigma2=2.0/sigma2=${D}/" -e "s/EN.i=50/EN.i=${I}/" -i "bak" $dstr/experiment_setup.R
  done
done
