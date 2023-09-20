#!/usr/bin/python3

# create a new output file
outfile = open('../../refs/config.json', 'w')

# get all file names
allSamples = list()
read = ["R1", "R2"]
numSamples = 0

with open('../../refs/fastq_headers.tsv', 'r') as infile:
    for line in infile:
        numSamples += 1
        split = line.split()
        fileName = split[0]  # Mayo_43_P_S17_L001_R1_001.fastq.gz, for each sample there are 2 reads in 2 lanes (4 files)
        allSamples.append(fileName.replace("_L001_R1_001.fastq.gz", ""))
        if line.__contains__("_M_"):
            meningesSamples.append(fileName.replace("_L001_R1_001.fastq.gz", ""))
        if line.__contains__("_P_"):
            parietalSamples.append(fileName.replace("_L001_R1_001.fastq.gz", ""))

# create header and write to outfile
header = '''{{
    "DIRECTORIES",
    "rawReads" : "/research/labs/neurology/fryer/projects/aducanumab/mouse/bulkRNA",
    "rawQC" : "rawQC/",
    "trimmedReads" : "trimmedReads/",
    "trimmedQC" : "trimmedQC/",
    "starAligned" : "starAligned/",
    "featureCounts" : "featureCounts/",
    "genomeDir" : "/research/labs/neurology/fryer/projects/references/mouse/refdata-gex-mm10-2020-A/star/",

    "FILES",
    "Mmusculus.gtf" : "/research/labs/neurology/fryer/projects/references/mouse/genes/genes.gtf",
    "Mmusculus.fa" : "/research/labs/neurology/fryer/projects/references/mouse/fasta/genome.fa",

    "SAMPLE INFORMATION",
    "allSamples": {0},
    "read": {1},

    "CLUSTER INFORMATION",
    "threads" : "20",
'''
outfile.write(header.format(allSamples, read))

# config formatting
counter = 0
with open('../../refs/fastq_headers.tsv', 'r') as infile:
    for line in infile:
        counter += 1

        # store sample name and info, Mayo_43_P_S17_L001_R1_001.fastq.gz, for each sample there is 2 reads in 2 lanes (4 files)
        split = line.split()
        lane1read1 = split[0].replace(".fastq.gz", "")
        lane1read2 = lane1read1.replace("R1", "R2")
        lane2read1 = lane1read1.replace("L001","L002")
        lane2read2 = lane1read2.replace("L001","L002")
        baseName = lane1read1.replace("_L001_R1_001", "")
        sampleInfo = split[1]

        # break down fastq file info
        # @A00127:312:HVNLJDSXY:2:1101:2211:1000
        # @<instrument>:<run number>:<flowcell ID>:<lane>:<tile>:<x-pos>:<y-pos>
        sampleInfo = sampleInfo.split(':')
        instrument = sampleInfo[0]
        instrument = instrument.replace("@", "")
        runNumber = sampleInfo[1]
        flowCell = sampleInfo[2]

        out = '''
    "{0}":{{
        "lane1read1": "{1}",
        "lane2read1": "{2}",
        "lane1read2": "{3}",
        "lane2read2": "{4}",
        "instrument": "{5}",
        "runNumber": "{6}",
        "flowCell": "{7}"
        '''
        outfile.write(out.format(baseName, lane1read1, lane2read1, lane1read2, lane2read2, instrument, runNumber, flowCell))
        if (counter == numSamples):
            outfile.write("}\n}")
        else:
            outfile.write("},\n")
outfile.close()

