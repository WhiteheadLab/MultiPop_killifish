#!/bin/bash -l
#SBATCH --cpus-per-task=24
#SBATCH --mem=40000
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/staralign-grandis-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/staralign-grandis-stderr-%j.txt
#SBATCH -J staralign-grandis
# modified Wed Aug 16 2016

module load perlnew
module load star

outdir="/home/jajpark/niehs/results/alignments/stargrandis/"
dir="/home/jajpark/niehs/Data/nebtrim_lanes_3-8/"

for sample in `ls $dir/*R1_001.qc.fq.gz`
do
	
	base=$(basename $sample "_R1_001.qc.fq.gz")
	echo $base
	
	echo `STAR --genomeDir /home/jajpark/niehs/align/star-index-grandis/ --runThreadN 24 --readFilesCommand zcat --readFilesIn ${dir}/${base}_R1_001.qc.fq.gz ${dir}/${base}_R2_001.qc.fq.gz --outFileNamePrefix $outdir/$base`
	
done


