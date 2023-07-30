#!/bin/bash 

path=$PWD"/fastq"
output=$PWD"/sample_groups_info"

# sort the file into more organized order
tail -n +2 ${path}/Tco.fqfiles | cut -f1,2,4,5 | sort -k2,2 -k3,3 > ${path}/sorted  

mkdir sample_groups_info

# categorize info of sample groups

#Clone1, 0h 
awk 'BEGIN{FS="\t";OFS="\t";}{if($2=="Clone1" && $3==0) {print $1}}' ${path}/sorted > ${output}/clone1_0h

#Clone1, 24h, induced
awk 'BEGIN{FS="\t";OFS="\t";}{if($2=="Clone1" && $3==24 && $4=="Induced") {print $1}}' ${path}/sorted > ${output}/clone1_24h_induced

#Clone1, 24h, uninduced 
awk 'BEGIN{FS="\t";OFS="\t";}{if($2=="Clone1" && $3==24 && $4=="Uninduced") {print $1}}' ${path}/sorted > ${output}/clone1_24h_uninduced

#Clone1, 48h, induced
awk 'BEGIN{FS="\t";OFS="\t";}{if($2=="Clone1" && $3==48 && $4=="Induced") {print $1}}' ${path}/sorted > ${output}/clone1_48h_induced

#Clone1, 48h, uninduced
awk 'BEGIN{FS="\t";OFS="\t";}{if($2=="Clone1" && $3==48 && $4=="Uninduced") {print $1}}' ${path}/sorted > ${output}/clone1_48h_uninduced

#Clone2, 0h
awk 'BEGIN{FS="\t";OFS="\t";}{if($2=="Clone2" && $3==0) {print $1}}' ${path}/sorted > ${output}/clone2_0h

#Clone2, 24h, induced
awk 'BEGIN{FS="\t";OFS="\t";}{if($2=="Clone2" && $3==24 && $4=="Induced") {print $1}}' ${path}/sorted > ${output}/clone2_24h_induced

#Clone2, 24h, uninduced
awk 'BEGIN{FS="\t";OFS="\t";}{if($2=="Clone2" && $3==24 && $4=="Uninduced") {print $1}}' ${path}/sorted > ${output}/clone2_24h_uninduced

#Clone2, 48h, induced
awk 'BEGIN{FS="\t";OFS="\t";}{if($2=="Clone2" && $3==48 && $4=="Induced") {print $1}}' ${path}/sorted > ${output}/clone2_48h_induced

#Clone2, 48h, uninduced
awk 'BEGIN{FS="\t";OFS="\t";}{if($2=="Clone2" && $3==48 && $4=="Uninduced") {print $1}}' ${path}/sorted > ${output}/clone2_48h_uninduced

#WT, 0h
awk 'BEGIN{FS="\t";OFS="\t";}{if($2=="WT" && $3==0) {print $1}}' ${path}/sorted > ${output}/WT_0h

#WT, 24h, induced
awk 'BEGIN{FS="\t";OFS="\t";}{if($2=="WT" && $3==24 && $4=="Induced") {print $1}}' ${path}/sorted > ${output}/WT_24h_induced

#WT, 24h, uninduced
awk 'BEGIN{FS="\t";OFS="\t";}{if($2=="WT" && $3==24 && $4=="Uninduced") {print $1}}' ${path}/sorted > ${output}/WT_24h_uninduced

#WT, 48h, induced
awk 'BEGIN{FS="\t";OFS="\t";}{if($2=="WT" && $3==48 && $4=="Induced") {print $1}}' ${path}/sorted > ${output}/WT_48h_induced

#WT, 48h, uninduced
awk 'BEGIN{FS="\t";OFS="\t";}{if($2=="WT" && $3==48 && $4=="Uninduced") {print $1}}' ${path}/sorted > ${output}/WT_48h_uninduced


# divide samples into different groups 

info=$PWD"/sample_groups_info/*"
files=$(ls $PWD/count_data)
path=$PWD"/count_data/*"

mkdir sample_groups

for file in ${info}
do 
cat ${file} | while read line
do 
if [ "${line}"=="${files}" ]
then 
dirname=$(basename ${file})
mkdir $PWD/sample_groups/${dirname}
cp $PWD/count_data/${line}  $PWD/sample_groups/${dirname}
fi 
done 
done 


# merge the column containing the number of aligned reads into one file 

folder=$PWD"/sample_groups"

for i in ${folder}/*
do
for file in ${i}/*
do
paste ${i}/Tco* > ${i}/temp.txt
cut -f1,2,3,6,9,12 ${i}/temp.txt > ${i}/numbers.txt
rm -f ${i}/temp.txt
done
done


# calculate the mean of expression level for each gene 

for i in ${folder}/*
do 
for file in ${i}/numbers.txt
do
awk 'BEGIN{FS="\t";OFS="\t";}{
s=0; 
numFields=0;
for(i=3; i<=NF;i++){
if(length($i)){
s+=$i;
numFields++
}
} 
print $0, (numFields ? s/numFields : 0)}' ${i}/numbers.txt > ${i}/temp.txt  
done 
done


# display only the gene name, description & mean 

for i in ${folder}/*
do 
for file in ${i}/temp.txt
do
filename=$(basename ${i})
awk 'BEGIN{FS="\t";OFS="\t";}{print $1,$2,$NF}' ${i}/temp.txt > ${i}/${filename}_mean.txt
done 
done
