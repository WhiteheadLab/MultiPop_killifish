### Experimental Design:
* 5 populations of Fundulus grandis were collected across the Gulf of Mexico, only ARS RNA-seq data so far: 
   * ARS: Aquatic Research Station, aquacultured pop in LA
   * GT: Grand Terre, recently oiled pop in LA
   * VB: Vince Bayou, industrial pollution pop from Houston Ship Channel
   * GB: Gang's Bayou, clean ref pop near Houston Ship Channel
  
* Adult fish were cultured in lab conditions for 1-2 generations before experiment
* Parent treatment: Adult fish were exposed to WAF or clean/control water for ~60 days before spawning
* Embryo exposure dosage: Embryos were exposed to WAF 00%, 10%, 32%, or 56% for 21 days
* Embryo developmental stage: Embryos were sampled for RNA-seq at stages 19, 28, 35, or hatch
     * Leftover embryos that were unhatched at the end of 21 days were collected as non-hatched (NH)
* Up to 5 replicates were sequenced for each treatment
* File naming convention: 
     * [SampleNumber, 4 digits] ARS [ParentTreatment, 1 letter] [Embryo exposure %, 2 digits] [Developmental Stage, 2 digits] [ReplicateNumber 1-5] 
     * Sample Number: unique number assigned to each embryo sequenced
     * ARS: population of F. grandis
     * Parent Treatment: Exposed (E) or Control (C)
     * Embryo exposure: 0, 10, 32, or 56%
     * Developmental Stage: 19, 28, 35, or HA
     * Replicate Number: Single digit, 1-5
* Samples 75, 145, 146, and 163 should be excluded from analysis due to barcoding error (see "Identifying samples that didn't get sequenced in the first lane trial")


###  General Pipeline:

* [Download reference genome](https://github.com/janejpark/niehs/blob/master/niehs_readme.md#downloading-reference-genome)
* [Retrieve raw reads from the sequencing facility](https://github.com/janejpark/niehs/blob/master/niehs_readme.md#retrieving-raw-read-data-from-slim)
* [Running FastQC](https://github.com/janejpark/niehs/blob/master/niehs_readme.md#running-fastqc)
* [Trim short reads with Trimmomatic](https://github.com/janejpark/niehs/blob/master/niehs_readme.md#trim-short-reads-with-trimmomatic)
* [Map reads using STAR aligner](https://github.com/janejpark/niehs/blob/master/niehs_readme.md#mapping-reads-to-reference-genome-and-transcriptome-using-star)
* [Visualize alignment stats](https://github.com/janejpark/niehs/blob/master/niehs_readme.md#visualizing-alignment-stats)
* [Visual QC of alignment](https://github.com/janejpark/niehs/blob/master/niehs_readme.md#visual-qc-of-alignment)
* [Post-alignment Quality Control](https://github.com/janejpark/niehs/blob/master/niehs_readme.md#post-alignment-quality-control)
* Differential expression analysis in R


#### Retrieving raw read data from Slim (UC Davis Genome Center Server)

Shell scripts: 
	
		getdata.sh
		getdata2.sh

Command to execute bash script on Farm cluster:

	sbatch -p hi getdata.sh

###### Downloading lanes 3-8:
15 September 2016

Used a series of wget bash scripts to download each lane. 

		getdata2.sh 
		...
		getdata7.sh
		
The first download of lane cbt64b3g2h might have corrupted the files, so I moved the first batch of downloaded files to: 

		/home/jajpark/niehs/Data/lanes_3-8/weirdfiles/
		
And re-downloaded the data into:

		/home/jajpark/niehs/Data/lanes_3-8/ReDLData/
		

#### Identifying samples that didn't get sequenced in the first lane trial

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


Sample 146 is actually Sample 145 with Sample 145's barcodes. Sample 173 is actually Sample 75 with Sample 75's barcodes. The reason there's nothing sequenced in Sample 146 and Sample 173 is because I listed the corresponding barcodes for 146 and 173 (which never got used) on the submission form. 

Because the barcodes for Sample 75 are also used for Sample 163, I essentially have double the amount of reads for Sample 163 (I can already see that in the demultiplexed file). Half of those reads are actually from Sample 75, but there's no way to tell those apart from Sample 163. 


I don't see double the amount of reads for Sample 145, however. For now, I'll accept that they're missing until after the preliminary analyses. I will also leave out Sample 163 in my analyses. If preliminary analyses indicate that that particular sample and treatment is important, I'll include it in future sequencing runs when making libraries for other populations. 

Sample 6 and 94 were made with barcodes i712 and i508, NOT i701 and i506 like they should have been.  

Samples removed from analysis: 
75, 145, 146, 163

### Running FastQC
FastQC is a raw read quality assessment command line tool.
I loaded the program using:

	module load fastqc
	
I used the following scripts to generate FastQC results for samples 0001-0088 and 0089-0176, respectively: 

	fastqctest_0001-0088.sh
	fastqctest1.sh
	sbatch -p hi fastqctest1.sh
	
Results located in 

	/home/jajpark/niehs/results/pretrimfastqc/lanes_1-2/

### ##Lanes 3-8:

	0001a_fastqc.sh
	...
	0001f_fastqc.sh
	
Results located in:

	/home/jajpark/niehs/results/pretrimfastqc/lanes_3-8/
		
		

### Retrieving reads from Undetermined Samples file, a.k.a. demultiplexing indexed reads
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

### Trim short reads with trimmomatic
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

The final script used to trim my reads is found at:
`/home/niehs/scripts/trimmomaticNEB.sh`
	
##### Notes on doing this on Lanes 3-8:
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
	
	
### FastQC on trimmed data

FastQC was performed on trimmed reads. 

	~/niehs/results/nebtrim_fastqc/

The resulting FastQC files are found in: 

	~/niehs/results/nebtrim_fastqc/lanes_1-2/
	~/niehs/results/nebtrim_fastqc/lanes_3-8/
	

### Downloading reference genome
For some reason ftp wasn't working as I expected on the farm cluster, so I used ftp on my personal laptop to download the latest reference genomes from ncbi (ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_other/Fundulus_heteroclitus/latest_assembly_versions/GCF_000826765.1_Fundulus_heteroclitus-3.0.2):

		ftp ftp://ftp.ncbi.nlm.nih.gov
		cd genomes/vertebrate_other/Fundulus_heteroclitus/latest_assembly_versions/GCF_000826765.1_Fundulus_heteroclitus-3.0.2
		mget *
		
Then I used scp to move all the files into my account on farm. 

### Mapping reads to reference genome using Bowtie2 and TopHat2

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


### Mapping reads to reference genome and transcriptome using STAR

I decided to try using STAR, which is apparently very fast and ascertains splice junctions on its own (independent of annotations). I wanted to compare alignment rates between a reference genome from NCBI refseq, and a reference transcriptome that Noah had used in the past for his RNAseq work. 

First I indexed the reference genome and transcriptome:

		starindex.sh		
Then I started the alignment processes using each:

		stargenomicalign.sh
		startranscralign.sh		
		
###### Edit (Sep 30, 2016)

STAR aligner produces much higher alignment rates (~80%) and only took a few hours to run. I'll move forward with these alignments for my analyses. 

###### Edit:16 November, 2016

I didn't include genome annotation in the index build and mapping, and the manual says it's important to include it for improving accuracy of mapping. I re-built my genome index using the annotation file: 

		~/niehs/align/star-gen-hetannot/GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.gff
		
using the following script: 

	0003c_starindex_hexannotate.sh
		
### Mapping reads from Lanes 3-8 to reference F. heteroclitus genome and F. grandis genome (Sep 26, 2016)

I indexed the referenge genome from F. grandis:

		0004a_starindex_grandis.sh

The script for aligning to the F. grandis reference genome is:
		
		0004b_staralign_grandish_1-2.sh
		0004b_staralign_grandis_3-8.sh

I aligned lanes 1-2 to the F. grandis reference genome and compared alignment statistics with that from the alignment to F. heteroclitus genome. (See R code listed in Visualizing Alignment Stats.)

I used the following script to align lanes 3-8 to the F. heteroclitus reference genome: 

		0004b_staralign_het_3-8.sh
		
###### Edit: 16 November 2016
I realigned using the genome index generated with annotation file (see edit in above section).

	0004d_staralign_hetannot_3-8.sh
	0004d_staralign_hetannot_1-2.sh

###### Edit: 28 November 2016
In future alignments, use the --outSAMattrRGline flag with STAR. 
You can also use the --outSAMtype flag to specify SAM/BAM output with/out sorting. 
	

##### Output(September 30, 2016)

The output is multiple files: 

* Aligned.out.sam 
* Log.final.out
* Log.out
* Log.progress.out
* out.tab
* STARtmp

### Alignment stats
September 30, 2016

Use samtools to: 

* convert STAR sam files into bam. 
* sort bam files
* filter alignments based on mapping quality

Use RSeQC to get more alignment stats. 


### Visualize alignment stats
I wanted to know mapping efficiency across all my samples, so I parsed out alignment statistics from the STAR final log out files: 

	/home/jajpark/niehs/scripts/star_out_parse.py
	
	output: /home/jajpark/niehs/Data/alignmentstats/star_alignment_stats.txt

The compiled R notebook for generating these graphs are found on local:

	~/GoogleDrive/LabNotebook/NIEHS_LSU_UCD/rnaseq/Ranalysis/alignmentstats_bargraph.html
	

##### Compare alignment stats between F. grandis and F. heteroclitus alignments
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


##### Compare alignment stats between F. heteroclitus without and with annotation included in STAR genome indexing
(November 18, 2016)

I re-did the alignments using a genome index I built including .gff file. I compared the summary statistics using the same R script (alignmentstats_bargraph.R) as above:

	mean(hetmapped)
	# 85.08952
	
	median(hetmapped)
	# 85.35978
	
	range(hetmapped)
	# 60.14234 91.33387
	
I have slightly higher alignment rate using the annotation than without. 

### Visual QC of alignment


I got IGV to work, but I'm not sure I'm using the right files because I can't make any sense of what's going on. I don't have chromosomes, instead I'm getting list of scaffolds. (Post edit 11/14/16: It's because the annotations are only up to the scaffold level.)

		
Today was a slow and arduous day of reading through many outdated tutorials on WHAT to do with alignment files. It seems like the tools are so widely used that nobody botehrs to spell things out for people like me, or they don't bother to update the manuals as new versions of the tools are released. I can't find a decent tutorial on the UCSC genome browser for the life of me, and it's impossible to know why IGV is listing scaffolds instead of chromosomes (Post-edit 11/14/16: now I know LOL). Underneath all of this, I still don't know if it was wise to use the NCBI/refseq reference genome for my alignment, since it seems it's a more conservative(?) alignment (Post-edit 11/14/16: This is a fine reference genome to use, because I'm getting ~80% alignment rate using STAR aligner, which is not much different from aligning to the F. grandis reference transcriptome). 


I just need to check coverage across the genome to make sure I don't have any blaring red flags in order to give the genome center the green light for further lanes of sequencing. 
		
		
OK so I restarted IGV and somehow the reference genome fixed itself and I can finally see the chromosomes (post-edit: Not sure how this happened, since I only have up to scaffold annotations). Now the main issue is that I have to build an alias file for my alignment files because the NCBI annotations for chromosomes are totally different from what IGV uses. WHY I don't know. But now that there's a concrete solution to this I can finally sleep. 

Post-edit: 
Tablet is much easier to use. 

### Post-Alignment Quality Control 
15 November, 2016

The first thing I need to do is merge bam files according to Sample ID across multiple lanes. 

I converted sam to bam, and sorted the bam files using:

		0005a_sambamsort_samtools.sh
		
Resulting output files are named like `$sampleAligned.out.bam` in:

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

### Perform annotation-based quality control
Last modified: 14 December, 2016

There are several tools available for doing some post-alignment QC. They seem to offer similar things, but require different file formats. Picard's CollectRNASeqMetrics uses a REF_FLAT file which I have no idea how to obtain from the GFF files I downloaded from NCBI, so I decided not to go down that route. 

[RSeQC](http://rseqc.sourceforge.net/) is presented at length in the textbook I'm using (RNA-Seq Data Analysis: A Practical Approach, by Korpelainen et al.), and it's available on the Farm cluster. I'll go ahead and use that. 

There are 4 [input file formats](http://rseqc.sourceforge.net/#input-format) accepted: bed, bam/sam, fasta, and chromosome size file. I don't know how this is going to work if I don't have chromosome-level annotations, but I'll worry about that when I get there. 

BAM files must be sorted and indexed. 

		0008a_sortindex.sh
		
##### Converting GFF to BED
I have to first convert my GFF/GTF annotation files to BED. Most people use awk to make their BED files from GFF, but because the RSeQC program needs a 12-column bed file, I decided to use a tool called [bedops](http://bedops.readthedocs.io/en/latest/index.html) for this task. 

I installed bedops using brew on 14 Dec, 2016

	brew install homebrew/science/bedops
	
Bedops was installed in:

	~/linuxbrew/.linuxbrew/Cellar/bedops/2.4.20/bin

The command used to convert gff to bed:
	
	convert2bed -i gff -o bed <~/niehs/refseq/GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.gff> ~/niehs/refseq/GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.bed

##### Using RSeQC

RSeQC has been installed on the farm, and is available as a module. 
It's important to load all the modules:
		
		module load python R RSeQC
		
However, the code for installation test and any other command on RSeQC is throwing an error message: 

		Illegal instruction
		
I sent an email to Terri for help. 

[Edit: it turns out I was sourcing python from my local home directory, so I got rid of python from local and it solved the problem]

Eventually I'll use: 
		
		geneBody_coverage.py -r ~/niehs/refseq/GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.bed -i /results/alignments/star_heteroclitus_annot_161116/merge/ -o rseqc/output
		
### Make read counts -- quantitate!
There are many different ways to quantitate read counts/generate read count tables. 

Salmon requires that aligned files (SAM/BAM) are generated using a reference transcriptome. I've already mapped my reads to a reference genome, so I need to work around this in order to use the tool. 
I
1. Convert bam to fastq file
	* bedtools: sort bam by read group or name using samtools sort -n 
	
			$ samtools sort -n aln.bam aln.qsort

			$ bedtools bamtofastq -i aln.qsort.bam \
                      -fq aln.end1.fq \m
                      -fq2 aln.end2.fq

2. Run Salmon in the light-mapping mode with reference transcriptome

For future DE experiments, it would be better just to run salmon right after raw read QC, since it bypasses the need for aligners via its quasi-mapping function (theoretically).  

For now I don't want to waste anymore time re-generating fastq files and having salmon re-map my reads, so I'll move forward with HTSeq, which has been around for much longer and is already an established method for generating read counts. 

The command and options for HTseq are below: 

	htseq-count --format=bam -i Dbxref -t exon $f $gff > ${OUTDIR}/$count

Because my annotation is a GFF and Htseq looks by default at GTF files, the default id_attribute argument is "gene_id". HOwever, my gff file doesn't have that, and the most informative field in column 9 is "Dbxref". 

I used "ID" at first, but later realized that that field is rather uninformative. From the [NCBI Refseq GFF3 readme](ftp://ftp.ncbi.nlm.nih.gov/genomes/README_GFF3.txt): 

	`ID
	
	A unique identifier for the feature. Most IDs are generated on-the-fly 
	   during file generation. They are not intended to be used as stable feature
	   identifiers, and they are likely to change between annotation versions. 
	   Multiple rows with the same ID designate a single feature that is 
	   composed of multiple parts, most common for CDSes and multi-exon alignments 
	   but possible for other feature types as well. Note other attributes such as 
	   gene symbols, GeneIDs, and transcript or protein accessions may occur on 
	   multiple features, whereas the ID is globally unique for an individual file.`
   
   
	Parent
	   ID of the parent of the feature
	   
	Dbxref
	   a set of comma-separated tag:ID pairs corresponding to the /db_xref
	   qualifiers provided in the source annotation. Note database IDs can contain
	   colons, so a format such as "HGNC:HGNC:1100" is expected and should be 
	   parsed on the first colon. URLs corresponding to specific database tags are 
	   available at:
	   https://www.ncbi.nlm.nih.gov/genbank/collab/db_xref   
	   
	   Most Dbxref tags known to NCBI are also available in the list provided by
	   the Gene Ontology Consortium at:
	   ftp://ftp.geneontology.org/pub/go/doc/GO.xrf_abbs
	
However, not all exons have Dbxref fields, although every entry in the gff has an ID field. All genes have Dbxref fields, but I'm not sure how many reads I'll miss by aligning to genes. This will be my temporary solution:

1. Generate read counts using --type=exon ... -i ID
2. Generate read counts uisng --type=gene ... -i Dbxref

That way I'll at least have one read counts table with a lot of hits, and I can see if I can look up annotation information from matching ID values in the gff file, and I can have another read counts table with informative annotation tags. 

...

A better solution to this would be to find all exons with missing Dbxref fields and delete them from the annotation file, then run htseq again. 

- "awk" or "grep" to find exons with Dbxref in same line
- check how many there are from above with total exons
- if its' not too much, then pipe all exon lines with dbxref to new annotation file. 


		grep -c exon GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.gff 
		#416781
		
		grep -i exon GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.gff > 17_01_04_exons.gff
		
		grep -v -i -c dbxref 17_01_04_exons.gff 
		#24
		
		grep -v -i dbxref 17_01_04_exons.gff > 17_01_04_questionable_exons.gff
		
		grep -i dbxref 17_01_04_exons.gff > 17_01_04_dbxref_exons.gff

The exons missing dbxref annotations all produce tRNAs, and can be viewed in `~/niehs/refseq/17_01_04_questionable_exons.gff`. 

I have a modified gff file containing just exons with dbxref annotations, found in `~/niehs/refseq/17_01_04_dbxref_exons.gff`. 

I also made a modified gff file of all features minus the questionable exons in `~/niehs/refseq/170104_fhet_genomic.gff`

	grep -Fwv -f 17_01_04_questionable_exons.gff GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.gff > 170104_fhet_genomic.gff
	
I ran htseq again using the modified gff file ``~/niehs/refseq/170104_fhet_genomic.gff` using: 

		0009c_htseqcount_dbxrefexons.sh
		
__27 February, 2017:__

Re-did count summarization using HTSeq on gene ID and featurecounts.

### Differential Expression Analysis
* limma voom: see 

		0010a_edgeR_htseq.R

* Use edgeR to make DGElist object containing sample and counts information.

* Another option is to write my own function in R after transforming/normalizing 

__27 March, 2017:__

Over the last week, I used limma to look at DE genes for following tests:

1. Parent Treatment x Dev.Stage interaction at 00% WAF (grouped across all stages)
2. PT x Dose interaction at stages 35 and HA (independently), for each dose (so 4 tests per stage). 

I'm getting ~9,000 genes that are DE due to PT x Dev interaction. The heatmap of trtment means for every gene wasn't very informative, so I'm going too look at volcano plot to see distribution of log-FCs, and use log-FC as another criteria for determining DE. 

Another thing to consider while re-doing the limma analysis would be to try more stringent raw count filtration and `voomWithQualityWeights` to remove heteroscadicisity (sp?). My reservation about more stringent 0 count filtration is that the replicate size for each treatment is 5 samples. Much of the variance is driven by development. Would this look different if I looked at mean-variance for each stage? 

I re-ran the model fitting using `voomWithQualityWeights`, and it didn't change the numbers of differentially expressed genes too much, or improve heteroscadisticity around the mean-variance trend. Still, it looks like there are more DE genes found using `voomWithQualityWeights`

		summary(results)
		# using regular voom
		> summary(results)
	   Intercept C.19.10 C.19.32 C.19.56 C.28.00 C.28.10 C.28.32 C.28.56 C.35.00
	-1         0       1       0       2     837     599    1163     847    3645
	0       9325   24659   24661   24657   22390   23056   21971   22478   15471
	1      15337       2       1       3    1435    1007    1528    1337    5546
	   C.35.10 C.35.32 C.35.56 C.HA.00 C.HA.10 C.HA.32 C.HA.56 E.19.00 E.19.10
	-1    3367    3465    3743    3135    2718    2621    2988       1       0
	0    15972   15896   15423   17043   17453   18247   17609   24657   24658
	1     5323    5301    5496    4484    4491    3794    4065       4       4
	   E.19.32 E.19.56 E.28.00 E.28.10 E.28.32 E.28.56 E.35.00 E.35.10 E.35.32
	-1       2     195     866     874     908    1059    3084    3039    4132
	0    24655   24286   22293   22502   22196   21763   17295   17197   14941
	1        5     181    1503    1286    1558    1840    4283    4426    5589
	   E.35.56 E.HA.00 E.HA.10 E.HA.56
	-1    2886    2314    2870       0
	0    17609   18819   17295   24660
	1     4167    3529    4497       2
	
	
	#using voomWithQualityWeights
		> summary(resultsqw19)
	   Intercept C.19.10 C.19.32 C.19.56 C.28.00 C.28.10 C.28.32 C.28.56 C.35.00
	-1         0       1       0       3    1400     816    1691    1142    4101
	0      10328   24657   24662   24653   21153   22515   21032   21823   14491
	1      14334       4       0       6    2109    1331    1939    1697    6070
	   C.35.10 C.35.32 C.35.56 C.HA.00 C.HA.10 C.HA.32 C.HA.56 E.19.00 E.19.10
	-1    4155    4422    4461    3198    3025    2689    2818       2       2
	0    14339   14418   14305   16545   16728   17705   17706   24643   24654
	1     6168    5822    5896    4919    4909    4268    4138      17       6
	   E.19.32 E.19.56 E.28.00 E.28.10 E.28.32 E.28.56 E.35.00 E.35.10 E.35.32
	-1       5       1    1275    1050    1159    1694    3102    3339    4838
	0    24639   24657   21310   22106   21713   20481   17084   16428   13702
	1       18       4    2077    1506    1790    2487    4476    4895    6122
	   E.35.56 E.HA.00 E.HA.10 E.HA.56
	-1    2804    2506    2973       2
	0    17735   18179   16797   24651
	1     4123    3977    4892       9

It looks like there are very few DE genes between stage 19 treatments. I thought this might be because most of the variance in the data seems to be driven by stage. I wanted to see if re-fitting a model for just stage 19 samples will give me different results. I used data from stage 19, and also using voomWithQualityWeights:

	> summary(resultsqw19)
   	Intercept C.19.10 C.19.32 C.19.56 E.19.00 E.19.10 E.19.32 E.19.56
	-1         0       0       2       3       2       4       5       0
	0      10805   24660   24659   24650   24622   24650   24644   24661
	1      13857       2       1       9      38       8      13       1
	
Having a separate model by stage seems to reduce number of DE genes relative to the intercept. In any case, this may end up proving more useful in the later steps of analysis, when disentangling interaction terms. 

Stage 28:

	> summary(resultsqw28)
 		  Intercept C..10 C..32 C..56 E..00 E..10 E..32 E..56
	-1       876     0     1     1     0     0     5     2
	0       7305 24657 24655 24656 24661 24656 24647 24652
	1      16481     5     6     5     1     6    10     8
	
Stage 35:

	> summary(resultsqw35)
 	  Intercept C.35.10 C.35.32 C.35.56 E.35.00 E.35.10 E.35.32 E.35.56
	-1       686       0      44      11       0       5     178       2
	0       5663   24661   24574   24639   24662   24647   24444   24654
	1      18313       1      44      12       0      10      40       6
	

__28 March 2017__ 

*Separate models by stage*

Using the individual model for stage35 above, I looked at the PTxDose interaction at 56% WAF. I compared that to the topTable result made previously from a 1-model system. At a closer look, I discovered that there were no significantly DE genes with adj. p value < 0.1 from the previous attempt. Whoops. Using the stage-specific model gave me a lot of significant DE genes (~14000). I ran the list through DAVID for functional annotation clustering. There were too many genes for cluster analysis, but I was able to view the chart. There are 814 genes that fall under "organic cyclic compound binding". The same interesting genes that I found for PTxDev DE genes were found here: estrogen receptor, cytochrome P450, arnt1, male germ cell kinase, neuronal differentiation 1. 

On closer look at the logFC, it looks really weird:

	topTable(contfit35, coef="w56", sort.by="P")
	             logFC  AveExpr        t      P.Value    adj.P.Val        B
	105932013 14.25606 13.66335 28.83183 5.599787e-33 1.381020e-28 62.12788
	105937865 12.47171 12.32740 27.26548 7.909253e-32 9.752900e-28 59.53038
	105921637 12.51972 11.62708 25.67121 1.347662e-30 1.041038e-26 56.99284
	105916096 13.91693 13.29394 25.50606 1.823490e-30 1.041038e-26 57.09129
	105931060 13.52156 12.72475 25.42652 2.110611e-30 1.041038e-26 56.84609
	105939000 15.13203 14.46505 24.80594 6.696218e-30 2.380655e-26 56.08876
	105927076 12.25369 12.09353 24.80112 6.757192e-30 2.380655e-26 55.70147
	105921217 11.10064 10.95896 24.47194 1.259329e-29 3.882196e-26 54.83461
	105925241 10.10908 10.08075 24.35411 1.576421e-29 4.319744e-26 54.47981
	105930710 11.20287 11.61188 24.01456 3.026721e-29 7.242479e-26 54.22836
	
But `topTable` using unified model and pulling out dose effect at 56% gives more reasonable logFC: 

	topTable(fit3556)
	              logFC      AveExpr         t      P.Value    adj.P.Val         B
	105936775  4.479790  0.152795599  6.895875 1.757023e-10 4.333171e-06 12.138112
	105930482 -4.473471  8.458702764 -5.952411 2.070574e-08 1.702150e-04  8.941065
	105929940 -4.692090  2.105728025 -6.040389 1.347609e-08 1.661736e-04  8.397469
	105939523 -2.093701 10.359492295 -5.744157 5.644430e-08 3.480073e-04  7.772681
	105932497  4.147859  3.364391927  5.379007 3.117502e-07 1.281397e-03  6.020681
	105936368 -4.511003  2.007941163 -5.398679 2.848062e-07 1.281397e-03  5.886317
	105931667  4.705631  1.306501198  4.675006 6.913639e-06 2.435774e-02  3.170620
	105932273  3.177862 -0.006818671  4.603544 9.322962e-06 2.773974e-02  2.931459
	105919173 -3.005268  0.483831788 -4.583734 1.012317e-05 2.773974e-02  2.883738
	105928563  3.358999  0.365081156  4.540860 1.208835e-05 2.981228e-02  2.733259
	
I'm not sure why having independent models is inflating my logFC and average expression. I might be subsetting the y object incorrectly by stage. 

I get a similar inflation of average expression and logFC when extracting interaction contrasts. 

	> e56 <- makeContrasts((E.19.56-E.19.00)-(C.19.56-Intercept), levels=design1)
	> e56f <- contrasts.fit(efit, e56)
	> e56f <- eBayes(e56f)
	> re56f <- decideTests(e56f)
	> summary(re56f)
	   (E.19.56 - E.19.00) - (C.19.56 - Intercept)
	-1                                           3
	0                                        13087
	1                                        11572
	> topTable(e56f)
	              logFC   AveExpr        t      P.Value    adj.P.Val        B
	105921665 11.488494 10.911254 29.87584 1.196537e-62 2.950899e-58 129.7285
	105930710 12.376979 11.762674 26.38871 3.148878e-56 3.882881e-52 116.0368
	105923754 12.722091 12.420111 25.20036 6.574248e-54 5.404470e-50 111.5159
	105936398 11.983826 11.052098 24.81793 3.796610e-53 2.340800e-49 109.1876
	105921217 11.152368 11.285832 24.07472 1.204396e-51 4.950468e-48 105.5543
	105937381 10.443410  9.564823 24.21916 6.120040e-52 3.018648e-48 105.2313
	105928962 10.148880  9.557919 23.92219 2.468554e-51 8.697068e-48 104.3923
	105934566 11.687234 11.197274 23.68443 7.597450e-51 2.342104e-47 104.3377
	105933124 10.383616 10.244375 23.40636 2.854051e-50 7.820735e-47 102.3620
	105918054  9.967542  9.299880 23.35656 3.620953e-50 8.929994e-47 101.3235

According to the limma user guide, I should be able to extract the same contrast when using the classic factorial equation, but I get rather different results: 

	> topTable(vfit, coef="E.exposure56")
	              logFC  AveExpr         t      P.Value   adj.P.Val        B
	105917294 -3.931277 6.878328 -5.773718 4.780072e-08 0.001178861 8.116851
	105929269 -5.284615 2.387163 -5.583166 1.181924e-07 0.001457430 7.237780
	105917783  5.909704 3.096009  5.341627 3.629113e-07 0.002622423 5.739069
	105940298  5.842474 4.869093  5.306927 4.253383e-07 0.002622423 5.676387
	105918932 -3.940197 4.238930 -5.165389 8.073589e-07 0.002982583 5.538375
	105933236 -3.180683 5.255047 -5.154821 8.465690e-07 0.002982583 5.497030
	105936064 -3.094511 7.922153 -5.178334 7.617315e-07 0.002982583 5.413435
	105921814 -3.916230 3.948750 -5.110663 1.031430e-06 0.003179640 5.331472
	105940024 -2.509924 7.339443 -5.081007 1.177036e-06 0.003225340 5.165495
	105926382 -2.841919 6.293465 -5.028096 1.487964e-06 0.003669617 4.936965

The p-values are also far greater than that calculated from the 1st method. 

What is going on?!?!!?!!? 

The coefficient "E.exposure56" should be the same as (E.56.00-E.19.00)-(C.56.00-C.19.00) according to the user guide. But the results of DE are clearly not the same. 

Next approach: 

* Seek help from another limma user
* Try using lm() on a top DE gene from one of the tests in limma, compare p-values or f-statistics??? Not sure how comparable it'll be if my data is normalized/transformed differently from voom...

__Update from 11 April 2017:__

I got the coefficients corrected on BioC support forum: 
<https://support.bioconductor.org/p/94684/#94711>

Aaron Lun's response: 

In your second approach, every coefficient other than the intercept represents the log-fold change of the corresponding group relative to the control-19 group. The (E.X - C.X) represents the log-fold change due to exposure at stage X, while E.19 represents the log-fold change due to exposure at stage 19. The difference between these two log-fold changes is the interaction term, which should be zero if the stage/exposure effects are purely additive.

I should also add that decideTests will report separate up/down statistics for each coefficient or column of the contrast matrix. This is not the same as the number of DE genes from dropping all coefficients at once, e.g., by running topTable with coef=NULL.

__14 April 2017: Comparing single model vs. stage-specific model__

* more genes are filtered out when using stage-specific model (specifically at stage 19). 
* More DGE detected for PTxDose interaction at stage 19 using single model vs. 19specific model. Are most of these genes filtered out in the beginning of 19specific analysis?
    * Compare vector of filtered out genes from 19specific analysis to rownames of topTable output in single model analysis. 

 8 of 214 DGE detected at st.19 for PTxDEV interaction using the single model are filtered out initially for st19-specific analysis

The DGE found in single model at st. 19 are still found in topTable of 19-specific model, but with higher p-values.

* So it looks like it comes down to the way test statistics are generated between the two models. A few genes are excluded in the stage-specific model that would otherwise still be included in the single model. Could this be a cause of contrasts.fit? 

At stage 35, using stage-specific model: 

	summary(tresults35)
	     w56   w32   w10
	-1     0   138     0
	0  23567 23305 23567
	1      0   124     0 

At stage 19 using stage-specific model: 

	summary(ixnresults19)
	     w56   w32   w10
	-1     0     1     0
	0  22234 22231 22234
	1      0     2     0


At stage 35, using allstage/unified model:

	summary(results35)
	     w56   w32   w10
	-1     0   121     1
	0  24662 24464 24661
	1      0    77     0

At stage 19 using allstage/unified model: 

	summary(results19)
	     w56   w32   w10
	-1    44     2     5
	0  24595 24658 24657
	1     23     2     0

topTable results of stage-specific model at stage 19, 56% WAF, subsetted by topTable results of unified model at stage 19, 56% WAF: 

	wptxdr.st19[singlemodel19,]
	              logFC     AveExpr         t      P.Value  adj.P.Val            B
	105940024 -2.380071  8.33276829 -4.177445 1.126267e-04 0.09830971  0.962509414
	105926074 -4.083222  3.90948893 -4.884168 1.026948e-05 0.06923963  3.147170944
	105929269 -4.144292  5.53802597 -4.268300 8.343405e-05 0.08833679  1.399856601
	105935506 -4.371201  3.26910012 -4.828546 1.245653e-05 0.06923963  2.940135282
	105916753 -3.439288  5.48071557 -4.351233 6.330571e-05 0.08279642  1.658709940
	105921814 -2.858100  6.71432198 -3.652719 6.024279e-04 0.15142437 -0.488340895
	105917783  5.264738  0.93730293  4.422555 4.984509e-05 0.08279642  1.592035863
	105936203 -5.633676  2.88375038 -4.524175 3.536879e-05 0.08068934  1.998350162
	105918068  4.736557 -0.34411087  4.408720 5.221691e-05 0.08279642  1.530341228
	105918932 -3.006710  5.98283244 -3.851881 3.226104e-04 0.13766487  0.143655586
	105936064 -2.206467 11.14682889 -3.941178 2.426251e-04 0.13428749  0.003184795
	105917294 -2.141225 10.93357289 -2.904713 5.381479e-03 0.23333846 -2.910135619
	105917711 -2.743697  5.38860281 -3.755816 4.368636e-04 0.13810716 -0.093797283
	105923711 -4.567731  1.19096961 -4.684030 2.050317e-05 0.07514875  2.350318695
	105940298  5.404554  1.21928557  3.720574 4.878188e-04 0.13810716 -0.293938151
	NA               NA          NA        NA           NA         NA           NA
	105926382 -1.879107  8.76183617 -3.381266 1.374437e-03 0.16762853 -1.428758933
	105926592 -2.523916  7.01362878 -3.203839 2.314674e-03 0.19437262 -1.771044346
	105936384 -3.360840  5.42166430 -3.634239 6.378568e-04 0.15249579 -0.448151789
	105926618 -4.682475  0.39511318 -4.836368 1.212340e-05 0.06923963  2.728954713
	105928627  4.228934  1.50023382  3.571753 7.730120e-04 0.15827686 -0.646834554
	105939954 -2.051219  6.60720400 -3.409439 1.263566e-03 0.16530262 -1.158585546
	105918611 -3.966311  2.04042711 -3.716368 4.942687e-04 0.13810716 -0.248187560
	105938803 -1.519920  6.54783057 -3.381726 1.372553e-03 0.16762853 -1.236722915
	105918296 -2.095529  7.30081626 -3.447614 1.126824e-03 0.16060481 -1.126033178
	105923230  4.779968 15.15362804  4.846872 1.168971e-05 0.06923963  2.579511803
	105935429 -2.205871  4.91184570 -3.596857 7.157137e-04 0.15827686 -0.527090212
	105934905  3.997112 -0.12459194  4.112819 1.391945e-04 0.10390249  0.751351864
	105921324 -1.870100  6.78536557 -3.719513 4.894378e-04 0.13810716 -0.295755256
	105938070  4.044256  0.05653822  4.296882 7.587918e-05 0.08435489  1.242342497
	105916657 -3.392817  3.16869824 -3.742677 4.552332e-04 0.13810716 -0.118106171
	105918462 -3.987413  3.10714129 -3.544919 8.390914e-04 0.15827686 -0.651053713
	105933236 -1.956058  7.97596576 -3.228744 2.153311e-03 0.19382304 -1.788644156
	105931628  2.537418  4.66668320  4.148623 1.238046e-04 0.09830971  1.055472739
	105925349  4.799892  0.85282296  4.160410 1.191088e-04 0.09830971  0.839394442
	105886209  4.463079  0.31005263  4.504043 3.786492e-05 0.08068934  1.764014434
	105929171  4.659262  0.09585575  4.060313 1.651619e-04 0.11475659  0.586462091
	105931640 -3.270716  4.79799251 -3.481934 1.016012e-03 0.15908459 -0.811676573
	105927004 -3.966843  2.73606660 -4.634139 2.432374e-05 0.07514875  2.304021747
	105927694 -1.926792  6.52395494 -3.709299 5.052927e-04 0.13869973 -0.305212938
	105932372  4.965309  0.21146563  4.384839 5.657229e-05 0.08279642  1.467477903
	105921468 -1.235303  9.57646551 -2.790754 7.330479e-03 0.25350738 -3.029224379
	105918313 -1.828203  9.00115777 -3.509797 9.337570e-04 0.15827686 -1.087669646
	105923403 -1.641109  6.56583217 -3.146611 2.729663e-03 0.20298106 -1.853924114
	105925114  4.794886  0.91718229  4.488417 3.992007e-05 0.08068934  1.701921297
	105920226 -3.717002  0.93478368 -3.802961 3.766344e-04 0.13810716 -0.041613374
	105922345  4.794898  1.96096370  3.902752 2.743728e-04 0.13428749  0.215299673
	105918335  4.101253  0.04448467  3.894218 2.819485e-04 0.13428749  0.157133524
	105927586  4.267480  2.13396969  3.643332 6.201815e-04 0.15152875 -0.419660593
	105919032 -3.814439  2.07181065 -3.653089 6.017375e-04 0.15142437 -0.404805553
	105926173 -2.520213  6.87554347 -3.488435 9.962252e-04 0.15908459 -0.953832647
	105934678 -3.825570  2.71697619 -3.889852 2.859012e-04 0.13428749  0.225858249
	105937838 -3.615060  1.92867423 -3.607368 6.929498e-04 0.15827686 -0.528475367
	105916175 -1.523493  8.49399904 -3.007623 4.046610e-03 0.22338347 -2.389654591
	105918668  5.937573  1.10462638  4.313066 7.190095e-05 0.08435489  1.258558758
	105939523 -1.397556 12.20984487 -3.714653 4.969224e-04 0.13810716 -0.782701939
	105928910 -2.011146  7.03247930 -3.141457 2.770281e-03 0.20328194 -1.922004994
	105930460  3.754842 -0.13865266  3.728768 4.754858e-04 0.13810716 -0.242030654
	105929494 -3.745407  2.37282570 -3.482016 1.015759e-03 0.15908459 -0.827812861
	105939619 -2.479176  5.06028822 -3.795721 3.853356e-04 0.13810716  0.028655790
	105928269  4.793336  0.53007951  4.444516 4.629419e-05 0.08279642  1.647911049
	105936812  5.581124  0.88545532  3.935060 2.474309e-04 0.13428749  0.267059792
	105930187  4.278393  0.45120737  3.930400 2.511532e-04 0.13428749  0.268525050
	105917484 -1.788396  8.68448428 -2.967962 4.519538e-03 0.22734768 -2.519726572
	105939751  4.241675  0.80316396  3.389428 1.341401e-03 0.16704758 -1.092369394
	105915575 -1.914055  8.05122088 -2.945467 4.810166e-03 0.23005569 -2.524563319
	105923417 -1.988549  8.70920137 -3.426707 1.199867e-03 0.16530262 -1.279114107

topTable of singlemodel19, 56% waf, ptxdr ixn: 

	             logFC      AveExpr         t      P.Value   adj.P.Val         B
	105940024 -2.525048  7.339443013 -5.466284 2.082153e-07 0.002567503 6.7331885
	105926074 -4.423741  4.067244372 -5.474897 2.000643e-07 0.002567503 6.5271641
	105929269 -4.258950  2.387163008 -5.344346 3.650242e-07 0.003000742 6.2903981
	105935506 -4.627264  3.174367432 -5.159183 8.437187e-07 0.005201948 5.2239504
	105916753 -3.634473  4.002374284 -4.823876 3.670618e-06 0.013243618 4.1552241
	105921814 -2.970526  3.948750023 -4.752474 4.979446e-06 0.013243618 3.8369982
	105917783  5.191207  3.096009299  4.783259 4.367520e-06 0.013243618 3.6207477
	105936203 -5.624500  2.247208132 -4.734685 5.370050e-06 0.013243618 3.6104415
	105918068  4.817042 -0.287573380  4.739579 5.259726e-06 0.013243618 3.4845833
	105918932 -3.093147  4.238929933 -4.631591 8.288523e-06 0.018582869 3.4031613
	105936064 -2.308301  7.922153028 -4.745977 5.118791e-06 0.013243618 3.2840515
	105917294 -2.189163  6.878327697 -4.600478 9.436927e-06 0.019394458 2.6762356
	105917711 -2.839401  3.785542562 -4.435462 1.859954e-05 0.026501414 2.6760685
	105923711 -4.837314  1.833649544 -4.483436 1.529579e-05 0.025148320 2.6205497
	105940298  5.381832  4.869092794  4.505479 1.397477e-05 0.024617552 2.5917335
	105933200  4.606842 -0.362345382  4.457726 1.698881e-05 0.026186129 2.5161083
	105926382 -1.964983  6.293464726 -4.425811 1.934253e-05 0.026501414 2.3425897
	105926592 -2.653015  3.743528738 -4.369194 2.431145e-05 0.031556256 2.3052309
	105936384 -3.481886  1.960531378 -4.324190 2.911549e-05 0.035902316 2.2630747
	105926618 -4.713069 -0.001775878 -4.279025 3.484721e-05 0.039063723 1.9094550
	105928627  4.352227  2.678868451  4.290770 3.326034e-05 0.039060306 1.8853132
	105939954 -2.193774  5.262890238 -4.213691 4.508929e-05 0.041601881 1.7920144
	105918611 -4.329269  2.410820708 -4.229177 4.242822e-05 0.041601881 1.7565608
	105938803 -1.648230  5.412459912 -4.198994 4.776222e-05 0.041601881 1.7360005
	105918296 -2.221835  5.211852225 -4.210634 4.563316e-05 0.041601881 1.6985233
	105923230  4.869934 14.788351005  4.527458 1.276741e-05 0.024220752 1.6930121
	105935429 -2.351301  4.457097838 -4.144454 5.907119e-05 0.041601881 1.6321227
	105934905  3.945770  1.920681247  4.179579 5.152679e-05 0.041601881 1.6088644
	105921324 -2.017544  5.274347035 -4.159982 5.561394e-05 0.041601881 1.5899349
	105938070  3.954773  2.619168008  4.160478 5.550670e-05 0.041601881 1.5480689
	105916657 -3.578228  3.506933019 -4.126650 6.328843e-05 0.041601881 1.5027900
	105918462 -4.400860  2.534666170 -4.130086 6.245261e-05 0.041601881 1.4929989
	105933236 -2.026593  5.255046908 -4.164972 5.454461e-05 0.041601881 1.4429712
	105931628  2.415401  5.113131249  4.072260 7.803000e-05 0.043744681 1.3854879
	105925349  4.828726  1.587952027  4.126112 6.342006e-05 0.041601881 1.3738833
	105886209  4.615654  0.251510997  4.123348 6.410151e-05 0.041601881 1.3676612
	105929171  4.651247  1.123146217  4.099669 7.023266e-05 0.043744681 1.2967001
	105931640 -3.485139  2.890144260 -4.039656 8.838387e-05 0.043744681 1.2749931
	105927004 -4.224083  2.537207187 -4.049953 8.497997e-05 0.043744681 1.2285050
	105927694 -2.064203  4.998001025 -4.044389 8.680329e-05 0.043744681 1.2017369
	105932372  4.969461  2.242928057  4.060011 8.177601e-05 0.043744681 1.1990314
	105921468 -1.367318  7.908958056 -4.145880 5.874539e-05 0.041601881 1.1957724
	105918313 -1.960064  7.601434032 -4.126765 6.326023e-05 0.041601881 1.1951616
	105923403 -1.750900  5.471131097 -4.038999 8.860548e-05 0.043744681 1.1715306
	105925114  4.807291  3.020633748  4.067838 7.936300e-05 0.043744681 1.1692355
	105920226 -3.850838  0.071563125 -4.046380 8.614666e-05 0.043744681 1.1540509
	105922345  4.836991  2.993394600  4.046542 8.609348e-05 0.043744681 1.1373066
	105918335  4.093138 -0.146412995  4.038753 8.868843e-05 0.043744681 1.1145801
	105927586  4.309942  2.580601529  4.027828 9.245465e-05 0.044708170 1.1142257
	105919032 -4.175901  2.338560047 -4.010556 9.872232e-05 0.045694766 1.0551184
	105926173 -2.642384  3.009012026 -4.008938 9.932952e-05 0.045694766 1.0485264
	105934678 -4.189641  2.494037325 -4.000990 1.023655e-04 0.045694766 1.0458510
	105937838 -3.964744  3.064850999 -3.994257 1.050067e-04 0.045694766 1.0023739
	105916175 -1.595857  6.809990164 -4.043585 8.707000e-05 0.043744681 0.9720864
	105918668  5.820351  4.782419821  3.992737 1.056119e-04 0.045694766 0.9567290
	105939523 -1.540793 10.359492295 -4.200055 4.756426e-05 0.041601881 0.9359792
	105928910 -2.117086  5.337558298 -3.981323 1.102635e-04 0.046884817 0.9092871
	105930460  3.644959  1.753016935  3.959532 1.196923e-04 0.048766578 0.9011967
	105929494 -3.995997  2.768030107 -3.955756 1.214024e-04 0.048766578 0.8855595
	105939619 -2.617981  4.117655113 -3.926680 1.353723e-04 0.049829123 0.8851880
	105928269  4.622293  2.779926835  3.952088 1.230859e-04 0.048766578 0.8841190
	105936812  5.462557  5.054665177  3.961312 1.188941e-04 0.048766578 0.8698021
	105930187  4.192467  1.749072678  3.948881 1.245760e-04 0.048766578 0.8563085
	105917484 -1.887437  6.575548160 -3.997019 1.039155e-04 0.045694766 0.7626870
	105939751  4.287812  1.825862940  3.929116 1.341455e-04 0.049829123 0.7562630
	105915575 -2.036178  5.820762932 -3.931020 1.331940e-04 0.049829123 0.6034281
	105923417 -2.083243  6.924337868 -3.933178 1.321233e-04 0.049829123 0.5698672

* Maybe has to do with the way voom calculates weights. Fewer samples vs a lot more samples --> difference in weights? 
* Also might have to do with the difference in number of tests, degrees of freedom, etc. 

__18 April 2017__

I tested the correlation between p.values of unified model and single stage model, and there's max correlation of 0.5 (testing all possible genes), and gets lower when testing the most significant genes (at cutoff of p=0.05 or p=0.1). See `pvalcorr.R` 

	##Correlation between unified model and single model p values,
	for all genes tested in single-stage model (~23567 genes): 
	> cor(x=unip, y=singp, use="complete.obs")
	[1] 0.5104432
	
	##
	> cor(x=uniadjp, y=singadjp, use="complete.obs")
	[1] 0.4652932
	
__22 September 2017__

Using David M Rocke's advice based on his [2015 preprint](https://www.biorxiv.org/content/biorxiv/early/2015/04/29/018739.full.pdf), I performed filtration, transformation, normalization, and lm() model fitting on all samples, and for each developmental stage. 

I used FDR correction using `sapply(pvaltable, p.adjust, method="fdr")` on each stage-specific analysis, and got zero significant p values for any coefficient, at adjusted pvalue cutoff of 0.05 or 0.1. 

What does this mean?

* Double check that sapply() is the correct function to use to adjust a dataframe of p-values
* If it is, then perhaps DM Rocke's method isn't the ideal path forward...? 
* Or does that mean that multiple comparison adjustment is not necessary? In his paper he sets a somewhat arbitrary adjust pvalue cutoff of 10^-4. Do I feel comfortable doing that in my own manuscript? Not really.

I managed to use tidyverse::gather() to properly format the dataframes such that I was able to use p.adjust. 

Data frames of DGE with adjustd pvalues are stored by coefficient in LabNotebook/rnaseq/Ranalysis folder. 

Next Steps:

* Perform cluster analysis on list of genes


### Using DAVID: functional annotation tool

* Results from DAVID GO enrichment analysis found in:

		~/GoogleDrive/LabNotebook/NIEHS_LSU_UCD/rnaseq/results
and labeled with _DAVID.txt


### Update: Which RNA-seq analysis tool to use? 19 October 2017

David Rocke's method: 

* transform data to fit assumptions of linear model, implement linear model (lm, anova, etc.) to detect dge

Gerald Quon's counter-argument: 

* Data goes against assumptions at very low and high counts, not suitable for lm
* We don't have enough power to manually transform and lm(). n=6 is still too small because of multifactorial design (and lots of variables). Increasing levels diminishes power. 

Gerald Quon disagreed with David Rocke's suggestion to log transform manually and use lm(), because we actually don't have enough replicates to justify using that method. Yes, we have many samples for the overall experiment, but because of all the variables in our experiment, we have diminished power for our analysis (Tony, please feel free to elaborate further on this). 

#### On normalizing read counts for gene length: 

From David Rocke, 1/15/2018:

"So that only matters if you need to compare expression across genes in the same sample, rather than expression across samples in the same gene. And the first goal is rather fraught since there are many biases based in sequence and genome location that affect expression differently for different genes.
	
The counts are what we actually measure, and it is not clear that normalizing the count of fragments mapped to a gene matters. For statistical analysis for a given gene, all that does is divide all the data points by the same thing, which in general changes nothing."

Important things to take care of as of 1/15/18:

* double check htseq count parameters used (multimapping)
* Compare with salmon to check for any clear advantages
* Decide if I should rerun read-count generation using STAR-aligned reads 

Verdict as of 1/16/18: 

It's still a good idea to use Salmon, because it can reduce systemic errors and sample-specific bias such as transcript positional bias (fragments preferentially located at end or beginning of fragments). 

Additionally, transcript-level estimates (which Salmon provides) [can improve gene-level inferences](https://f1000research.com/articles/4-1521/v2). 


## Re-doing read quantification using salmon
#### 10 January 2018

Differences between [alignment and mapping](https://www.biostars.org/p/180986/)

Reference transcriptome: 

* Lisa Cohen concatenated two [reference transcriptomes by Don Gilbert]
(http://arthropods.eugenes.org/EvidentialGene/killifish/genes/kfish2rae5/) that contain alternate gene model information. I used that concatenation, found here:

		~/niehs/refseq/kfish2rae5g.mrna.combined
		
* Downloaded new annotation file from [lab website](https://whiteheadresearch.wordpress.com/protocols/). Located: 

		~/niehs/refseq/heteroclitus_refseq_GBE_2017-05-12.gff 

* Trimmed and merged data located: 

		~/niehs/Data/trimmed_data/mergedfq/
		
1. Ran salmon index: 

		~/niehs/scripts/0009b_salmindex.sh

	Code as of 10 January 2018: 

		#!/bin/bash -l
		#SBATCH -D /home/jajpark/niehs/scripts/
		#SBATCH -o /home/jajpark/niehs/slurm-log/salmindex-stout-%j.txt
		#SBATCH -e /home/jajpark/niehs/slurm-log/salmindex-stderr-%j.txt
		#SBATCH -J salmindx
		#SBATCH --mem=16000
		#SBATCH -p high
		#SBATCH -t 24:00:00 
		Modified 10 January, 2018, JP
		
		set -e
		set -u
		
		module load salmon
		
		DIR=~/niehs/refseq/
		cd $DIR
	
		##first build salmon index
		reft=kfish2rae5g.mrna.combined
		
		salmon index -t $reft -i transcripts_salm_index --type quasi --threads 8
	
2. Ran salmon quant: 

		~/niehs/scripts/0009d_salmonquant.sh
		
	Code as of 10 January 2018: 
		module load bio
		
		DIR=~/niehs/Data/trimmed_data/mergedfq
		IND=~/niehs/refseq/transcripts_salm_index
		OUTDIR=~/niehs/results/180110_salmoncount
		
		
		#f=$(find $DIR -name "*R1*.fq" | sed -n $(echo $SLURM_ARRAY_TASK_ID)p)
		
		cd $DIR
		
		for f in `ls *R1*.fq.gz`
		do 
		
		name=`echo $f | cut -f 8 -d "/" | cut -f 1 -d "_"`
		echo "Processing sample ${name}"
		
		salmon quant -i $IND -l A \
		         -1 ${nam_R1_merged.fq.gz \
		         -2 ${name}_R2_merged.fq.gz \
		         -p 8 -o ${OUTDIR}/${name}_quant
		         
		done
	
3. Check mapping rate: 

     * ~65% mapping rate 

One reason mapping rate on Salmon is lower than alignment rate using STAR is that mapping =/= alignment. There is a lightweight alignment mode on Salmon using `--type fmd` 

Alternative things to try: 
 
 
* Use STAR to map reads and quantify using salmon  in alignment mode
     * Use `STARparBAM="--outSAMtype BAM SortedByCoordinate --quantMode TranscriptomeSAM"`
     * Make sure star aln formats are compatible with salmon

* Use STAR aligned reads and use gene length correction before count quantification
     * is this simply cpm function in edger? I thought we discussed this point in the meeting with David Rocke.... somehow it's not important to normalize for fragment length?

_Update Jan 22, 2018:_ 

* I aligned reads to NCBI refseq with lab's annotation using STAR, and these reads are incompatible with Salmon (a number of transcripts in BAM file that are missing in the refseq rna.fna and kfish (don gilbert) transcriptomes. [salmon issue log](https://github.com/COMBINE-lab/salmon/issues/104)

Another post about [drop in mapping rate from alignment rate](https://www.biostars.org/p/283088/)

Next steps:

* Try salmon quasi-mapping with ncbi rna.fna file and compare that mapping rate with alignment rate to refseq genome (~80%)
* Try salmon quasi-mapping with smaller k value 
* Try salmon lightweight alignment mode with both ncbi and don gilbert transcriptome 
* See post: https://www.biostars.org/p/283088/   

_Jan 23, 2018:_

* Created Salmon indexes: 
     - Don gilbert kfish_fmd
     - Don Gilbert kfish_k21
     - Refseq, quasi, default k (k=31)

* Started quantifying to the above indexes. 
* How to parse thru logs and get mapping rates for each sample? 

Quantifying using the Refseq rna_from_genomic.fna.gz file gives me about the same mapping rate as with using Don Gilbert's kfish transcriptome, higher rate by 1-3% but still in ~65-70% range. Higher mapping rate to genome occurs for a variety of reasons, such as genomic contamination. 

Reads were ultimately mapped to don gilbert's reference transcriptome, fmd mode. 

   
_Jan 29, 2018:_

I have quant files for each type of Salmon mapping (quasi- and lightweight), and now I want to import transcript-level abundances into R to estimate gene-level abundances. 

The quant files using NCBI Refseq transcriptome have the following format for names: 

	Name	Length	EffectiveLength	TPM	NumReads
	lcl|NW_012224401.1_mrna_XM_012856390.1_1	840	608.506	0.14808	1
	lcl|NW_012224401.1_mrna_XM_012853081.1_2	3237	3005.31	1.28926	43
	lcl|NW_012224401.1_mrna_XM_012849362.1_3	3178	2946.31	1.89616	62

The correct name format I need to convert NCBI transcript names into gene ids is: 

	XM_012858822.1
	
I will edit my Refseq-mapped quant files to have the desired name format:

I used sed to edit: 

	dir=/home/jajpark/niehs/results/180123_refseqind_salmcounts
	
	cd $dir
	
	for i in `ls */quant.sf` ;
	do
	sed -i "s/|/_/; s/lcl_NW_012224401.1_mrna_//; s/\.[0-9]*\t/\t/" $i; 
	done
	
_Jan 30, 2018:_

I will generate gene-level counts from transcript abundances using tximport. 

There is a file from Noah's paper with all the gene models across killifish gene id and ncbi gene id.  

Convert all transcript names into Killifish geneID 