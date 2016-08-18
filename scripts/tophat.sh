#!/bin/bash -l
#SBATCH --cpus-per-task=24
#SBATCH --mem=16000
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/tpht-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/tpht-stderr-%j.txt
#SBATCH -J tpht
# modified Wed Aug 10 2016

set -e
set -u

module load bowtie2
module load tophat

reference_index="/home/jajpark/niehs/align/f_heteroclitus"
transcript_annotation="/home/jajpark/niehs/align/GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.gff"
dir="/home/jajpark/niehs/Data/trim"
outdir="/home/jajpark/niehs/align/tophat"

## Execute tophat for reads that are unzipped already: 
for sample in `ls /home/jajpark/niehs/Data/trim/*R1_001.qc.fq`
do
	
	base=$(basename $sample "_R1_001.qc.fq")
	echo $base
	
	echo `tophat -G ${transcript_annotation} -o ${outdir} --no-novel-juncs ${reference_index} ${dir}/${base}_R1_001.qc.fq ${dir}/${base}_R2_001.qc.fq`
	
done


### Execute tophat for reads that are still zipped: 
for sample in `ls /home/jajpark/niehs/Data/trim/*R1_001.qc.fq.gz`
do
	
	base=$(basename $sample "_R1_001.qc.fq.gz")
	echo $base
	
	echo `gunzip ${dir}/${base}*`
	echo `tophat -G ${transcript_annotation} -o ${outdir} --no-novel-juncs ${reference_index} ${dir}/${base}_R1_001.qc.fq ${dir}/${base}_R2_001.qc.fq`
	
done

