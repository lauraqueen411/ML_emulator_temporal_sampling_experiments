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
CODE_DIR="/nesi/project/niwa00018/queenle/ML_emulator_temporal_sampling_experiments/plotting/compute_metrics"
cd $CODE_DIR

# Define arrays
metrics=("rx1d")
#"top_200" 
epochs=("220" "225" "230")

for metric in "${metrics[@]}"; do
    for epoch in "${epochs[@]}"; do

      sbatch -J "${metric}_${epoch}" compute_PSD_job.sl "${metric}" "${epoch}"
      echo "$metric $epoch"

    done
done