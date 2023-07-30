#!/bin/bash 

# copy genome seq to current dir 
cp -R /localdisk/data/BPSM/ICA1/Tcongo_genome/ .

path=$PWD"/Tcongo_genome"

# uncompress file 
gzip -d ${path}/Tri*

# indexing genome sequence 
bowtie2-build ${path}/TriTryp* T.congolense

# align fastq seq to indexed genome seq 
for seq in $(ls ~/ICA1/fastq/*1.fq.gz)
do 
file=$(echo ${seq} | rev | cut -c 8- | rev)
bowtie2 -p 4 -x T.congolense -q -1 ${file}1.fq.gz -2 ${file}2.fq.gz -S ${file}.sam
done 

# move the sam files to a new directory 
mkdir sam_output
mv ~/ICA1/fastq/*.sam sam_output

# convert SAM to BAM format 
path1=$PWD"/sam_output"   #location of SAM files 

for file in ${path1}/*.sam 
do 
filename=$(echo ${file} | rev | cut -c 6-13 | rev)
samtools view -S -b ${file} > ${path1}/${filename}.bam
done 

# sort the alignment in BAM files
for file in ${path1}/*.bam
do
name=$(echo ${file} | rev | cut -c 5-12 | rev)
samtools sort ${file} -o ${path1}/${name}_sorted.bam 
done
 
# index sorted BAM files 
for file in ${path1}/*_sorted.bam
do 
samtools index ${file}
done
