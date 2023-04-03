#!/bin/bash -e

eval "$(conda shell.bash hook)"
conda activate vlq

python wastewater_analysis/pipeline/preprocess_references.py -m reqfiles/gisaidmetadata.tsv -f reqfiles/gisaidseq.fasta.xz -k 1000 --seed 0 --country USA -o reqfiles/reference_set --enddate "2022-12-01" 

conda activate vlqsetup
cp ../data/ref/wuhan1.fasta ./reqfiles
bash -e wastewater_analysis/pipeline/call_variants.sh ./reqfiles/reference_set /mnt/e/wwbenchmark/vlq/reqfiles/wuhan1.fasta

python wastewater_analysis/pipeline/select_samples.py -m reqfiles/gisaidmetadata.tsv -f reqfiles/gisaidseq.fasta.xz -o reqfiles/reference_set --vcf reqfiles/reference_set/*_merged.vcf.gz --freq reqfiles/reference_set/*_merged.frq