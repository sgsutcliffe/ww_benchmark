#!/bin/bash -e

eval "$(conda shell.bash hook)"
conda activate pipes

mkdir -p reqfiles

gdown 1AJTb4IL07VHhLWgMEmdOC1RI2sx2TWaK -O reqfiles/ifile
gdown 1AnV1-rDABYc4VZTvQze_oft817JzWkBh -O reqfiles/vfile
gdown 1J8kNdHZFlMx-5MKzI7ISKH0lrWR-OHeF -O reqfiles/gfile
#gdown https://drive.google.com/file/d/1AnV1-rDABYc4VZTvQze_oft817JzWkBh -O redundant

conda deactivate

