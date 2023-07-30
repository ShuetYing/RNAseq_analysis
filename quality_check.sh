#!/bin/bash

# make a directory named ICA1
mkdir ICA1 
cd ICA1

# copy RNAseq sequence data to current directory 
cp -R /localdisk/data/BPSM/ICA1/fastq . 

# run quality check 
path=$PWD"/fastq"
output=$PWD"/fastqc_output"

mkdir fastqc_output

fastqc -t 5 -o ${output} ${path}/Tco-*
