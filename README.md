````markdown
# On the Relationship Between Temporal Training Data and ML Regional Climate Model Emulator Skill

This repository contains the code supporting the draft manuscript:

> **"On the relationship between temporal training data and ML regional climate model emulator skill"**

Please contact **Neelesh Rampal** for questions:  
📧 neelesh.rampal@niwa.co.nz

---

## Quick Start

### Clone the Repository

```bash
git clone https://github.com/lauraqueen411/ML_emulator_temporal_sampling_experiments.git
````

**Note:** This repository is *not fully self-contained*. Essential training and inference data are located on the **Maui** system and described below.

---

## Project Structure

This repository is organized into three main components:

1. **Training** – Model training workflows and configurations
2. **Inference** – Emulator application and evaluation
3. **Plotting** – Analysis and figure generation

---

## Python Environment

All training, inference, and plotting scripts use the following environment on **Maui**:

```bash
/nesi/project/niwa00018/rampaln/envs/ml_env_v2/bin/python
```

A reproducible environment file is included:

```
environment.yml
```

This can be used to recreate the `ml_env_v2` Conda environment **with no builds**.

---

### Jupyter Kernel

All notebooks use the **"jupyter\_env"** kernel:

```
/scale_wlg_persistent/filesets/home/queenle/.local/share/jupyter/kernels/nellys_env/
```

---

## Emulator Training

Training scripts are located in:

```
/training
```

### Main Training Scripts

* **submit\_jobs\_{cluster}.sh**

  * Submits Slurm jobs for each emulator
  * Reads configs from `/emulators/`
* **run\_experiments\_{cluster}.sl**

  * Slurm configuration for Maui or Mahuika clusters
* **train\_model\_temporal\_experiments.py**

  * Main Python training script

---

### Essential Training Files

* **temporal\_samplings\_2.csv**

  * Critical for temporal sampling experiments
  * Defined using:

    ```
    /training/define_temporal_samplings.ipynb
    ```
  * **Important:** Re-run carefully to avoid overwriting the CSV.

---

### Training Inputs

* Emulator config `.json` files in:

  ```
  /training/emulators/
  ```
* Predictor, target, and static inputs defined in the configs:

  ```
  /nesi/project/niwa00018/ML_downscaling_CCAM/
  ```

---

### Training Outputs

* Model weights (`.h5`) and periodic images (`.png`) saved to:

  ```
  /emulators/{emulator_name}/
  ```

---

## Emulator Inference

Inference scripts are in:

```
/inference
```

### Main Inference Scripts

* **submit\_runs.sh**

  * Submits Slurm jobs for inference
  * Edit variables to select:

    * GCMs
    * Emulators
    * ML types (GAN, U-Net)
    * Epochs

* **apply\_emulator\_{cluster}.sl**

  * Slurm configuration for Maui/Mahuika

* **run\_emulator\_temporal\_tests.py**

  * Main inference script

* **compute\_metrics.py**

  * Computes climatological metrics after inference
  * Metrics include:

    * Annual/seasonal means
    * Rx1d
    * Total max
    * Historical (1985–2004) and future (2080–2099) periods

---

### Inference Inputs

* Emulator config from:

  ```
  /training/emulators
  ```
* Perfect (coarsened RCM) inputs:

  ```
  /nesi/project/niwa00018/ML_downscaling_CCAM/multi-variate-gan/inputs/predictor_fields/
  ```
* Imperfect (raw GCM) inputs:

  ```
  /nesi/project/niwa03712/CMIP6_data/Downscaled_Preprocessed/
  ```

---

### Inference Outputs

* Results saved in:

  ```
  /inference/output/
  ```

* Structure:

  ```
  /{GCM}/{emulator}/
      - NetCDF downscaled simulations
      - Organized by historical/ssp370, perfect/imperfect, GAN/U-Net, epochs

  /metrics/{GCM}/{emulator}/
      - NetCDF metric climatologies
  ```

---

## Plotting

Plotting code is in:

```
/plotting
```

### Figure Notebooks

* Named by manuscript figure numbers:

  ```
  Figure_1_temporal_sampling.ipynb, etc.
  ```
* Each notebook:

  * Produces final figure
  * Generates *all* plots across experiment dimensions (GCMs, epoch, framework)

---

### Other Plotting Notebooks

* Without "Figure" in the name:

  * Exploratory or supplementary analyses

---

### Plotting Outputs

* Final manuscript figures:

  ```
  /plotting/final_figures
  ```
* All experiment plots:

  ```
  /plotting/plots
  ```

---

### Plotting Metrics Computation

Located in:

```
/plotting/compute_metrics
```

* RMSE image errors: computed in notebooks
* Histogram and PSD counts:

  * Bash → SLURM → Python workflow
  * Results saved in:

    ```
    /results
    ```

---
