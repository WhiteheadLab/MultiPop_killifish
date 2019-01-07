#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/grepbarcodes-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/grepbarcodes-stderr-%j.txt
#SBATCH -J grepbarcodes
set -e
set -u

## Look for the top 20 most prevalent barcode sequences in the first 400000 reads of Undetermined sample
# zcat Undetermined_S0_L005_R1_001.fastq.gz | grep '^@J00113' | cut -d : -f 10 | sort | uniq -c | sort -nr | head -20


## Do a grep search on barcode sequence in the header line, pull out the subsequent 3 lines, then pipe to a new file. 
zcat /home/jajpark/niehs/data/Data/wtv2m3vq5z/Unaligned2/Project_AWJP_L5_AWJJP001/Undetermined_S0_L005_R1_001.fastq.gz | grep -A 3 'AGCGATAG+GTCAGTAC' > /home/jajpark/niehs/data/Data/wtv2m3vq5z/Unaligned2/Project_AWJP_L5_AWJJP001/0006ARSE32351_S81_L005_R1_001.fastq
zcat /home/jajpark/niehs/data/Data/wtv2m3vq5z/Unaligned2/Project_AWJP_L5_AWJJP001/Undetermined_S0_L005_R2_001.fastq.gz | grep -A 3 'AGCGATAG+GTCAGTAC' > /home/jajpark/niehs/data/Data/wtv2m3vq5z/Unaligned2/Project_AWJP_L5_AWJJP001/0006ARSE32351_S81_L005_R2_001.fastq
echo "\n Sample 0006 Sorted"


zcat /home/jajpark/niehs/data/Data/3b4t6qxtd5/Unaligned2/Project_AWJP_L6_AWJJP002/Undetermined_S0_L006_R1_001.fastq.gz | grep -A 3 'AGCGATAG+GTCAGTAC' > /home/jajpark/niehs/data/Data/3b4t6qxtd5/Unaligned2/Project_AWJP_L6_AWJJP002/0094ARSC00354_S168_L006_R1_001.fastq
zcat /home/jajpark/niehs/data/Data/3b4t6qxtd5/Unaligned2/Project_AWJP_L6_AWJJP002/Undetermined_S0_L006_R2_001.fastq.gz | grep -A 3 'AGCGATAG+GTCAGTAC' > /home/jajpark/niehs/data/Data/3b4t6qxtd5/Unaligned2/Project_AWJP_L6_AWJJP002/0094ARSC00354_S168_L006_R2_001.fastq
echo "\n Sample 0094 Sorted"

## Compress fastq files
gzip -v /home/jajpark/niehs/data/Data/wtv2m3vq5z/Unaligned2/Project_AWJP_L5_AWJJP001/0006ARSE32351_S81_L005_R1_001.fastq
gzip -v /home/jajpark/niehs/data/Data/wtv2m3vq5z/Unaligned2/Project_AWJP_L5_AWJJP001/0006ARSE32351_S81_L005_R2_001.fastq
echo "\n Sample 0006 zipped"

gzip -v /home/jajpark/niehs/data/Data/3b4t6qxtd5/Unaligned2/Project_AWJP_L6_AWJJP002/0094ARSC00354_S168_L006_R1_001.fastq
gzip -v /home/jajpark/niehs/data/Data/3b4t6qxtd5/Unaligned2/Project_AWJP_L6_AWJJP002/0094ARSC00354_S168_L006_R2_001.fastq
echo "\n Sample 0094 zipped"