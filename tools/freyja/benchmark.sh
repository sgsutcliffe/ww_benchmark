#!/bin/bash
for i in `ls ../data/samples/*R1*`; do 
	echo $i; 
	input=`basename $i | cut -d'_' -f1`; 
	echo $input; 
	./run.sh ../data/samples/${input}_R1.fastq.gz ../data/samples/${input}_R2.fastq.gz; 
done;
