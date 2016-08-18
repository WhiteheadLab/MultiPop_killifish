#!/bin/bash -l
#SBATCH -D /home/jajpark/niehs/scripts/
#SBATCH -o /home/jajpark/niehs/slurm-log/fixfastq-stout-%j.txt
#SBATCH -e /home/jajpark/niehs/slurm-log/fixfastq-stderr-%j.txt
#SBATCH -J fixfstq
set -e
set -u

zcat /home/jajpark/niehs/data/Data/wtv2m3vq5z/Unaligned2/Project_AWJP_L5_AWJJP001/0006ARSE32351_S81_L005_R1_001.fastq.gz | sed '/^--$/d' > /home/jajpark/niehs/data/Data/wtv2m3vq5z/Unaligned2/Project_AWJP_L5_AWJJP001/0006ARSE32351_S81_L005_R1_001_1.fastq | gzip -v
zcat /home/jajpark/niehs/data/Data/wtv2m3vq5z/Unaligned2/Project_AWJP_L5_AWJJP001/0006ARSE32351_S81_L005_R2_001.fastq.gz | sed '/^--$/d' > /home/jajpark/niehs/data/Data/wtv2m3vq5z/Unaligned2/Project_AWJP_L5_AWJJP001/0006ARSE32351_S81_L005_R2_001_1.fastq

zcat /home/jajpark/niehs/data/Data/3b4t6qxtd5/Unaligned2/Project_AWJP_L6_AWJJP002/0094ARSC00354_S168_L006_R1_001.fastq.gz | sed '/^--$/d' > /home/jajpark/niehs/data/Data/3b4t6qxtd5/Unaligned2/Project_AWJP_L6_AWJJP002/0094ARSC00354_S168_L006_R1_001_1.fastq
zcat /home/jajpark/niehs/data/Data/3b4t6qxtd5/Unaligned2/Project_AWJP_L6_AWJJP002/0094ARSC00354_S168_L006_R2_001.fastq.gz | sed '/^--$/d' > /home/jajpark/niehs/data/Data/3b4t6qxtd5/Unaligned2/Project_AWJP_L6_AWJJP002/0094ARSC00354_S168_L006_R2_001_1.fastq


# gzip -v /home/jajpark/niehs/data/Data/wtv2m3vq5z/Unaligned2/Project_AWJP_L5_AWJJP001/0006ARSE32351_S81_L005_R1_001_1.fastq
gzip -v /home/jajpark/niehs/data/Data/wtv2m3vq5z/Unaligned2/Project_AWJP_L5_AWJJP001/0006ARSE32351_S81_L005_R2_001_1.fastq
echo "\n Sample 0006 zipped"

gzip -v /home/jajpark/niehs/data/Data/3b4t6qxtd5/Unaligned2/Project_AWJP_L6_AWJJP002/0094ARSC00354_S168_L006_R1_001_1.fastq
gzip -v /home/jajpark/niehs/data/Data/3b4t6qxtd5/Unaligned2/Project_AWJP_L6_AWJJP002/0094ARSC00354_S168_L006_R2_001_1.fastq
echo "\n Sample 0094 zipped"
