#!/bin/sh
#SBATCH --job-name run_snakemake
#SBATCH --mem 2G
#SBATCH --mail-user todd.kennedi@mayo.edu
#SBATCH --mail-type END,FAIL
#SBATCH --output logs/%x.%N.%j.stdout
#SBATCH --error logs/%x.%j.stderr
#SBATCH --partition cpu-short
#SBATCH --time 24:00:00 ## HH:MM:SS

# activate conda environment
source $HOME/.bash_profile
conda activate aducanumab

# change directory to where Snakefile is located
cd ../..
pwd

# run snakemake
# dry run: snakemake -nr
snakemake -s Snakefile -j 20 --rerun-incomplete --latency-wait 60 --cluster "sbatch --mem=40G --output=scripts/01_preprocessing/logs/snakemake_job_logs/%x.%N.%j.stdout --error=scripts/01_preprocessing/logs/snakemake_job_logs/%x.%N.%j.stderr --partition=cpu-short --tasks=20 --time 05:00:00"
