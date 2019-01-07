#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/rseqc-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/rseqc-stderr-%j.txt
#SBATCH -J rseqc
#SBATCH --mem=16000
#SBATCH -p high
#SBATCH -t 24:00:00 
## Modified 04 Jan, 2017 JP

module load python numpy R RSeQC

REF=~/niehs/refseq/GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.bed
DIR=~/niehs/results/alignments/star_heteroclitus_annot_161116/merge/
OUTDIR=~/niehs/results/rseqc/output


geneBody_coverage.py -r $REF \
					-i $DIR \
					-o $OUTDIR
					
