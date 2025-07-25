#!/bin/bash -l
#SBATCH --job-name=GPU_job
#SBATCH --partition=niwa_work
#SBATCH --time=23:59:00
#SBATCH --cluster=maui_ancil
#SBATCH --mem=250G
#SBATCH --gpus-per-node=A100:2
#SBATCH --account=niwap03712
#SBATCH --mail-user=laura.queen@niwa.co.nz
#SBATCH --mail-type=ALL
#SBATCH --output log/%j-%x.out
#SBATCH --error log/%j-%x.out
#SBATCH --exclude=wmg102

module purge # optional
module load NeSI
module load cuDNN/8.1.1.33-CUDA-11.2.0
nvidia-smi

/nesi/project/niwa00018/rampaln/envs/ml_env_v2/bin/python train_model_temporal_experiments.py $1



