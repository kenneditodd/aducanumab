# Kennedi Todd
# August 15, 2023

# go to counts folder
cd ../../featureCounts

# GENE COUNT MATRIX
#-----------------------------------------------------------------------------------------

# create list of meninges gene featureCount count files
ls -1 | grep gene.counts$ > gene_count_files.txt

# store number of files in variable
n=$(cat gene_count_files.txt | wc -l)

# if there are at least two files
if [ $n -ge 2 ]
then 
	# get Geneid and counts column of first file
	firstFile=$(head -n 1 gene_count_files.txt)
	tail -n+2 $firstFile | cut -f1,7 > file1.txt
	
	# get counts column of remaining files
	i=2
	for file in $(tail -n+2 gene_count_files.txt)
	do
		tail -n+2 $file | cut -f7 > file$i;
		let "i+=1"
	done

	# paste files together
	paste -d "\t" file* > gene_counts_matrix.tsv					

	# rename columns
	sed -i 's,starAligned/,,g' gene_counts_matrix.tsv
	sed -i 's,.Aligned.sortedByCoord.out.bam,,g' gene_counts_matrix.tsv
	sed -i 's/Geneid/gene_id/g' gene_counts_matrix.tsv

	# cleanup
	rm file*
	
	# print
	echo "Gene counts matrix successfully generated."
else
	echo "Could not generate gene counts matrix. You need at least two samples to generate this tissue matrix."
fi

# cleanup
rm meninges_count_files.txt


# EXON COUNT MATRIX
#-----------------------------------------------------------------------------------------

# create list of meninges gene featureCount count files
ls -1 | grep _M_ | grep sex_specific | grep gene.counts$ > meninges_count_files.txt

# store number of files in variable
n=$(cat meninges_count_files.txt | wc -l)

# if there are at least two files
if [ $n -ge 2 ]
then 
	# get Geneid and counts column of first file
	firstFile=$(head -n 1 meninges_count_files.txt)
	tail -n+2 $firstFile | cut -f1,7 > file1.txt
	
	# get counts column of remaining files
	i=2
	for file in $(tail -n+2 meninges_count_files.txt)
	do
		tail -n+2 $file | cut -f7 > file$i;
		let "i+=1"
	done

	# paste files together
	paste -d "\t" file* > meninges_sex_specific_counts_matrix.tsv					

	# rename columns
	sed -i 's,starAligned/,,g' meninges_sex_specific_counts_matrix.tsv
	sed -i 's,.Aligned.sortedByCoord.out.bam,,g' meninges_sex_specific_counts_matrix.tsv
	sed -i 's/Geneid/ID/g' meninges_sex_specific_counts_matrix.tsv

	# cleanup
	rm file*
	
	# print
	echo "Sex specific meninges counts matrix successfully generated."
else
	echo "Could not generate sex specific meninges counts matrix. You need at least two samples to generate this tissue matrix."
fi

# cleanup
rm meninges_count_files.txt
