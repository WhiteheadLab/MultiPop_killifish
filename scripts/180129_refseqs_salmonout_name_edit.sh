


dir=/home/jajpark/niehs/results/180123_refseqind_salmcounts

cd $dir

for i in `ls */quant.sf` ;
do
sed -i "s/|/_/; s/lcl_NW_012224401.1_mrna_//; s/_[0-9]//g" $i; 
done



for i in `ls */quant.sf` ;
do
sed -i.bu "s/XM12/XM_012/; s/lcl.*rna_//" $i; 
done

for i in `ls */quant.sf` ;
do
sed -i "s/XM12/XM_012/; s/lcl_NW_.*rna_//" $i; 
done


sed -r 's/^\(.{14\}).*\t/\t/' quant.sf > tester
