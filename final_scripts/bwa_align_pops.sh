#!/bin/bash -l
#SBATCH --array=1-665%50
#SBATCH -D /home/jajpark/niehs/final_scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/191110_bwapops-stout-%A-%a.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/191110_bwapops-stderr-%A-%a.txt
#SBATCH -J bwa_align_pops
#SBATCH -p high
#SBATCH -t 24:00:00 


module load bwa/0.7.9a 
module load samtools/1.9  

DIR=~/niehs/Data/trimmed_data/all_pops
MID=~/niehs/Data/aligned
OUTDIR=~/niehs/Data/aligned/pt2

cd $DIR

#set sample 
f=$(find $DIR -name "*1.qc.fq.gz" | sed -n $(echo $SLURM_ARRAY_TASK_ID)p)
name=$(echo $f | cut -d "/" -f 8 | cut -d "_" -f 1-7)
echo "Processing sample ${name}"


if [ -f $MID/${name}.bam ] || [ -f $OUTDIR/${name}.bam ]; then 
	echo "yay"
	
else

# define input
fq1=${name}_1.qc.fq.gz
echo $fq1
fq2=${name}_2.qc.fq.gz
echo $fq2

# set bwa output variables
bamp=$(echo $fq1 | sed 's/_1.qc.fq.gz/.bam/')

# read group info
header=$(zgrep -m 1 -e "@" $fq1)

run=$(echo $header | cut -d ":" -f 2)
flowcell=$(echo $header | cut -d ":" -f 3)
samp=$(echo $name | cut -d "_" -f 1-4)
lane=$(echo $header | cut -d ":" -f 4)
sampbarcode=$(echo $header | cut -d ":" -f 10)
rg=$(echo \@RG\\tID:$flowcell.$lane\\tPL:Illumina\\tPU:$flowcell.$lane.$sampbarcode\\tLB:$samp\\tSM:$samp)

# define indexed reference genome
genome=/home/jajpark/niehs/refseq/fhet

# run bwa
bwa mem -R $rg $genome $fq1 $fq2 | \
samtools sort -O bam -T $OUTDIR/$bamp.temp > $OUTDIR/$bamp

fi
