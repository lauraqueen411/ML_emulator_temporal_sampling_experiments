import xarray as xr
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import glob
import os
from scipy.stats import binned_statistic, binned_statistic_dd
import sys

ml_output_dir = '/nesi/project/niwa00018/queenle/ML_emulator_temporal_sampling_experiments/inference/output'

result_dir = '/nesi/project/niwa00018/queenle/ML_emulator_temporal_sampling_experiments/plotting/compute_metrics/results/histogram_counts'

# CCAM dynamical downscaled output
CCAM_downscaled_ds = xr.open_dataset('/nesi/project/niwa00018/ML_downscaling_CCAM/multi-variate-gan/inputs/target_fields/target_fields_hist_ssp370_concat.nc')['pr']

def get_ml_counts(n,gcm,ml_type,framework,epoch,start,end,bins):
    
    if framework == 'imperfect' and int(start) < 2015:
        da = xr.open_dataarray(f'{ml_output_dir}/{gcm}/pr_ACCESS-CM2_{n}/{gcm}_pr_historical_{framework}_framework_{ml_type}_epoch_{epoch}.nc')
    else:
        da = xr.open_dataarray(f'{ml_output_dir}/{gcm}/pr_ACCESS-CM2_{n}/{gcm}_pr_ssp370_{framework}_framework_{ml_type}_epoch_{epoch}.nc')
        
    da = da.sel(time=slice(start,end))
    data = da.values.flatten()
    rainy = data[data>1]

    counts, bin_edges = np.histogram(rainy, bins=bins)

    return(counts)

def get_ccam_counts(gcm,start,end,bins):
    da = CCAM_downscaled_ds.sel(GCM=gcm,time=slice(start,end))
    da = da*86400 # convert from flux to mm/day
    data = da.values.flatten()
    rainy = data[data>1]

    counts, bin_edges = np.histogram(rainy, bins=bins)
    
    return(counts)
    
    
    
'''
__MAIN__
'''

#start,end = ('1985','2004')
bins = np.arange(1, 1051, 20)
bin_left = bins[:-1]
bin_right = bins[1:]

epoch = sys.argv[1]
print(epoch)

for period in [('1985','2004'),('2080','2099')]:
    start,end = period
    
    print(f'\n{start}-{end}')
    
    for gcm in ['EC-Earth3','NorESM2-MM']:
        print(gcm)
        ccam_counts = get_ccam_counts(gcm,start,end,bins)

        for ml_type in ['GAN','unet']:
            print(ml_type)
            for framework in ['perfect','imperfect']:
                print(framework)
                if os.path.exists(f'{result_dir}/{gcm}_{ml_type}_{framework}_epoch_{epoch}_{start}-{end}_histogram_counts.csv'):
                    print('file exists, skipping')
                    continue

                result_dict = {}
                result_dict['bin_left'] = bin_left
                result_dict['bin_right'] = bin_right
                result_dict['CCAM'] = ccam_counts

                for n in ['5','10','20','30','40','50','60','80','100','120','140','1961-1980','2015-2034','2080-2099']:
                    print(n)
                    ml_counts = get_ml_counts(n,gcm,ml_type,framework,epoch,start,end,bins)

                    result_dict[n] = ml_counts

                df = pd.DataFrame.from_dict(result_dict)

                df.to_csv(f'{result_dir}/{gcm}_{ml_type}_{framework}_epoch_{epoch}_{start}-{end}_histogram_counts.csv')

