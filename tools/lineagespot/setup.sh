#!/bin/bash -e

mkdir -p reqfiles

cd reqfiles

cp ../../data/ref/NC_045512.2.fasta .

wget -O nCoV-2019.primer.bed https://raw.githubusercontent.com/artic-network/artic-ncov2019/master/primer_schemes/nCoV-2019/V4.1/SARS-CoV-2.primer.bed

wget -O - https://github.com/BiodataAnalysisGroup/lineagespot/archive/master.tar.gz | tar -xz --strip=2 "lineagespot-master/inst/extdata/ref"
mkdir referenceLineages
mv extdata/ref/* referenceLineages

wget -O NC_045512.2_annot.gff3 "https://raw.githubusercontent.com/BiodataAnalysisGroup/lineagespot/master/inst/extdata/NC_045512.2_annot.gff3"

mkdir -p data/wuhan1
cd data/wuhan1

wget -O genes.gbk "https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?tool=portal&save=file&log$=seqview&db=nuccore&report=gbwithparts&id=1798174254&withparts=on&ncbi_phid=null"

cd ../../

echo "wuhan1.genome : SARS-CoV-2" >  snpEff.config

snpEff build -genbank -v wuhan1