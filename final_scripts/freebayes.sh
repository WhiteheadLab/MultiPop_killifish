#!/bin/bash 
#SBATCH --array=1-700%50
#SBATCH -D /home/jajpark/niehs/final_scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/200108-freebayes-stout-%A-%a.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/200108-freebayes-stderr-%A-%a.txt
#SBATCH -J freeb
#SBATCH -p high
#SBATCH -t 24:00:00 

cd ~/niehs/refseq

echo This is array task number $SLURM_ARRAY_TASK_ID

# put relevant data in variables
CHR=$(sed -n ${SLURM_ARRAY_TASK_ID}p ~/niehs/refseq/fundulus-heteroclitus-500kb.bed | cut -f 1)
START=$(expr $(sed -n ${SLURM_ARRAY_TASK_ID}p ~/niehs/refseq/fundulus-heteroclitus-500kb.bed | cut -f 2) + 1)
STOP=$(sed -n ${SLURM_ARRAY_TASK_ID}p ~/niehs/refseq/fundulus-heteroclitus-500kb.bed | cut -f 3)

# define region variable
	# for most tools in the format chr:start-stop
REGION=${CHR}:${START}-${STOP}

echo This task will analyze region $REGION of the human genome. 

inbam=~/niehs/Data/mergedalignments	
outdir=~/niehs/Data/variantcalling
GEN=~/niehs/refseq/GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.fna
freeb=/home/jajpark/freebayes/bin/freebayes

cd $inbam

$freeb -0 --min-coverage 750 \
-g 100000 \
-f $GEN \
-L bamlist.txt \
-r $REGION > $outdir/var.vcf


