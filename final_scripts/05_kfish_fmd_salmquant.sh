#!/bin/bash -l
#SBATCH --array=1-80%50
#SBATCH -D /home/jajpark/niehs/final_scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/200309-salmcountfmd-stout-%A-%a.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/200309-salmcountfmd-stderr-%A-%a.txt
#SBATCH -J salmcount_kfish_fmd
#SBATCH --mem=6000
#SBATCH -p high
#SBATCH -t 24:00:00 
## Modified 29 January, 2019, JP

module load bio

DIR=~/niehs/Data/trimmed_data/liversamples
IND=~/niehs/refseq/kfish_salm_index_fmd
OUTDIR=~/niehs/results/liver_kfish_fmd_salmcounts

cd $DIR

f=$(find $DIR -name "*_1.qc.fq.gz" | sed -n $(echo $SLURM_ARRAY_TASK_ID)p)
name=$(echo $f | cut -d "/" -f 8 | cut -d "_" -f 1-3)
echo "Processing sample ${name}"

salmon quant -i $IND -l ISR \
         -1 <(gunzip -c ${name}_L5_1.qc.fq.gz ${name}_L6_1.qc.fq.gz) \
         -2 <(gunzip -c ${name}_L5_2.qc.fq.gz ${name}_L6_2.qc.fq.gz) \
         -p 8 -o ${OUTDIR}/${name}_quant
         