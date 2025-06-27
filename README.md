# On the relationship between temporal training data and ML regional climate model emulator skill
This repository contains the code for the draft manuscript titled: "On the relationship between temporal training data and ML regional climate model emulator skill".

Please contact Neelesh Rampal if you have any further questions about this work (neelesh.rampal@niwa.co.nz). 

## Cloning / External Data
First, clone this repository ```bash git clone https://github.com/lauraqueen411/ML_emulator_temporal_sampling_experiments.git```.

This repo is not entirely self-contained; essential training and inference files are located in other directories on Maui. 

Predictor and target data for training are located here on Maui:
/nesi/project/niwa00018/ML_downscaling_CCAM/

GCM (imperfect) inference inputs are located here:
/nesi/project/niwa03712/CMIP6_data/Downscaled_Preprocessed/

Coarsened RCM (perfect) inference inputs are located here:
/nesi/project/niwa00018/ML_downscaling_CCAM/multi-variate-gan/inputs/predictor_fields/

## Python Environment and Jupyter Kernel

Training, inference and plotting python files are run using the following python:
/nesi/project/niwa00018/rampaln/envs/ml_env_v2/bin/python

A fresh copy of the 'ml_env_v2' conda environment with no builds is located in the 'environment.yml' should it need to be recreated.

All jupyter notebooks use the jupyter kernel called "jupyter_env", located here:
/scale_wlg_persistent/filesets/home/queenle/.local/share/jupyter/kernels/nellys_env/


## Training the Model

Training occurs in the /training directory.

There are three main scripts for training, where {cluster} refers to maui or mahu (aka mahuika):
* submit_jobs_{cluster}.sh (submits slurm jobs for each emulator reading in /emulator/ config json files)
* run_experiments_{cluster}.sl (the slurm configuration for each job)
* train_model_temporal_experiments.py (the main python training script)

Additionally, the **temporal_samplings_2.csv** file is essential for the temporal sampling experiments. It is read by the emulator config files
and is the **basis of the entire experiment design**. The method for defining the samplings is in the 'definte_temporal_samplings.ipynb' notebook.
This should be re-run carefully to ensure the sampling .csv file is not overwritten.

Training inputs:
* Emulator config (.json) files are located in the /training/emulators/ directory
* paths to predictor, target and static inputs are defined in the config files and generally point to this directory: /nesi/project/niwa00018/ML_downscaling_CCAM/

Training outputs:
* weights (.h5) files and periodic image (.png) files are saved to respective /emulators/{emulator_name}/ folder throughout training.

### Emulator Inference

Emulator inference occurs in the /inference directory.

There are three important scripts when running emulator inference:
* submit_runs.sh (submits slurm jobs for inference)
    * NOTE: variables need to be set to select which GCMs, emulators, ml_types (GAN, U-Net) and epochs are being used for inference
* apply_emulator_{cluster}.sl (slurm configuration for each job for the relevent Maui or Mahuika cluster)
* run_emulator_temporal_tests.py (the main python script for emulator inference)
* compute_metrics.py (script called by the slurm file directly after inference to compute selected metrics)
    * metric (i.e. annual mean, seasonal means, Rx1day, total max) climatologies computed for historical (1985-2004), future (2080-2099) periods

Inference inputs:
* reads in relevant emulator config file from /training/emulators
* perfect (coarsened RCM) inputs from /nesi/project/niwa00018/ML_downscaling_CCAM/multi-variate-gan/inputs/predictor_fields/
* imperfect (raw GCM) inputs from /nesi/project/niwa03712/CMIP6_data/Downscaled_Preprocessed/

Inference outputs:

Output saved in /inference/output/...
* /{GCM}/{emulator}/ - netcdf files for downscaled simulation separated by [historical/ssp370], [perfect/imperfect], [GAN/unet], and epochs.
* /metrics/{GCM}/{emulator}/ - netcdf files for metric climatologies separated by [perfect/imperfect], [GAN/unet], and epochs.

### Plotting





