#!/bin/bash -l

module use /opt/nesi/modulefiles/
module unuse /opt/niwa/CS500_centos7_skl/modules/all
module unuse /opt/niwa/share/modules/all

export SYSTEM_STRING=CS500
export OS_ARCH_STRING=centos7
export CPUARCH_STRING=skl
export PYTHONUSERBASE=/nesi/project/niwa00018/rampaln/conda_tmp
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64
#module purge # optional
#module load CDO/1.9.5-GCC-7.1.0
#module load Miniforge3

# Navigate to the code directory
CODE_DIR="/nesi/project/niwa00018/queenle/ML_emulator_temporal_sampling_experiments/inference"
cd $CODE_DIR

# Define arrays
ml_models=("pr_ACCESS-CM2_5" "pr_ACCESS-CM2_10" "pr_ACCESS-CM2_20" "pr_ACCESS-CM2_30" "pr_ACCESS-CM2_40" "pr_ACCESS-CM2_50" "pr_ACCESS-CM2_60" "pr_ACCESS-CM2_80" "pr_ACCESS-CM2_100" "pr_ACCESS-CM2_120" "pr_ACCESS-CM2_1961-1980" "pr_ACCESS-CM2_2015-2034" "pr_ACCESS-CM2_2080-2099")
# "pr_ACCESS-CM2_140" 

gcms=("ACCESS-CM2" "EC-Earth3" "NorESM2-MM")
variants=("r4i1p1f1" "r1i1p1f1" "r1i1p1f1")

variable="pr"
ssp="ssp370"
gan="GAN" #GAN, unet
epoch=230

for ml_model in "${ml_models[@]}"; do
    # Loop through GCMs
    for i in "${!gcms[@]}"; do

      gcm="${gcms[i]}"
      variant="${variants[i]}"

      sbatch -J "${ml_model}_${gcm}" apply_emulator_mahu.sl "${ssp}" "${gcm}" "${variant}" "${variable}" "${ml_model}" "${gan}" "${epoch}"
      echo "$ml_model $gcm $ssp $variable"
      
    done
done
