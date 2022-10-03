# Waste water benchmark dataset 
Created by Sussane Kraemer

Synthetic samples for the benchmarking of wastewater SARS-CoV-2 variant detection pipelines.

The 'samples/' folder contains 100 forward and reverse simulated illumina reads of a combination of BA.1, BA.2, Delta, Recombinant, Synthetic non-lineage
at varying frequencies.

The answer key for 1) read length 2) relative abundance (ratio) 3) coverage (lowcov: 50x hicov: 1000x) 4) sample #

Dataset was built with the goal of assessing the ability of tools to:
 - Delineate lineages and sublineages
 - Delineate frequencies in mixed samples
 - Detect lineages at low frequency 1%
 - Genomes with amplicon drop-out
 - Novel variants
 - Recombinants
 - Low coverage & short read sequencing
