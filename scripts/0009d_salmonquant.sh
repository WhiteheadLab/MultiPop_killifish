#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/180110_salmcount-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/180110_salmcount-stderr-%j.txt
#SBATCH -J salmcount
#SBATCH --mem=16000
#SBATCH -p high
#SBATCH -t 24:00:00 
## Modified 10 January, 2018, JP

module load bio

DIR=~/niehs/Data/trimmed_data/mergedfq
IND=~/niehs/refseq/transcripts_salm_index
OUTDIR=~/niehs/results/180110_salmoncount


#f=$(find $DIR -name "*R1*.fq" | sed -n $(echo $SLURM_ARRAY_TASK_ID)p)

cd $DIR

for f in `ls *R1*.fq.gz`
do 

name=`echo $f | cut -f 8 -d "/" | cut -f 1 -d "_"`
echo "Processing sample ${name}"

salmon quant -i $IND -l A \
         -1 ${name}_R1_merged.fq.gz \
         -2 ${name}_R2_merged.fq.gz \
         -p 8 -o ${OUTDIR}/${name}_quant
         
done

