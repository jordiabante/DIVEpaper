#!/bin/sh

#SBATCH -p horence,owners			# run on any of the three queues, whichever is available first
#SBATCH --time=2:00:00				# how much max time to request
#SBATCH --mem=10000				# how much max mem to request in MBs
#SBATCH --job-name=cryptic_ssake		# job name
#SBATCH --output=ssake_logs/ssake_%A_%a.out
#SBATCH --error=ssake_logs/ssake_%A_%a.err
#SBATCH --array=1-199%25

# get srr
srr="$(sed -n "$SLURM_ARRAY_TASK_ID"p /oak/stanford/groups/horence/jordi/cryptic/dive/putative_mge_seeds/ssake_submission_list.txt)"

# IO
proj_dir="/oak/stanford/groups/horence/jordi/cryptic/"
seeds="/oak/stanford/groups/horence/jordi/cryptic/dive/putative_mge_seeds/${srr}_pass_1_anchors_annot_filtered_maxlen_50_diveqval_0_mgends.fasta"

# Source environment
source activate ssake_env

# call
ssake_paired.sh "$proj_dir" "$srr" "$seeds"

