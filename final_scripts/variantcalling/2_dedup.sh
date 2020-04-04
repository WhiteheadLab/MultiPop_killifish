#!/bin/bash -l
#SBATCH --array=1-838%50
#SBATCH -D /home/jajpark/niehs/final_scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/191220-dedup-stout-%A-%a.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/191220-dedup-stderr-%A-%a.txt
#SBATCH -J markdup
#SBATCH -p high
#SBATCH -t 24:00:00 

module load picardtools 
module load samtools

DIR=~/niehs/Data/aligned
OUT=~/niehs/Data/dedup

cd $DIR

#set sample 
f=$(find $DIR -name "*.bam" | sed -n $(echo $SLURM_ARRAY_TASK_ID)p)
name=$(echo $f | cut -d "/" -f 7 | cut -d "." -f 1)
echo "Processing sample ${name}"


# define input
i=$f
o=$OUT/${name}_dedup.bam
m=$OUT/${name}_metrics.txt

java -Xmx2g -jar $PICARD/picard.jar MarkDuplicates \
I=$i \
O=$o \
METRICS_FILE=$m \
ASSUME_SORTED=true \
VALIDATION_STRINGENCY=SILENT 

