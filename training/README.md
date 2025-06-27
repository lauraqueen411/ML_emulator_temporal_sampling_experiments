## Emulator Training (/training)

### Main Training Scripts

* **submit\_jobs\_{cluster}.sh**
  * Submits Slurm jobs for each emulator
  * Reads config (.json) files from `/emulators/`
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
* Predictor, target, and static inputs defined in the configs. General located in:
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
