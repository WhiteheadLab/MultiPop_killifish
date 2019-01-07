
import os

def parse_star(star_out_file):

# example output file:
# 
#                                 Started job on |	Aug 18 22:00:50
#                             Started mapping on |	Aug 18 22:22:01
#                                    Finished on |	Aug 18 22:22:52
#       Mapping speed, Million of reads per hour |	219.17
#
#                          Number of input reads |	3104873
#                      Average input read length |	199
#                                    UNIQUE READS:
#                   Uniquely mapped reads number |	2683963
#                        Uniquely mapped reads % |	86.44%

	
	#important_lines = [6,9,10]
	important_nums = []
	if os.path.isfile(star_out_file)==True:
		with open(star_out_file) as outfile:
			for line_full in outfile:
				line=line_full.strip()
				if line.startswith("Number of input reads") == True:
					input_reads=line.split()
					#print input_reads
					important_nums.append(input_reads[-1])	
				elif line.startswith("Uniquely mapped reads number") == True:
 					reads_number=line.split()
					#print reads_number
 					important_nums.append(reads_number[-1])
				elif line.startswith("Uniquely mapped reads %") == True:
 					reads_perc=line.split()
 					#print reads_perc
 					important_nums.append(reads_perc[-1])
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
				

def get_sample_dictionary(basedir):
    listoffiles=os.listdir(basedir)
    sample_dictionary={}
    for filename in listoffiles:
	if filename.endswith(".final.out"):
		sample=filename.split("_")[0] 
		sample_dictionary[sample]=basedir+filename	
    return sample_dictionary

def alignment_table_file_star(basedir):
    #alignment_table_filename="/home/ljcohen/parse_files/"+"star_alignment_stats.txt"
    alignment_table_filename="/home/jajpark/niehs/Data/alignmentstats/"+"star_hetannot_2.txt"
    header=["Sample","Input Reads","Uniquely mapped reads", "% Mapped"]
    len(header)
    sample_dictionary=get_sample_dictionary(basedir)
    print sample_dictionary
    print len(sample_dictionary.keys())
    with open(alignment_table_filename,"w") as datafile:
        datafile.write("\t".join(header))
        datafile.write("\n")
        for sample in sample_dictionary.keys():
	    star_out_file=sample_dictionary[sample]
            important_nums=parse_star(star_out_file)
            datafile.write(sample+"\t")
            datafile.write("\t".join(important_nums))
            datafile.write("\n")
    datafile.close()
    print "Alignment stats written:",alignment_table_filename


# example star_out_file: /home/jajpark/niehs/results/alignments/stargen/0001ARSC32191_S1_L005Log.final.out"
basedir="/home/jajpark/niehs/results/alignments/star_heteroclitus_annot_161116/lanes_3-8/"
alignment_table_file_star(basedir)

