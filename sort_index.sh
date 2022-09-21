#!/bin/bash
t$ -cwd
#$ -j y
#$ -l h_rt=1:0:0
#$ -t 1-11
#$ -pe smp 8
#$ -m a
#$ -M mateus.ochoa@gmail.com
#$ -o logs/
#$ -w w

samples=($(ls /data/Blizard-Rakyan/Mateus/data/bam/mm2/wg_rdna/*.bam))
ix=$(( $SGE_TASK_ID-1 ))
path=${samples[$ix]}
sample=$(basename $path)

echo "${sample}: Started"

ofd="/data/Blizard-Rakyan/Mateus/data/bam/mm2/wg_rdna_sorted/"
cd $ofd

ofn="${sample}.sorted"

echo "${sample}: Sorting"
module load -s samtools
( samtools sort -o ${ofn} -@ $NSLOTS ${path} &&
   mv $ofn ${sample} && 
    echo "${sample}: Sorted" &&
    samtools index ${sample} &&
    echo "${sample}: Indexed" &&
    echo "${sample}: Finished" ) ||
    echo "${sample}: Error"
