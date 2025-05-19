#!/bin/bash -l
#SBATCH --job-name=GPU_job
#SBATCH --partition=hgx
#SBATCH --time=00:59:00
#SBATCH --mem=100G
#SBATCH --cpus-per-task=32
#SBATCH --gpus-per-node=A100:1
#SBATCH --account=niwa03712
#SBATCH --mail-type=ALL
#SBATCH --output log/%j-%x.out
#SBATCH --error log/%j-%x.out

/nesi/project/niwa00018/queenle/ml_env_v2/bin/python3.8 compute_rmse.py unet