import xarray as xr
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import glob
import os
from scipy.stats import binned_statistic, binned_statistic_dd
import sys

def get_ml(n,gcm,ml_type,framework,epoch,start,end,metric):
    
    if framework == 'imperfect' and int(start) < 2015:
        da = xr.open_dataarray(f'{ml_output_dir}/{gcm}/pr_ACCESS-CM2_{n}/{gcm}_pr_historical_{framework}_framework_{ml_type}_epoch_{epoch}.nc')
    else:
        da = xr.open_dataarray(f'{ml_output_dir}/{gcm}/pr_ACCESS-CM2_{n}/{gcm}_pr_ssp370_{framework}_framework_{ml_type}_epoch_{epoch}.nc')
        
    da = da.sel(time=slice(start,end))
    da = da.dropna(dim='time', how='any')
        
    if metric == 'rx1d':
        da = da.groupby('time.year').max()
        
    elif metric == 'top_200':
        domain_mean = da.mean(dim=['lat', 'lon'])
        highest_200_days = domain_mean.sortby(domain_mean)[-200:].time

        # mask by rainiest days
        da = da.sel(time=highest_200_days)
        
    # normalize
    da = (da - da.mean())/da.std()
        
    return(da)


def get_ccam(gcm,start,end,metric):
    da = CCAM_downscaled_ds.sel(GCM=gcm,time=slice(start,end))
    da = da.dropna(dim='time', how='any')
    da = da*86400 # convert from flux to mm/day
    
    if metric == 'rx1d':
        da = da.groupby('time.year').max()
    
    elif metric == 'top_200':
        domain_mean = da.mean(dim=['lat', 'lon'])
        highest_200_days = domain_mean.sortby(domain_mean)[-200:].time

        # mask by rainiest days
        da = da.sel(time=highest_200_days)
        
    # normalize
    da = (da - da.mean())/da.std()
    
    return(da)

 
def psd(y, bins=np.arange(0, 0.52, 0.02)):
    """
    Compute Power Spectral Density (PSD) of an image y.
 
    Args:
    - y: Input image with shape (time, lat, lon).
    - bins: Array of bin edges for binning the wavenumbers.
 
    Returns:
    - psd_array: Array of PSD values with shape (time, K), where K is sqrt(kx^2 + ky^2),
                 representing the wavenumber in X and Y.
 
    - bin_edges: Bin edges used for binning the wavenumbers.
    """
    # Compute 2D FFT of the input image
    ffts = np.fft.fft2(y)
    ffts = np.fft.fftshift(abs(ffts) ** 2)
 
    # Compute the frequency grids
    freq = np.fft.fftshift(np.fft.fftfreq(172))
    freq2 = np.fft.fftshift(np.fft.fftfreq(179))
    kx, ky = np.meshgrid(freq, freq2)
    kx = kx.T
    ky = ky.T
 
    # Compute PSD by binning wavenumbers
    x = [
        binned_statistic(
            np.sqrt(kx.ravel() ** 2 + ky.ravel() ** 2),
            values=np.vstack(ffts[i].ravel()).T,
            statistic="mean",
            bins=bins,
        ).statistic
        for i in range(ffts.shape[0])
    ]
 
    # Compute PSD for the last time step (for normalization)
    x2 = binned_statistic(
        np.sqrt(kx.ravel() ** 2 + ky.ravel() ** 2),
        values=np.vstack(ffts[-1].ravel()).T,
        statistic="mean",
        bins=bins,
    )
 
    # Normalize the PSD and return it along with bin edges
    return np.array(x)[:, 0, :] / abs(x2.bin_edges[0] - x2.bin_edges[1]), x2.bin_edges


    
'''
__MAIN__
'''

ml_output_dir = '/nesi/project/niwa00018/queenle/ML_emulator_temporal_sampling_experiments/inference/output'
result_dir = '/nesi/project/niwa00018/queenle/ML_emulator_temporal_sampling_experiments/plotting/compute_metrics/results/PSD_counts'

# CCAM dynamical downscaled output
CCAM_downscaled_ds = xr.open_dataset('/nesi/project/niwa00018/ML_downscaling_CCAM/multi-variate-gan/inputs/target_fields/target_fields_hist_ssp370_concat.nc')['pr']


bins=np.arange(0, 0.52, 0.02)
bin_left = bins[:-1]
bin_right = bins[1:]


metric = sys.argv[1]
epoch = sys.argv[2]

print(f'metric: {metric}')
print(f'epoch: {epoch}\n')

for period in [('1985','2004'),('2080','2099')]:
    start,end = period

    print(f'\n{start}-{end}')

    for gcm in ['EC-Earth3','NorESM2-MM']:
        print(gcm)
        ccam_data = get_ccam(gcm,start,end,metric)
        ccam_psd,ccam_bins = psd(ccam_data)
        ccam_psd_mean = ccam_psd.mean(axis=0)

        for ml_type in ['GAN','unet']:
            print(ml_type)

            for framework in ['perfect','imperfect']:
                print(framework)

                if os.path.exists(f'{result_dir}/{gcm}_{ml_type}_{framework}_epoch_{epoch}_{start}-{end}_{metric}_PSD_counts.csv'):
                    print('file exists, skipping')
                    continue

                result_dict = {}
                result_dict['bin_left'] = bin_left
                result_dict['bin_right'] = bin_right
                result_dict['CCAM'] = ccam_psd_mean

                for n in ['5','10','20','30','40','50','60','80','100','120','140','1961-1980','2015-2034','2080-2099']:#,'140'

                    ml_data = get_ml(n,gcm,ml_type,framework,epoch,start,end,metric)
                    ml_psd,ml_bins = psd(ml_data)

                    ml_psd_mean = ml_psd.mean(axis=0)

                    #print(ml_psd_mean)

                    result_dict[n] = ml_psd_mean

                df = pd.DataFrame.from_dict(result_dict)

                df.to_csv(f'{result_dir}/{gcm}_{ml_type}_{framework}_epoch_{epoch}_{start}-{end}_{metric}_PSD_counts.csv')

                    
                    
