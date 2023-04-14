#!/bin/sh

#SBATCH -p horence,owners			# run on any of the three queues, whichever is available first
#SBATCH --time=10:00:00				# how much max time to request
#SBATCH --mem=100000				# how much max mem to request in MBs
#SBATCH --job-name=cryptic_dive			# job name
#SBATCH --output=dive_logs/dive_%j.out
#SBATCH --error=dive_logs/dive_%j.err

# IO
fastq_file="$1"
outdir="/oak/stanford/groups/horence/jordi/cryptic/dive/"

# Source environment
source activate biodive

# Load blast
ml biology
ml ncbi-blast+/2.11.0

# dive call
python3 dive_call.py "$fastq_file" "$outdir"

