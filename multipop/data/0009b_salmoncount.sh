#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/salmindex-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/salmindex-stderr-%j.txt
#SBATCH -J salmindx
#SBATCH --mem=16000
#SBATCH -p high
#SBATCH -t 24:00:00 
## Modified 15 December, 2016, JP

set -e
set -u

module load salmon
DIR=~/niehs/results/alignments/star_heteroclitus_annot_161116/merge