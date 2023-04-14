#!/bin/bash
#############################
# File Name : start_jupyter.sbatch
#
# Purpose : Start a jupyter notebook that can easily be accessed by local machine at localhost:8888
#           This will be a self-submitting daemon, so it will always be up
#
# Creation Date : 12-12-2017
#
# Last Modified : Mon 07 Mar 2022 09:39:04 AM PST
#
# Created By : Rob Bierman
#
##############################

#########################################################
#                                                       #
#      Parameters that don't need to change             #
#                                                       #
#########################################################
#Single commented out SBATCH are active, more than that is inactive
#SBATCH -p quake,normal
#SBATCH --time=14:00:00                     # how much time to run
#SBATCH --mem=100G                           # how much mem in MBs
##SBATCH --dependency=singleton             # required to wait till previous version is done
#SBATCH --job-name=dive_jup                 # name the job jupyter host
##SBATCH --output=/dev/null                 # slurm.out file (throw away out log)
##SBATCH --error=/dev/null                  # slurm.err file (throw away err log)

#########################################################
#                                                       #
#              Parameters to change                     #
#                                                       #
#########################################################

MY_PORT="33003" #<-- choose your own port between 30000 and 40000 
NOTEBOOK_ROOT="/oak/stanford/groups/horence"

# go to notebook root
cd $NOTEBOOK_ROOT

# activate environment
source activate DIVE-notebook

jupyter-notebook --no-browser --port=$MY_PORT

