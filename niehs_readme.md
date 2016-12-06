JJPark

Project: NIEHS UCD-LSU
 
RNASeq Analysis

Last modified: 5 December, 2016

####Retrieving raw read data from Slim (UC Davis Genome Center Server)

Shell scripts: 
	
		getdata.sh
		getdata2.sh

Command to execute bash script on Farm cluster:

	sbatch -p hi getdata.sh

######Downloading lanes 3-8:
15 September 2016

Used a series of wget bash scripts to download each lane. 

		getdata2.sh 
		...
		getdata7.sh
		
The first download of lane cbt64b3g2h might have corrupted the files, so I moved the first batch of downloaded files to: 

		/home/jajpark/niehs/Data/lanes_3-8/weirdfiles/
		
And re-downloaded the data into:

		/home/jajpark/niehs/Data/lanes_3-8/ReDLData/
		

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


Sample 146 is actually Sample 145 with Sample 145's barcodes. Sample 173 is actually Sample 75 with Sample 75's barcodes. The reason there's nothing sequenced in Sample 146 and Sample 173 is because I listed their *correct* barcodes on the submission form. 

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
	
Results located in 

	/home/jajpark/niehs/results/pretrimfastqc/lanes_1-2/

#####Lanes 3-8:

	0001a_fastqc.sh
	...
	0001f_fastqc.sh
	
Results located in:

	/home/jajpark/niehs/results/pretrimfastqc/lanes_3-8/
		
		

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

I used trimmomatic again on raw reads using NEBNextAdapt.fa as the adapter file as well, but the resulting FastQC and numbers from the screen print from both trimmomatic runs look the same.

The .fa files are located: 

	~/programs/Trimmomatic-0.36/adapters

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

	
#####Notes on doing this on Lanes 3-8:
September 13, 2016

I changed the name of the directories containing the raw data from lanes 1-2 and lanes 3-8. These must remain separated because lanes 1-2 are denoted with L005 and L006, respectively, and the last two lanes in lanes_3-8 are also denoted with these same identifiers. 

		0002_trimmomaticNEB.sh
		
		##Some of the raw data (from folder cbt64b3g2h) that I dl'd was corrupted, so I ran it again on re-downloaded data:
		0002b_trimmomaticNEB.sh 

The absolute path for raw data from lanes 1-2:

	/home/jajpark/niehs/Data/lanes_1-2/
	
The absolute path for raw data from lanes 3-8:
	
	/home/jajpark/niehs/Data/lanes_3-8/
	
The absolute path for trimmed data from lanes 1-2:

	/home/jajpark/niehs/Data/nebtrim_lanes_1-2/
	
The absolute path for trimmed data from lanes 3-8:
	
	/home/jajpark/niehs/Data/nebtrim_lanes_3-8/
	
After running trimmomatic on the raw data, I moved the raw data that I re-downloaded for Lane 3 into /nebtrim_lanes_3-8. All raw data in the larger folder are now good to use. 
	
	
###FastQC on trimmed data

FastQC was performed on trimmed reads. 

	/home/jajpark/niehs/results/nebtrim_fastqc/

The resulting FastQC files are found in: 

	/home/jajpark/niehs/results/nebtrim_fastqc/lanes_1-2/
	/home/jajpark/niehs/results/nebtrim_fastqc/lanes_3-8/
	

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
		
######Edit (Sep 30, 2016)######
STAR aligner produces much higher alignment rates (~80%) and only took a few hours to run. I'll move forward with these alignments for my analyses. 

######Edit:16 November, 2016#####

I didn't include genome annotation in the index build and mapping, and the manual says it's important to include it for improving accuracy of mapping. I re-built my genome index using the annotation file: 

		~/niehs/align/star-gen-hetannot/GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.gff
		
using the following script: 

	0003c_starindex_hexannotate.sh
		
#####Mapping reads from Lanes 3-8 to reference F. heteroclitus genome and F. grandis genome (Sep 26, 2016)

I indexed the referenge genome from F. grandis:

		0004a_starindex_grandis.sh

The script for aligning to the F. grandis reference genome is:
		
		0004b_staralign_grandish_1-2.sh
		0004b_staralign_grandis_3-8.sh

I aligned lanes 1-2 to the F. grandis reference genome and compared alignment statistics with that from the alignment to F. heteroclitus genome. (See R code listed in Visualizing Alignment Stats.)

I used the following script to align lanes 3-8 to the F. heteroclitus reference genome: 

		0004b_staralign_het_3-8.sh
		
######Edit: 16 November 2016
I realigned using the genome index generated with annotation file (see edit in above section).

	0004d_staralign_hetannot_3-8.sh
	0004d_staralign_hetannot_1-2.sh

######Edit: 	28 November 2016
In future alignments, use the --outSAMattrRGline flag with STAR. 
You can also use the --outSAMtype flag to specify SAM/BAM output with/out sorting. 
	

#####Output(September 30, 2016)

The output is multiple files: 

* Aligned.out.sam 
* Log.final.out
* Log.out
* Log.progress.out
* out.tab
* STARtmp

###Alignment stats
September 30, 2016

Use samtools to: 

* convert STAR sam files into bam. 
* sort bam files
* filter alignments based on mapping quality

Use RSeQC to get more alignment stats. 


###Visualizing alignment stats
I wanted to know mapping efficiency across all my samples, so I parsed out alignment statistics from the STAR final log out files: 

	/home/jajpark/niehs/scripts/star_out_parse.py
	
	output: /home/jajpark/niehs/Data/alignmentstats/star_alignment_stats.txt

The compiled R notebook for generating these graphs are found on local:

	~/GoogleDrive/LabNotebook/NIEHS_LSU_UCD/rnaseq/Ranalysis/alignmentstats_bargraph.html
	

#####Compare alignment stats between F. grandis and F. heteroclitus alignments
(September 26, 2016)

Aligning to F. grandis genome yielded slightly higher alignment rates: 

	mean(hetmapped)
	# 84.813

	median(hetmapped)
	# 85.14

	range(hetmapped)
	# 57.81 89.39
	
	mean(grandmapped)
	# 87.23

	median(grandmapped)
	# 87.86

	range(grandmapped)
	# 61.15 91.13

Not sure how much of the grandis genome is annotated (need to ask Cole Matson). (Post-edit 11/14/16: The genome isn't annotated yet.) Just in case I'll have alignments using both heteroclitus and grandis genomes. 


#####Compare alignment stats between F. heteroclitus without and with annotation included in STAR genome indexing
(November 18, 2016)

I re-did the alignments using a genome index I built including .gff file. I compared the summary statistics using the same R script (alignmentstats_bargraph.R) as above:

	mean(hetmapped)
	# 85.08952
	
	median(hetmapped)
	# 85.35978
	
	range(hetmapped)
	# 60.14234 91.33387
	
I have slightly higher alignment rate using the annotation than without. 

###Visual QC of alignment


I got IGV to work, but I'm not sure I'm using the right files because I can't make any sense of what's going on. I don't have chromosomes, instead I'm getting list of scaffolds. (Post edit 11/14/16: It's because the annotations are only up to the scaffold level.)

		
Today was a slow and arduous day of reading through many outdated tutorials on WHAT to do with alignment files. It seems like the tools are so widely used that nobody botehrs to spell things out for people like me, or they don't bother to update the manuals as new versions of the tools are released. I can't find a decent tutorial on the UCSC genome browser for the life of me, and it's impossible to know why IGV is listing scaffolds instead of chromosomes (Post-edit 11/14/16: now I know LOL). Underneath all of this, I still don't know if it was wise to use the NCBI/refseq reference genome for my alignment, since it seems it's a more conservative(?) alignment (Post-edit 11/14/16: This is a fine reference genome to use, because I'm getting ~80% alignment rate using STAR aligner, which is not much different from aligning to the F. grandis reference transcriptome). 


I just need to check coverage across the genome to make sure I don't have any blaring red flags in order to give the genome center the green light for further lanes of sequencing. 
		
		
OK so I restarted IGV and somehow the reference genome fixed itself and I can finally see the chromosomes (post-edit: Not sure how this happened, since I only have up to scaffold annotations). Now the main issue is that I have to build an alias file for my alignment files because the NCBI annotations for chromosomes are totally different from what IGV uses. WHY I don't know. But now that there's a concrete solution to this I can finally sleep. 

Post-edit: 
Tablet is much easier to use. 

###Post-Alignment Quality Control 
15 November, 2016

The first thing I need to do is merge bam files according to Sample ID across multiple lanes. 

I converted sam to bam, and sorted the bam files using:

		0005a_sambamsort_samtools.sh
		
Resulting output files are named like $sampleAligned.out.bam in:

		~/niehs/results/alignments/star_heteroclitus_annot_161116/lanes_1-2/
		~/niehs/results/alignments/star_heteroclitus_annot_161116/lanes_3-8/
		
In order to merge my bam files, I need @RG information for all my files. It turns out that there is a flag in STAR that allows for @RG specification, but because I missed that memo I'll have to use Picard Tools to add @RG information to my alignment files. 
		
		
I loosely based the @RG fields off of the [GATK guide](https://software.broadinstitute.org/gatk/guide/article?id=6472) on read group fields requirements. Below are what I used: 

	ID = sample name _ lane number
	This tag identifies which read group each read belongs to, so each read group's ID must be unique. It is referenced both in the read group definition line in the file header (starting with @RG) and in the RG:Z tag for each read record. Note that some Picard tools have the ability to modify IDs when merging SAM files in order to avoid collisions. In Illumina data, read group IDs are composed using the flowcell + lane name and number, making them a globally unique identifier across all sequencing data in the world. Use for BQSR: ID is the lowest denominator that differentiates factors contributing to technical batch effects: therefore, a read group is effectively treated as a separate run of the instrument in data processing steps such as base quality score recalibration, since they are assumed to share the same error model.
	
	PU = Platform Unit (e.g. x)
		
	SM = Sample (e.g. ARSC32191, or ARS, ParentControl, 32% oil dose, stage 19, rep 1)
	The name of the sample sequenced in this read group. GATK tools treat all read groups with the same SM value as containing sequencing data for the same sample, and this is also the name that will be used for the sample column in the VCF file. Therefore it's critical that the SM field be specified correctly. When sequencing pools of samples, use a pool name instead of an individual sample name.
	
	PL = Platform/technology used to produce the read (e.g. Illumina)
	This constitutes the only way to know what sequencing technology was used to generate the sequencing data. Valid values: ILLUMINA, SOLID, LS454, HELICOS and PACBIO.
	
	LB = GATK says DNA preparation library identifier, but because each sample is its own library, I used lane number (e.g. L001)
	MarkDuplicates uses the LB field to determine which read groups might contain molecular duplicates, in case the same DNA library was sequenced on multiple lanes.
	

I used PicardTools in the following script, and moved all bam files with @RG to the following directory:

	0006a_addRG_lanes1-2.sh
	0006b_addRG_lanes3-8.sh
	~/niehs/results/alignments/star_heteroclitus_annot_161116/withRG/


3. Merge sorted STAR bam files from across different lanes into one big bam file:
     * There are a number of different programs to use for this step (samtools merge, bamtools merge, picardtools)
     
I used samtools merge in the following script and moved all merged bam files into the following directory:

	0007_mergebam.sh
	~/niehs/results/alignments/star_heteroclitus_annot_161116/merge/
	
	


(Sometime in August, using TopHat2 aligned sam files)
I used samtools to sort and index my accepted_hits.bam file. 
Then I used the bedtools genomecov ()genomeCoverageBed) package to calculate coverage across my reference genome. (Post-edit: wasn't sure if I got it to work and didn't really know what I was looking at and abandoned it for the time being. )
I used the UCSC genome browser and IGV to visualize this data. 

###Perform annotation-based quality control
* RSeQC
* Picard's CollectRNASeqMetrics

###Perform quantitation of gene expression
* HTSeq

###Differential Expression Analysis
* edgeR or DESeq2? What are the differences and why are they important?

###


