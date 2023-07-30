#!/bin/bash 

# copy bedfile to current dir 
cp /localdisk/data/BPSM/ICA1/TriTrypDB-46_TcongolenseIL3000_2019.bed .

# count the number of reads that align to the genome 
input=$PWD"/sam_output"
output=$PWD"/multicov_output"

mkdir multicov_output 

for file in ${input}/*_sorted.bam
do
filename=$(echo ${file} | rev | cut -c 12-19 | rev)
bedtools multicov -bams ${file} -bed TriTrypDB*.bed > ${output}/${filename}.txt
done

# generate files containing the number of reads aligned to each gene  
input=$PWD"/multicov_output"
output=$PWD"/count_data"

mkdir count_data 

for file in ${input}/*.txt
do 
filename=$(echo ${file} | rev | cut -c 5-8,10-12 | rev)
cut -f 4,5,6 ${file} > ${output}/${filename} 
done
