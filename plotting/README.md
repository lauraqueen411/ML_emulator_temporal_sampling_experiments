## Plotting (/plotting)

### Figure Notebooks

* Named by manuscript figure numbers:

  ```
  Figure_1_temporal_sampling.ipynb, etc.
  ```
* Each notebook:

  * Produces final figure
  * Generates *all* plots across experiment dimensions (GCMs, epoch, framework)
  * Notebooks without 'Figure' in the title contain code for other exploratory or supplementary plotting.

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

### Plotting Metrics Computation (/plotting/compute_metrics)

* RMSE image errors are computed in notebooks
* histogram and PSD counts are computed using a bash -> SLURM -> python workflow
* all metric results are saved in the /results directory

---
