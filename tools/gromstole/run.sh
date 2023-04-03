#!/bin/bash

#to run the script
#for i in `ls ../data/samples/*R1*`; do echo $i; input=`basename $i | cut -d'_' -f1`; echo $input; ./run.sh ../data/samples/${input}_R1.fastq.gz ../data/samples/${input}_R2.fastq.gz; done;

eval "$(conda shell.bash hook)"
conda activate gromstole


gunzip -c $1 > gromstole/sample.read1.fastq
gunzip -c $2 > gromstole/sample.read2.fastq

echo $1
echo $2

cd gromstole
#git submodule foreach git pull origin main

mkdir -p sample
mkdir -p output
python scripts/minimap2.py sample.read1.fastq sample.read2.fastq -o sample

for file in `ls constellations/constellations/definitions`; 
do 
echo $file; 
echo constellations/constellations/definitions/$file;
Rscript scripts/estimate-freqs.R sample constellations/constellations/definitions/$file output/$file
done;

#Rscript scripts/estimate-freqs.R sample constellations/constellations/definitions/cB.1.617.2.json sample/sample.delta.json 

output=`basename $1 | cut -d'_' -f1`
echo $output

mv output ../$output
rm -rf sample*

conda deactivate
