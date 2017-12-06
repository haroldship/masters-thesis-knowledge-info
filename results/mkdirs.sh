#!/bin/bash

DECAYS="unif 2.0 1.4 1 0.7"
INCIDENTS="50 100 200 500 1000"

for D in $DECAYS; do
  for I in $INCIDENTS; do
    dstr="unif_${I}_${D}_1h"
    [ -d $dstr ] && continue;
    echo "making directory $dstr"
    cp -a template $dstr
    if [ $D = "unif" ]; then
      sed -e "s/genhill(sigma=1.0)/genunif()/" -e "s/EN.i=50/EN.i=${I}/" -i "bak" $dstr/experiment_setup.R
    else
      sed -e "s/sigma=1.0/sigma=${D}/" -e "s/EN.i=50/EN.i=${I}/" -i "bak" $dstr/experiment_setup.R
    fi
  done
done
