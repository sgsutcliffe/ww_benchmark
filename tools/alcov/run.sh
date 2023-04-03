#!/bin/bash -e

#to run the script
#for i in `ls ../data/samples/*R1*`; do echo $i; input=`basename $i | cut -d'_' -f1`; echo $input; ./run.sh ../data/samples/${input}_R1.fastq.gz ../data/samples/${input}_R2.fastq.gz; done;

eval "$(conda shell.bash hook)"
conda activate alcov

R1=$1
R2=$2

echo $R1
echo $R2

trim_galore -o . --paired $R1 $R2 --basename sample > sample.trim.output 2>&1
minimap2 -t 8 -ax sr ../data/ref/wuhan1.fasta sample_val_1.fq.gz sample_val_2.fq.gz > sample.sam
samtools view -@ 8 -Sb sample.sam > sample.bam
samtools sort -@ 8 sample.bam -o sample.sorted.bam
samtools index sample.sorted.bam

alcov find_lineages sample.sorted.bam > mutation.out

output=`basename $R1 | cut -d'_' -f1`

echo $output

mkdir $output
mv mutation.out $output/$output.mutations.txt
mv lineage.out $output/$output.lineages.txt

rm sample*

conda deactivate

