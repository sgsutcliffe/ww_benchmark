#!/bin/bash

eval "$(conda shell.bash hook)"
conda activate ag

Rscript installPackages.r
cp run_iPMVC_in_parallel.py Wastewater_surveillance_pipeline/Variant_calling

conda deactivate