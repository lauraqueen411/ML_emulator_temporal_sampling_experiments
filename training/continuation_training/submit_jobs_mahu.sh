#!/bin/bash -l

module purge # optional
module load NeSI
#module load cuDNN/8.1.1.33-CUDA-11.2.0

# Navigate to the code directory
CODE_DIR="/nesi/project/niwa00018/queenle/ML_emulator_temporal_sampling_experiments/training/continuation_training"
cd $CODE_DIR

# Define arrays
ml_models=("pr_ACCESS-CM2_140_cont")
#"pr_ACCESS-CM2_5" "pr_ACCESS-CM2_10" "pr_ACCESS-CM2_20" "pr_ACCESS-CM2_30" "pr_ACCESS-CM2_40" "pr_ACCESS-CM2_50" "pr_ACCESS-CM2_60" "pr_ACCESS-CM2_80"
#("pr_ACCESS-CM2_1961-1980" "pr_ACCESS-CM2_2015-2034" "pr_ACCESS-CM2_2080-2099")


for ml_model in "${ml_models[@]}"; do

    sbatch -J "$ml_model" run_experiments_mahu.sl "/nesi/project/niwa00018/queenle/ML_emulator_temporal_sampling_experiments/training/continuation_training/emulators/$ml_model/config_info.json"
    echo "$ml_model"

done
