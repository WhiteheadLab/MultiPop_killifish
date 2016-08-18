JJPark
Project: NIEHS UCD-LSU 
RNASeq Analysis
Last modifiled: Wednesday August 16, 2016

####Retrieving raw read data from Slim (UC Davis Genome Center Server)

Shell scripts: 
	
		getdata.sh
		getdata2.sh

Command to execute bash script on Farm cluster:

	sbatch -p hi getdata.sh


####Identifying samples that didn't get sequenced in the first lane trial

Tues July 12, 2016

SampleID BarcodeSequences #ofclusters %oflane

**Lane 5:**

0006ARSE32351	ATTACTCG-TAAGATTA	14,678	0.00

**Lane 6:** 

0094ARSC00354	ATTACTCG-TAAGATTA	10,911	0.00

0146ARSC00NH4	TAATGCGC-GCCTCTAT	17,190	0.00

0173ARSC56NH3	TCTCGCGC-CTTCGCCT	13,098	0.00

* I used a long grep command to print the top 20 most prevalent barcodes in the Unidentified samples in both lanes. 

		zcat Undetermined_S0_L006_R1_001.fastq.gz | head -400000 | grep '@J00113' | cut -d : -f 10 | sort | uniq -c | sort -nr | head -20

		zcat ~/niehs/data/Data/wtv2m3vq5z/Unaligned2/Project_AWJP_L5_AWJJP001/Undetermined_S0_L005_R1_001.fastq.gz | head -400000 | grep '@J00113:142:H7VNNBBXX'| cut -d : -f 10 | sort | uniq -c | sort -nr | head -20

Output files in `~/niehs/results/undet_top20barcodes_001_088.txt`or `~/niehs/results/undet_top20barcodes_089_176.txt`. 

I didn't see the ATTACTCG-TAAGATTA barcode combination in the top 20 hit in either Undetermined sample files. 

I checked back on my notes about Sample 146 and Sample 173- it looks like they were never prepared. Confused about how I had tubes that I pipetted out of... The tube labels look like they were mistakenly corrected, and I was likely confused by bad handwriting. I had mistakenly recorded the library having been prepared on 5/2/16, but in fact I had prepared library for Sample 145 using the correct barcodes for 145 on that day as a re-do. I made libraries for Samples 75 and 145. I had therefore quantified those samples twice, and pooled those duplicates together in th eprocess thinking I had a sample 173 and Sample 146. 

Sample 146 is actually Sample 145. Sample 173 is actually Sample 75. 

Because the barcodes for Sample 75 are also used for Sample 163, I essentially have double the amount of reads for Sample 163 (I can already see that in the demultiplexed file). Half of those reads are actually from Sample 75, but there's no way to tell those apart from Sample 163. 


I don't see double the amount of reads for Sample 145, however. For now, I'll accept that they're missing until after the preliminary analyses. I will also leave out Sample 163 in my analyses. If preliminary analyses indicate that that particular sample and treatment is important, I'll include it in future sequencing runs when making libraries for other populations. 

Sample 6 and 94 were made with barcodes i712 and i508, NOT i701 and i506 like they should have been.  


###Running FastQC
FastQC is a raw read quality assessment command line tool.
I loaded the program using:

	module load fastqc
	
I used the following scripts to generate FastQC results for samples 0001-0088 and 0089-0176, respectively: 

	fastqctest_0001-0088.sh
	fastqctest1.sh
	sbatch -p hi fastqctest1.sh
	
Results located in `/home/jajpark/niehs/results/0001_0088_qc` and `/home/jajpark/niehs/results/0089_0176_qc`

###Retrieving reads from Undetermined Samples file, a.k.a. demultiplexing indexed reads
Because I used the wrong barcodes for Samples 0006 and 0094, I used the `fastx barcode splitter` command line tool. 

		demultiplex.sh

Loaded the tool from Farm. For some reason, perlbrew is a required command before I can load fastx:

		module load perlbrew
		module load fastx
		
I probably should have done this before running FastQC, since I now have to re-do FastQC on samples 0006 and 0094 respectively. 

fastx barcode splitter requires a .txt file of all the barcodes. I only included the barcodes from i712 and i508. I couldn't figure out if the program needs reverse complement reads of i508 so I included reverse complements of both barcodes. 

I first ran the program allowing for 3 mismatches, then with the default 1 mismatch. 

I then realized that the program is performing the barcode search at the beginning of the sequence line, not in the header. 

So then I used a grep command pipeline to look for the barcode sequence in the header and redirect corresponding read lines to the sample file. See: 

		grepbarcodes.sh
		
		
Ultimately, the genome center re-did the demultiplexing. The new files for all samples ended up being ~1-2MB larger than the first demultiplexing attempt, so I updated all my data with the newly demultiplexed reads. 

###Trim short reads with trimmomatic
Reads were trimmed lightly using Trimmomatic command line tool. 

		trimmomatic.sh
		
FastQC was performed on trimmed reads. 

I used trimmomatic again on raw reads using NEBNextAdapt.fa as the adapter file as well, but the resulting FastQC and numbers from the screen print from both trimmomatic runs look the same.

From using Illumina TruSeq3-PE.fa:
	
	TrimmomaticPE: Started with arguments:
 	0001ARSC32191_S1_L005_R1_001.fastq.gz 0001ARSC32191_S1_L005_R2_001.fastq.gz /home/jajpark/niehs/Data/trim/0001ARSC32191_S1_L005_R1_001.qc.fq.gz /home/jajpark/niehs/Data/trim/s1_se /home/jajpark/niehs/Data/trim/0001ARSC32191_S1_L005_R2_001.qc.fq.gz /home/jajpark/niehs/Data/trim/s2_se ILLUMINACLIP:/home/jajpark/programs/Trimmomatic-0.36/adapters/TruSeq3-PE.fa:2:40:15 LEADING:2 TRAILING:2 SLIDINGWINDOW:4:2 MINLEN:25
	Using PrefixPair: 'TACACTCTTTCCCTACACGACGCTCTTCCGATCT' and 'GTGACTGGAGTTCAGACGTGTGCTCTTCCGATCT'
	ILLUMINACLIP: Using 1 prefix pairs, 0 forward/reverse sequences, 0 forward only sequences, 0 reverse only sequences
	Quality encoding detected as phred33
	Input Read Pairs: 3105178 Both Surviving: 3101995 (99.90%) Forward Only 	Surviving: 3139 (0.10%) Reverse Only Surviving: 0 (0.00%) Dropped: 44 (0.00%)
	TrimmomaticPE: Completed successfully

From using NEBNextAdapt.fa:

	TrimmomaticPE: Started with arguments:
 	0001ARSC32191_S1_L005_R1_001.fastq.gz 0001ARSC32191_S1_L005_R2_001.fastq.gz /home/jajpark/niehs/Data/nebtrim/0001ARSC32191_S1_L005_R1_001.qc.fq.gz /home/jajpark/niehs/Data/nebtrim/s1_se /home/jajpark/niehs/Data/nebtrim/0001ARSC32191_S1_L005_R2_001.qc.fq.gz /home/jajpark/niehs/Data/nebtrim/s2_se ILLUMINACLIP:/home/jajpark/programs/Trimmomatic-0.36/adapters/NEBnextAdapt.fa:2:40:15 LEADING:2 TRAILING:2 SLIDINGWINDOW:4:2 MINLEN:25
	Using Long Clipping Sequence: 'ACACTCTTTCCCTACACGACGCTCTTCCGATC'
	Using Long Clipping Sequence: 'GATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT'
	Using Long Clipping Sequence: 'GATCGGAAGAGCACACGTCTGAACTCCAGTC'
	Using Long Clipping Sequence: 'GACTGGAGTTCAGACGTGTGCTCTTCCGATC'
	ILLUMINACLIP: Using 0 prefix pairs, 4 forward/reverse sequences, 0 forward only 	sequences, 0 reverse only sequences
	Quality encoding detected as phred33
	Input Read Pairs: 3105178 Both Surviving: 3104873 (99.99%) Forward Only 	Surviving: 25 (0.00%) Reverse Only Surviving: 16 (0.00%) Dropped: 264 (0.01%)
	TrimmomaticPE: Completed successfully
	
I compared the two .fa files and found the adapter sequences are different. I'm going to use data generated by NEBnextAdapt.fa trimming since that's the kit I used, but this does worry me. 


###Downloading reference genome
For some reason ftp wasn't working as I expected on the farm cluster, so I used ftp on my personal laptop to download the latest reference genomes from ncbi (ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_other/Fundulus_heteroclitus/latest_assembly_versions/GCF_000826765.1_Fundulus_heteroclitus-3.0.2):

		ftp ftp://ftp.ncbi.nlm.nih.gov
		cd genomes/vertebrate_other/Fundulus_heteroclitus/latest_assembly_versions/GCF_000826765.1_Fundulus_heteroclitus-3.0.2
		mget *
		
Then I used scp to move all the files into my account on farm. 

###Mapping reads to reference genome using Bowtie2 and TopHat2

1. I built indexes using bowtie2 from the reference genome: *genomic.fna.gz
2. I used bowtie2 to align my short reads to the f_heteroclitus reference genome. 

Bowtie2 works in 2 parts: 1) index reference genome to produce 4 files, and 2) aligns paired reads to indexed files. 

The f_heteroclitus indexed reference genome is located in ~/niehs/align, as well as the .sam files. 

		bowtie2.sh

I ran bowtie2 up till the first 13 or so samples when I realized that Tophat2 might be better for mapping short reads to genomes, because tophat can also look at possible splice junctions. 

I can compare the overall alignment rate between the two methods for the first few samples. 

		tophat.sh
		
The NCBI refseq files didn't include a transcriptome annotation file (.gff), just a genome annotation file. So, I used that in my TopHat pipeline.

I changed the tophat pipeline to use the cds_from_genomic.fna file as transcript annotation instead, but that failed the pipeline. So then I changed it back. 
I also noticed way too late (like 19 samples in) that the output I originally defined had the tophat application OVERWRITE the outputs. So basically I only have output for sample 18 or whatever the last sample was before I changed the script. 

Now the script is written such that outputs are written in a new folder for each sample. 

		tophat_1.sh

*Bowtie2 Results:*

~70% overall alignment rate
See: /home/jajpark/niehs/results/alignments/bowtie2/bwt-stderr-10007222.txt

*TopHat results:*

I ended up getting something like ~45% concordant pair alignment rate, which is pretty low according to Lisa. 

See: alignment summary files under each sample directory in /home/jajpark/niehs/results/alignments/tophat/


###Mapping reads to reference genome and transcriptome using STAR

I decided to try using STAR, which is apparently very fast and ascertains splice junctions on its own (independent of annotations). I wanted to compare alignment rates between a reference genome from NCBI refseq, and a reference transcriptome that Noah had used in the past for his RNAseq work. 

First I indexed the reference genome and transcriptome:

		starindex.sh
Then I started the alignment processes using each:

		stargenomicalign.sh
		startranscralign.sh
	

###Samtools


I used samtools to sort and index my accepted_hits.bam file. 
Then I used the bedtools genomecov ()genomeCoverageBed) package to calculate coverage across my reference genome. 
I used the UCSC genome browser and IGV to visualize this data. 

###Visual QC of alignment


I got IGV to work, but I'm not sure I'm using the right files because I can't make any sense of what's going on. I don't have chromosomes, instead I'm getting list of scaffolds. 

		
Today was a slow and arduous day of reading through many outdated tutorials on WHAT to do with alignment files. It seems like the tools are so widely used that nobody botehrs to spell things out for people like me, or they don't bother to update the manuals as new versions of the tools are released. I can't find a decent tutorial on the UCSC genome browser for the life of me, and it's impossible to know why IGV is listing scaffolds instead of chromosomes. Underneath all of this, I still don't know if it was wise to use the NCBI/refseq reference genome for my alignment, since it seems it's a more conservative(?) alignment. 


I just need to check coverage across the genome to make sure I don't have any blaring red flags in order to give the genome center the green light for further lanes of sequencing. 
		
		
OK so I restarted IGV and somehow the reference genome fixed itself and I can finally see the chromosomes (post-edit: I only learned after the fact that there are no chromosome annotations, only up till scaffold). NOW the main issue is I have to build an alias file for my alignment files because the NCBI annotations for chromosomes are totally different from what IGV uses. WHY I don't know. But now that there's a concrete solution to this I can finally sleep. 

Post-edit: 
Tablet is a much easier browser to use. 


				
