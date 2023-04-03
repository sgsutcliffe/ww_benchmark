#!/bin/bash 

#to run the script
#for i in `ls ../data/samples/*R1*`; do echo $i; input=`basename $i | cut -d'_' -f1`; echo $input; ./run.sh ../data/samples/${input}_R1.fastq.gz ../data/samples/${input}_R2.fastq.gz; done;

eval "$(conda shell.bash hook)"
conda activate lcs

mkdir -p LCS/outputs/variants_table &&
zcat LCS/data/pre-generated-marker-tables/pango-designation-markers-v1.2.60.tsv.gz > LCS/outputs/variants_table/pango-markers-table.tsv

mkdir -p LCS/data/fastq
cp $1 LCS/data/fastq/sample_1.fastq.gz
cp $2 LCS/data/fastq/sample_2.fastq.gz

echo "sample" > LCS/data/tags_pool_mypool

cd LCS
snakemake --config markers=pango dataset=mypool --cores 8 --resources mem_gb=8000
cd ../

output=`basename $1 | cut -d'_' -f1`
echo $output

mkdir -p $output
mv LCS/outputs/decompose/mypool.out $output/$output.frequency.txt
mv LCS/outputs/decompose/mypool.status $output/$output.status.txt

rm -rf LCS/outputs
rm -rf LCS/data/fastq
rm LCS/data/tags_pool_mypool

conda deactivate
