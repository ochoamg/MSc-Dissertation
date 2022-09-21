#!/bin/bash

fn=$1
units=$2
ofd=$3
sta=2
echo $end

mkdir -p $ofd

tfn="${ofd}multi.vcf.tmp"
ofn="${ofd}multi.vcf"

cp $fn $tfn


for i in $(eval echo "{$sta..$units}") 
do
i=$(($i-1)) 
    awk '/^[^#]/' $fn | \
        awk -v IX="${i}" '{OFS = "\t"; $2=$2 + (IX*44838); print }' >> $tfn
done

sed "s/KY962518.1_looped_2120/KY962518.1_looped_2120_${units}_units/g" $tfn > $ofn
rm $tfn
