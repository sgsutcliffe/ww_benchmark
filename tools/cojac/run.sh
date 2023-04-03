#!/bin/bash -e

#to run the script
#for i in `ls ../data/samples/*R1*`; do echo $i; input=`basename $i | cut -d'_' -f1`; echo $input; ./run.sh ../data/samples/${input}_R1.fastq.gz ../data/samples/${input}_R2.fastq.gz; done;


eval "$(conda shell.bash hook)"
conda activate preprocess

#./getReqFiles.sh

R1=$1
R2=$2

trim_galore -o . --paired $R1 $R2 --basename sample > trim.output 2>&1
minimap2 -t 8 -ax sr ../data/ref/wuhan1.fasta sample_val_1.fq.gz > sample_1.sam
minimap2 -t 8 -ax sr ../data/ref/wuhan1.fasta sample_val_2.fq.gz > sample_2.sam
samtools view -@ 8 -Sb sample_1.sam > sample_1.bam
samtools sort -@ 8 sample_1.bam -o sample_1.sorted.bam
#samtools view -@ 8 -u -f 1 -F 12 sample_1.sorted.bam > sample_1.mapped.bam
#samtools sort -@ 8 sample_1.mapped.bam -o sample_1.sorted.mapped.bam
samtools index sample_1.sorted.bam
samtools view -@ 8 -Sb sample_2.sam > sample_2.bam
samtools sort -@ 8 sample_2.bam -o sample_2.sorted.bam
#samtools view -@ 8 -u -f 1 -F 12 sample_2.sorted.bam > sample_2.mapped.bam
#samtools sort -@ 8 sample_2.mapped.bam -o sample_2.sorted.mapped.bam
samtools index sample_2.sorted.bam


conda activate cojac
cooc-mutbamscan -b reqfiles/SARS-CoV-2.insert.V4.txt -m reqfiles/voc/ -a sample_1.sorted.bam sample_2.sorted.bam -j sample.json
#cooc-mutbamscan -b reqfiles/SARS-CoV-2.insert.V4.txt -m reqfiles/voc/ -A amplicons.v4.yaml
#cooc-curate -a amplicons.v4.yaml voc/omicron_ba2_mutations.yaml voc/omicron_ba1_mutations.yaml voc/delta_mutations.yaml
#cooc-pubmut -m reqfiles/voc/ -a amplicons.v4.yaml -j sample.json -o sample.tsv
cooc-tabmut -j sample.json -o sample.csv -l

output=`basename $R1 | cut -d'_' -f1`

echo $output

mkdir $output
mv sample.json $output/$output.json
mv sample.csv  $output/$output.csv

rm trim.output
rm sample*

conda deactivate
