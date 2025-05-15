#!/bin/bash -l

module purge # optional
module load NeSI
#module load cuDNN/8.1.1.33-CUDA-11.2.0

# Navigate to the code directory
CODE_DIR="/nesi/project/niwa00018/queenle/On-the-Extrapolation-of-Generative-Adversarial-Networks-for-downscaling-precipitation-extremes"
cd $CODE_DIR

# Define arrays
ml_models=("pr_ACCESS-CM2_100")
#"pr_ACCESS-CM2_10" "pr_ACCESS-CM2_20" "pr_ACCESS-CM2_30" "pr_ACCESS-CM2_40" "pr_ACCESS-CM2_50" "pr_ACCESS-CM2_60" "pr_ACCESS-CM2_70" "pr_ACCESS-CM2_80" "pr_ACCESS-CM2_90" "pr_ACCESS-CM2_100" "tasmax_ACCESS-CM2_5" "tasmax_ACCESS-CM2_10" "tasmax_ACCESS-CM2_20" "tasmax_ACCESS-CM2_30" "tasmax_ACCESS-CM2_40" "tasmax_ACCESS-CM2_50" "tasmax_ACCESS-CM2_60" "tasmax_ACCESS-CM2_70" "tasmax_ACCESS-CM2_80" "tasmax_ACCESS-CM2_90" "tasmax_ACCESS-CM2_100")


for ml_model in "${ml_models[@]}"; do

    sbatch -J "$ml_model" run_experiments_maui.sl "/nesi/project/niwa00018/queenle/ML_emulator_development/emulators/$ml_model/config_info.json"
    echo "$ml_model"

done
