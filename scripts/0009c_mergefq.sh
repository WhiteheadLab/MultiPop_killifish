#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/mergefq-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/mergefq-stderr-%j.txt
#SBATCH -J mergefq
#SBATCH --mem=16000
#SBATCH -p high
#SBATCH -t 24:00:00 
## Modified 2017-01-09

#DIR1=~/niehs/Data/trimmed_data/mergedfq/lanes_1-2
DIR2=~/niehs/Data/trimmed_data/mergedfq/lanes_3-8
OUTDIR=~/niehs/Data/trimmed_data/mergedfq

# cp ~/niehs/Data/trimmed_data/nebtrim_lanes_3-8/* ${DIR2}/
# 
# cd $DIR1
# for f in `ls *_L005_*.qc.fq.gz`
# do
# 	#Relabel lane numbers from L005,L006 to L007, L008
# 	newfile1="$(echo ${f} | sed -e 's/L005/L007/')" 
#  
# 	mv $f ${DIR2}/$newfile1 
# 
# done
# 
# for f in `ls *L006*.qc.fq.gz`
# do
# 	#Relabel lane numbers from L005,L006 to L007, L008
# 	newfile2="$(echo ${f} | sed -e 's/L006/L008/')" 
# 	
# 	mv $f ${DIR2}/$newfile2
# 	
# done

#merge fq files by read
cd $DIR2
for f in `ls *R1*.qc.fq.gz` 
do
# base=$(basename $f "_S*.qc.fq.gz")
# name=`echo $f | cut -c 5-13`
name=`echo $f | cut -f 9 -d "/" | cut -f 1 -d "_"`

echo $f
echo $name
	
cat ${name}*R1*.qc.fq.gz > ${OUTDIR}/${name}_R1_merged.fq.gz
cat ${name}*R2*.qc.fq.gz > ${OUTDIR}/${name}_R2_merged.fq.gz

echo "finished merging ${name}"

done



	

