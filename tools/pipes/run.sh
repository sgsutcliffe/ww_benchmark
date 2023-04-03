#!/bin/bash -e

eval "$(conda shell.bash hook)"
conda activate pipes

#./getReqFiles.sh

gunzip -c $1 > read1.fastq
gunzip -c $2 > read2.fastq

trim_galore -o . --paired $1 $2 --basename sample > trim.output 2>&1

cp SARS_CoV_2_wastewater_surveillance/eliminate_strains/eliminate_strains/MN908947.3.fasta .

SARS_CoV_2_wastewater_surveillance/eliminate_strains/eliminate_strains -i reqfiles/ifile -s sample.sam -f 0.01 -o mismatch.txt -v reqfiles/vfile -p -1 sample_val_1.fq -2 sample_val_2.fq -n -e 0.005 -g reqfiles/gfile -x 35000

Rscript SARS_CoV_2_wastewater_surveillance/EM_C_LLR.R -i mismatch.txt

conda deactivate
