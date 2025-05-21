#!/bin/bash -l
#SBATCH --job-name=GPU_job
#SBATCH --partition=hgx
#SBATCH --time=23:59:00
#SBATCH --mem=200G
#SBATCH --cpus-per-task=32
#SBATCH --gpus-per-node=A100:2
#SBATCH --account=niwa03712
#SBATCH --mail-user=laura.queen@niwa.co.nz
#SBATCH --mail-type=ALL
#SBATCH --output log/%j-%x.out
#SBATCH --error log/%j-%x.out

module purge # optional
module load NeSI
module load gcc/9.3.0
#module load CDO/1.9.5-GCC-7.1.0
#module load Miniconda3/4.12.0
module load cuDNN/8.1.1.33-CUDA-11.2.0
#conda activate ml_env
nvidia-smi
# set the experiment name that we are implementing


/nesi/project/niwa00018/rampaln/envs/ml_env_v2/bin/python train_model_temporal_experiments.py $1


