#!/bin/bash
#$ -cwd
#$ -j y
#$ -l h_rt=1:0:0
#$ -l h_vmem=4G
#$ -pe smp 16
#$ -o logs/
echo "Starting"

mkdir -p '/data/Blizard-Rakyan/Mateus/cuteSV/temp'
source /data/Blizard-Rakyan/Mateus/scripts/envs/cuteSV/bin/activate

cuteSV '/data/Blizard-Rakyan/Mateus/data/bam/2465_data/all.bam'\
       '/data/Blizard-Rakyan/Rakyan_Lab_Files/Genomes/Human/WG/Hg38/rDNA/WG_rDNA/hg38.rDNA.fa'\
       '/data/Blizard-Rakyan/Mateus/cuteSV/cutesv_read_names.vcf'\
       '/data/Blizard-Rakyan/Mateus/cuteSV/temp'\
       --max_cluster_bias_INS 100\
       --diff_ratio_merging_INS 0.3\
       --max_cluster_bias_DEL 100\
       --diff_ratio_merging_DEL 0.3\
       --report_readid

echo "Finished"
