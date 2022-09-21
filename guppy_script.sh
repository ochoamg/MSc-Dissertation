#!/bin/bash
#$ -cwd
#$ -j y
#$ -l h_rt=240:0:0
#$ -l h_vmem=8G
#$ -pe smp 8
#$ -m bea
#$ -M mateus.ochoa@gmail.com
#$ -l gpu=1
#$ -l gpu_type=volta
#$ -o logs/

echo "Started"

ifd='/data/Blizard-Rakyan/Mateus/data/raw/2465_data/*'
ofd='/data/Blizard-Rakyan/Mateus/data/fastq/2465_data/'

guppy_fd="/data/Blizard-Rakyan/Rakyan_Lab_Files/Seq_Tools/ONT/Guppy/4.2.2/ont-guppy/data"
config="dna_r9.4.1_450bps_modbases_dam-dcm-cpg_hac.cfg"
json="template_r9.4.1_450bps_modbases_dam-dcm-cpg_hac.jsn"

module load cuda/9.0.176
module load singularity

mkdir -p $ofd

singularity exec --nv /data/containers/nanopore/nanopore-guppy-4.2.2.img \
    guppy_basecaller \
    -x auto \
    -i $ifd \
    -s $ofd \
    -r \
    -c ${guppy_fd}/${config} \
    -m ${guppy_fd}/${json} \
    --num_callers 8 \
    --chunks_per_runner 96 \
    --verbose \
    --resume
echo "Finished"
