#!/bin/bash -e

eval "$(conda shell.bash hook)"
conda activate ag

R1=$1
R2=$2

mkdir -p working/out

echo "sample" > working/lst_samples.txt
cp $R1 working/sample_R1.fastq.gz
cp $R2 working/sample_R2.fastq.gz
cp ./Wastewater_surveillance_pipeline/Post_variant_calling_analysis/MN908947_3.fasta working/MN908947_3.fasta
bwa index working/MN908947_3.fasta

python ./Wastewater_surveillance_pipeline/Variant_calling/run_iPMVC_in_parallel.py working lst_samples.txt 2
samtools depth working/sample_preprocessed_sorted.bam -o working/out/common_depth_report.csv

mkdir -p working2
echo "sample" > working2/lst_samples.txt
cp working/out/variants_sample.tab ./working2
cp ./Wastewater_surveillance_pipeline/Post_variant_calling_analysis/MN908947_3.fasta working2/MN908947_3.fasta
cp working/out/common_depth_report.csv ./working2
cp ./Wastewater_surveillance_pipeline/Post_variant_calling_analysis/Table_Sample_stratifications_of_interest.csv working2/Table_Sample_stratifications_of_interest.csv
cp ./Wastewater_surveillance_pipeline/Post_variant_calling_analysis/Metadata_samples.csv working2/Metadata_samples.csv
cp ./Wastewater_surveillance_pipeline/Post_variant_calling_analysis/df_signature_muts_prevalence_VOCs_VUIs.csv working2/df_signature_muts_prevalence_VOCs_VUIs.csv
cp ./Wastewater_surveillance_pipeline/Post_variant_calling_analysis/LATEST_REPORT.csv working2/LATEST_REPORT.csv
cp ./Wastewater_surveillance_pipeline/Post_variant_calling_analysis/ListeCH_prefix.csv working2/ListeCH_prefix.csv

Rscript Wastewater_surveillance_pipeline/Post_variant_calling_analysis/Wastewater_Illumina.r ./working2

mv working/out .
rm -rf working
rm fastp.*

conda deactivate
