import json
import os
from pprint import pprint 

parsedir="/home/jajpark/niehs/results/"
rootdir="/home/jajpark/niehs/results/180128_refseq_fmd_salmcounts/"
filedir="/aux_info/meta_info.json"
listoffiles=os.listdir(rootdir)
testname=rootdir.split("/")[5]


def parse():
	parse_filename=parsedir+testname+"_map_rates.txt"
	for i in listoffiles: 
		with open(rootdir+i+filedir) as metafile:
			meta=json.load(metafile)
			mapped=meta["percent_mapped"]
			with open(parse_filename, "a+") as datafile:
				datafile.write(i + "\t" + str(mapped) + "\n")
	datafile.close()
	print "Mapping rates written:",parse_filename


	# Full path for .json file: 
	# /home/jajpark/niehs/results/180123_refseqind_salmcounts/0001ARSC32191_quant/aux_info/meta_info.json
