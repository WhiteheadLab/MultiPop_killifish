import os

def parse_trimmomatic(trim_out_file):

# Module slurm/15.08.11 loaded
# TrimmomaticPE: Started with arguments:
#  0001ARSC32191_S1_L005_R1_001.fastq.gz 0001ARSC32191_S1_L005_R2_001.fastq.gz /home/jajpark/niehs/Data/nebtrim/0001ARSC32191_S1_L005_R1_001.qc.fq.gz /home/jajpark/niehs/Data/nebtrim/s1_se /home/jajpark/niehs/Data/nebtrim/0001ARSC32191_S1_L005_R2_001.qc.fq.gz /home/jajpark/niehs/Data/nebtrim/s2_se ILLUMINACLIP:/home/jajpark/programs/Trimmomatic-0.36/adapters/NEBnextAdapt.fa:2:40:15 LEADING:2 TRAILING:2 SLIDINGWINDOW:4:2 MINLEN:25
# Using Long Clipping Sequence: 'ACACTCTTTCCCTACACGACGCTCTTCCGATC'
# Using Long Clipping Sequence: 'GATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT'
# Using Long Clipping Sequence: 'GATCGGAAGAGCACACGTCTGAACTCCAGTC'
# Using Long Clipping Sequence: 'GACTGGAGTTCAGACGTGTGCTCTTCCGATC'
# ILLUMINACLIP: Using 0 prefix pairs, 4 forward/reverse sequences, 0 forward only sequences, 0 reverse only sequences
# Quality encoding detected as phred33
# Input Read Pairs: 3105178 Both Surviving: 3104873 (99.99%) Forward Only Surviving: 25 (0.00%) Reverse Only Surviving: 16 (0.00%) Dropped: 264 (0.01%)
# TrimmomaticPE: Completed successfully
# TrimmomaticPE: Started with arguments:
#  0002ARSC32351_S2_L005_R1_001.fastq.gz 0002ARSC32351_S2_L005_R2_001.fastq.gz /home/jajpark/niehs/Data/nebtrim/0002ARSC32351_S2_L005_R1_001.qc.fq.gz /home/jajpark/niehs/Data/nebtrim/s1_se /home/jajpark/niehs/Data/nebtrim/0002ARSC32351_S2_L005_R2_001.qc.fq.gz /home/jajpark/niehs/Data/nebtrim/s2_se ILLUMINACLIP:/home/jajpark/programs/Trimmomatic-0.36/adapters/NEBnextAdapt.fa:2:40:15 LEADING:2 TRAILING:2 SLIDINGWINDOW:4:2 MINLEN:25
# Using Long Clipping Sequence: 'ACACTCTTTCCCTACACGACGCTCTTCCGATC'
# Using Long Clipping Sequence: 'GATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT'
# Using Long Clipping Sequence: 'GATCGGAAGAGCACACGTCTGAACTCCAGTC'
# Using Long Clipping Sequence: 'GACTGGAGTTCAGACGTGTGCTCTTCCGATC'
# ILLUMINACLIP: Using 0 prefix pairs, 4 forward/reverse sequences, 0 forward only sequences, 0 reverse only sequences
# Quality encoding detected as phred33
# Input Read Pairs: 5593017 Both Surviving: 5589898 (99.94%) Forward Only Surviving: 105 (0.00%) Reverse Only Surviving: 116 (0.00%) Dropped: 2898 (0.05%)
# TrimmomaticPE: Completed successfully
# TrimmomaticPE: Started with arguments:
	
	#important_lines = [6,9,10]
	important_nums = []
	if os.path.isfile(trim_out_file)==True:
		with open(trim_out_file) as outfile:
			for line_full in outfile:
				line=line_full.strip()
				if line.startswith("Input Read Pairs:") == True:
					reads_num=line.split()
					input_reads=reads_num[3]
					surviving_reads=reads_num[6]
					#print input_reads
					important_nums.extend(input_reads, surviving_reads)	
				
	print important_nums
	return important_nums
				
			# for line in outfile:
# 				if line.startswith("Uniquely mapped reads number") == True:
# 					reads_number=line.split()
# 					print reads_number
# 					important_nums.append(reads_number[-1])
# 				return important_nums
# 				
# 			for line in outfile:
# 				if line.startswith("Uniquely mapped reads %") == True:
# 					reads_perc=line.split()
# 					print reads_perc
# 					important_nums.append(reads_perc[-1])
# 				return important_nums
# 		
				

# build sample name dictionary for making data structure 
# -- how to parse this out from a single text file? 
def get_sample_dictionary(basedir): # do I need basedir if I'm pulling sample names from a single file?
    #listoffiles=os.listdir(basedir)
    sample_dictionary={}
    with open(trim_out_file) as outfile:
		for line in outfile:
			if line.startswith("  00"):
		sample=line.split("_")[0] 
		sample_dictionary[sample]=basedir+sample # not sure about this
    return sample_dictionary

def trim_table(basedir):
    #alignment_table_filename="/home/ljcohen/parse_files/"+"star_alignment_stats.txt"
    trim_table_filename="/home/jajpark/niehs/Data/nebtrim/"+"trimmomatic_reads_table.txt"
    header=["Sample","Input Reads","Surviving Reads"]
    len(header)
    #sample_dictionary=get_sample_dictionary(basedir)
    print sample_dictionary
    print len(sample_dictionary.keys())
    with open(trim_table_filename,"w") as datafile:
        datafile.write("\t".join(header))
        datafile.write("\n")
        for sample in sample_dictionary.keys():
	    trim_out_file=sample_dictionary[sample] # is this right in this case?? not sure what to do here
            important_nums=parse_trimmomatic(trim_out_file)
            datafile.write(sample+"\t")
            datafile.write("\t".join(important_nums))
            datafile.write("\n")
    datafile.close()
    print "Trimmomatic stats written:",trim_table_filename


trim_out_file: "/home/jajpark/niehs/Data/nebtrim/nebtrimmomatic-out.txt"
# basedir="/home/jajpark/niehs/Data/nebtrim/" # I probably don't need this if I'm parsing a single file
trim_table(basedir)