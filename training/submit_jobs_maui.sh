#!/bin/bash -l

module purge # optional
module load NeSI

# Navigate to the code directory
CODE_DIR="/nesi/project/niwa00018/queenle/ML_emulator_temporal_sampling_experiments/training"
cd $CODE_DIR

# Define arrays
ml_models=("pr_ACCESS-CM2_40")
# "pr_ACCESS-CM2_5" "pr_ACCESS-CM2_10" "pr_ACCESS-CM2_20" "pr_ACCESS-CM2_30" "pr_ACCESS-CM2_50" "pr_ACCESS-CM2_60" "pr_ACCESS-CM2_80" "pr_ACCESS-CM2_100" "pr_ACCESS-CM2_120" "pr_ACCESS-CM2_140")

#("pr_ACCESS-CM2_1961-1980" "pr_ACCESS-CM2_2015-2034" "pr_ACCESS-CM2_2080-2099")


for ml_model in "${ml_models[@]}"; do

    sbatch -J "$ml_model" run_experiments_maui.sl "/nesi/project/niwa00018/queenle/ML_emulator_temporal_sampling_experiments/training/emulators/$ml_model/config_info.json"
    echo "$ml_model"

done
