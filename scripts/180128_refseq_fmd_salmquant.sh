#!/bin/bash -l
#SBATCH --array=1-174%50
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/180128_salmcountfmd-stout-%A-%a.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/180128_salmcountfmd-stderr-%A-%a.txt
#SBATCH -J salmcount_refseq_fmd
#SBATCH --mem=6000
#SBATCH -p med
#SBATCH -t 24:00:00 
## Modified 28 January, 2018, JP

module load bio

DIR=~/niehs/Data/trimmed_data/mergedfq
IND=~/niehs/refseq/refseq_salm_index_fmd
OUTDIR=~/niehs/results/180128_refseq_fmd_salmcounts

cd $DIR

f=$(find $DIR -name "*R1*.fq.gz" | sed -n $(echo $SLURM_ARRAY_TASK_ID)p)
name=`echo $f | cut -f 8 -d "/" | cut -f 1 -d "_"`
echo "Processing sample ${name}"

salmon quant -i $IND -l A \
         -1 ${name}_R1_merged.fq.gz \
         -2 ${name}_R2_merged.fq.gz \
         -p 8 -o ${OUTDIR}/${name}_quant
         
done

