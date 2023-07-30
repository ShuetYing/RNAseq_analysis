#!/bin/bash

path=$PWD"/fastqc_output"

# unzip files 
for file in ${path}/*.zip 
do 
unzip ${file} -d ${path}
done 

# assess quality score for the seq
cat ${path}/*/summary.txt | grep "Per base sequence quality" > base_quality_summary.txt

linesinfile=$(wc -l < base_quality_summary.txt)
numberofpasses=$(grep -c "PASS" base_quality_summary.txt)

echo ">>There are a total of ${linesinfile} sequences" > analysis_conclusion.txt

if [ "${linesinfile}" == "${numberofpasses}" ] 
then 
echo ">>ALL sequences pass the quality check"
else 
echo ">>Only ${numberofpasses} sequences pass the quality check"
fi >> analysis_conclusion.txt
