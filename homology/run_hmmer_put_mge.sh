#!/bin/sh

#SBATCH --time=2:00:00				# how much max time to request
#SBATCH --mem=10000				# how much max mem to request in MBs
#SBATCH --job-name=cryptic_hmmer		# job name
#SBATCH --output=hmmer_logs/hmmer_%A_%a.out
#SBATCH --error=hmmer_logs/hmmer_%A_%a.err
#SBATCH --array=1-199%25

# get srr
srr="$(sed -n "$SLURM_ARRAY_TASK_ID"p /oak/stanford/groups/horence/jordi/cryptic/dive/putative_mge_seeds/ssake_submission_list.txt)"

# IO
fa="/oak/stanford/groups/horence/jordi/cryptic/ssake_ass/${srr}/${srr}_ssake_10_contigs.fa"

# Source environment
source activate prot_hmlgy

# call
prot_hmlgy.sh "$fa"

