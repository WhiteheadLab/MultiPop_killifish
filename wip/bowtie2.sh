#!/bin/bash -l
#SBATCH --cpus-per-task=24
#SBATCH --mem=16000
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/bwt-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/bwt-stderr-%j.txt
#SBATCH -J bwt
set -e
set -u

module load bowtie2


cd /home/jajpark/niehs/align/

for sample in `ls /home/jajpark/niehs/Data/trim/*R1_001.qc.fq.gz`
do
	dir="/home/jajpark/niehs/Data/trim"
	base=$(basename $sample "R1_001.qc.fq.gz")
	echo $base
	
	echo `gunzip ${dir}/${base}*`
	echo `bowtie2 -x f_heteroclitus -1 ${dir}/${base}R1_001.qc.fq -2 ${dir}/${base}R2_001.qc.fq -S ${dir}/${base}.sam`
	
done

