#!/bin/bash -l
#SBATCH --array=1-174%50
#SBATCH -D /home/jajpark/niehs/final_scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/191217-bwaars-stout-%A-%a.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/191217-bwaars-stderr-%A-%a.txt
#SBATCH -J bwa_align
#SBATCH -p high
#SBATCH -t 24:00:00 


module load bwa/0.7.9a 
module load samtools/1.9  

DIR=~/niehs/Data/trimmed_data/mergedfq
#MID=~/niehs/Data/aligned
OUTDIR=~/niehs/Data/aligned

cd $DIR

#set sample 
f=$(find $DIR -name "*R1_merged.fq.gz" | sed -n $(echo $SLURM_ARRAY_TASK_ID)p)
name=$(echo $f | cut -d "/" -f 8 | cut -d "_" -f 1)
echo "Processing sample ${name}"

#if [ -f $MID/${name}.bam ] || [ -f $OUTDIR/${name}.bam ]; then 
#	echo "yay"
	
#else 


# define input
fq1=${name}_R1_merged.fq.gz
echo $fq1
fq2=$(echo $fq1 | sed 's/_R1_/_R2_/')
echo $fq2

# set bwa output variables
bamp=$(echo $fq1 | sed 's/.fq.gz/.bam/' | sed 's/_R[12]_merged//')

# read group info
run=merged
lib=merged
samp=$(echo $fq1 | grep -oP "[^/]+(?=_R1)")
lane=merged
sub=merged
rg=$(echo \@RG\\tID:$samp\\tPL:Illumina\\tPU:x\\tLB:$lib\\tSM:$samp)

# define indexed reference genome
genome=/home/jajpark/niehs/refseq/fhet

# run bwa
bwa mem -R $rg $genome $fq1 $fq2 | \
samtools sort -O bam -T $OUTDIR/$bamp.temp > $OUTDIR/$bamp

#fi
