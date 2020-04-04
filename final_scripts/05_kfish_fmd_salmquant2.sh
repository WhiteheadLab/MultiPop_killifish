#!/bin/bash -l
#SBATCH --array=1-83%50
#SBATCH -D /home/jajpark/niehs/final_scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/190129-salmcountfmd2-stout-%A-%a.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/190129-salmcountfmd2-stderr-%A-%a.txt
#SBATCH -J salmcount_kfish_fmd2
#SBATCH --mem=6000
#SBATCH -p high
#SBATCH -t 24:00:00 
## Modified 29 January, 2019, JP

module load bio

DIR=~/niehs/Data/trimmed_data/all_pops
IND=~/niehs/refseq/kfish_salm_index_fmd
OUTDIR=~/niehs/results/190129_kfishind_fmd_salmcounts

cd $DIR

f=$(find $DIR -name "*L5_1.qc.fq.gz" | sed -n $(echo $SLURM_ARRAY_TASK_ID)p)
name=$(echo $f | cut -d "/" -f 8 | cut -d "_" -f 1-6)
echo "Processing sample ${name}"

salmon quant -i $IND -l ISR \
         -1 <(gunzip -c ${name}_L5_1.qc.fq.gz ${name}_L6_1.qc.fq.gz ${name}_L7_1.qc.fq.gz ${name}_L8_1.qc.fq.gz)\
         -2 <(gunzip -c ${name}_L5_2.qc.fq.gz ${name}_L6_2.qc.fq.gz ${name}_L7_2.qc.fq.gz ${name}_L8_2.qc.fq.gz) \
         -p 8 -o ${OUTDIR}/${name}_quant
