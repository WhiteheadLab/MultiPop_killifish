#!/bin/bash -l
#SBATCH --cpus-per-task=24
#SBATCH --mem=40000
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/startranscalign-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/startranscalign-stderr-%j.txt
#SBATCH -J startranscalign
# modified Wed Aug 16 2016

module load perlnew
module load star

# change into output directory
outdir="/home/jajpark/niehs/results/alignments/startran"

# define trimmed reads directory
dir="/home/jajpark/niehs/Data/nebtrim"

for sample in `ls /home/jajpark/niehs/Data/nebtrim/*R1_001.qc.fq.gz` 
do
	
	base=$(basename $sample "_R1_001.qc.fq.gz")
	echo $base
	
	echo `STAR --genomeDir /home/jajpark/niehs/align/startran-index --runThreadN 24 --readFilesCommand zcat --readFilesIn ${dir}/${base}_R1_001.qc.fq.gz ${dir}/${base}_R2_001.qc.fq.gz --outFileNamePrefix $outdir/$base`
	
done


# for sample in `ls /home/jajpark/niehs/Data/nebtrim/*R1_001.qc.fq.gz`  
# do 
# 
# 	num=${sample:0:4}
# 	echo $num
# 
# if [ "${num}" -gt 23 ]	
# then 
# 	do
# 	
# 	base=$(basename $sample "_R1_001.qc.fq.gz")
# 	echo $base
# 	
# 	echo `STAR --genomeDir /home/jajpark/niehs/align/startran-index --runThreadN 24 --readFilesCommand zcat --readFilesIn ${dir}/${base}_R1_001.qc.fq ${dir}/${base}_R2_001.qc.fq --outFileNamePrefix $outdir/$base`
# 	
# done