#!/bin/bash -e

#to run the script
#for i in `ls ../data/samples/*R1*`; do echo $i; input=`basename $i | cut -d'_' -f1`; echo $input; ./run.sh ../data/samples/${input}_R1.fastq.gz ../data/samples/${input}_R2.fastq.gz; done;

eval "$(conda shell.bash hook)"
conda activate freyja

#./getReqFiles.sh

R1=$1
R2=$2

trim_galore -o . --paired $R1 $R2 --basename sample > trim.output 2>&1
minimap2 -t 8 -ax sr ../data/ref/wuhan1.fasta sample_val_1.fq.gz sample_val_2.fq.gz > sample.sam
samtools view -@ 8 -Sb sample.sam > sample.bam
samtools sort -@ 8 -n sample.bam -o sample.sorted.bam
samtools view -@ 8 -u -f 1 -F 12 sample.sorted.bam > sample.mapped.bam
samtools sort -@ 8 sample.mapped.bam -o sample.sorted.mapped.bam

samtools index sample.sorted.mapped.bam

ivar trim \
    -b reqfiles/nCoV-2019.primer.bed \
    -q 15 \
    -m 200 \
    -s 4 \
    -i sample.sorted.mapped.bam \
    -p sample.sorted.mapped.trimmed.bam > sample.ivar.out

samtools sort -@ 8 sample.sorted.mapped.trimmed.bam -o sample.sorted.mapped.trimmed.f.bam

freyja variants sample.sorted.mapped.trimmed.f.bam --variants sample.variant --depths sample.depth --ref /mnt/e/wwbenchmark/freyja/reqfiles/MN908947.3.fasta
freyja demix sample.variant.tsv sample.depth --output freyja_output.tsv

output=`basename $R1 | cut -d'_' -f1`

echo $output

mkdir $output
mv freyja_output.tsv $output/$output.freyjaoutput.txt

rm sample*
#rm -r reqfiles

conda deactivate
