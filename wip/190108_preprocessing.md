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
