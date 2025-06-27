## Emulator Inference (/inference)

### Main Inference Scripts

* **submit\_runs.sh**
  * Submits Slurm jobs for inference
  * Note: must manually edit variables to select GCMs, emulators, ML types (GAN/U-Net) and epoch for inference
* **apply\_emulator\_{cluster}.sl**
  * Slurm configuration for Maui/Mahuika
* **run\_emulator\_temporal\_tests.py**
  * Main inference script
* **compute\_metrics.py**
  * Computes climatological metrics after inference
  * Metrics include annual/seasonal means, rx1d, total max
  * Historical (1985-2004) and future (2080-2099) climatologies computed

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

### Inference Outputs (/inference/output/)

* Structure:
  ```
  /{GCM}/{emulator}/
      - NetCDF files of downscaled simulations
      - Separated by historical/ssp370, perfect/imperfect, GAN/U-Net, epochs

  /metrics/{GCM}/{emulator}/
      - NetCDF files of metric climatologies
  ```

---
