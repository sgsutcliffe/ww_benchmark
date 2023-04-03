#!/bin/bash -e

#to run the script
#for i in `ls ../data/samples/*R1*`; do echo $i; input=`basename $i | cut -d'_' -f1`; echo $input; ./run.sh ../data/samples/${input}_R1.fastq.gz ../data/samples/${input}_R2.fastq.gz; done;

eval "$(conda shell.bash hook)"
conda activate lineagespot

R1=$1
R2=$2

#./getReqFiles.sh

trim_galore -o . --paired $R1 $R2 --basename sample > trim.output 2>&1
minimap2 -t 8 -ax sr ./reqfiles/NC_045512.2.fasta sample_val_1.fq.gz sample_val_2.fq.gz > sample.sam
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

samtools sort -@ 8 -n sample.sorted.mapped.trimmed.bam -o sample.sorted.mapped.trimmed.f.bam
bedtools bamtofastq -i sample.sorted.mapped.trimmed.f.bam -fq sample.r1.mapped.fastq -fq2 sample.r2.mapped.fastq

minimap2 -t 8 -ax sr ./reqfiles/NC_045512.2.fasta sample.r1.mapped.fastq sample.r2.mapped.fastq > sample.f.sam

samtools view -@ 8 -Sb sample.f.sam > sample.f.bam 
samtools sort -@ 8 -o sample.f.sorted.bam sample.f.bam 

picard MarkDuplicates I=sample.f.sorted.bam O=sample.f.sorted.uniq.bam M=sample_dup_metrics.txt

freebayes -f ./reqfiles/NC_045512.2.fasta -F 0.01 -C 1 --pooled-continuous sample.f.sorted.uniq.bam > sample.freebayes.vcf

snpEff ann wuhan1 -config reqfiles/snpEff.config sample.freebayes.vcf > sample.freebayes.ann.vcf

Rscript run.r

output=`basename $1 | cut -d'_' -f1`
echo $output

mkdir -p $output

mv output_variants.tsv $output/${output}_variants.tsv
mv output_lineagehits.tsv $output/${output}_lineagehits.tsv
mv output_lineagereport.tsv $output/${output}_lineagereport.tsv

rm snpEff*
rm trim.output
rm sample*

conda deactivate
