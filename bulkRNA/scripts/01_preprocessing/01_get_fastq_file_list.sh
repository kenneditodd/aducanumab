#!/bin/bash

# Get fastq file list
cd /research/labs/neurology/fryer/projects/aducanumab/mouse/bulkRNA

# initialize output file
out=/research/labs/neurology/fryer/m214960/aducanumab/bulkRNA/refs/fastq_file_list.txt

# save file list
ls -1 | grep L001_R1_001.fastq.gz > $out