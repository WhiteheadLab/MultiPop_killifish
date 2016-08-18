#!/bin/bash -l
#SBATCH --cpus-per-task=24
#SBATCH --mem=40000
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/stargenalign-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/stargenalign-stderr-%j.txt
#SBATCH -J stargenalign
# modified Wed Aug 16 2016

module load perlnew
module load star

outdir="/home/jajpark/niehs/results/alignments/stargen"
dir="/home/jajpark/niehs/Data/nebtrim"

for sample in `ls /home/jajpark/niehs/Data/nebtrim/*R1_001.qc.fq.gz`
do
	
	base=$(basename $sample "_R1_001.qc.fq.gz")
	echo $base
	
	echo `STAR --genomeDir /home/jajpark/niehs/align/stargen-index/ --runThreadN 24 --readFilesCommand zcat --readFilesIn ${dir}/${base}_R1_001.qc.fq ${dir}/${base}_R2_001.qc.fq --outFileNamePrefix $outdir/$base`
	
done


