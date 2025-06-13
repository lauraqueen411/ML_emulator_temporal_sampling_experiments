#!/bin/bash -l
#SBATCH --job-name=GPU_job
#SBATCH --partition=gpu
#SBATCH --time=03:59:00
#SBATCH --mem=100G
#SBATCH --cpus-per-task=32
#SBATCH --gpus-per-node=A100:1
#SBATCH --account=niwa03712
#SBATCH --mail-type=ALL
#SBATCH --output log/%j-%x.out
#SBATCH --error log/%j-%x.out

metric=$1
epoch=$2

/nesi/project/niwa00018/queenle/ml_env_v2/bin/python3.8 -u compute_PSD_counts.py $metric $epoch