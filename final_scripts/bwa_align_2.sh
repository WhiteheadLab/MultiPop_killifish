#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/final_scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/191016_bwapops-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/191016_bwapops-stderr-%j.txt
#SBATCH -J bwa_align_pops
#SBATCH -p high
#SBATCH -t 24:00:00 


module load bwa/0.7.9a 
module load samtools/1.9  

DIR=~/niehs/Data/trimmed_data/all_pops
OUTDIR=~/niehs/Data/aligned

cd $DIR

#set sample 

f=$(find $DIR -name "EE_00_35_2_USPD16092635-D702-AK1546_HW2K3CCXY_L4_1.qc.fq.gz")
name=$(echo $f | cut -d "/" -f 8 | cut -d "_" -f 1-7)
echo "Processing sample ${name}"


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