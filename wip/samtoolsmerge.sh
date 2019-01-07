#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/merge-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/merge-stderr-%j.txt
#SBATCH -J stoolsmerge
set -e
set -u

module load samtools

samtools merge -nur1f -b /home/jajpark/niehs/Data/samtoolsfiles/bamlist.txt /home/jajpark/niehs/results/merged.bam 

