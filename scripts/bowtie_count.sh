#!/usr/bin/env bash

# Script for executing Bowtie and generating count files

# Obtain fastqPattern
fastqPattern=$1;
# Obtain number of allowed mismatches
mismatches=$2;
# Obtain maximum number for multimapping
multimapping=$3;
# Bowtie index location
index=$4;
# Library dir
lib=$5

# Directory of FASTQ files
in_dir=data/original_data/FASTQ;
in_FASTQ=${in_dir}/${lib}/*${fastqPattern};

# Directory of BAM and counts files
out_dir_bam=data/derived_data/BAM/;
out_dir_counts=data/derived_data/counts/;

for i in $in_FASTQ; do
	# Filename w/o path
	sample=`basename $i`;
	echo "#### Bowtie mapping and counting of $sample ####"
	
	# Log file
	log_file=log_files/bowtie_${sample/_${fastqPattern}}.log
	
	# Check if BAM file exits, if YES skip
	if [ -e ${out_dir_bam}${sample/_${fastqPattern}}.bam ]; then
		echo "Already done, continuing ...";
		continue;
	fi

	# Execute Bowtie with 6 threads, obtaining the output in a bam file 
	# and redirecting the stderr to a log file
	bowtie -p6 -v$mismatches -m$multimapping -S $index $i 2> $log_file \
	| samtools view -Sb > ${out_dir_bam}${sample/_${fastqPattern}}.bam
	
	# Generate count table
	# sort is needed because uniq only matches on repeated lines
	# https://unix.stackexchange.com/questions/170043/sort-and-count-number-of-occurrence-of-lines
	samtools view ${out_dir_bam}${sample/_${fastqPattern}}.bam \
	| cut -f 3 | sort | uniq -c | grep -v '*' | \
	awk -v condition="${sample/_${fastqPattern}}" 'BEGIN{print "GENE_CLONE\t"condition};{print $2"\t"$1}' \
	> ${out_dir_counts}${sample/_${fastqPattern}}.counts
done


