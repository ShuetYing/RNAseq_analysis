#!/bin/bash

mkdir fold_change_groups

# categorize groups for fold change 

folder=$PWD"/sample_groups"
out_dir=$PWD"/fold_change_groups"

for i in ${folder}/*
do 
if [[ ${i} == *"0h"* ]]
then
mkdir ${out_dir}/0h 
cp ${i}/*mean.txt ${out_dir}/0h 
elif [[ ${i} == *"24h_induced"* ]]
then 
mkdir ${out_dir}/24h_induced
cp ${i}/*mean.txt ${out_dir}/24h_induced
elif [[ ${i} == *"24h_uninduced"* ]]
then
mkdir ${out_dir}/24h_uninduced
cp ${i}/*mean.txt ${out_dir}/24h_uninduced 
elif [[ ${i} == *"48h_induced"* ]] 
then 
mkdir ${out_dir}/48h_induced
cp ${i}/*mean.txt ${out_dir}/48h_induced 
else
mkdir ${out_dir}/48h_uninduced
cp ${i}/*mean.txt ${out_dir}/48h_uninduced 
fi 
done

# combine clone1 & clone2 to WT for comparison  

folder=$PWD"/fold_change_groups"

a="clone1"
b="clone2"

for i in ${folder}/*
do 
for file in ${i}/*
do 
if [[ ${file} == *"$a"* ]] 
then 
paste ${i}/WT*.txt ${file} | cut -f 1,2,3,6 > ${i}/${a}_merged.txt
elif [[ ${file} == *"$b"* ]]
then 
paste ${i}/WT*.txt ${file} | cut -f 1,2,3,6 > ${i}/${b}_merged.txt 
fi 
done 
done 

# calculate the fold change of gene expression 

for i in ${folder}/*
do 
for file in ${i}/*merged.txt
do
filename=$(echo ${file} | rev | cut -c 12-17 | rev)
awk 'BEGIN{FS="\t";OFS="\t";}{gsub("0","1",$3)}1' ${file} | awk 'BEGIN{FS="\t";OFS="\t";}{$5 = $4 / $3}1' | sort -t$'\t' -k5,5nr > ${i}/${filename}.txt
done 
done
